//
//  SearchViewController.swift
//  StartProject-ios
//
//  Created by Камиль Кадыров on 20.10.2022.
//  Copyright © 2022 TEKHNOKRATIYA. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    
    private let pageHeader = PageHeader(text: Text.Search.search)
    
    private let bottomBorder: UIView = {
        let lineView = UIView()
        lineView.layer.borderWidth = 2
        lineView.layer.borderColor = Asset.darkGray.color.cgColor
        return lineView
    }()
    
    private let mainFrame: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private let searchTextField: UISearchTextField = {
        let view = UISearchTextField()
        view.placeholder = Text.Search.textfieldPlaceholder
        view.keyboardType = .webSearch
        return view
    }()
    
    private var label: UILabel?
    private var searchTableView: SearchFilmTableView?
    private var segmentControl: UISegmentedControl?
    private var recomendationCategory: FilmCategoryView!
    private var topFilmsCategory: FilmCategoryView!
    private var viewModel: (SearchViewModelInput & SearchViewModelOutput)!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchTextField.delegate = self
        title = ""
        viewModel = SearchViewModel(imdbService: ImdbService())
        addSubviews()
        makeConstraints()
        setupBinding()
        viewModel.viewDidLoad()
    }
    
    private func addSubviews() {
        navigationItem.titleView = UIImageView(image: Asset.smallLogo.image)
        view.backgroundColor = Asset.lightGray.color
        
        recomendationCategory = FilmCategoryView(
            categoryName: Text.Search.recomendation,
            collectionView: SearchFilmsCollectionView(isVertical: false, reachedLastRow: viewModel.viewReachedLastRow))
        
        topFilmsCategory = FilmCategoryView(
            categoryName: Text.Search.topFilms,
            collectionView: SearchFilmsCollectionView(isVertical: false, reachedLastRow: viewModel.viewReachedLastRow))
        
        recomendationCategory.allButton.addTarget(self, action: #selector(recomendedAllTapped), for: .touchUpInside)
        topFilmsCategory.allButton.addTarget(self, action: #selector(topFilmsAllTapped), for: .touchUpInside)
        
        view.addSubview(pageHeader)
        view.addSubview(mainFrame)
        view.addSubview(recomendationCategory)
        view.addSubview(topFilmsCategory)
        view.addSubview(bottomBorder)
        view.addSubview(searchTextField)
    }
    
    private func makeConstraints() {
        pageHeader.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(71)
        }
        mainFrame.snp.makeConstraints { make in
            make.top.equalTo(pageHeader.snp.bottom)
            make.horizontalEdges.equalToSuperview()
            make.height.equalToSuperview()
        }
        bottomBorder.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(1)
        }
        searchTextField.snp.makeConstraints { make in
            make.top.equalTo(pageHeader.snp.bottom).offset(Grid.verticalOffset_m)
            make.horizontalEdges.equalToSuperview().inset(Grid.horizontalInset)
            make.height.equalTo(40)
        }
        recomendationCategory.snp.makeConstraints { make in
            make.top.equalTo(searchTextField.snp.bottom).offset(Grid.verticalOffset_l)
            make.leading.equalToSuperview().inset(Grid.horizontalInset)
            make.trailing.equalToSuperview()
            make.height.equalTo(260)
        }
        topFilmsCategory.snp.makeConstraints { make in
            make.top.equalTo(recomendationCategory.snp.bottom).offset(Grid.verticalOffset_l)
            make.leading.equalToSuperview().inset(Grid.horizontalInset)
            make.trailing.equalToSuperview()
            make.height.equalTo(260)
        }
    }
    
    private func setupBinding() {
        viewModel.didLoadRecomendedFilms = { films in
            DispatchQueue.main.async {
                self.recomendationCategory.collectionView.addFilms(films: films)
                self.recomendationCategory.collectionView.reloadData()
            }
        }
        viewModel.didLoadTopFilms = { films in
            DispatchQueue.main.async {
                self.topFilmsCategory.collectionView.addFilms(films: films)
                self.topFilmsCategory.collectionView.reloadData()
            }
        }
        viewModel.didLoadRecomendedFilmsPosters = { posters in
            DispatchQueue.main.async {
                self.recomendationCategory.collectionView.addPostersData(postersData: posters)
                self.recomendationCategory.collectionView.reloadData()
            }
        }
        viewModel.didLoadTopFilmsPosters = { posters in
            self.topFilmsCategory.collectionView.addPostersData(postersData: posters)
            self.topFilmsCategory.collectionView.reloadData()
        }
        
        viewModel.didLoadSearchedFIlms = { films in
            DispatchQueue.main.async {
                self.searchTableView?.addFilms(films: films)
                self.searchTableView?.reloadData()
            }
        }
        
        viewModel.didLoadSearchedFilmsPostres = { posters in
            DispatchQueue.main.async {
                self.searchTableView?.addPostersData(postersData: posters)
                self.searchTableView?.reloadData()
            }
        }
    }
    
    @objc func recomendedAllTapped() {
        let recomendedFilmsVC = CategoryFilmsViewController(filmsCategory: .recomended)
        self.navigationController?.pushViewController(recomendedFilmsVC, animated: true)
    }
    
    @objc func topFilmsAllTapped() {
        let topFilmsVC = CategoryFilmsViewController(filmsCategory: .top)
        self.navigationController?.pushViewController(topFilmsVC, animated: true)
    }
}

extension SearchViewController: UITextFieldDelegate {
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        removeViewsAfterEditing()
        recomendationCategory.isHidden = false
        topFilmsCategory.isHidden = false
        searchTableView?.removeFromSuperview()
        
        searchTextField.snp.remakeConstraints { make in
            make.top.equalTo(pageHeader.snp.bottom).offset(Grid.verticalOffset_m)
            make.horizontalEdges.equalToSuperview().inset(Grid.horizontalInset)
            make.height.equalTo(40)
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        recomendationCategory.isHidden = true
        topFilmsCategory.isHidden = true
        addViewsWhileEditing(isEmpty: textField.text?.isEmpty ?? true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        removeViewsAfterEditing()
        
        searchTableView = SearchFilmTableView()
        guard let searchTableView = searchTableView else { return false }
        view.addSubview(searchTableView)
        
        searchTableView.snp.makeConstraints({ make in
            make.leading.trailing.equalToSuperview().inset(Grid.horizontalInset)
            make.top.equalTo(searchTextField.snp.bottom).offset(Grid.verticalOffset_l)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        })
        
        viewModel.searchDidEnd(text: textField.text)
        return true
    }
    
    func addViewsWhileEditing(isEmpty: Bool) {
        segmentControl = UISegmentedControl(items: [Text.Search.imdb, Text.Films.collection])
        guard let segmentControl = segmentControl else { return }
        segmentControl.setTitleTextAttributes([
            NSAttributedString.Key.font: FontFamily.SFProText.medium.font(size: 16)], for: .normal)
        segmentControl.selectedSegmentIndex = 0
        view.addSubview(segmentControl)
        
        segmentControl.snp.makeConstraints { make in
            make.top.equalTo(pageHeader.snp.bottom).offset(Grid.verticalOffset_m)
            make.horizontalEdges.equalToSuperview().inset(Grid.horizontalInset)
            make.centerX.equalToSuperview()
            make.height.equalTo(40)
        }
        searchTextField.snp.remakeConstraints { make in
            make.top.equalTo(segmentControl.snp.bottom).offset(Grid.verticalOffset_m)
            make.horizontalEdges.equalToSuperview().inset(Grid.horizontalInset)
            make.height.equalTo(40)
        }
        
        if isEmpty {
            label = UILabel()
            guard let label = label else { return }
            label.text = Text.Search.hint
            label.font = FontFamily.SFProText.regular.font(size: 16)
            label.textColor = Asset.darkGray.color
            label.numberOfLines = 0
            view.addSubview(label)
            
            label.snp.makeConstraints { make in
                make.top.equalTo(searchTextField.snp.bottom).offset(Grid.verticalOffset_l)
                make.horizontalEdges.equalToSuperview().inset(Grid.horizontalInset)
                make.height.equalTo(50)
            }
        }
    }
    
    func removeViewsAfterEditing() {
        label?.removeFromSuperview()
    }
}

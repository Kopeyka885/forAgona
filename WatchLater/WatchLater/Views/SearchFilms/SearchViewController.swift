//
//  SearchViewController.swift
//  StartProject-ios
//
//  Created by Камиль Кадыров on 20.10.2022.
//  Copyright © 2022 TEKHNOKRATIYA. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    
    private var searchTableView = SearchFilmsTableView()
    private var recomendationCategory: CategoryFilmsView!
    private var topFilmsCategory: CategoryFilmsView!
    private var viewModel: (SearchViewModelInput & SearchViewModelOutput)!
    
    private let searchTextField: UISearchTextField = {
        let view = UISearchTextField()
        view.placeholder = Text.Search.textfieldPlaceholder
        view.keyboardType = .webSearch
        view.clearButtonMode = .always
        view.text = ""
        return view
    }()
    
    private var label: UILabel = {
        let view = UILabel()
        view.isHidden = true
        view.text = Text.Search.hint
        view.font = FontFamily.SFProText.regular.font(size: 16)
        view.textColor = Asset.darkGray.color
        view.numberOfLines = 0
        return view
    }()
    
    private var segmentControl: UISegmentedControl = {
        let view = UISegmentedControl(items: [Text.Search.imdb, Text.Films.collection])
        view.isHidden = true
        view.setTitleTextAttributes([.font: FontFamily.SFProText.medium.font(size: 16)], for: .normal)
        view.selectedSegmentIndex = 0
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchTextField.delegate = self
        viewModel = SearchViewModel(imdbService: ImdbService())
        addSubviews()
        makeConstraints()
        setupBinding()
        viewModel.viewDidLoad()
    }
    
    private func addSubviews() {
        navigationItem.titleView = UIImageView(image: Asset.smallLogo.image)
        view.backgroundColor = Asset.lightGray.color
        searchTableView.isHidden = true
        
        recomendationCategory = CategoryFilmsView(
            categoryName: Text.Search.recomendation,
            collectionView: SearchFilmsCollectionView(isVertical: false, reachedLastRow: viewModel.viewReachedLastRow))
        
        topFilmsCategory = CategoryFilmsView(
            categoryName: Text.Search.topFilms,
            collectionView: SearchFilmsCollectionView(isVertical: false, reachedLastRow: viewModel.viewReachedLastRow))
        
        recomendationCategory.allButton.addTarget(self, action: #selector(recomendedAllTapped), for: .touchUpInside)
        topFilmsCategory.allButton.addTarget(self, action: #selector(topFilmsAllTapped), for: .touchUpInside)
        
        navigationController?.navigationBar.prefersLargeTitles = true
        title = Text.Search.search
        navigationController?.navigationBar.layer.shadowColor = Asset.lightGray.color.cgColor
        navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 0, height: 1)
        navigationController?.navigationBar.layer.shadowOpacity = 1
        
        view.addSubview(label)
        view.addSubview(segmentControl)
        view.addSubview(searchTableView)
        view.addSubview(recomendationCategory)
        view.addSubview(topFilmsCategory)
        view.addSubview(searchTextField)
    }
    
    private func makeConstraints() {
        searchTextField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(Grid.verticalOffsetMedium)
            make.horizontalEdges.equalToSuperview().inset(Grid.horizontalInset)
            make.height.equalTo(Grid.textFieldHeight)
        }
        recomendationCategory.snp.makeConstraints { make in
            make.top.equalTo(searchTextField.snp.bottom).offset(Grid.verticalOffsetLarge)
            make.leading.equalToSuperview().inset(Grid.horizontalInset)
            make.trailing.equalToSuperview()
            make.height.equalTo(260)
        }
        topFilmsCategory.snp.makeConstraints { make in
            make.top.equalTo(recomendationCategory.snp.bottom).offset(Grid.verticalOffsetLarge)
            make.leading.equalToSuperview().inset(Grid.horizontalInset)
            make.trailing.equalToSuperview()
            make.height.equalTo(260)
        }
        label.snp.makeConstraints { make in
            make.top.equalTo(searchTextField.snp.bottom).offset(Grid.verticalOffsetLarge)
            make.horizontalEdges.equalToSuperview().inset(Grid.horizontalInset)
            make.height.equalTo(50)
        }
        segmentControl.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(Grid.verticalOffsetMedium)
            make.horizontalEdges.equalToSuperview().inset(Grid.horizontalInset)
            make.centerX.equalToSuperview()
            make.height.equalTo(Grid.segmentControlHeight)
        }
        searchTableView.snp.makeConstraints({ make in
            make.leading.trailing.equalToSuperview().inset(Grid.horizontalInset)
            make.top.equalTo(searchTextField.snp.bottom).offset(Grid.verticalOffsetLarge)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        })
    }
    
    private func setupBinding() {
        viewModel.didLoadFilms = { category, films in
            DispatchQueue.main.async {
                switch category {
                case .recomended:
                    self.recomendationCategory.collectionView.addFilms(films: films)
                    
                case .top:
                    self.topFilmsCategory.collectionView.addFilms(films: films)
                    
                case .search:
                    self.searchTableView.addFilms(films: films)
                }
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
        textField.text = ""
        DispatchQueue.main.async {
            textField.resignFirstResponder()
        }
        
        label.isHidden = true
        searchTableView.isHidden = true
        segmentControl.isHidden = true
        
        recomendationCategory.isHidden = false
        topFilmsCategory.isHidden = false
        
        searchTextField.snp.remakeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(Grid.verticalOffsetMedium)
            make.horizontalEdges.equalToSuperview().inset(Grid.horizontalInset)
            make.height.equalTo(40)
        }
        return false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        recomendationCategory.isHidden = true
        topFilmsCategory.isHidden = true
        label.isHidden = false
        segmentControl.isHidden = false
        
        searchTextField.snp.remakeConstraints { make in
            make.top.equalTo(segmentControl.snp.bottom).offset(Grid.verticalOffsetMedium)
            make.horizontalEdges.equalToSuperview().inset(Grid.horizontalInset)
            make.height.equalTo(40)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        label.isHidden = true
        searchTableView.isHidden = false
        viewModel.searchDidEnd(text: textField.text)
        textField.endEditing(true)
        return true
    }
}

//
//  FilmsViewController.swift
//  StartProject-ios
//
//  Created by Kamil Kadyrov on 13.09.2022.
//  Copyright © 2022 TEKHNOKRATIYA. All rights reserved.
//

import UIKit

class FilmsViewController: UIViewController {
    
    private let categorySwitcher: UISegmentedControl = {
        let segmentControl = UISegmentedControl(items: [Text.Films.willWatch, Text.Films.watched])
        segmentControl.setTitleTextAttributes([
            NSAttributedString.Key.font: FontFamily.SFProText.medium.font(size: 16)], for: .normal)
        segmentControl.selectedSegmentIndex = 0
        return segmentControl
    }()
    
    private var filmsCollectionView: FilmsCollectionView!
    private var filmsTableView: FilmTableView!
    private var viewModel: (FilmsViewModelInput & FilmsViewModelOutput)!
    private var isCollectionView = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = FilmsViewModel()
        addSubviews()
        makeConstraints()
        changePresenationMode()
        setupBinding()
        viewModel.viewDidLoad()
    }
    
    private func addSubviews() {
        view.backgroundColor = .white
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.topItem?.title = Text.Films.collection
        navigationController?.navigationBar.layer.shadowColor = Asset.lightGray.color.cgColor
        navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 0, height: 1)
        navigationController?.navigationBar.layer.shadowOpacity = 1
        navigationController?.navigationBar.barTintColor = Asset.lightGray.color
        
        filmsCollectionView = FilmsCollectionView(reachedLastRow: viewModel.viewReachedLastRow)
        filmsCollectionView.showCell = viewModel.showCell
        filmsTableView = FilmTableView(reachedLastRow: viewModel.viewReachedLastRow)
        
        let searchBtn = UIBarButtonItem(
            image: Asset.search.image,
            style: .plain,
            target: self,
            action: #selector(searchTapped))
        searchBtn.tintColor = Asset.agonaBlue.color
        
        let tableOrListBtn = UIBarButtonItem(
            image: Asset.list.image,
            style: .plain,
            target: self,
            action: #selector(listOrTableTapped))
        tableOrListBtn.tintColor = Asset.agonaBlue.color
        
        navigationItem.leftBarButtonItem = searchBtn
        navigationItem.rightBarButtonItem = tableOrListBtn
        navigationItem.titleView = UIImageView(image: Asset.smallLogo.image)
        
        view.addSubview(categorySwitcher)
        view.addSubview(filmsCollectionView)
        view.addSubview(filmsTableView)
    }
    
    private func makeConstraints() {
        categorySwitcher.snp.makeConstraints { make in
            make.width.equalToSuperview().inset(Grid.horizontalInset)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(Grid.verticalOffsetMedium)
            make.centerX.equalToSuperview()
            make.height.equalTo(Grid.segmentControlHeight)
        }
        filmsCollectionView.snp.makeConstraints { make in
            make.top.equalTo(categorySwitcher.snp.bottom).offset(Grid.verticalOffsetMedium)
            make.width.equalToSuperview().inset(Grid.horizontalInset)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
            make.centerX.equalToSuperview()
        }
        filmsTableView.snp.makeConstraints { make in
            make.top.equalTo(categorySwitcher.snp.bottom).offset(Grid.verticalOffsetMedium)
            make.width.equalToSuperview().inset(Grid.horizontalInset)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
            make.centerX.equalToSuperview()
        }
    }
    
    private func setupBinding() {
        viewModel.didLoadFilms = { films in
            DispatchQueue.main.async {
                self.filmsCollectionView.addFilms(films: films)
                guard let filmsTableView = self.filmsTableView else { return }
                filmsTableView.addFilms(films: films)
            }
        }
    }
    
    @objc func searchTapped() {
        let searchVC = SearchViewController()
        self.navigationController?.pushViewController(searchVC, animated: true)
    }
    
    @objc func listOrTableTapped() {
        self.viewModel.viewDidBeginRefreshing()
        DispatchQueue.main.async {
            self.changePresenationMode()
        }
    }
    
    func changePresenationMode() {
        isCollectionView = !isCollectionView
        if isCollectionView {
            if let filmsTableView = filmsTableView {
                filmsTableView.isHidden = true
                filmsCollectionView.isHidden = false
            }
            navigationItem.rightBarButtonItem?.image = Asset.table.image
        } else {
            filmsCollectionView.isHidden = true
            filmsTableView.isHidden = false
            navigationItem.rightBarButtonItem?.image = Asset.list.image
        }
    }
}

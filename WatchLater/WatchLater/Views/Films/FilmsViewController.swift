//
//  FilmsViewController.swift
//  StartProject-ios
//
//  Created by Kamil Kadyrov on 13.09.2022.
//  Copyright © 2022 TEKHNOKRATIYA. All rights reserved.
//

import UIKit

class FilmsViewController: UIViewController {
    
    private let pageHeader = PageHeader(text: Text.Films.collection)
    
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
    
    private let categorySwitcher: UISegmentedControl = {
        let segmentControl = UISegmentedControl(items: [Text.Films.willWatch, Text.Films.watched])
        segmentControl.setTitleTextAttributes([
            NSAttributedString.Key.font: FontFamily.SFProText.medium.font(size: 16)], for: .normal)
        segmentControl.selectedSegmentIndex = 0
        return segmentControl
    }()
    
    private var filmsCollectionView: FilmsCollectionView!
    private var filmsTableView: FilmTableView?
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
        view.backgroundColor = Asset.lightGray.color
        
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
        
        view.addSubview(pageHeader)
        view.addSubview(mainFrame)
        view.addSubview(categorySwitcher)
        view.addSubview(bottomBorder)
    }
    
    private func makeConstraints() {
        pageHeader.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(71)
        }
        mainFrame.snp.makeConstraints { make in
            make.top.equalTo(pageHeader.snp.bottom)
            make.width.equalToSuperview()
            make.height.equalToSuperview()
        }
        categorySwitcher.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.92)
            make.top.equalTo(pageHeader.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.height.equalTo(40)
        }
        bottomBorder.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(1)
        }
    }
    
    private func setupBinding() {
        viewModel.didLoadFilms = { films in
            DispatchQueue.main.async {
                self.filmsCollectionView.addFilms(films: films)
                self.filmsCollectionView.reloadData()
                guard let filmsTableView = self.filmsTableView else { return }
                filmsTableView.addFilms(films: films)
                filmsTableView.reloadData()
            }
        }
        viewModel.didLoadPosters = { posters in
            DispatchQueue.main.async {
                self.filmsCollectionView.addPostersData(postersData: posters)
                self.filmsCollectionView.reloadData()
                guard let filmsTableView = self.filmsTableView else { return }
                filmsTableView.addPostersData(postersData: posters)
                filmsTableView.reloadData()
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
                filmsTableView.removeFromSuperview()
            }
            navigationItem.rightBarButtonItem?.image = Asset.table.image
            filmsCollectionView = FilmsCollectionView(reachedLastRow: viewModel.viewReachedLastRow)
            view.addSubview(filmsCollectionView)
            filmsCollectionView.snp.makeConstraints { make in
                make.top.equalTo(categorySwitcher.snp.bottom).offset(20)
                make.width.equalToSuperview().multipliedBy(0.92)
                make.bottom.equalTo(view.safeAreaLayoutGuide)
                make.centerX.equalToSuperview()
            }
        } else {
            filmsCollectionView.removeFromSuperview()
            navigationItem.rightBarButtonItem?.image = Asset.list.image
            filmsTableView = FilmTableView(reachedLastRow: viewModel.viewReachedLastRow)
            guard let filmsTableView = filmsTableView else { return }
            view.addSubview(filmsTableView)
            filmsTableView.snp.makeConstraints { make in
                make.top.equalTo(categorySwitcher.snp.bottom).offset(20)
                make.width.equalToSuperview().multipliedBy(0.92)
                make.bottom.equalTo(view.safeAreaLayoutGuide)
                make.centerX.equalToSuperview()
            }
        }
    }
}

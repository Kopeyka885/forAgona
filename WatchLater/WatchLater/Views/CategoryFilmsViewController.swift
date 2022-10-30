//
//  CategoryFilmsViewController.swift
//  StartProject-ios
//
//  Created by Камиль Кадыров on 26.10.2022.
//

import UIKit

class CategoryFilmsViewController: UIViewController {

    private var pageHeader: PageHeader
    private var filmsCollection: (FilmsCollectable & UIView)!
    private var viewModel: (RecomendedFilmsViewModelInput & RecomendedFilmsViewModelOutput)!
    private var filmsCategory: FilmCategory
    
    init(filmsCategory: FilmCategory) {
        switch filmsCategory {
        case .recomended:
            pageHeader = PageHeader(text: Text.Search.recomendation)
            
        case .top:
            pageHeader = PageHeader(text: Text.Search.topFilms)
        }
        self.filmsCategory = filmsCategory
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = RecomendedFilmsViewModel(filmsCategory: filmsCategory)
        filmsCollection = FilmsCollectionView(reachedLastRow: viewModel.viewReachedLastRow)
        addSubviews()
        makeConstraints()
        setupBinding()
        viewModel.viewDidLoad()
    }
    
    private func addSubviews() {
        view.backgroundColor = .white
        view.addSubview(pageHeader)
        view.addSubview(filmsCollection)
    }
    
    private func makeConstraints() {
        pageHeader.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(71)
        }
        filmsCollection.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(Grid.horizontalInset)
            make.top.equalTo(pageHeader.snp.bottom).offset(Grid.verticalOffset_m)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func setupBinding() {
        viewModel.didLoadFilms = { films in
            DispatchQueue.main.async {
                self.filmsCollection.addFilms(films: films)
                self.filmsCollection.reloadData()
            }
        }
        viewModel.didLoadPosters = { posters in
            DispatchQueue.main.async {
                self.filmsCollection.addPostersData(postersData: posters)
                self.filmsCollection.reloadData()
            }
        }
    }
}

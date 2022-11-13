//
//  CategoryFilmsViewController.swift
//  StartProject-ios
//
//  Created by Камиль Кадыров on 26.10.2022.
//

import UIKit

class CategoryFilmsViewController: UIViewController {
    
    private var filmsCollection: CategoryFilmsCollectionView!
    private var viewModel: (CategoryFilmsViewModelInput & CategoryFilmsViewModelOutput)!
    private var filmsCategory: FilmCategory
    
    init(filmsCategory: FilmCategory) {
        self.filmsCategory = filmsCategory
        super.init(nibName: nil, bundle: nil)
        switch filmsCategory {
        case .recomended:
            title = Text.Search.recomendation
            
        case .top:
            title = Text.Search.topFilms
            
        case .search:
            title = Text.Search.search
        }
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = CategoryFilmsViewModel(filmsCategory: filmsCategory)
        filmsCollection = CategoryFilmsCollectionView(reachedLastRow: viewModel.viewReachedLastRow)
        addSubviews()
        makeConstraints()
        setupBinding()
        viewModel.viewDidLoad()
    }
    
    private func addSubviews() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.layer.shadowColor = Asset.lightGray.color.cgColor
        navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 0, height: 1)
        navigationController?.navigationBar.layer.shadowOpacity = 1
        
        view.backgroundColor = .white
        view.addSubview(filmsCollection)
    }
    
    private func makeConstraints() {
        filmsCollection.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(Grid.horizontalInset)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(Grid.verticalOffsetMedium)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func setupBinding() {
        viewModel.didLoadFilms = { films in
            DispatchQueue.main.async {
                self.filmsCollection.addFilms(films: films)
            }
        }
    }
}

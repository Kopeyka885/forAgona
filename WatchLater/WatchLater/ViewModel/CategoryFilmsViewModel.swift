//
//  CategoryFilmsViewModel.swift
//  StartProject-ios
//
//  Created by Камиль Кадыров on 26.10.2022.
//

import Foundation

protocol CategoryFilmsViewModelInput {
    func viewDidLoad()
    func viewReachedLastRow()
}

protocol CategoryFilmsViewModelOutput {
    var didLoadFilms: ((_ films: [Film]) -> Void)? { get set }
}

final class CategoryFilmsViewModel: CategoryFilmsViewModelInput, CategoryFilmsViewModelOutput {
    var didLoadFilms: (([Film]) -> Void)?
    private let imdbService = ImdbService()
    private var currentPage = 0
    private let pageSize = 30
    private var filmsCategory: FilmCategory
    
    init(filmsCategory: FilmCategory) {
        self.filmsCategory = filmsCategory
    }
    
    private func processingResponse(response: Result<ImdbFilmPage, Error>) {
        switch response {
        case .success(let filmPage):
            let films = filmPage.items.map { item in
                Film(
                    id: Int(item.rank) ?? 0,
                    title: item.title,
                    posterId: item.image,
                    description: nil,
                    genres: nil,
                    rating: Float(item.imDbRating) ?? 0,
                    date: item.year
                )
            }
            currentPage += 1
            didLoadFilms?(films)
            
        case .failure(let error):
            print(error.localizedDescription)
        }
    }
    
    func viewDidLoad() {
        imdbService.getFIlms(category: filmsCategory) { response in
            self.processingResponse(response: response)
        }
    }
    
    func viewReachedLastRow() {}
}

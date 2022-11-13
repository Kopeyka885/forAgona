//
//  SearchViewModel.swift
//  StartProject-ios
//
//  Created by Камиль Кадыров on 22.10.2022.
//

import Foundation

protocol SearchViewModelInput {
    func viewDidLoad()
    func viewReachedLastRow()
    func searchDidEnd(text: String?)
}

protocol SearchViewModelOutput {
    var didLoadFilms: ((_ category: FilmCategory, _ films: [Film]) -> Void)? { get set }
}

final class SearchViewModel: SearchViewModelInput, SearchViewModelOutput {
    let amountOfFilmsToShow = 15
    var didLoadFilms: ((_ category: FilmCategory, _ films: [Film]) -> Void)?
    private let imdbService: ImdbServiceProtocol
    
    init(imdbService: ImdbServiceProtocol) {
        self.imdbService = imdbService
    }
    
    func viewDidLoad() {
        downloadCategoryFilms(category: .recomended)
        downloadCategoryFilms(category: .top)
    }
    
    func viewReachedLastRow() {
        print("do nothing")
    }
    
    func searchDidEnd(text: String?) {
        imdbService.searchFilmsByTitle(searchQuery: text) { response in
            switch response {
            case .success(let searchResult):
                let films = searchResult.results.map { item in
                    Film(
                        id: Int(item.id[item.id.index(item.id.startIndex, offsetBy: 2)...]) ?? 0,
                        title: item.title,
                        posterId: item.image,
                        description: item.description,
                        genres: nil,
                        rating: nil,
                        date: nil)
                }
                self.didLoadFilms?(.search, films)
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func downloadCategoryFilms(category: FilmCategory) {
        imdbService.getFIlms(category: category) { response in
            switch response {
            case .success(let imdbFilmPage):
                let films = imdbFilmPage.items[...self.amountOfFilmsToShow].map { item in
                    Film(
                        id: Int(item.rank) ?? 0,
                        title: item.title,
                        posterId: item.image,
                        description: nil,
                        genres: nil,
                        rating: Float(item.imDbRating) ?? 0,
                        date: item.year)
                }
                self.didLoadFilms?(category, films)
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

enum FilmCategory: String {
    case recomended = "/MostPopularMovies/"
    case top = "/Top250Movies/"
    case search = "/SearchMovie/"
}

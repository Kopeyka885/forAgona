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
    var didLoadRecomendedFilms: ((_ films: [Film]) -> Void)? { get set }
    var didLoadTopFilms: ((_ films: [Film]) -> Void)? { get set }
    var didLoadRecomendedFilmsPosters: ((_ posters: [Int: Data]) -> Void)? { get set }
    var didLoadTopFilmsPosters: ((_ posters: [Int: Data]) -> Void)? { get set }
}

final class SearchViewModel: SearchViewModelInput, SearchViewModelOutput {
    var didLoadRecomendedFilms: (([Film]) -> Void)?
    var didLoadTopFilms: (([Film]) -> Void)?
    var didLoadRecomendedFilmsPosters: (([Int: Data]) -> Void)?
    var didLoadTopFilmsPosters: ((_ posters: [Int: Data]) -> Void)?
    private let imdbService: ImdbServiceProtocol
    
    init(imdbService: ImdbServiceProtocol) {
        self.imdbService = imdbService
    }
    
    func viewDidLoad() {
        imdbService.getRecomendationFIlms { response in
            switch response {
            case .success(let imdbFilmPage):
                var films = [Film]()
                for item in imdbFilmPage.items[...15] {
                    let film = Film(id: Int(item.rank) ?? 0,
                                    title: item.title,
                                    posterId: item.image,
                                    description: nil,
                                    genres: nil,
                                    rating: Float(item.imDbRating) ?? 0,
                                    date: item.year)
                    films.append(film)
                }
                self.didLoadRecomendedFilms?(films)
                self.downloadFilmsPosters(filmCategory: .recomended, films: films)
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        imdbService.getTopFIlms { response in
            switch response {
            case .success(let imdbFilmPage):
                var films = [Film]()
                for item in imdbFilmPage.items[...15] {
                    let film = Film(id: Int(item.rank) ?? 0,
                                    title: item.title,
                                    posterId: item.image,
                                    description: nil,
                                    genres: nil,
                                    rating: Float(item.imDbRating) ?? 0,
                                    date: item.year)
                    films.append(film)
                }
                self.didLoadTopFilms?(films)
                self.downloadFilmsPosters(filmCategory: .top, films: films)
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    func viewReachedLastRow() {
        print("do nothing")
    }
    
    func searchDidEnd(text: String?) {
        imdbService.searchFilmsByTitle(searchQuery: text) { response in
            switch response {
            case .success(let searchResult):
                print("idi nahuy zaebal")
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func downloadFilmsPosters(filmCategory: FilmCategory, films: [Film]) {
        let group = DispatchGroup()
        var posters = [Int: Data]()
        for film in films {
            group.enter()
            imdbService.downloadPoster(url: film.posterId ?? "") { response in
                switch response {
                case .success(let data):
                    posters[film.id] = data
                    
                case .failure(let error):
                    print(error)
                }
                group.leave()
            }
        }
        group.notify(queue: .main) {
            switch filmCategory {
            case .recomended:
                self.didLoadRecomendedFilmsPosters?(posters)
                
            case .top:
                self.didLoadTopFilmsPosters?(posters)
            }
        }
    }
}

enum FilmCategory {
    case recomended
    case top
}

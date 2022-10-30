//
//  RecomendedFilmsViewModel.swift
//  StartProject-ios
//
//  Created by Камиль Кадыров on 26.10.2022.
//

import Foundation

protocol RecomendedFilmsViewModelInput {
    func viewDidLoad()
    func viewReachedLastRow()
}

protocol RecomendedFilmsViewModelOutput {
    var didLoadFilms: ((_ films: [Film]) -> Void)? { get set }
    var didLoadPosters: ((_ posters: [Int: Data?]) -> Void)? { get set }
}

final class RecomendedFilmsViewModel: RecomendedFilmsViewModelInput, RecomendedFilmsViewModelOutput {
    var didLoadFilms: (([Film]) -> Void)?
    var didLoadPosters: (([Int: Data?]) -> Void)?
    private let imdbService = ImdbService()
    private var films = [Film]()
    private var images = [Int: String]()
    private var currentPage = 0
    private let pageSize = 30
    private var filmsCategory: FilmCategory

    init(filmsCategory: FilmCategory) {
        self.filmsCategory = filmsCategory
    }
    
    private func processingResponse(response: Result<ImdbFilmPage, Error>) {
        switch response {
        case .success(let filmPage):
            var films = [Film]()
            for item in filmPage.items {
                let film = Film(id: Int(item.rank) ?? 0,
                                title: item.title,
                                posterId: item.image,
                                description: nil,
                                genres: nil,
                                rating: Float(item.imDbRating) ?? 0,
                                date: item.year)
                films.append(film)
                self.images[film.id] = film.posterId
            }
            self.films = films
            self.loadNextPage()
            
        case .failure(let error):
            print(error.localizedDescription)
        }
    }
    
    func viewDidLoad() {
        switch filmsCategory {
        case .recomended:
            imdbService.getRecomendationFIlms { response in
                self.processingResponse(response: response)
            }
            
        case .top:
            imdbService.getTopFIlms { response in
                self.processingResponse(response: response)
            }
        }
    }
    
    func viewReachedLastRow() {
        print("images.count / pageSize = \(images.count / pageSize)")
        if currentPage < images.count / pageSize {
            loadNextPage()
            print("current page: \(currentPage)")
        }
    }
    
    private func loadNextPage() {
        let group = DispatchGroup()
        var posters = [Int: Data?]()
        
        let startIndex = currentPage * pageSize
        let endIndex = (currentPage + 1) * pageSize
        for i in startIndex..<endIndex {
            group.enter()
            imdbService.downloadPoster(url: images[i + 1] ?? "") { response in
                switch response {
                case .success(let data):
                    posters[i + 1] = data
                    group.leave()
                    
                case .failure(let error):
                    print(error.localizedDescription)
                    group.leave()
                }
            }
        }
        let filmsPage = Array(films[currentPage * (pageSize)..<(currentPage + 1) * pageSize])
        currentPage += 1
        group.notify(queue: .main) {
            self.didLoadPosters?(posters)
            self.didLoadFilms?(filmsPage)
        }
    }
}

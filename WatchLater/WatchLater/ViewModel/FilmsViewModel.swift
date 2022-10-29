//
//  FilmsViewModel.swift
//  StartProject-ios
//
//  Created by Kamil Kadyrov on 15.10.2022.
//  Copyright © 2022 TEKHNOKRATIYA. All rights reserved.
//

import Foundation

protocol FilmsViewModelInput {
    func viewDidLoad()
    func viewDidBeginRefreshing()
    func viewReachedLastRow()
}
protocol FilmsViewModelOutput {
    var didLoadFilms: ((_ films: [Film]) -> Void)? { get set }
    var didLoadPosters: ((_ posters: [Int: Data?]) -> Void)? { get set }
}

final class FilmsViewModel: FilmsViewModelInput, FilmsViewModelOutput {
    
    var didLoadFilms: ((_ films: [Film]) -> Void)?
    var didLoadPosters: ((_ posters: [Int: Data?]) -> Void)?
    private var pageNumber = 0
    private let pageSize = 30
    private var maxPageNumber = Int.max
    private let filmsService: FilmsServiceProtocol
    
    init(filmsService: FilmsServiceProtocol) {
        self.filmsService = filmsService
    }
    
    func viewDidLoad() {
        loadNextPage()
    }
    
    func viewReachedLastRow() {
        loadNextPage()
    }
    
    func viewDidBeginRefreshing() {
        pageNumber = 0
        loadNextPage()
    }
    
    private func loadNextPage() {
        guard pageNumber < maxPageNumber else { return }
        
        filmsService.downloadFilmsPage(page: pageNumber, size: pageSize) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let page):
                self.maxPageNumber = page.pageCount
                self.didLoadFilms?(page.filmDtos)
                self.downloadFilmsPosters(films: page.filmDtos)
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        self.pageNumber += 1
    }
    
    private func downloadFilmsPosters(films: [Film]) {
        let group = DispatchGroup()
        var posters = [Int: Data?]()
        for film in films {
            group.enter()
            filmsService.downloadPoster(filmId: film.id, posterId: film.posterId) { response in
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
            self.didLoadPosters?(posters)
        }
    }
}

//
//  FilmsViewModel.swift
//  StartProject-ios
//
//  Created by Kamil Kadyrov on 15.10.2022.
//  Copyright © 2022 TEKHNOKRATIYA. All rights reserved.
//

import Foundation
import Kingfisher

protocol FilmsViewModelInput {
    func viewDidLoad()
    func viewDidBeginRefreshing()
    func viewReachedLastRow()
    func showCell(_ cell: FilmCollectionViewCell, _ posterId: String, _ index: IndexPath)
}
protocol FilmsViewModelOutput {
    var didLoadFilms: ((_ films: [Film]) -> Void)? { get set }
    var didLoadPosters: ((_ posters: [Int: Data]) -> Void)? { get set }
}

final class FilmsViewModel: FilmsViewModelInput, FilmsViewModelOutput {
    
    var didLoadFilms: ((_ films: [Film]) -> Void)?
    var didLoadPosters: ((_ posters: [Int: Data]) -> Void)?
    private var pageNumber = 0
    private let pageSize = 30
    private var maxPageNumber = Int.max
    private let filmsService = FilmsService()
    
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
    
    func showCell(_ cell: FilmCollectionViewCell, _ posterId: String, _ indexPath: IndexPath) {
        var key = ""
        DispatchQueue.main.async {
            key = cell.title.text ?? ""
        }
        ImageCache.default.retrieveImage(forKey: key, options: nil, completionHandler: { image, cacheType in
            if let image = image {
                DispatchQueue.main.async {
                    cell.imageView.image = image
                }
            } else {
                FilmsService().downloadPoster(posterId: posterId) { response in
                    switch response {
                    case .success(let data):
                        let image = Kingfisher.image(data: data ?? Data(),
                                                     scale: 1,
                                                     preloadAllAnimationData: true,
                                                     onlyFirstFrame: true)
                        ImageCache.default.store(image ?? Image(), forKey: key)
                        DispatchQueue.main.async {
                            cell.imageView.image = image
                        }
                        
                    case .failure(let error):
                        print(error)
                    }
                }
            }
        })
    }
    
    private func loadNextPage() {
        guard pageNumber < maxPageNumber else { return }
        
        filmsService.downloadFilmsPage(page: pageNumber, size: pageSize) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let page):
                let films = page.filmDtos.map { item in
                    Film(
                        id: item.id,
                        title: item.title,
                        posterId: item.posterId,
                        description: item.description,
                        genres: item.genres,
                        rating: item.rating,
                        date: item.timestamp
                    )
                }
                self.maxPageNumber = page.pageCount
                self.didLoadFilms?(films)
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        self.pageNumber += 1
    }
}

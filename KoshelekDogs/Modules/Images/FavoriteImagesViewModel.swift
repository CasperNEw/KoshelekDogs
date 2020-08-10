//
//  FavoriteImagesViewModel.swift
//  KoshelekDogs
//
//  Created by Дмитрий Константинов on 10.08.2020.
//  Copyright © 2020 Дмитрий Константинов. All rights reserved.
//

import UIKit

class FavoriteImagesViewModel: ImagesViewModelProtocol {

    // MARK: - Properties
    private var dog: FavoriteDog?

    private var images: Set<Image> = []
    private let networkService: NetworkService
    private let database: FavoriteRepository

    var loadDataCompletion: ((Result<(title: String, images: [Image]), Error>) -> Void)?

    // MARK: - Initialization
    init(networkService: NetworkService,
         database: FavoriteRepository) {

        self.networkService = networkService
        self.database = database
    }

    // MARK: - Public functions
    public func loadData() {
        guard let dog = dog else { return }

        let group = DispatchGroup()
        dog.urls.forEach { url in

            group.enter()
            networkService.getImageData(with: url) { result in

                switch result {
                case .success(let data):
                    self.images.insert(Image(breed: dog.breed,
                                             url: url,
                                             data: data,
                                             isFavorite: true))
                case .failure(let error):
                    self.loadDataCompletion?(.failure(error))
                }
                group.leave()
            }
        }

        group.notify(queue: .main) {
            self.loadDataCompletion?(.success((title: dog.breed, images: Array(self.images))))
        }
    }

    public func changeFavorite(image: Image) {
        guard let dog = dog else { return }

        switch image.isFavorite {
        case true:
            database.removeFromFavorite(breed: image.breed,
                                        url: image.url) { result in

                        switch result {
                        case .success:
                            self.images.remove(image)
                            self.loadDataCompletion?(.success((title: dog.breed,
                                                               images: Array(self.images))))

                        case .failure(let error):
                            self.loadDataCompletion?(.failure(error))
                        }
            }

        case false:
            break
        }
    }
}

// MARK: - ImagesViewModelInput
extension FavoriteImagesViewModel: ImagesViewModelInput {

    func configure(with dog: (breed: String, subBreed: String)) { }

    func configure(with dog: FavoriteDog) {
        self.dog = dog
    }
}

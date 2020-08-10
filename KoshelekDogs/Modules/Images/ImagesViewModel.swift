//
//  ImagesViewModel.swift
//  KoshelekDogs
//
//  Created by Дмитрий Константинов on 10.08.2020.
//  Copyright © 2020 Дмитрий Константинов. All rights reserved.
//

import UIKit

protocol ImagesViewModelInput {
    func configure(with dog: (breed: String, subBreed: String))
    func configure(with dog: FavoriteDog)
}

protocol ImagesViewModelProtocol {
    var loadDataCompletion: ((Result<(title: String, images: [Image]), Error>) -> Void)? { get set }
    func loadData()
    func changeFavorite(image: Image)

}

class ImagesViewModel: ImagesViewModelProtocol {

    // MARK: - Properties
    private var dog: (breed: String, subBreed: String) = ("", "")
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

        networkService.getImages(dog: dog) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let images):

                images.forEach { self.images.insert($0) }
                let breed = self.dog.subBreed.isEmpty ? self.dog.breed : self.dog.subBreed
                self.database.getFavorite(breed: breed,
                                           completion: { result in

                            switch result {
                            case .success(let favorite):
                                favorite?.urls?.forEach({ url in
                                    self.images.forEach { image in
                                        if image.url == url {
                                            self.images.insert(Image(breed: image.breed,
                                                                     url: image.url,
                                                                     data: image.data,
                                                                     isFavorite: true))
                                        }
                                    }
                                })
                                self.loadDataCompletion?(.success((title: self.dog.breed,
                                                                   images: Array(self.images))))
                            case .failure(let error):
                                print(error)
                                return
                            }
                })

            case .failure(let error):
                self.loadDataCompletion?(.failure(error))
            }
        }
    }

    public func changeFavorite(image: Image) {

        switch image.isFavorite {
        case true:
            database.removeFromFavorite(breed: image.breed,
                                        url: image.url) { result in

                        switch result {
                        case .success:
                            self.images.remove(image)
                            self.images.insert(Image(breed: image.breed,
                                                url: image.url,
                                                data: image.data,
                                                isFavorite: !image.isFavorite))

                            self.loadDataCompletion?(.success((title: self.dog.breed,
                                                               images: Array(self.images))))

                        case .failure(let error):
                            self.loadDataCompletion?(.failure(error))
                        }
            }

        case false:
            database.addToFavorite(breed: image.breed,
                                   url: image.url) { result in

                                    switch result {
                                    case .success:
                                        self.images.remove(image)
                                        self.images.insert(Image(breed: image.breed,
                                                                 url: image.url,
                                                                 data: image.data,
                                                                 isFavorite: !image.isFavorite))

                                        self.loadDataCompletion?(.success((title: self.dog.breed,
                                                                           images: Array(self.images))))

                                    case .failure(let error):
                                        self.loadDataCompletion?(.failure(error))
                                    }
            }
        }
    }
}

// MARK: - ImagesViewModelInput
extension ImagesViewModel: ImagesViewModelInput {

    func configure(with dog: FavoriteDog) { }

    func configure(with dog: (breed: String, subBreed: String)) {
        self.dog = dog
    }
}

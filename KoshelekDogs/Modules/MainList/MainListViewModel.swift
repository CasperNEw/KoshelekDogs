//
//  MainListViewModel.swift
//  KoshelekDogs
//
//  Created by Дмитрий Константинов on 10.08.2020.
//  Copyright © 2020 Дмитрий Константинов. All rights reserved.
//

protocol MainListViewModelInput {
    func configure(with data: Any?)
}

class MainListViewModel {

    // MARK: - Properties
    private let networkService: NetworkService
    private let database: FavoriteRepository
    private var allDogs: [Dog] = []
    private var favoriteDogs: [FavoriteDog] = []

    enum DataType {
        case all(_ value: [Dog] = [])
        case favorite(_ value: [FavoriteDog] = [])
    }

    var loadDataCompletion: ((Result<DataType, Error>) -> Void)?

    // MARK: - Initialization
    init(networkService: NetworkService,
         database: FavoriteRepository) {

        self.networkService = networkService
        self.database = database
    }

    // MARK: - Public functions
    public func loadData() {

        networkService.getDogsList { result in

            switch result {
            case .success(let dogs):
                self.allDogs = dogs
                self.loadDataCompletion?(.success(.all(dogs)))
            case .failure(let error):
                self.loadDataCompletion?(.failure(error))
            }
        }
    }

    public func changeMode(mode: DataType) {

        switch mode {
        case .all:
            loadDataCompletion?(.success(.all(allDogs)))
        case .favorite:
            database.getAllFavorites { result in

                var favoriteDogs: [FavoriteDog] = []
                switch result {
                case .success(let favorites):
                    favorites.forEach { favorite in
                        guard let breed = favorite.breed, let urls = favorite.urls else { return }
                        favoriteDogs.append(FavoriteDog(breed: breed, urls: urls))

                    }
                    self.favoriteDogs = favoriteDogs
                    self.loadDataCompletion?(.success(.favorite(self.favoriteDogs)))
                case .failure(let error):
                    self.loadDataCompletion?(.failure(error))
                }
            }
        }
    }
}

// MARK: - Module functions
extension MainListViewModel { }

// MARK: - MainListViewModelInput
extension MainListViewModel: MainListViewModelInput {

    func configure(with data: Any?) { }

}

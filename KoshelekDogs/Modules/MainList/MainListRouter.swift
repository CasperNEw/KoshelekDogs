//
//  MainListRouter.swift
//  KoshelekDogs
//
//  Created by Дмитрий Константинов on 10.08.2020.
//  Copyright © 2020 Дмитрий Константинов. All rights reserved.
//

protocol MainListRouterInput {
    func pushSubBreedViewController(with dog: Dog)
    func pushImagesViewController(breed: String, subBreed: String)
    func pushImagesViewController(favoriteDog: FavoriteDog)
}

class MainListRouter: MainListRouterInput {

    // MARK: - Properties
    weak var viewController: MainListViewController?

    // MARK: - MainListRouterInput
    func pushSubBreedViewController(with dog: Dog) {

        let viewController = SubBreedViewController(dog: dog)
        viewController.delegate = self.viewController
        self.viewController?.navigationController?.pushViewController(viewController, animated: true)
    }

    func pushImagesViewController(breed: String, subBreed: String) {

        let viewController = ImagesConfigurator.create()
        let viewModelInput = ImagesConfigurator.configure(with: viewController)
        viewModelInput.configure(with: (breed, subBreed))
        self.viewController?.navigationController?.pushViewController(viewController, animated: true)
    }

    func pushImagesViewController(favoriteDog: FavoriteDog) {

        let viewController = ImagesConfigurator.create()
        let viewModelInput = ImagesConfigurator.configureFavorite(with: viewController)
        viewModelInput.configure(with: favoriteDog)
        self.viewController?.navigationController?.pushViewController(viewController, animated: true)
    }
}

//
//  ImagesConfigurator.swift
//  KoshelekDogs
//
//  Created by Дмитрий Константинов on 10.08.2020.
//  Copyright © 2020 Дмитрий Константинов. All rights reserved.
//

import UIKit

enum ImagesConfigurator {

    static func create() -> ImagesViewController {
        return ImagesViewController(nibName: ImagesViewController.identifier, bundle: nil)
    }

    static func configure(with reference: ImagesViewController) -> ImagesViewModelInput {

        let networkService = NetworkService()

        let context = (UIApplication.shared.delegate as? AppDelegate)?
            .persistentContainer
            .viewContext

        let database = FavoriteRepository(context: context)
        let viewModel = ImagesViewModel(networkService: networkService, database: database)
        reference.viewModel = viewModel

        return viewModel
    }

    static func configureFavorite(with reference: ImagesViewController) -> ImagesViewModelInput {

        let networkService = NetworkService()

        let context = (UIApplication.shared.delegate as? AppDelegate)?
            .persistentContainer
            .viewContext

        let database = FavoriteRepository(context: context)
        let viewModel = FavoriteImagesViewModel(networkService: networkService, database: database)
        reference.viewModel = viewModel

        return viewModel
    }
}

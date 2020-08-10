//
//  MainListConfigurator.swift
//  KoshelekDogs
//
//  Created by Дмитрий Константинов on 10.08.2020.
//  Copyright © 2020 Дмитрий Константинов. All rights reserved.
//

import UIKit

enum MainListConfigurator {

    static func create() -> MainListViewController {
        return MainListViewController(nibName: MainListViewController.identifier, bundle: nil)
    }

    @discardableResult
    static func configure(with reference: MainListViewController) -> MainListViewModelInput {

        let networkService = NetworkService()

        let context = (UIApplication.shared.delegate as? AppDelegate)?
            .persistentContainer
            .viewContext

        let database = FavoriteRepository(context: context)

        let viewModel = MainListViewModel(networkService: networkService,
                                          database: database)

        let router = MainListRouter()
        router.viewController = reference

        reference.router = router
        reference.viewModel = viewModel

        return viewModel
    }
}

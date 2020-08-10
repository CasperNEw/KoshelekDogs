//
//  SceneDelegate.swift
//  KoshelekDogs
//
//  Created by Дмитрий Константинов on 09.08.2020.
//  Copyright © 2020 Дмитрий Константинов. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {

        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        window?.rootViewController = createRootViewController()
        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) { }
    func sceneDidBecomeActive(_ scene: UIScene) { }
    func sceneWillResignActive(_ scene: UIScene) { }
    func sceneWillEnterForeground(_ scene: UIScene) { }

    func sceneDidEnterBackground(_ scene: UIScene) {
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }
}

// MARK: - Module functions
extension SceneDelegate {

    private func createRootViewController() -> UIViewController {

        let viewController = MainListConfigurator.create()
        MainListConfigurator.configure(with: viewController)

        let navigationController = UINavigationController(rootViewController: viewController)
        let attributes = [NSAttributedString.Key.font: UIFont(name: "Noteworthy-Bold", size: 15)]
        UINavigationBar.appearance().titleTextAttributes = attributes as [NSAttributedString.Key: Any]
        return navigationController
    }
}

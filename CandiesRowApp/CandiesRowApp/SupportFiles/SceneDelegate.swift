//
//  SceneDelegate.swift
//  CandiesRowApp
//
//  Created by Василий Вырвич on 8.04.24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let viewController = StartViewController()
        let window = UIWindow (windowScene: windowScene)
        window.rootViewController = viewController
        window.makeKeyAndVisible()
        self.window = window
        guard let _ = (scene as? UIWindowScene) else { return }
    }
}


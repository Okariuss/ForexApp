//
//  AppCoordinator.swift
//  ForexApp
//
//  Created by Okan Orkun on 27.06.2026.
//  Copyright © 2026 Okarius. All rights reserved.
//

import UIKit

@MainActor
final class AppCoordinator: Coordinator {
    private let window: UIWindow
    private let dependencies: AppDependencies
    private let navigationController: UINavigationController

    init(
        window: UIWindow,
        dependencies: AppDependencies
    ) {
        self.window = window
        self.dependencies = dependencies
        navigationController = UINavigationController()
    }

    func start() {
        let rootViewController = UIViewController()
        rootViewController.title = "Forex"
        rootViewController.view.backgroundColor = .systemBackground

        navigationController.setViewControllers(
            [rootViewController],
            animated: false
        )

        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
}

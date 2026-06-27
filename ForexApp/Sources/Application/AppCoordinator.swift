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
    private let navigationController: UINavigationController

    init(window: UIWindow) {
        self.window = window
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
    }
}

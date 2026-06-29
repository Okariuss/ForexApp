//
//  SceneDelegate.swift
//  ForexApp
//
//  Created by Okan Orkun on 27.06.2026.
//  Copyright © 2026 Okarius. All rights reserved.
//

import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    private var appCoordinator: AppCoordinator?

    func scene(
        _ scene: UIScene,
        willConnectTo _: UISceneSession,
        options _: UIScene.ConnectionOptions
    ) {
        guard let windowScene = scene as? UIWindowScene else {
            return
        }

        let window = UIWindow(windowScene: windowScene)

        do {
            let configuration = try AppConfiguration()

            let dependencies = AppDependencies(
                configuration: configuration
            )

            self.window = window

            appCoordinator = AppCoordinator(
                window: window,
                dependencies: dependencies
            )
            appCoordinator?.start()

        } catch {
            preconditionFailure(
                "App Configuration is invalid: \(error)"
            )
        }
    }
}

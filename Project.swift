import ProjectDescription

let project = Project(
    name: "ForexApp",
    organizationName: "Okarius",
    settings: .settings(
        configurations: [
            .debug(
                name: "Debug",
                xcconfig: "Configurations/Debug.xcconfig"
            ),
            .release(
                name: "Release",
                xcconfig: "Configurations/Release.xcconfig"
            ),
        ],
    ),
    targets: [
        .target(
            name: "ForexApp",
            destinations: .iOS,
            product: .app,
            bundleId: "com.okarius.forexapp",
            deploymentTargets: .iOS("26.0"),
            infoPlist: .extendingDefault(
                with: [
                    "CFBundleShortVersionString": "$(MARKETING_VERSION)",
                    "CFBundleVersion": "$(CURRENT_PROJECT_VERSION)",
                    "UIApplicationSceneManifest": [
                        "UIApplicationSupportsMultipleScenes": false,
                        "UISceneConfigurations": [
                            "UIWindowSceneSessionRoleApplication": [
                                [
                                    "UISceneConfigurationName": "Default Configuration",
                                    "UISceneDelegateClassName": "$(PRODUCT_MODULE_NAME).SceneDelegate",
                                ],
                            ],
                        ],
                    ],
                    "UILaunchScreen": [
                        "UIColorName": "",
                        "UIImageName": "",
                    ],
                ]
            ),
            buildableFolders: [
                "ForexApp/Sources",
                "ForexApp/Resources",
            ],
            dependencies: []
        ),
        .target(
            name: "ForexAppTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "com.okarius.forexapp.tests",
            deploymentTargets: .iOS("26.0"),
            infoPlist: .default,
            buildableFolders: [
                "ForexApp/Tests"
            ],
            dependencies: [
                .target(name: "ForexApp")
            ]
        ),
    ]
)

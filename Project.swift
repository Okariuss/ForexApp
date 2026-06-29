import ProjectDescription

let sharedSettings: Settings = .settings(
    configurations: [
        .debug(
            name: "Debug",
            xcconfig: "Configurations/Debug.xcconfig"
        ),
        .release(
            name: "Release",
            xcconfig: "Configurations/Release.xcconfig"
        )
    ],
    defaultSettings: .recommended(
        excluding: [
            "SWIFT_VERSION"
        ]
    )
)

let project = Project(
    name: "ForexApp",
    organizationName: "Okarius",
    settings: sharedSettings,
    targets: [
        .target(
            name: "NetworkingCore",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.okarius.forexapp.networkingcore",
            deploymentTargets: .iOS("26.0"),
            infoPlist: .default,
            buildableFolders: [
                "Modules/NetworkingCore/Sources"
            ],
            dependencies: [],
            settings: sharedSettings
        ),
        .target(
            name: "NetworkingCoreTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "com.okarius.forexapp.networkingcore.tests",
            deploymentTargets: .iOS("26.0"),
            infoPlist: .default,
            buildableFolders: [
                "Modules/NetworkingCore/Tests"
            ],
            dependencies: [
                .target(
                    name: "NetworkingCore"
                )
            ],
            settings: sharedSettings
        ),
        .target(
            name: "RatesDomain",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.okarius.forexapp.ratesdomain",
            deploymentTargets: .iOS("26.0"),
            infoPlist: .default,
            buildableFolders: [
                "Modules/RatesDomain/Sources"
            ],
            dependencies: [],
            settings: sharedSettings
        ),
        .target(
            name: "RatesDomainTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "com.okarius.forexapp.ratesdomain.tests",
            deploymentTargets: .iOS("26.0"),
            infoPlist: .default,
            buildableFolders: [
                "Modules/RatesDomain/Tests"
            ],
            dependencies: [
                .target(
                    name: "RatesDomain"
                )
            ],
            settings: sharedSettings
        ),
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
                                    "UISceneDelegateClassName": "$(PRODUCT_MODULE_NAME).SceneDelegate"
                                ]
                            ]
                        ]
                    ],
                    "UILaunchScreen": [
                        "UIColorName": "",
                        "UIImageName": ""
                    ]
                ]
            ),
            buildableFolders: [
                "ForexApp/Sources",
                "ForexApp/Resources"
            ],
            dependencies: [
                .target(
                    name: "RatesDomain"
                )
            ],
            settings: sharedSettings
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
            ],
            settings: sharedSettings
        )
    ]
)

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
            name: "RatesData",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.okarius.forexapp.ratesdata",
            deploymentTargets: .iOS("26.0"),
            infoPlist: .default,
            buildableFolders: [
                "Modules/RatesData/Sources"
            ],
            dependencies: [
                .target(
                    name: "NetworkingCore"
                ),
                .target(
                    name: "RatesDomain"
                )
            ],
            settings: sharedSettings
        ),
        .target(
            name: "RatesDataTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "com.okarius.forexapp.ratesdata.tests",
            deploymentTargets: .iOS("26.0"),
            infoPlist: .default,
            buildableFolders: [
                "Modules/RatesData/Tests"
            ],
            dependencies: [
                .target(
                    name: "RatesData"
                )
            ],
            settings: sharedSettings
        ),
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
                    "ExchangeRateAPIBaseURL": "$(EXCHANGE_RATE_API_BASE_URL)",
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
                ),
                .target(
                    name: "NetworkingCore"
                ),
                .target(
                    name: "RatesData"
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

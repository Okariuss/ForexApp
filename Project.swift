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

// MARK: - Modules

// MARK: PresentationCore Module

private let presentationCoreTarget: Target = .target(
    name: "PresentationCore",
    destinations: .iOS,
    product: .framework,
    bundleId: "com.okarius.forexapp.presentationcore",
    deploymentTargets: .iOS("26.0"),
    infoPlist: .default,
    buildableFolders: [
        "Modules/PresentationCore/Sources"
    ],
    dependencies: [],
    settings: sharedSettings
)

private let presentationCoreTestTarget: Target = .target(
    name: "PresentationCoreTests",
    destinations: .iOS,
    product: .unitTests,
    bundleId: "com.okarius.forexapp.presentationcore.tests",
    deploymentTargets: .iOS("26.0"),
    infoPlist: .default,
    buildableFolders: [
        "Modules/PresentationCore/Tests"
    ],
    dependencies: [
        .target(
            name: "PresentationCore"
        )
    ],
    settings: sharedSettings
)

// MARK: RatesFeature Module

private let ratesFeatureTarget: Target = .target(
    name: "RatesFeature",
    destinations: .iOS,
    product: .framework,
    bundleId: "com.okarius.forexapp.ratesfeature",
    deploymentTargets: .iOS("26.0"),
    infoPlist: .default,
    buildableFolders: [
        "Modules/RatesFeature/Sources"
    ],
    dependencies: [
        .target(
            name: "RatesDomain"
        ),
        .target(
            name: "DesignSystem"
        ),
        .target(
            name: "PresentationCore"
        ),
        .target(
            name: "AppMacros"
        )
    ],
    settings: sharedSettings
)

private let ratesFeatureTestTarget: Target = .target(
    name: "RatesFeatureTests",
    destinations: .iOS,
    product: .unitTests,
    bundleId: "com.okarius.forexapp.ratesfeature.tests",
    deploymentTargets: .iOS("26.0"),
    infoPlist: .default,
    buildableFolders: [
        "Modules/RatesFeature/Tests"
    ],
    dependencies: [
        .target(
            name: "RatesFeature"
        ),
        .target(
            name: "AppMacros"
        )
    ],
    settings: sharedSettings
)

// MARK: DesignSystem Module

private let designSystemTarget: Target = .target(
    name: "DesignSystem",
    destinations: .iOS,
    product: .framework,
    bundleId: "com.okarius.forexapp.designsystem",
    deploymentTargets: .iOS("26.0"),
    infoPlist: .default,
    buildableFolders: [
        "Modules/DesignSystem/Sources"
    ],
    dependencies: [],
    settings: sharedSettings
)

private let designSystemTestTarget: Target = .target(
    name: "DesignSystemTests",
    destinations: .iOS,
    product: .unitTests,
    bundleId: "com.okarius.forexapp.designsystem.tests",
    deploymentTargets: .iOS("26.0"),
    infoPlist: .default,
    buildableFolders: [
        "Modules/DesignSystem/Tests"
    ],
    dependencies: [
        .target(
            name: "DesignSystem"
        )
    ],
    settings: sharedSettings
)

// MARK: RatesData Module

private let ratesDataTarget: Target = .target(
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
)

private let ratesDataTestTarget: Target = .target(
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
)

// MARK: NetworkingCore Module

private let networkingCoreTarget: Target = .target(
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
)

private let networkingCoreTestTarget: Target = .target(
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
)

// MARK: RatesDomain Module

private let ratesDomainTarget: Target = .target(
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
)

private let ratesDomainTestTarget: Target = .target(
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
)

// MARK: - Macros

// MARK: AppMacrosPlugin

private let appMacrosPlugin: Target = .target(
    name: "AppMacrosPlugin",
    destinations: .macOS,
    product: .macro,
    bundleId:
    "com.okarius.forexapp.macros.plugin",
    deploymentTargets: .macOS("14.0"),
    infoPlist: .default,
    buildableFolders: [
        "Modules/AppMacrosPlugin/Sources"
    ],
    dependencies: [
        .external(name: "SwiftCompilerPlugin"),
        .external(name: "SwiftSyntax"),
        .external(name: "SwiftSyntaxBuilder"),
        .external(name: "SwiftSyntaxMacros")
    ],
    settings: sharedSettings
)

private let appMacros: Target = .target(
    name: "AppMacros",
    destinations: .iOS,
    product: .framework,
    bundleId: "com.okarius.forexapp.macros",
    deploymentTargets: .iOS("26.0"),
    infoPlist: .default,
    buildableFolders: [
        "Modules/AppMacros/Sources"
    ],
    dependencies: [
        .target(name: "AppMacrosPlugin")
    ],
    settings: sharedSettings
)

private let appMacrosTests: Target = .target(
    name: "AppMacrosTests",
    destinations: .iOS,
    product: .unitTests,
    bundleId:
    "com.okarius.forexapp.macros.tests",
    deploymentTargets: .iOS("26.0"),
    infoPlist: .default,
    buildableFolders: [
        "Modules/AppMacros/Tests"
    ],
    dependencies: [
        .target(name: "AppMacros")
    ],
    settings: sharedSettings
)

// MARK: - APP

let project = Project(
    name: "ForexApp",
    organizationName: "Okarius",
    settings: sharedSettings,
    targets: [
        appMacrosPlugin,
        appMacros,
        appMacrosTests,
        presentationCoreTarget,
        presentationCoreTestTarget,
        ratesFeatureTarget,
        ratesFeatureTestTarget,
        designSystemTarget,
        designSystemTestTarget,
        ratesDataTarget,
        ratesDataTestTarget,
        networkingCoreTarget,
        networkingCoreTestTarget,
        ratesDomainTarget,
        ratesDomainTestTarget,
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
                    "DefaultBaseCurrencyCode": "$(DEFAULT_BASE_CURRENCY_CODE)",
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
                ),
                .target(
                    name: "PresentationCore"
                ),
                .target(
                    name: "RatesFeature"
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

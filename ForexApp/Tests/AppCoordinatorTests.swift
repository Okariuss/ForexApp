@testable import ForexApp
import RatesDomain
import Testing
import UIKit

@MainActor
struct AppCoordinatorTests {
    @Test func startSetsRateListAsRoot() throws {
        let windowScene = try #require(
            UIApplication.shared.connectedScenes
                .compactMap { $0 as? UIWindowScene }
                .first
        )
        let window = UIWindow(windowScene: windowScene)
        let dependencies = try AppDependencies(
            ratesRepository: RatesRepositoryStub(),
            baseCurrencyPreferenceStore: BaseCurrencyPreferenceStoreStub(),
            defaultBaseCurrency: CurrencyCode("USD")
        )
        let subject = AppCoordinator(
            window: window,
            dependencies: dependencies
        )

        subject.start()

        let navigationController =
            window.rootViewController as? UINavigationController

        #expect(navigationController != nil)
        #expect(
            navigationController?
                .topViewController?
                .title == "Rates"
        )
    }
}

private struct RatesRepositoryStub: RatesRepository {
    func fetchRates(
        baseCurrency _: CurrencyCode
    ) async throws -> [ExchangeRate] {
        []
    }
}

@MainActor
private final class BaseCurrencyPreferenceStoreStub: BaseCurrencyPreferenceStoring {
    var baseCurrencyCode: String?
}

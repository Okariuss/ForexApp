@testable import ForexApp
import Testing
import UIKit

@MainActor
struct AppCoordinatorTests {
    @Test func startSetsNavigationControllerAsRoot() throws {
        let windowScene = try #require(
            UIApplication.shared.connectedScenes
                .compactMap { $0 as? UIWindowScene }
                .first
        )
        let window = UIWindow(windowScene: windowScene)
        let subject = AppCoordinator(window: window)

        subject.start()

        let navigationController =
            window.rootViewController as? UINavigationController

        #expect(navigationController != nil)
        #expect(navigationController?.topViewController?.title == "Forex")
    }
}

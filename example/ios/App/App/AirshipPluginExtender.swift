import Foundation
import AirshipFrameworkProxy
import AirshipCore
import UIKit
import Combine

@objc(AirshipPluginExtender)
public class AirshipPluginExtender: NSObject, AirshipPluginExtenderProtocol {

    public static var subscription: AnyCancellable?
    /// Called on the same run loop when Airship takesOff.
    @MainActor
    public static func onAirshipReady() {
        // Updates Airship windows to use the override
        AirshipWindowFactory.shared.makeBlock = { scene in
            let window = UIWindow(windowScene: scene)
            switch (UserDefaults.standard.theme) {
            case .dark: window.overrideUserInterfaceStyle = .dark
            case .light: window.overrideUserInterfaceStyle = .light
            default: break
            }
            return window
        }

        // Optional, update the main window on launch
        self.updateMainWindowTheme(theme: UserDefaults.standard.theme)

        // Optional, keep the main window in sync
        subscription = NotificationCenter.default.publisher(for: UserDefaults.didChangeNotification)
            .map { _ in
                UserDefaults.standard.theme
            }
            .removeDuplicates()
            .receive(on: RunLoop.main)
            .sink { theme in
                Self.updateMainWindowTheme(theme: theme)
            }
    }

    private static func updateMainWindowTheme(theme: Theme) {
        let window = UIApplication.shared.delegate?.window as? UIWindow
        switch (theme) {
        case .dark: window?.overrideUserInterfaceStyle = .dark
        case .light: window?.overrideUserInterfaceStyle = .light
        default: window?.overrideUserInterfaceStyle = .unspecified
        }
    }
}

fileprivate enum Theme: String, Sendable {
    case system
    case light
    case dark
}

fileprivate extension UserDefaults {
    var theme: Theme {
        let themeString = string(forKey: "CapacitorStorage.appTheme")
        guard let themeString else { return .system }
        return switch(themeString.lowercased()) {
        case "light": .light
        case "dark": .dark
        case "system": .light
        default: .system
        }
    }
}

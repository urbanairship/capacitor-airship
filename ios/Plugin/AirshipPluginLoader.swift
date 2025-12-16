
public import AirshipFrameworkProxy
public import Foundation
public import UIKit

@objc(AirshipPluginLoader)
public class AirshipPluginLoader: NSObject, AirshipPluginLoaderProtocol {
    @MainActor
    public static func onLoad() {
        NotificationCenter.default.addObserver(
            forName: UIApplication.didFinishLaunchingNotification,
            object: nil,
            queue: nil
        ) { _ in
            Task { @MainActor in
                AirshipCapacitorAutopilot.shared.onApplicationDidFinishLaunching()
            }
        }
    }
}

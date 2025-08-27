
public import AirshipFrameworkProxy
public import Foundation
public import UIKit

@objc(AirshipPluginLoader)
public class AirshipPluginLoader: NSObject, AirshipPluginLoaderProtocol {
    @MainActor
    public static func onApplicationDidFinishLaunching(
        launchOptions: [UIApplication.LaunchOptionsKey : Any]?
    ) {
        AirshipCapacitorAutopilot.shared.onApplicationDidFinishLaunching()
    }
}

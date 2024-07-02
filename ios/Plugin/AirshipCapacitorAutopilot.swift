/* Copyright Airship and Contributors */

#if canImport(AirshipKit)
import AirshipKit
#elseif canImport(AirshipCore)
import AirshipCore
#endif

import AirshipFrameworkProxy
import Capacitor

@objc
public final class AirshipCapacitorAutopilot: NSObject {

    @objc
    public static let shared: AirshipCapacitorAutopilot = AirshipCapacitorAutopilot()

    @MainActor
    private var pluginInitialized: Bool = false
    @MainActor
    private var applicationDidFinishLaunching: Bool = false
    @MainActor
    private var launchOptions: [UIApplication.LaunchOptionsKey : Any]?

    fileprivate var pluginConfig: PluginConfig?

    /*
     * In Capacitor 5, the order of initialization is:
     * - AppDelegate#applicationDidFinishLaunching
     * - onPluginInitialized
     * - onApplicationDidFinishLaunching
     *
     * We are going to be resilient to that order changing by tracking each state
     * any only attempting takeOff automatically after both onPluginInitialized
     * and onApplicationDidFinishLaunching are called on Autopilot.
     */

    @MainActor
    @objc
    public func onApplicationDidFinishLaunching(
        launchOptions: [UIApplication.LaunchOptionsKey : Any]?
    ) {
        AirshipProxy.shared.delegate = self 
        self.launchOptions = launchOptions
        self.applicationDidFinishLaunching = true
        if self.pluginInitialized, self.applicationDidFinishLaunching {
            try? AirshipProxy.shared.attemptTakeOff(
                launchOptions: self.launchOptions
            )
        }
    }

    @MainActor
    public func onPluginInitialized(pluginConfig: PluginConfig?) {
        self.pluginInitialized = true
        self.pluginConfig = pluginConfig
        if self.pluginInitialized, self.applicationDidFinishLaunching {
            try? AirshipProxy.shared.attemptTakeOff(
                launchOptions: self.launchOptions
            )
        }
    }

    @MainActor
    func attemptTakeOff(json: Any) throws -> Bool {
        return try AirshipProxy.shared.takeOff(
            json: json,
            launchOptions: self.launchOptions
        )
    }
}

extension AirshipCapacitorAutopilot: AirshipProxyDelegate {
    public func migrateData(store: AirshipFrameworkProxy.ProxyStore) {}
    
    public func loadDefaultConfig() -> AirshipConfig {
        let airshipConfig = AirshipConfig.default()
        if let config = self.pluginConfig?.getObject("config") {
            do {
                let proxyConfig: ProxyConfig = try AirshipJSON.wrap(config).decode()
                airshipConfig.applyProxyConfig(proxyConfig: proxyConfig)
            } catch {
                AirshipLogger.error("Failed to parse config: \(error)")
            }
        }
        return airshipConfig
    }
    
    @MainActor
    public func onAirshipReady() {
        Airship.analytics.registerSDKExtension(
            AirshipSDKExtension.capacitor,
            version: AirshipCapacitorVersion.version
        )
    }
}



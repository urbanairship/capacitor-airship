/* Copyright Airship and Contributors */

import AirshipKit
import AirshipFrameworkProxy

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

    /*
     * In Capacitor 5, the order of initailization is:
     * - AppDelegate#applicationDidFinishLaunching
     * - onPluginInitialized
     * - onApplicationDidFinishLaunching
     *
     * We are going to be resiliant to that order changing by tracking each state
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
    public func onPluginInitialized() {
        self.pluginInitialized = true
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
    public func migrateData(store: AirshipFrameworkProxy.ProxyStore) {
    }
    
    // Can we pull this from the plugin config easily?
    public func loadDefaultConfig() -> AirshipConfig {
        let config = AirshipConfig.default()
        
//        settings?.apply(config: config)
        return config
    }
    
    @MainActor
    public func onAirshipReady() {
        Airship.analytics.registerSDKExtension(
            AirshipSDKExtension.cordova,
            version: AirshipCapacitorVersion.version
        )
    }
}



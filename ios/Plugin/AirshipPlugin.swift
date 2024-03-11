import Foundation
import Capacitor

/**
 * Please read the Capacitor iOS Plugin Development Guide
 * here: https://capacitorjs.com/docs/plugins/ios
 */
@objc(AirshipPlugin)
public class AirshipPlugin: CAPPlugin {
    @objc 
    func perform(_ call: CAPPluginCall) {
        guard let method = call.getString("method") else {
            call.reject("Missing method")
            return
        }

        CAPLog.print("⚡️  To Airship -> ", pluginId, method, call.callbackId as Any)

        let value = call.getString("value") ?? ""
        call.resolve([
            "value": "\(method) \(value)"
        ])
    }
}

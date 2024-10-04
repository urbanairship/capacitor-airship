import Foundation
import Capacitor

#if canImport(AirshipKit)
import AirshipKit
#elseif canImport(AirshipCore)
import AirshipCore
#endif

import AirshipFrameworkProxy

/**
 * Please read the Capacitor iOS Plugin Development Guide
 * here: https://capacitorjs.com/docs/plugins/ios
 */
@objc(AirshipPlugin)
public class AirshipPlugin: CAPPlugin, CAPBridgedPlugin {

    public let identifier = "AirshipPlugin"
    public let jsName = "Airship"
    public let pluginMethods: [CAPPluginMethod] = [
        CAPPluginMethod(name: "perform", returnType: CAPPluginReturnPromise)
    ]
    
    private static let eventNames: [AirshipProxyEventType: String] = [
         .authorizedNotificationSettingsChanged: "ios_authorized_notification_settings_changed",
         .pushTokenReceived: "push_token_received",
         .deepLinkReceived: "deep_link_received",
         .channelCreated: "channel_created",
         .messageCenterUpdated: "message_center_updated",
         .displayMessageCenter: "display_message_center",
         .displayPreferenceCenter: "display_preference_center",
         .notificationResponseReceived: "notification_response_received",
         .pushReceived: "push_received",
         .notificationStatusChanged: "notification_status_changed",
         .liveActivitiesUpdated: "ios_live_activities_updated"
     ]

    @MainActor
    public override func load() {
        AirshipCapacitorAutopilot.shared.onPluginInitialized(
            pluginConfig: self.getConfig()
        )

        Task {
            for await _ in await AirshipProxyEventEmitter.shared.pendingEventAdded {
                await self.notifyPendingEvents()
            }
        }
    }

    @MainActor
    private func notifyPendingEvents() async {
        for eventType in AirshipProxyEventType.allCases {
            await AirshipProxyEventEmitter.shared.processPendingEvents(type: eventType) { event in
                return sendEvent(event)
            }
        }
    }

    @MainActor
    private func sendEvent(_ event: AirshipProxyEvent) -> Bool {
        guard let eventName = Self.eventNames[event.type] else {
            return false
        }
        guard self.hasListeners(eventName) else {
            return false
        }

        self.notifyListeners(eventName, data: event.body)
        return true
    }

    @objc
    func perform(_ call: CAPPluginCall) {
        guard let method = call.getString("method") else {
            call.reject("Missing method")
            return
        }

        CAPLog.print("⚡️  To Airship -> ", pluginId, method, call.callbackId as Any)

        Task {
            do {
                if let result = try await self.handle(method: method, call: call) {
                    call.resolve(["value": try AirshipJSON.wrap(result).unWrap() as Any])
                } else {
                    call.resolve([:])
                }
            } catch {
                call.reject(error.localizedDescription)
            }
        }
    }

    public override func addListener(_ call: CAPPluginCall) {
        super.addListener(call)

        Task {
            await notifyPendingEvents()
        }
    }

    @MainActor
    private func handle(method: String, call: CAPPluginCall) async throws -> Any? {

        switch method {

        // Airship
        case "takeOff":
            return try AirshipCapacitorAutopilot.shared.attemptTakeOff(
                json: try call.requireAnyArg()
            )

        case "isFlying":
            return AirshipProxy.shared.isFlying()

        // Channel
        case "channel#getChannelId":
            return try AirshipProxy.shared.channel.getChannelId()

        case "channel#editTags":
            try AirshipProxy.shared.channel.editTags(
                json: try call.requireAnyArg()
            )
            return nil

        case "channel#getTags":
            return try AirshipProxy.shared.channel.getTags()

        case "channel#editTagGroups":
            try AirshipProxy.shared.channel.editTagGroups(
                json: try call.requireAnyArg()
            )
            return nil

        case "channel#editSubscriptionLists":
            try AirshipProxy.shared.channel.editSubscriptionLists(
                json: try call.requireAnyArg()
            )
            return nil

        case "channel#editAttributes":
            try AirshipProxy.shared.channel.editAttributes(
                json: try call.requireAnyArg()
            )
            return nil

        case "channel#getSubscriptionLists":
            return try await AirshipProxy.shared.channel.getSubscriptionLists()

        case "channel#enableChannelCreation":
            try AirshipProxy.shared.channel.enableChannelCreation()
            return nil

        // Contact
        case "contact#editTagGroups":
            try AirshipProxy.shared.contact.editTagGroups(
                json: try call.requireAnyArg()
            )
            return nil

        case "contact#editSubscriptionLists":
            try AirshipProxy.shared.contact.editSubscriptionLists(
                json: try call.requireAnyArg()
            )
            return nil

        case "contact#editAttributes":
            try AirshipProxy.shared.contact.editAttributes(
                json: try call.requireAnyArg()
            )
            return nil

        case "contact#getSubscriptionLists":
            return try await AirshipProxy.shared.contact.getSubscriptionLists()

        case "contact#identify":
            try AirshipProxy.shared.contact.identify(
                try call.requireStringArg()
            )
            return nil

        case "contact#reset":
            try AirshipProxy.shared.contact.reset()
            return nil

        case "contact#notifyRemoteLogin":
            try AirshipProxy.shared.contact.notifyRemoteLogin()
            return nil

        case "contact#getNamedUserId":
            return try await AirshipProxy.shared.contact.getNamedUser()


        // Push
        case "push#getPushToken":
            return try AirshipProxy.shared.push.getRegistrationToken()

        case "push#setUserNotificationsEnabled":
            try AirshipProxy.shared.push.setUserNotificationsEnabled(
                try call.requireBooleanArg()
            )
            return nil

        case "push#enableUserNotifications":
            return try await AirshipProxy.shared.push.enableUserPushNotifications(
                args: try call.optionalCodableArg()
            )

        case "push#isUserNotificationsEnabled":
            return try AirshipProxy.shared.push.isUserNotificationsEnabled()

        case "push#getNotificationStatus":
            return try await AirshipProxy.shared.push.getNotificationStatus()

        case "push#getActiveNotifications":
            return await AirshipProxy.shared.push.getActiveNotifications()

        case "push#clearNotification":
            AirshipProxy.shared.push.clearNotification(
                try call.requireStringArg()
            )
            return nil

        case "push#clearNotifications":
            AirshipProxy.shared.push.clearNotifications()
            return nil

        case "push#ios#getBadgeNumber":
            return try AirshipProxy.shared.push.getBadgeNumber()

        case "push#ios#setBadgeNumber":
            try await AirshipProxy.shared.push.setBadgeNumber(
                try call.requireIntArg()
            )
            return nil

        case "push#ios#setAutobadgeEnabled":
            try AirshipProxy.shared.push.setAutobadgeEnabled(
                try call.requireBooleanArg()
            )
            return nil

        case "push#ios#isAutobadgeEnabled":
            return try AirshipProxy.shared.push.isAutobadgeEnabled()

        case "push#ios#resetBadgeNumber":
            try await AirshipProxy.shared.push.setBadgeNumber(0)
            return nil

        case "push#ios#setNotificationOptions":
            try AirshipProxy.shared.push.setNotificationOptions(
                names: try call.requireStringArrayArg()
            )
            return nil

        case "push#ios#setForegroundPresentationOptions":
            try AirshipProxy.shared.push.setForegroundPresentationOptions(
                names: try call.requireStringArrayArg()
            )
            return nil

        case "push#ios#getAuthorizedNotificationStatus":
            return try AirshipProxy.shared.push.getAuthroizedNotificationStatus()

        case "push#ios#getAuthorizedNotificationSettings":
            return try AirshipProxy.shared.push.getAuthorizedNotificationSettings()

        case "push#ios#setQuietTimeEnabled":
            try AirshipProxy.shared.push.setQuietTimeEnabled(
                try call.requireBooleanArg()
            )
            return nil

        case "push#ios#isQuietTimeEnabled":
            return try AirshipProxy.shared.push.isQuietTimeEnabled()

        case "push#ios#setQuietTime":
            try AirshipProxy.shared.push.setQuietTime(
                try call.requireCodableArg()
            )
            return nil

        case "push#ios#getQuietTime":
            return try AirshipProxy.shared.push.getQuietTime()

        // In-App
        case "inApp#setPaused":
            try AirshipProxy.shared.inApp.setPaused(
                try call.requireBooleanArg()
            )
            return nil

        case "inApp#isPaused":
            return try AirshipProxy.shared.inApp.isPaused()

        case "inApp#setDisplayInterval":
            try AirshipProxy.shared.inApp.setDisplayInterval(
                try call.requireIntArg()
            )
            return nil

        case "inApp#getDisplayInterval":
            return try AirshipProxy.shared.inApp.getDisplayInterval()

        // Analytics
        case "analytics#trackScreen":
            try AirshipProxy.shared.analytics.trackScreen(
                try? call.requireStringArg()
            )
            return nil

        case "analytics#addCustomEvent":
            try AirshipProxy.shared.analytics.addEvent(
                call.requireAnyArg()
            )
            return nil

        case "analytics#associateIdentifier":
            let args = try call.requireStringArrayArg()
            guard args.count == 1 || args.count == 2 else {
                throw AirshipErrors.error("Call requires 1 to 2 strings.")
            }
            try AirshipProxy.shared.analytics.associateIdentifier(
                identifier: args.count == 2 ? args[1] : nil,
                key: args[0]
            )
            return nil

        // Message Center
        case "messageCenter#getMessages":
            return try? await AirshipProxy.shared.messageCenter.getMessages()

        case "messageCenter#display":
            try AirshipProxy.shared.messageCenter.display(
                messageID: try? call.requireStringArg()
            )
            return nil

        case "messageCenter#showMessageView":
            try AirshipProxy.shared.messageCenter.showMessageView(
                messageID: try call.requireStringArg()
            )
            return nil

        case "messageCenter#showMessageCenter":
            try AirshipProxy.shared.messageCenter.showMessageCenter(
                messageID: try? call.requireStringArg()
            )
            return nil

        case "messageCenter#dismiss":
            try AirshipProxy.shared.messageCenter.dismiss()
            return nil

        case "messageCenter#markMessageRead":
            try await AirshipProxy.shared.messageCenter.markMessageRead(
                messageID: call.requireStringArg()
            )
            return nil

        case "messageCenter#deleteMessage":
            try await AirshipProxy.shared.messageCenter.deleteMessage(
                messageID: call.requireStringArg()
            )
            return nil

        case "messageCenter#getUnreadMessageCount":
            return try await AirshipProxy.shared.messageCenter.getUnreadCount()

        case "messageCenter#refreshMessages":
            try await AirshipProxy.shared.messageCenter.refresh()
            return nil

        case "messageCenter#setAutoLaunchDefaultMessageCenter":
            AirshipProxy.shared.messageCenter.setAutoLaunchDefaultMessageCenter(
                try call.requireBooleanArg()
            )
            return nil

        // Preference Center
        case "preferenceCenter#display":
            try AirshipProxy.shared.preferenceCenter.displayPreferenceCenter(
                preferenceCenterID: try call.requireStringArg()
            )
            return nil

        case "preferenceCenter#getConfig":
            return try await AirshipProxy.shared.preferenceCenter.getPreferenceCenterConfig(
                preferenceCenterID: try call.requireStringArg()
            )

        case "preferenceCenter#setAutoLaunchPreferenceCenter":
            let args = try call.requireArrayArg()
            guard
                args.count == 2,
                let identifier = args[0] as? String,
                let autoLaunch = args[1] as? Bool
            else {
                throw AirshipErrors.error("Call requires [String, Bool]")
            }

            AirshipProxy.shared.preferenceCenter.setAutoLaunchPreferenceCenter(
                autoLaunch,
                preferenceCenterID: identifier
            )
            return nil

        // Privacy Manager
        case "privacyManager#setEnabledFeatures":
            try AirshipProxy.shared.privacyManager.setEnabled(
                featureNames: try call.requireStringArrayArg()
            )
            return nil

        case "privacyManager#getEnabledFeatures":
            return try AirshipProxy.shared.privacyManager.getEnabledNames()

        case "privacyManager#enableFeatures":
            try AirshipProxy.shared.privacyManager.enable(
                featureNames: try call.requireStringArrayArg()
            )
            return nil

        case "privacyManager#disableFeatures":
            try AirshipProxy.shared.privacyManager.disable(
                featureNames: try call.requireStringArrayArg()
            )
            return nil

        case "privacyManager#isFeaturesEnabled":
            return try AirshipProxy.shared.privacyManager.isEnabled(
                featuresNames: try call.requireStringArrayArg()
            )

        // Locale
        case "locale#setLocaleOverride":
            try AirshipProxy.shared.locale.setCurrentLocale(
                try call.requireStringArg()
            )
            return nil

        case "locale#clearLocaleOverride":
            try AirshipProxy.shared.locale.clearLocale()
            return nil

        case "locale#getCurrentLocale":
            return try AirshipProxy.shared.locale.getCurrentLocale()

        // Actions
        case "actions#run":
            let args = try call.requireArrayArg()
            guard
                args.count == 1 || args.count == 2,
                let actionName = args[0] as? String
            else {
                throw AirshipErrors.error("Call requires [String, Any?]")
            }

            let arg = try? AirshipJSON.wrap(args[1])
            let result = try await AirshipProxy.shared.action.runAction(
                actionName,
                value: args.count == 2 ? arg : nil
            ) as? AirshipJSON
            return result?.unWrap()

        // Feature Flag
        case "featureFlagManager#flag":
            return try await AirshipProxy.shared.featureFlagManager.flag(
                name: try call.requireStringArg()
            )

        case "featureFlagManager#trackInteraction":
            try AirshipProxy.shared.featureFlagManager.trackInteraction(
                flag: call.requireCodableArg()
            )

            return nil

        // Live Activity Manager
        case "liveUpdateManager#list":
            if #available(iOS 16.1, *) {
                return try await LiveActivityManager.shared.list(
                    try call.requireCodableArg()
                )
            } else {
                throw AirshipErrors.error("Live Activities only available on 16.1+")
            }

        case "liveUpdateManager#listAll":
            if #available(iOS 16.1, *) {
                return try await LiveActivityManager.shared.listAll()
            } else {
                throw AirshipErrors.error("Live Activities only available on 16.1+")
            }

        case "liveUpdateManager#start":
            if #available(iOS 16.1, *) {
                return try await LiveActivityManager.shared.start(
                    try call.requireCodableArg()
                )
            } else {
                throw AirshipErrors.error("Live Activities only available on 16.1+")
            }

        case "liveUpdateManager#update":
            if #available(iOS 16.1, *) {
                try await LiveActivityManager.shared.update(
                    try call.requireCodableArg()
                )
            } else {
                throw AirshipErrors.error("Live Activities only available on 16.1+")
            }
            return nil

        case "liveUpdateManager#end":
            if #available(iOS 16.1, *) {
                try await LiveActivityManager.shared.end(
                    try call.requireCodableArg()
                )
            } else {
                throw AirshipErrors.error("Live Activities only available on 16.1+")
            }
            return nil

        default:
            throw AirshipErrors.error("Not implemented \(method)")
        }
    }
}

extension CAPPluginCall {
    func optionalCodableArg<T: Decodable>() throws -> T?  {
        guard let value = self.getValue("value") else {
            return nil
        }

        return try AirshipJSON.wrap(value).decode()
    }

    func requireCodableArg<T: Decodable>() throws -> T  {
        guard let value = self.getValue("value") else {
            throw AirshipErrors.error("Missing argument")
        }

        return try AirshipJSON.wrap(value).decode()
    }

    func requireArrayArg() throws -> [Any] {
        guard let value = self.getArray("value") else {
            throw AirshipErrors.error("Argument must be an array")
        }

        return value
    }

    func requireArrayArg<T>(count: UInt, parse: (Any) throws -> T) throws -> [T] {
        guard let value = self.getArray("value"), value.count == count else {
            throw AirshipErrors.error("Invalid argument array")
        }

        return try value.map { try parse($0) }
    }

    func requireStringArrayArg() throws -> [String] {
        guard let value = self.getArray("value") as? [String] else {
            throw AirshipErrors.error("Argument must be a string array")
        }

        return value
    }

    func requireAnyArg() throws -> Any {
        guard let value = self.getValue("value") else {
            throw AirshipErrors.error("Argument must not be null")
        }

        return value
    }

    func requireBooleanArg() throws -> Bool {
        guard let value = self.getBool("value") else {
            throw AirshipErrors.error("Argument must not be a bool")
        }

        return value
    }

    func requireStringArg() throws -> String {
        guard let value = self.getString("value") else {
            throw AirshipErrors.error("Argument must not be a string")
        }

        return value
    }

    func requireIntArg() throws -> Int {
        let value = try requireAnyArg()

        if let int = value as? Int {
            return int
        }

        if let double = value as? Double {
            return Int(double)
        }

        if let number = value as? NSNumber {
            return number.intValue
        }

        throw AirshipErrors.error("Argument must be an int")
    }

    func requireDoubleArg() throws -> Double {
        let value = try requireAnyArg()

        if let double = value as? Double {
            return double
        }

        if let int = value as? Int {
            return Double(int)
        }

        if let number = value as? NSNumber {
            return number.doubleValue
        }

        throw AirshipErrors.error("Argument must be a double")
    }
}

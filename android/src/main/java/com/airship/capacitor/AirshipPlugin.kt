package com.airship.capacitor

import android.os.Build
import com.getcapacitor.JSObject
import com.getcapacitor.Plugin
import com.getcapacitor.PluginCall
import com.getcapacitor.PluginMethod
import com.getcapacitor.annotation.CapacitorPlugin
import com.urbanairship.Autopilot
import com.urbanairship.PendingResult
import com.urbanairship.UALog
import com.urbanairship.actions.ActionResult
import com.urbanairship.android.framework.proxy.EventType
import com.urbanairship.android.framework.proxy.events.EventEmitter
import com.urbanairship.android.framework.proxy.proxies.AirshipProxy
import com.urbanairship.android.framework.proxy.proxies.EnableUserNotificationsArgs
import com.urbanairship.android.framework.proxy.proxies.FeatureFlagProxy
import com.urbanairship.android.framework.proxy.proxies.LiveUpdateRequest
import com.urbanairship.json.JsonList
import com.urbanairship.json.JsonMap
import com.urbanairship.json.JsonSerializable
import com.urbanairship.json.JsonValue
import com.urbanairship.json.jsonMapOf
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.SupervisorJob
import kotlinx.coroutines.launch
import kotlinx.coroutines.plus
import org.json.JSONArray
import org.json.JSONObject

@CapacitorPlugin(name = "Airship")
class AirshipPlugin : Plugin() {
    private val scope: CoroutineScope = CoroutineScope(Dispatchers.Main) + SupervisorJob()

    companion object {
        private val EVENT_NAME_MAP = mapOf(
            EventType.BACKGROUND_NOTIFICATION_RESPONSE_RECEIVED to "notification_response_received",
            EventType.FOREGROUND_NOTIFICATION_RESPONSE_RECEIVED to "notification_response_received",
            EventType.CHANNEL_CREATED to "channel_created",
            EventType.DEEP_LINK_RECEIVED to "deep_link_received",
            EventType.DISPLAY_MESSAGE_CENTER to "display_message_center",
            EventType.DISPLAY_PREFERENCE_CENTER to "display_preference_center",
            EventType.MESSAGE_CENTER_UPDATED to "message_center_updated",
            EventType.PUSH_TOKEN_RECEIVED to "push_token_received",
            EventType.FOREGROUND_PUSH_RECEIVED to "push_received",
            EventType.BACKGROUND_PUSH_RECEIVED to "push_received",
            EventType.NOTIFICATION_STATUS_CHANGED to "notification_status_changed"
        )
    }
    override fun load() {
        super.load()
        Autopilot.automaticTakeOff(context.applicationContext)

        scope.launch {
            EventEmitter.shared().pendingEventListener.collect {
                notifyPendingEvents()
            }
        }
        UALog.i { "Airship capacitor plugin loaded." }
    }

    @SuppressWarnings("unused")
    @PluginMethod(returnType = PluginMethod.RETURN_NONE)
    override fun addListener(call: PluginCall) {
        super.addListener(call)
        notifyPendingEvents()
    }

    private fun notifyPendingEvents() {
        EventType.entries.forEach { eventType ->
            EventEmitter.shared().processPending(listOf(eventType)) { event ->
                val name = EVENT_NAME_MAP[event.type]
                if (hasListeners(name)) {
                    notifyListeners(name, event.body.toJSObject())
                    true
                } else {
                    false
                }
            }
        }
    }

    @PluginMethod
    @SuppressWarnings("unused")
    fun perform(call: PluginCall) {
        val data = JsonValue.wrap(call.data).optMap()
        val method = data.opt("method").optString()
        val arg = data.opt("value")

        val proxy = AirshipProxy.shared(context)

        when (method) {
            // Airship
            "takeOff" -> call.resolve(scope, method) { proxy.takeOff(arg) }
            "isFlying" -> call.resolve(scope, method) { proxy.isFlying() }

            // Channel
            "channel#getChannelId" -> call.resolve(scope, method) { proxy.channel.getChannelId() }

            "channel#editTags" -> call.resolve(scope, method) { proxy.channel.editTags(arg) }
            "channel#getTags" -> call.resolve(scope, method) { proxy.channel.getTags().toList() }
            "channel#editTagGroups" -> call.resolve(scope, method) { proxy.channel.editTagGroups(arg) }
            "channel#editSubscriptionLists" -> call.resolve(scope, method) {
                proxy.channel.editSubscriptionLists(
                    arg
                )
            }

            "channel#editAttributes" -> call.resolve(scope, method) {
                proxy.channel.editAttributes(
                    arg
                )
            }

            "channel#getSubscriptionLists" -> call.resolve(scope, method) { proxy.channel.getSubscriptionLists() }
            "channel#enableChannelCreation" -> call.resolve(scope, method) { proxy.channel.enableChannelCreation() }

            // Contact
            "contact#reset" -> call.resolve(scope, method) { proxy.contact.reset() }
            "contact#notifyRemoteLogin" -> call.resolve(scope, method) { proxy.contact.notifyRemoteLogin() }
            "contact#identify" -> call.resolve(scope, method) { proxy.contact.identify(arg.requireString()) }
            "contact#getNamedUserId" -> call.resolve(scope, method) { proxy.contact.getNamedUserId() }
            "contact#editTagGroups" -> call.resolve(scope, method) { proxy.contact.editTagGroups(arg) }
            "contact#editSubscriptionLists" -> call.resolve(scope, method) {
                proxy.contact.editSubscriptionLists(
                    arg
                )
            }

            "contact#editAttributes" -> call.resolve(scope, method) {
                proxy.contact.editAttributes(
                    arg
                )
            }

            "contact#getSubscriptionLists" -> call.resolve(scope, method) { proxy.contact.getSubscriptionLists() }

            // Push
            "push#setUserNotificationsEnabled" -> call.resolve(scope, method) {
                proxy.push.setUserNotificationsEnabled(
                    arg.requireBoolean()
                )
            }

            "push#enableUserNotifications" -> call.resolve(scope, method) {
                val options = if (arg.isNull) {
                    null
                } else {
                    EnableUserNotificationsArgs.fromJson(arg)
                }
                proxy.push.enableUserPushNotifications(options)
            }

            "push#isUserNotificationsEnabled" -> call.resolve(scope, method) { proxy.push.isUserNotificationsEnabled() }
            "push#getNotificationStatus" -> call.resolve(scope, method) { proxy.push.getNotificationStatus() }
            "push#getActiveNotifications" -> call.resolve(scope, method) {
                if (Build.VERSION.SDK_INT >= 23) {
                    proxy.push.getActiveNotifications()
                } else {
                    emptyList()
                }
            }

            "push#clearNotification" -> call.resolve(scope, method) {
                proxy.push.clearNotification(
                    arg.requireString()
                )
            }

            "push#clearNotifications" -> call.resolve(scope, method) { proxy.push.clearNotifications() }
            "push#getPushToken" -> call.resolve(scope, method) { proxy.push.getRegistrationToken() }
            "push#android#isNotificationChannelEnabled" -> call.resolve(scope, method) {
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                    proxy.push.isNotificationChannelEnabled(arg.requireString())
                } else {
                    true
                }
            }

            "push#android#setNotificationConfig" -> call.resolve(scope, method) {
                proxy.push.setNotificationConfig(
                    arg
                )
            }

            "push#android#setForegroundNotificationsEnabled" -> call.resolve(scope, method) {
                proxy.push.isForegroundNotificationsEnabled = arg.requireBoolean()
                return@resolve Unit
            }

            "push#android#isForegroundNotificationsEnabled" -> call.resolve(scope, method) {
                proxy.push.isForegroundNotificationsEnabled
            }

            // In-App
            "inApp#setPaused" -> call.resolve(scope, method) {
                proxy.inApp.setPaused(
                    arg.getBoolean(
                        false
                    )
                )
            }

            "inApp#isPaused" -> call.resolve(scope, method) { proxy.inApp.isPaused() }
            "inApp#setDisplayInterval" -> call.resolve(scope, method) {
                proxy.inApp.setDisplayInterval(
                    arg.getLong(0)
                )
            }

            "inApp#getDisplayInterval" -> call.resolve(scope, method) { proxy.inApp.getDisplayInterval() }

            // Analytics
            "analytics#getSessionId" -> call.resolve(scope, method) { proxy.analytics.getSessionId() }
            "analytics#trackScreen" -> call.resolve(scope, method) { proxy.analytics.trackScreen(arg.string) }
            "analytics#addCustomEvent" -> call.resolve(scope, method) { proxy.analytics.addEvent(arg) }
            "analytics#associateIdentifier" -> {
                val associatedIdentifierArgs = arg.requireStringList()
                proxy.analytics.associateIdentifier(
                    associatedIdentifierArgs[0],
                    associatedIdentifierArgs.getOrNull(1)
                )
            }

            // Message Center
            "messageCenter#getMessages" -> call.resolve(scope, method) {
                JsonValue.wrapOpt(proxy.messageCenter.getMessages())
            }

            "messageCenter#dismiss" -> call.resolve(scope, method) { proxy.messageCenter.dismiss() }
            "messageCenter#display" -> call.resolve(scope, method) { proxy.messageCenter.display(arg.string) }
            "messageCenter#showMessageView" -> call.resolve(scope, method) {
                proxy.messageCenter.showMessageView(
                    arg.requireString()
                )
            }

            "messageCenter#showMessageCenter" -> call.resolve(scope, method) {
                proxy.messageCenter.showMessageCenter(
                    arg.string
                )
            }

            "messageCenter#markMessageRead" -> call.resolve(scope, method) {
                proxy.messageCenter.markMessageRead(
                    arg.requireString()
                )
            }

            "messageCenter#deleteMessage" -> call.resolve(scope, method) {
                proxy.messageCenter.deleteMessage(
                    arg.requireString()
                )
            }

            "messageCenter#getUnreadCount" -> call.resolve(scope, method) { proxy.messageCenter.getUnreadMessagesCount() }
            "messageCenter#setAutoLaunchDefaultMessageCenter" -> call.resolve(scope, method) {
                proxy.messageCenter.setAutoLaunchDefaultMessageCenter(
                    arg.requireBoolean()
                )
            }

            "messageCenter#refreshMessages" -> call.resolve(scope, method) {
                if (!proxy.messageCenter.refreshInbox()) {
                    throw Exception("Failed to refresh")
                }
                return@resolve Unit
            }

            // Preference Center
            "preferenceCenter#display" -> call.resolve(scope, method) {
                proxy.preferenceCenter.displayPreferenceCenter(
                    arg.requireString()
                )
            }

            "preferenceCenter#getConfig" -> call.resolve(scope, method) {
                proxy.preferenceCenter.getPreferenceCenterConfig(
                    arg.requireString()
                )
            }

            "preferenceCenter#setAutoLaunchPreferenceCenter" -> call.resolve(scope, method) {
                val autoLaunchArgs = arg.requireList()
                proxy.preferenceCenter.setAutoLaunchPreferenceCenter(
                    autoLaunchArgs.get(0).requireString(),
                    autoLaunchArgs.get(1).getBoolean(false)
                )
            }

            // Privacy Manager
            "privacyManager#setEnabledFeatures" -> call.resolve(scope, method) {
                proxy.privacyManager.setEnabledFeatures(
                    arg.requireStringList()
                )
            }

            "privacyManager#getEnabledFeatures" -> call.resolve(scope, method) { proxy.privacyManager.getFeatureNames() }
            "privacyManager#enableFeatures" -> call.resolve(scope, method) {
                proxy.privacyManager.enableFeatures(
                    arg.requireStringList()
                )
            }

            "privacyManager#disableFeatures" -> call.resolve(scope, method) {
                proxy.privacyManager.disableFeatures(
                    arg.requireStringList()
                )
            }

            "privacyManager#isFeaturesEnabled" -> call.resolve(scope, method) {
                proxy.privacyManager.isFeatureEnabled(
                    arg.requireStringList()
                )
            }

            // Locale
            "locale#setLocaleOverride" -> call.resolve(scope, method) {
                proxy.locale.setCurrentLocale(
                    arg.requireString()
                )
            }

            "locale#getCurrentLocale" -> call.resolve(scope, method) { proxy.locale.getCurrentLocale() }
            "locale#clearLocaleOverride" -> call.resolve(scope, method) { proxy.locale.clearLocale() }

            // Actions
            "actions#run" -> call.resolve(scope, method) {
                val actionArgs = arg.requireList()
                val name = actionArgs.get(0).requireString()
                val value: JsonValue? = if (actionArgs.size() == 2) {
                    actionArgs.get(1)
                } else {
                    null
                }

                val result = proxy.actions.runAction(name, value)
                if (result.status == ActionResult.STATUS_COMPLETED) {
                    result.value
                } else {
                    throw Exception("Action failed ${result.status}")
                }
            }

            // Feature Flag
            "featureFlagManager#flag" -> call.resolve(scope, method) {
                proxy.featureFlagManager.flag(arg.requireString())
            }

            "featureFlagManager#trackInteraction" -> {
                call.resolve(scope, method) {
                    val featureFlagProxy = FeatureFlagProxy(arg)
                    proxy.featureFlagManager.trackInteraction(flag = featureFlagProxy)
                }
            }

            // Live Update
            "liveUpdateManager#list" -> call.resolve(scope, method) {
                val request = LiveUpdateRequest.List.fromJson(arg)
                proxy.liveUpdateManager.list(request)
            }

            "liveUpdateManager#listAll" -> call.resolve(scope, method) {
                proxy.liveUpdateManager.listAll()
            }

            "liveUpdateManager#start" -> call.resolve(scope, method) {
                val request = LiveUpdateRequest.Start.fromJson(arg)
                proxy.liveUpdateManager.start(request)
            }

            "liveUpdateManager#update" -> call.resolve(scope, method) {
                val request = LiveUpdateRequest.Update.fromJson(arg)
                proxy.liveUpdateManager.update(request)
            }

            "liveUpdateManager#end" -> call.resolve(scope, method) {
                val request = LiveUpdateRequest.End.fromJson(arg)
                proxy.liveUpdateManager.end(request)
            }

            "liveUpdateManager#clearAll" -> call.resolve(scope, method) {
                proxy.liveUpdateManager.clearAll()
            }

            else -> call.reject("Not implemented")
        }
    }
}


internal fun PluginCall.resolve(scope: CoroutineScope, method: String, function: suspend () -> Any?) {
    scope.launch {
        try {
            when (val result = function()) {
                is Unit -> {
                    this@resolve.resolve(JSObject())
                }
                else -> {
                    this@resolve.resolve(jsonMapOf("value" to result).toJSObject())
                }
            }
        } catch (e: Exception) {
            this@resolve.reject(method, e)
        }
    }
}

internal fun JsonValue.requireBoolean(): Boolean {
    require(this.isBoolean)
    return this.getBoolean(false)
}

internal fun JsonValue.requireStringList(): List<String> {
    return this.requireList().list.map { it.requireString() }
}
internal fun JsonList.toJSONArray(): JSONArray {
    val array = JSONArray()
    this.forEach {
        array.put(it.unwrap())
    }
    return array
}


internal fun JsonMap.toJSObject(): JSObject {
    return JSObject.fromJSONObject(this.toJSONObject())
}

internal fun JsonMap.toJSONObject(): JSONObject {
    return JSONObject(map.mapValues { it.value.unwrap() })
}


internal fun JsonSerializable.unwrap(): Any? {
    val json = this.toJsonValue()
    return when {
        json.isNull -> null
        json.isJsonList -> json.requireList().toJSONArray()
        json.isJsonMap -> json.requireMap().toJSONObject()
        else -> json.value
    }
}

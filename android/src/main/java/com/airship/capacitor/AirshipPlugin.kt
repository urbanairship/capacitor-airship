package com.airship.capacitor

import android.os.Build
import com.getcapacitor.JSArray
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
import com.urbanairship.android.framework.proxy.proxies.FeatureFlagProxy
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
        EventType.values().forEach { eventType ->
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
            "takeOff" -> call.resolveResult(method) { proxy.takeOff(arg) }
            "isFlying" -> call.resolveResult(method) { proxy.isFlying() }

            // Channel
            "channel#getChannelId" -> call.resolveResult(method) { proxy.channel.getChannelId() }

            "channel#editTags" -> call.resolveResult(method) { proxy.channel.editTags(arg) }
            "channel#getTags" -> call.resolveResult(method) { proxy.channel.getTags().toList() }
            "channel#editTagGroups" -> call.resolveResult(method) { proxy.channel.editTagGroups(arg) }
            "channel#editSubscriptionLists" -> call.resolveResult(method) { proxy.channel.editSubscriptionLists(arg) }
            "channel#editAttributes" -> call.resolveResult(method) { proxy.channel.editAttributes(arg) }
            "channel#getSubscriptionLists" -> call.resolvePending(method) { proxy.channel.getSubscriptionLists() }
            "channel#enableChannelCreation" -> call.resolveResult(method) { proxy.channel.enableChannelCreation() }

            // Contact
            "contact#reset" -> call.resolveResult(method) { proxy.contact.reset() }
            "contact#notifyRemoteLogin" -> call.resolveResult(method) { proxy.contact.notifyRemoteLogin() }
            "contact#identify" -> call.resolveResult(method) { proxy.contact.identify(arg.requireString()) }
            "contact#getNamedUserId" -> call.resolveResult(method) { proxy.contact.getNamedUserId() }
            "contact#editTagGroups" -> call.resolveResult(method) { proxy.contact.editTagGroups(arg) }
            "contact#editSubscriptionLists" -> call.resolveResult(method) { proxy.contact.editSubscriptionLists(arg) }
            "contact#editAttributes" -> call.resolveResult(method) { proxy.contact.editAttributes(arg) }
            "contact#getSubscriptionLists" -> call.resolvePending(method) { proxy.contact.getSubscriptionLists() }

            // Push
            "push#setUserNotificationsEnabled" -> call.resolveResult(method) { proxy.push.setUserNotificationsEnabled(arg.requireBoolean()) }
            "push#enableUserNotifications" -> call.resolvePending(method) { proxy.push.enableUserPushNotifications() }
            "push#isUserNotificationsEnabled" -> call.resolveResult(method) { proxy.push.isUserNotificationsEnabled() }
            "push#getNotificationStatus" -> call.resolveResult(method) { proxy.push.getNotificationStatus() }
            "push#getActiveNotifications" -> call.resolveResult(method) {
                if (Build.VERSION.SDK_INT >= 23) {
                    proxy.push.getActiveNotifications()
                } else {
                    emptyList()
                }
            }
            "push#clearNotification" -> call.resolveResult(method) { proxy.push.clearNotification(arg.requireString()) }
            "push#clearNotifications" -> call.resolveResult(method) { proxy.push.clearNotifications() }
            "push#getPushToken" -> call.resolveResult(method) { proxy.push.getRegistrationToken() }
            "push#android#isNotificationChannelEnabled" -> call.resolveResult(method) {
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                    proxy.push.isNotificationChannelEnabled(arg.requireString())
                } else {
                    true
                }
            }
            "push#android#setNotificationConfig" -> call.resolveResult(method) { proxy.push.setNotificationConfig(arg) }
            "push#android#setForegroundNotificationsEnabled" -> call.resolveResult(method) {
                proxy.push.isForegroundNotificationsEnabled = arg.requireBoolean()
                return@resolveResult Unit
            }
            "push#android#isForegroundNotificationsEnabled" -> call.resolveResult(method) {
                proxy.push.isForegroundNotificationsEnabled
            }

            // In-App
            "inApp#setPaused" -> call.resolveResult(method) { proxy.inApp.setPaused(arg.getBoolean(false)) }
            "inApp#isPaused" -> call.resolveResult(method) { proxy.inApp.isPaused() }
            "inApp#setDisplayInterval" -> call.resolveResult(method) { proxy.inApp.setDisplayInterval(arg.getLong(0)) }
            "inApp#getDisplayInterval" -> call.resolveResult(method) { proxy.inApp.getDisplayInterval() }

            // Analytics
            "analytics#trackScreen" -> call.resolveResult(method) { proxy.analytics.trackScreen(arg.optString()) }
            "analytics#addCustomEvent" -> call.resolveResult(method) { proxy.analytics.addEvent(arg) }
            "analytics#associateIdentifier" -> {
                val associatedIdentifierArgs = arg.requireStringList()
                proxy.analytics.associateIdentifier(
                    associatedIdentifierArgs[0],
                    associatedIdentifierArgs.getOrNull(1)
                )
            }

            // Message Center
            "messageCenter#getMessages" -> call.resolveResult(method) {
                JsonValue.wrapOpt(proxy.messageCenter.getMessages())
            }
            "messageCenter#dismiss" -> call.resolveResult(method) { proxy.messageCenter.dismiss() }
            "messageCenter#display" -> call.resolveResult(method) { proxy.messageCenter.display(arg.optString()) }
            "messageCenter#showMessageView" -> call.resolveResult(method) { proxy.messageCenter.showMessageView(arg.requireString()) }
            "messageCenter#markMessageRead" -> call.resolveResult(method) { proxy.messageCenter.markMessageRead(arg.requireString()) }
            "messageCenter#deleteMessage" -> call.resolveResult(method) { proxy.messageCenter.deleteMessage(arg.requireString()) }
            "messageCenter#getUnreadMessageCount" -> call.resolveResult(method) { proxy.messageCenter.getUnreadMessagesCount() }
            "messageCenter#setAutoLaunchDefaultMessageCenter" -> call.resolveResult(method) { proxy.messageCenter.setAutoLaunchDefaultMessageCenter(arg.requireBoolean()) }
            "messageCenter#refreshMessages" -> call.resolveDeferred(method) { resolveCallback ->
                proxy.messageCenter.refreshInbox().addResultCallback {
                    if (it == true) {
                        resolveCallback(null, null)
                    } else {
                        resolveCallback(null, Exception("Failed to refresh"))
                    }
                }
            }

            // Preference Center
            "preferenceCenter#display" -> call.resolveResult(method) { proxy.preferenceCenter.displayPreferenceCenter(arg.requireString()) }
            "preferenceCenter#getConfig" -> call.resolvePending(method) { proxy.preferenceCenter.getPreferenceCenterConfig(arg.requireString()) }
            "preferenceCenter#setAutoLaunchPreferenceCenter" -> call.resolveResult(method) {
                val autoLaunchArgs = arg.requireList()
                proxy.preferenceCenter.setAutoLaunchPreferenceCenter(
                    autoLaunchArgs.get(0).requireString(),
                    autoLaunchArgs.get(1).getBoolean(false)
                )
            }

            // Privacy Manager
            "privacyManager#setEnabledFeatures" -> call.resolveResult(method) { proxy.privacyManager.setEnabledFeatures(arg.requireStringList()) }
            "privacyManager#getEnabledFeatures" -> call.resolveResult(method) { proxy.privacyManager.getFeatureNames() }
            "privacyManager#enableFeatures" -> call.resolveResult(method) { proxy.privacyManager.enableFeatures(arg.requireStringList()) }
            "privacyManager#disableFeatures" -> call.resolveResult(method) { proxy.privacyManager.disableFeatures(arg.requireStringList()) }
            "privacyManager#isFeaturesEnabled" -> call.resolveResult(method) { proxy.privacyManager.isFeatureEnabled(arg.requireStringList()) }

            // Locale
            "locale#setLocaleOverride" -> call.resolveResult(method) { proxy.locale.setCurrentLocale(arg.requireString()) }
            "locale#getCurrentLocale" -> call.resolveResult(method) { proxy.locale.getCurrentLocale() }
            "locale#clearLocaleOverride" -> call.resolveResult(method) { proxy.locale.clearLocale() }

            // Actions
            "actions#run" -> call.resolveDeferred(method) { resolveCallback ->
                val actionArgs = arg.requireList()
                val name= actionArgs.get(0).requireString()
                val value: JsonValue? = if (actionArgs.size() == 2) { actionArgs.get(1) } else { null }

                proxy.actions.runAction(name, value)
                    .addResultCallback { actionResult ->
                        if (actionResult != null && actionResult.status == ActionResult.STATUS_COMPLETED) {
                            resolveCallback(actionResult.value, null)
                        } else {
                            resolveCallback(null, Exception("Action failed ${actionResult?.status}"))
                        }
                    }
            }

            // Feature Flag
            "featureFlagManager#flag" -> call.resolveDeferred(method) { resolveCallback ->
                scope.launch {
                    try {
                        val flag = proxy.featureFlagManager.flag(arg.requireString())
                        resolveCallback(flag, null)
                    } catch (e: Exception) {
                        resolveCallback(null, e)
                    }
                }
            }

            "featureFlagManager#trackInteraction" -> {
                call.resolveDeferred(method) { resolveCallback ->
                    scope.launch {
                        try {
                            val featureFlagProxy = FeatureFlagProxy(arg)
                            proxy.featureFlagManager.trackInteraction(flag = featureFlagProxy)
                            resolveCallback(null, null)
                        } catch (e: Exception) {
                            resolveCallback(null, e)
                        }
                    }
                }
            }

            else -> call.reject("Not implemented")
        }
    }
}


internal fun PluginCall.resolveResult(method: String, function: () -> Any?) {
    resolveDeferred(method) { callback -> callback(function(), null) }
}

internal fun <T> PluginCall.resolveDeferred(method: String, function: ((T?, Exception?) -> Unit) -> Unit) {
    try {
        function { result, error ->
            if (error != null) {
                this.reject(method, error)
            } else {


                try {
                    when (result) {
                        is Unit -> {
                            this.resolve(JSObject())
                        }
                        else -> {
                            this.resolve(jsonMapOf("value" to result).toJSObject())
                        }
                    }
                } catch (e: Exception) {
                    this.reject(method, e)
                }
            }
        }
    } catch (e: Exception) {
        this.reject(method, e)
    }
}

internal fun <T> PluginCall.resolvePending(method: String, function: () -> PendingResult<T>) {
    resolveDeferred(method) { callback ->
        function().addResultCallback {
            callback(it, null)
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

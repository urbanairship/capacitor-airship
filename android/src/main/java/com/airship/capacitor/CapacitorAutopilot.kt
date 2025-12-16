/* Copyright Urban Airship and Contributors */

package com.airship.capacitor

import android.content.Context
import android.util.Log
import com.getcapacitor.CapConfig
import com.urbanairship.Airship
import com.urbanairship.AirshipConfigOptions
import com.urbanairship.analytics.Extension
import com.urbanairship.android.framework.proxy.BaseAutopilot
import com.urbanairship.android.framework.proxy.ProxyConfig
import com.urbanairship.android.framework.proxy.ProxyStore
import com.urbanairship.android.framework.proxy.applyProxyConfig
import com.urbanairship.json.JsonValue

class CapacitorAutopilot : BaseAutopilot() {

    override fun onReady(context: Context) {
        Log.i("CapacitorAutopilot", "onAirshipReady")
        Airship.analytics.registerSDKExtension(Extension.CAPACITOR, AirshipCapacitorVersion.version)
    }

    override fun createConfigBuilder(context: Context): AirshipConfigOptions.Builder {
        val pluginConfig = CapConfig.loadDefault(context).getPluginConfiguration("Airship")
        val proxyConfig = ProxyConfig(JsonValue.wrapOpt(pluginConfig.getObject("config")).optMap())
        val builder =  AirshipConfigOptions.newBuilder()
        try { builder.tryApplyDefaultProperties(context) } catch (_: Exception) {}
        builder.applyProxyConfig(context, proxyConfig)
        return builder
    }

    override fun onMigrateData(context: Context, proxyStore: ProxyStore) {

    }
}
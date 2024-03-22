/* Copyright Urban Airship and Contributors */

package com.airship.capacitor

import android.content.Context
import android.util.Log
import com.getcapacitor.CapConfig
import com.urbanairship.AirshipConfigOptions
import com.urbanairship.UAirship
import com.urbanairship.analytics.Analytics
import com.urbanairship.android.framework.proxy.BaseAutopilot
import com.urbanairship.android.framework.proxy.ProxyConfig
import com.urbanairship.android.framework.proxy.ProxyStore
import com.urbanairship.android.framework.proxy.applyProxyConfig
import com.urbanairship.json.JsonValue

class CapacitorAutopilot : BaseAutopilot() {

    override fun onAirshipReady(airship: UAirship) {
        super.onAirshipReady(airship)

        Log.i("CapacitorAutopilot", "onAirshipReady")

        // TODO capacitor
        airship.analytics.registerSDKExtension(Analytics.EXTENSION_CORDOVA, AirshipCapacitorVersion.version)
    }

    override fun createConfigBuilder(context: Context): AirshipConfigOptions.Builder {
        val pluginConfig = CapConfig.loadDefault(context).getPluginConfiguration("Airship")
        val proxyConfig = ProxyConfig(JsonValue.wrapOpt(pluginConfig.getObject("config")).optMap())
        val builder =  AirshipConfigOptions.newBuilder().applyDefaultProperties(context)
        builder.applyProxyConfig(context, proxyConfig)
        return builder
    }

    override fun onMigrateData(context: Context, proxyStore: ProxyStore) {

    }
}
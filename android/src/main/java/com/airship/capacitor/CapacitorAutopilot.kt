/* Copyright Urban Airship and Contributors */

package com.airship.capacitor

import android.content.Context
import android.util.Log
import com.getcapacitor.CapConfig
import com.urbanairship.AirshipConfigOptions
import com.urbanairship.Airship
import com.urbanairship.analytics.Extension
import com.urbanairship.android.framework.proxy.BaseAutopilot
import com.urbanairship.android.framework.proxy.ProxyConfig
import com.urbanairship.android.framework.proxy.ProxyStore
import com.urbanairship.android.framework.proxy.applyProxyConfig
import com.urbanairship.json.JsonValue

class CapacitorAutopilot : BaseAutopilot() {

    @Volatile
    private var cachedPluginConfig: ProxyConfig? = null

    override fun onReady(context: Context) {
        Log.i("CapacitorAutopilot", "onAirshipReady")
        Airship.analytics.registerSDKExtension(Extension.CAPACITOR, AirshipCapacitorVersion.version)
    }

    override fun createConfigBuilder(context: Context): AirshipConfigOptions.Builder {
        return super.createConfigBuilder(context).apply {
            applyProxyConfig(context, pluginConfig(context))
        }
    }

    /**
     * Returns the Airship plugin config declared in `capacitor.config.json`, parsing it once per
     * process.
     *
     * `CapConfig.loadDefault` re-reads and re-parses the asset on every call, and callers may be on
     * the main thread. The asset ships in the APK, so the first parse stays valid for the life of
     * the process.
     */
    private fun pluginConfig(context: Context): ProxyConfig {
        cachedPluginConfig?.let { return it }

        return synchronized(this) {
            cachedPluginConfig ?: run {
                val pluginConfig = CapConfig.loadDefault(context).getPluginConfiguration("Airship")
                ProxyConfig(JsonValue.wrapOpt(pluginConfig.getObject("config")).optMap())
                    .also { cachedPluginConfig = it }
            }
        }
    }

    override fun onMigrateData(context: Context, proxyStore: ProxyStore) {

    }
}

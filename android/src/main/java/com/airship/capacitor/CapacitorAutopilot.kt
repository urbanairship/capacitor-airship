/* Copyright Urban Airship and Contributors */

package com.airship.capacitor

import android.content.Context
import android.util.Log
import com.urbanairship.UAirship
import com.urbanairship.analytics.Analytics
import com.urbanairship.android.framework.proxy.BaseAutopilot
import com.urbanairship.android.framework.proxy.ProxyStore

class CapacitorAutopilot : BaseAutopilot() {

    override fun onAirshipReady(airship: UAirship) {
        super.onAirshipReady(airship)

        val context = UAirship.getApplicationContext()

        Log.i("CapacitorAutopilot", "onAirshipReady")

        // TODO capacitor
        airship.analytics.registerSDKExtension(Analytics.EXTENSION_CORDOVA, AirshipCapacitorVersion.version)

    }

    override fun onMigrateData(context: Context, proxyStore: ProxyStore) {

    }
}
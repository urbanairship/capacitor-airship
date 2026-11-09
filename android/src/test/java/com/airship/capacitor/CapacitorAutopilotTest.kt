/* Copyright Urban Airship and Contributors */

package com.airship.capacitor

import android.content.Context
import com.getcapacitor.CapConfig
import com.getcapacitor.PluginConfig
import io.mockk.every
import io.mockk.mockk
import io.mockk.mockkStatic
import io.mockk.unmockkStatic
import io.mockk.verify
import org.junit.After
import org.junit.Assert.assertNotNull
import org.junit.Before
import org.junit.Test
import org.junit.runner.RunWith
import org.robolectric.RobolectricTestRunner
import org.robolectric.RuntimeEnvironment
import org.robolectric.annotation.Config

@RunWith(RobolectricTestRunner::class)
@Config(sdk = [34])
class CapacitorAutopilotTest {

    private val context: Context get() = RuntimeEnvironment.getApplication()

    @Before
    fun setUp() {
        val pluginConfig = mockk<PluginConfig>(relaxed = true)
        val capConfig = mockk<CapConfig>()
        every { capConfig.getPluginConfiguration("Airship") } returns pluginConfig

        mockkStatic(CapConfig::class)
        every { CapConfig.loadDefault(any()) } returns capConfig
    }

    @After
    fun tearDown() {
        unmockkStatic(CapConfig::class)
    }

    @Test
    fun `createConfigBuilder reads capacitor_config_json only once`() {
        val autopilot = CapacitorAutopilot()

        assertNotNull(autopilot.createConfigBuilder(context))
        assertNotNull(autopilot.createConfigBuilder(context))

        verify(exactly = 1) { CapConfig.loadDefault(any()) }
    }
}

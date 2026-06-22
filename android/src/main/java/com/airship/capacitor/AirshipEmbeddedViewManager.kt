package com.airship.capacitor

import android.view.View
import android.view.ViewGroup
import android.widget.FrameLayout
import com.getcapacitor.Bridge
import com.urbanairship.embedded.AirshipEmbeddedView

/**
 * Manages native embedded views that overlay the Capacitor web view. Views are
 * positioned by the JS layer to match a placeholder element's bounding rect,
 * so frames are in CSS pixels and converted to device pixels using display
 * density.
 *
 * Each embedded view is hosted inside a clipping container sized to a clip
 * rect (typically the placeholder's scroll container). The hosted view is
 * offset within the container so that, as the placeholder scrolls beyond the
 * clip bounds, the view is clipped and appears to scroll under the surrounding
 * web content.
 */
internal class AirshipEmbeddedViewManager(private val bridge: Bridge) {

    data class Frame(val x: Double, val y: Double, val width: Double, val height: Double)

    private class ClipHolder(val container: FrameLayout, val view: View)

    private val holders = mutableMapOf<String, ClipHolder>()
    private var overlay: FrameLayout? = null

    fun create(viewId: String, embeddedId: String, frame: Frame, clip: Frame) {
        dispose(viewId)

        val view = AirshipEmbeddedView(bridge.context, embeddedId)
        val container = FrameLayout(bridge.context).apply {
            clipChildren = true
        }
        container.addView(view)
        overlay().addView(container)

        val holder = ClipHolder(container, view)
        holders[viewId] = holder
        layout(holder, frame, clip)
    }

    fun updateFrame(viewId: String, frame: Frame, clip: Frame) {
        layout(requireHolder(viewId), frame, clip)
    }

    fun setVisible(viewId: String, visible: Boolean) {
        requireHolder(viewId).container.visibility = if (visible) View.VISIBLE else View.INVISIBLE
    }

    fun dispose(viewId: String) {
        holders.remove(viewId)?.let { holder ->
            overlay?.removeView(holder.container)
        }
    }

    private fun requireHolder(viewId: String): ClipHolder {
        return holders[viewId] ?: throw IllegalArgumentException("No embedded view for viewId $viewId")
    }

    private fun overlay(): FrameLayout {
        overlay?.let { return it }

        val parent = bridge.webView.parent as? ViewGroup
            ?: throw IllegalStateException("Web view unavailable")

        // The overlay does not intercept touches, so events outside embedded
        // views fall through to the web view below it.
        val container = FrameLayout(bridge.context)
        parent.addView(
            container,
            ViewGroup.LayoutParams(
                ViewGroup.LayoutParams.MATCH_PARENT,
                ViewGroup.LayoutParams.MATCH_PARENT
            )
        )

        overlay = container
        return container
    }

    private fun layout(holder: ClipHolder, frame: Frame, clip: Frame) {
        val density = bridge.webView.resources.displayMetrics.density

        holder.container.layoutParams = FrameLayout.LayoutParams(
            (clip.width * density).toInt(),
            (clip.height * density).toInt()
        ).apply {
            leftMargin = (clip.x * density).toInt()
            topMargin = (clip.y * density).toInt()
        }

        // Offset the view within the clip container; negative margins push it
        // past the container bounds, where it is clipped.
        holder.view.layoutParams = FrameLayout.LayoutParams(
            (frame.width * density).toInt(),
            (frame.height * density).toInt()
        ).apply {
            leftMargin = ((frame.x - clip.x) * density).toInt()
            topMargin = ((frame.y - clip.y) * density).toInt()
        }

        holder.container.requestLayout()
    }
}

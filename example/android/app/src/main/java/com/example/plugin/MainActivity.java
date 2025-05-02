package com.example.plugin;

import android.app.Activity;
import android.app.UiModeManager;
import android.content.Context;
import android.content.SharedPreferences;
import android.os.Build;
import android.os.Bundle;

import androidx.annotation.Nullable;
import androidx.annotation.RequiresApi;

import com.getcapacitor.BridgeActivity;

// Extended MainActivity to be a SharedPreferences.OnSharedPreferenceChangeListener to listen for changes from the Capacitor preferences plugin

public class MainActivity extends BridgeActivity implements SharedPreferences.OnSharedPreferenceChangeListener {

    // Key that the JS side sets the theme override
    private final static String APP_THEME_KEY = "appTheme";

    /**
     * Enum to parse the theme override. Should be one of `light`, `dark`, or `system`.
     */
    public enum Theme {
        SYSTEM,
        LIGHT,
        DARK;

        // Optional: You can add a method to parse the string to enum
        public static Theme fromString(String theme) {
            if (theme != null) {
                for (Theme t : Theme.values()) {
                    if (t.name().equalsIgnoreCase(theme)) {
                        return t;
                    }
                }
            }
            throw new IllegalArgumentException("Unexpected value: " + theme);
        }
    }

    private SharedPreferences sharedPreferences;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        // The default config stores preferences in `CapacitorStorage`
        sharedPreferences = getApplication().getSharedPreferences("CapacitorStorage", Activity.MODE_PRIVATE);

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            updateThemeOverride();
        }

        super.onCreate(savedInstanceState);
    }

    @Override
    public void onStart() {
        super.onStart();
        sharedPreferences.registerOnSharedPreferenceChangeListener(this);
    }

    @Override
    public void onStop() {
        super.onStop();
        sharedPreferences.unregisterOnSharedPreferenceChangeListener(this);
    }

    @Override
    public void onSharedPreferenceChanged(SharedPreferences sharedPreferences, @Nullable String key) {
        // Update the theme override if the key matches
        if (APP_THEME_KEY.equals(key)) {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
                updateThemeOverride();
            }
        }
    }

    @RequiresApi(api = Build.VERSION_CODES.S)
    private void updateThemeOverride() {
        UiModeManager uiManager = (UiModeManager) getApplication().getSystemService(Context.UI_MODE_SERVICE);
        if (uiManager == null) {
            // log error
            return;
        }

        try {
            String override = sharedPreferences.getString(APP_THEME_KEY, Theme.SYSTEM.name());
            switch (Theme.fromString(override)) {
                case SYSTEM -> {
                    uiManager.setApplicationNightMode(UiModeManager.MODE_NIGHT_AUTO);
                }
                case LIGHT -> {
                    uiManager.setApplicationNightMode(UiModeManager.MODE_NIGHT_NO);
                }
                case DARK -> {
                    uiManager.setApplicationNightMode(UiModeManager.MODE_NIGHT_YES);
                }
            }
        } catch (Exception e) {
            // log error
        }
    }
}


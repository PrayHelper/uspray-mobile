package com.prayhelper.prayhelper

import io.flutter.embedding.android.FlutterActivity
import android.content.Intent;
import android.provider.Settings;

class MainActivity: FlutterActivity() {
    private fun openManageDefaultAppsSettings() {
        val intent = Intent(Settings.ACTION_MANAGE_DEFAULT_APPS_SETTINGS)
        startActivity(intent)
    }
}

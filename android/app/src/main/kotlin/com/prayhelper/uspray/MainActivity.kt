package com.prayhelper.uspray

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.content.Intent
import android.provider.Settings
import androidx.annotation.NonNull
import android.net.Uri

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.prayhelper.uspray/invokeDefault"
    private val packageName = "com.prayhelper.uspray"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CHANNEL
        ).setMethodCallHandler { call, result ->
            if (call.method == "openManageDefaultAppsSettings") {
                openManageDefaultAppsSettings()
                result.success(null)
            } else {
                result.notImplemented()
            }
        }
    }

    private fun openManageDefaultAppsSettings() {
        val intent = Intent(Settings.ACTION_MANAGE_DEFAULT_APPS_SETTINGS)
        startActivity(intent)
    }
}







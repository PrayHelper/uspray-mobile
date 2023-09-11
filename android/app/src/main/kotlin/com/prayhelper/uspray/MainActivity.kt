package com.prayhelper.uspray

import android.content.Intent
import android.net.Uri
import android.provider.Settings
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.os.Bundle

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.prayhelper.uspray/invokeDefault"
    private val packageName = "com.prayhelper.uspray"

    ///
//    override fun onCreate(savedInstanceState: Bundle?) {
//        super.onCreate(savedInstanceState)
//        handleIntent(intent)
//    }
//
//    override fun onNewIntent(intent: Intent) {
//        super.onNewIntent(intent)
//        handleIntent(intent)
//    }
//
//    private fun handleIntent(intent: Intent) {
//        val appLinkAction = intent.action
//        val appLinkData: Uri? = intent.data
//        if (Intent.ACTION_VIEW == appLinkAction) {
//            appLinkData?.lastPathSegment?.also { recipeId ->
//                println("For Test")
//            }
//        }
//    }
    ///


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
        val intent = Intent(Settings.ACTION_APPLICATION_DETAILS_SETTINGS)
        val uri: Uri = Uri.fromParts("package", "com.prayhelper.uspray", null)
        intent.setData(uri)
        startActivity(intent)
    }
}







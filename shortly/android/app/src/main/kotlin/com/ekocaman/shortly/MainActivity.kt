package com.ekocaman.shortly

import android.content.Intent
import android.os.Bundle

import io.flutter.app.FlutterActivity
import io.flutter.plugins.GeneratedPluginRegistrant
import com.ekocaman.shortly.services.NotificationService

class MainActivity : FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        GeneratedPluginRegistrant.registerWith(this)

        Intent(this, NotificationService::class.java).apply {
            startService(this)
        }
    }
}

package com.ekocaman.shortly.receivers

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.util.Log
import com.ekocaman.shortly.services.NotificationService

class LockReceiver : BroadcastReceiver() {

    override fun onReceive(context: Context, intent: Intent) {
        context.startService(Intent(context, NotificationService::class.java))
        Log.d("LockReceiver", "onReceive called")
        when (intent.action) {
            Intent.ACTION_SCREEN_OFF ->
                onScreenOff(context)
            Intent.ACTION_SCREEN_ON ->
                onScreenOn(context)
        }
    }

    private fun onScreenOn(context: Context) {
        Log.d("LockReceiver", "onScreenOn")
    }

    private fun onScreenOff(context: Context) {
        Log.d("LockReceiver", "onScreenOff")
    }
}
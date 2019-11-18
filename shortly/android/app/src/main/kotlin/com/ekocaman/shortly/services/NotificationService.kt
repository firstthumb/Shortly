package com.ekocaman.shortly.services

import android.app.Service
import android.content.*
import android.os.Binder
import android.os.IBinder
import android.util.Log
import com.ekocaman.shortly.receivers.LockReceiver

class NotificationService : Service() {

    private lateinit var binder: Binder
    private lateinit var lockScreenReceiver: BroadcastReceiver

    override fun onBind(intent: Intent?): IBinder? {
        return binder
    }

    private val clipboardReceiver = ClipboardManager.OnPrimaryClipChangedListener {
        val manager = getSystemService(Context.CLIPBOARD_SERVICE) as ClipboardManager
        if (manager.primaryClip?.itemCount ?: 0 > 0) {
            val item = manager.primaryClip?.getItemAt(0)
            Log.d("NotificationService", "Item : $item")
        }
    }

    override fun onCreate() {
        Log.d("NotificationService", "onCreate")
        super.onCreate()
        binder = Binder()
        initClipBoard()
        initDeviceUsageReceiver()
    }

    override fun onDestroy() {
        Log.d("NotificationService", "onDestroy")
        unregisterReceiver(lockScreenReceiver)
        stopListenClipboard()
        super.onDestroy()
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        Log.d("NotificationService", "onStartCommand action : " + intent?.action)

        return START_STICKY
    }

    private fun initClipBoard() {
        Log.d("NotificationService", "startListenClipboard")
        val manager = getSystemService(Context.CLIPBOARD_SERVICE) as ClipboardManager
        manager.removePrimaryClipChangedListener(clipboardReceiver)
        manager.addPrimaryClipChangedListener(clipboardReceiver)
    }

    private fun stopListenClipboard() {
        Log.d("NotificationService", "stopListenClipboard")
        val manager = getSystemService(Context.CLIPBOARD_SERVICE) as ClipboardManager
        manager.removePrimaryClipChangedListener(clipboardReceiver)
    }

    private fun initDeviceUsageReceiver() {
        lockScreenReceiver = LockReceiver()
        IntentFilter().apply {
            addAction(Intent.ACTION_SCREEN_ON)
            addAction(Intent.ACTION_SCREEN_OFF)
            registerReceiver(lockScreenReceiver, this)
        }
    }
}
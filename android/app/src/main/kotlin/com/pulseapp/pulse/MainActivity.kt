package com.pulseapp.pulse

import android.app.NotificationChannel
import android.app.NotificationManager
import android.os.Build
import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity

class MainActivity : FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        createNotificationChannels()
    }

    // One channel per kind, so people can silence messages but keep matches
    // (Android settings → Apps → Pulse → Notifications). Ids must match the
    // `channel` values in supabase/functions/send-push.
    private fun createNotificationChannels() {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.O) return
        val manager = getSystemService(NotificationManager::class.java) ?: return
        listOf(
            Triple("matches", R.string.channel_matches, R.string.channel_matches_description),
            Triple("messages", R.string.channel_messages, R.string.channel_messages_description),
            Triple("crews", R.string.channel_crews, R.string.channel_crews_description),
        ).forEach { (id, name, description) ->
            val channel = NotificationChannel(
                id,
                getString(name),
                NotificationManager.IMPORTANCE_HIGH,
            )
            channel.description = getString(description)
            manager.createNotificationChannel(channel)
        }
    }
}

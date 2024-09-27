package com.example.sms_sender

import android.telephony.SmsManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.MethodChannel
import io.flutter.embedding.engine.FlutterEngine
import android.telephony.SubscriptionManager
import android.content.Context
import android.util.Log  // Add this to log SIM slot information

class MainActivity: FlutterActivity() {
    private val CHANNEL = "sms_sender"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "sendSMS") {
                val recipient: String? = call.argument("recipient")
                val message: String? = call.argument("message")
                val simSlot: Int? = call.argument("simSlot")

                if (recipient != null && message != null && simSlot != null) {
                    sendSmsUsingSimSlot(recipient, message, simSlot, result)
                } else {
                    result.error("INVALID_ARGUMENT", "Recipient, message, or simSlot was null", null)
                }
            } else {
                result.notImplemented()
            }
        }
    }

    private fun sendSmsUsingSimSlot(recipient: String, message: String, simSlot: Int, result: MethodChannel.Result) {
        try {
            val subscriptionManager = getSystemService(Context.TELEPHONY_SUBSCRIPTION_SERVICE) as SubscriptionManager
            val subscriptionInfoList = subscriptionManager.activeSubscriptionInfoList

            // Log available SIM slots for debugging
            Log.d("SIM_SLOT_INFO", "Available SIM slots: ${subscriptionInfoList.size}")
            for (info in subscriptionInfoList) {
                Log.d("SIM_SLOT_INFO", "Slot index: ${info.simSlotIndex}, Subscription ID: ${info.subscriptionId}")
            }

            // Ensure simSlot is within the available subscription list
            if (simSlot >= 0 && simSlot < subscriptionInfoList.size) {
                val subscriptionId = subscriptionInfoList[simSlot].subscriptionId
                val smsManager = SmsManager.getSmsManagerForSubscriptionId(subscriptionId)

                smsManager.sendTextMessage(recipient, null, message, null, null)
                result.success("Message sent via SIM $simSlot")
            } else {
                result.error("SIM_SLOT_ERROR", "Invalid SIM slot number", null)
            }
        } catch (e: Exception) {
            result.error("ERROR", "Failed to send SMS: ${e.localizedMessage}", e)
        }
    }
}

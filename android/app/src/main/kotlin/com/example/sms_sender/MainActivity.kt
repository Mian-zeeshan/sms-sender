package com.example.sms_sender

import android.Manifest
import android.content.pm.PackageManager
import android.telephony.SmsManager
import android.telephony.SubscriptionManager
import android.content.Context
import android.util.Log
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.MethodChannel
import io.flutter.embedding.engine.FlutterEngine
import android.widget.Toast

class MainActivity : FlutterActivity() {
    private val CHANNEL = "sms_sender"
    private val SMS_PERMISSION_REQUEST_CODE = 101

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "sendSMS") {
                val recipient: String? = call.argument("recipient")
                val message: String? = call.argument("message")
                val simSlot: Int? = call.argument("simSlot")

                if (recipient != null && message != null && simSlot != null) {
                    // Check permissions before sending SMS
                    if (checkPermissions()) {
                        sendSmsUsingSimSlot(recipient, message, simSlot, result)
                    } else {
                        requestPermissions()
                        result.error("PERMISSION_ERROR", "SMS or phone state permissions not granted", null)
                    }
                } else {
                    result.error("INVALID_ARGUMENT", "Recipient, message, or simSlot was null", null)
                }
            } else {
                result.notImplemented()
            }
        }
    }

    private fun checkPermissions(): Boolean {
        val sendSmsPermission = ContextCompat.checkSelfPermission(this, Manifest.permission.SEND_SMS)
        val readPhoneStatePermission = ContextCompat.checkSelfPermission(this, Manifest.permission.READ_PHONE_STATE)
        return sendSmsPermission == PackageManager.PERMISSION_GRANTED &&
               readPhoneStatePermission == PackageManager.PERMISSION_GRANTED
    }

    private fun requestPermissions() {
        ActivityCompat.requestPermissions(
            this,
            arrayOf(Manifest.permission.SEND_SMS, Manifest.permission.READ_PHONE_STATE),
            SMS_PERMISSION_REQUEST_CODE
        )
    }

    override fun onRequestPermissionsResult(requestCode: Int, permissions: Array<String>, grantResults: IntArray) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)
        if (requestCode == SMS_PERMISSION_REQUEST_CODE) {
            if (grantResults.isNotEmpty() && grantResults[0] == PackageManager.PERMISSION_GRANTED) {
                // Permission granted, proceed to handle SMS sending
                Log.d("PERMISSION", "SMS and phone state permissions granted")
               
            } else {
                Log.d("PERMISSION", "Permissions denied")
                 Toast.makeText(this, "Permissions denied", Toast.LENGTH_SHORT).show()
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

                // Send the SMS
                smsManager.sendTextMessage(recipient, null, message, null, null)
                result.success("Message sent via SIM $simSlot")
           


            } else {
               
                Toast.makeText(this, "Invalid SIM slot number", Toast.LENGTH_SHORT).show()
                result.error("SIM_SLOT_ERROR", "Invalid SIM slot number", null)
            }
        } catch (e: Exception) {
            Toast.makeText(this, "Failed to send SMS: ${e.localizedMessage}", Toast.LENGTH_SHORT).show()
            result.error("ERROR", "Failed to send SMS: ${e.localizedMessage}", e)
        }
    }
}

// Copyright (c) 2025-2026 Pavel D. (teslor)
// SPDX-License-Identifier: AGPL-3.0-or-later

package com.teslor.sms_telebot

import android.app.Activity
import android.content.pm.PackageManager
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import io.flutter.plugin.common.MethodChannel

class PermissionRequestManager(private val activity: Activity) {

    companion object {
        private const val REQUEST_CODE = 1001
    }

    private var pendingResult: MethodChannel.Result? = null
    private var pendingPermission: String? = null

    private fun check(permission: String?): Boolean {
        return !permission.isNullOrBlank() &&
            ContextCompat.checkSelfPermission(activity, permission) == PackageManager.PERMISSION_GRANTED
    }

    fun request(permission: String?, result: MethodChannel.Result) {
        if (permission.isNullOrBlank()) {
            result.success(permissionResult(granted = false, requestBlocked = false))
            return
        }

        if (check(permission)) {
            result.success(permissionResult(granted = true, requestBlocked = false))
            return
        }

        if (pendingResult != null) {
            result.error(
                "permission_request_in_progress",
                "Another permission request is already in progress",
                null
            )
            return
        }

        pendingPermission = permission
        pendingResult = result
        ActivityCompat.requestPermissions(activity, arrayOf(permission), REQUEST_CODE)
    }

    private fun shouldShowRationale(permission: String?): Boolean {
        return !permission.isNullOrBlank() &&
            ActivityCompat.shouldShowRequestPermissionRationale(activity, permission)
    }

    fun onRequestPermissionsResult(requestCode: Int, grantResults: IntArray): Boolean {
        if (requestCode != REQUEST_CODE) return false

        val granted = grantResults.firstOrNull() == PackageManager.PERMISSION_GRANTED
        val requestBlocked = !granted && !shouldShowRationale(pendingPermission)
        pendingResult?.success(permissionResult(granted = granted, requestBlocked = requestBlocked))
        pendingPermission = null
        pendingResult = null
        return true
    }

    private fun permissionResult(granted: Boolean, requestBlocked: Boolean): Map<String, Boolean> {
        return mapOf(
            "granted" to granted,
            "requestBlocked" to requestBlocked
        )
    }
}

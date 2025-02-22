package com.example.detox_app

import android.content.Context
import android.content.Intent
import android.os.Build
import android.util.Log
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.app.ActivityManager

import android.app.usage.UsageEvents
import android.app.usage.UsageStats
import android.app.usage.UsageStatsManager
import java.util.SortedMap
import java.util.TreeMap

import io.flutter.embedding.android.FlutterActivity

class MainActivity: FlutterActivity(){
    private val channelName = "appsTimeUsage"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        val methodChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channelName)

        methodChannel.setMethodCallHandler { call, result ->
            if (call.method == "getTime") {
               val timeResult = getActiveAppPackageName(this@MainActivity)
               result.success(timeResult)
            }
        }
    }

    fun getActiveAppPackageName(context: Context): String {
        var pkgName: String? = null
        val usageStatsManager = context
                .getSystemService(USAGE_STATS_SERVICE) as UsageStatsManager
        val timeTnterval = (1000 * 600).toLong()
        val endTime = System.currentTimeMillis()
        val beginTime = endTime - timeTnterval
        val myUsageEvents: UsageEvents = usageStatsManager.queryEvents(beginTime, endTime)
        while (myUsageEvents.hasNextEvent()) {
            val myEvent: UsageEvents.Event = UsageEvents.Event()
            myUsageEvents.getNextEvent(myEvent)
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
                when (myEvent.eventType) {
                    UsageEvents.Event.ACTIVITY_RESUMED -> pkgName = myEvent.packageName
                    UsageEvents.Event.ACTIVITY_PAUSED -> if (myEvent.packageName.equals(pkgName)) {
                        pkgName = null
                    }
                }
            } else {
                when (myEvent.eventType) {
                    UsageEvents.Event.ACTIVITY_RESUMED -> pkgName = myEvent.packageName
                    UsageEvents.Event.ACTIVITY_RESUMED -> if (myEvent.packageName.equals(pkgName)) {
                        pkgName = null
                    }
                }
            }
        }
        if (pkgName == null){
            var currentApp = ""
            val usm = this.getSystemService(USAGE_STATS_SERVICE) as UsageStatsManager
            val time = System.currentTimeMillis()
            val appList =
                    usm.queryUsageStats(UsageStatsManager.INTERVAL_DAILY, time - 1000 * 1000, time)
            if (appList != null && appList.size > 0) {
                val mySortedMap: SortedMap<Long, UsageStats> = TreeMap()
                for (usageStats in appList) {
                    mySortedMap[usageStats.lastTimeUsed] = usageStats
                }
                if (mySortedMap != null && !mySortedMap.isEmpty()) {
                    currentApp = mySortedMap[mySortedMap.lastKey()]!!.packageName
                }
            }
            return currentApp
        }
        else{
            return  pkgName
        }

    }
}

package com.office.onwords

import android.content.BroadcastReceiver
import android.content.ComponentName
import android.content.pm.PackageManager
import androidx.annotation.NonNull
import com.office.onwords.helper.AppSharedPref
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

    private val CHANNEL = "com.dynamicIcon"
    var methodChannelResult: MethodChannel.Result? = null


    @Override
    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor, CHANNEL).setMethodCallHandler { call, result ->
            try {
                methodChannelResult = result;
                if (call.method.equals("launcherFirst")) {
                    AppSharedPref.setLauncherIcon(this, "launcherAlias.FirstLauncherAlias")
                    AppSharedPref.setCount(this, 1)
                    result.success("Icons changed successfully")
                } else if (call.method.equals("launcherSecond")) {
                    AppSharedPref.setLauncherIcon(this, "launcherAlias.SecondLauncherAlias")
                    AppSharedPref.setCount(this, 2)
                    result.success("Icons changed successfully")
                } else {
                    AppSharedPref.setLauncherIcon(this, "launcherAlias.DefaultLauncherAlias")
                    AppSharedPref.setCount(this, 0)
                    result.success("Icons changed successfully")
                }
            } catch (e: Exception) {
                print(e)
            }
        }
    }

    // App icon will change at the time when your activity gets destroyed, To Prevent the unnecessary app close issue.
    override fun onDestroy() {
        super.onDestroy()
        setIcon(AppSharedPref.getLauncherIcon(this).toString(), AppSharedPref.getCount(this))
    }


    //dynamically change app icon
    private fun setIcon(targetIcon: String, index: Int) {
        try {
            val packageManager: PackageManager = applicationContext!!.packageManager
            val packageName = applicationContext!!.packageName
            val className = StringBuilder()
            className.append(packageName)
            className.append(".")
            className.append(targetIcon)
            when (index) {
                0 -> {
                    packageManager.setComponentEnabledSetting(
                        ComponentName(packageName, "$packageName.$targetIcon"),
                        PackageManager.COMPONENT_ENABLED_STATE_ENABLED, PackageManager.DONT_KILL_APP
                    )

                    packageManager.setComponentEnabledSetting(
                        ComponentName(
                            packageName!!,
                            "$packageName.launcherAlias.FirstLauncherAlias"
                        ),
                        PackageManager.COMPONENT_ENABLED_STATE_DISABLED,
                        PackageManager.DONT_KILL_APP
                    )
                    packageManager.setComponentEnabledSetting(
                        ComponentName(
                            packageName,
                            "$packageName.launcherAlias.SecondLauncherAlias"
                        ),
                        PackageManager.COMPONENT_ENABLED_STATE_DISABLED,
                        PackageManager.DONT_KILL_APP
                    )
                }

                1 -> {
                    packageManager.setComponentEnabledSetting(
                        ComponentName(packageName, "$packageName.$targetIcon"),
                        PackageManager.COMPONENT_ENABLED_STATE_ENABLED, PackageManager.DONT_KILL_APP
                    )

                    packageManager.setComponentEnabledSetting(
                        ComponentName(
                            packageName!!,
                            "$packageName.launcherAlias.DefaultLauncherAlias"
                        ),
                        PackageManager.COMPONENT_ENABLED_STATE_DISABLED,
                        PackageManager.DONT_KILL_APP
                    )
                    packageManager.setComponentEnabledSetting(
                        ComponentName(
                            packageName!!,
                            "$packageName.launcherAlias.SecondLauncherAlias"
                        ),
                        PackageManager.COMPONENT_ENABLED_STATE_DISABLED,
                        PackageManager.DONT_KILL_APP
                    )
                }

                2 -> {
                    packageManager.setComponentEnabledSetting(
                        ComponentName(packageName, "$packageName.$targetIcon"),
                        PackageManager.COMPONENT_ENABLED_STATE_ENABLED, PackageManager.DONT_KILL_APP
                    )

                    packageManager.setComponentEnabledSetting(
                        ComponentName(
                            packageName!!,
                            "$packageName.launcherAlias.DefaultLauncherAlias"
                        ),
                        PackageManager.COMPONENT_ENABLED_STATE_DISABLED,
                        PackageManager.DONT_KILL_APP
                    )
                    packageManager.setComponentEnabledSetting(
                        ComponentName(
                            packageName!!,
                            "$packageName.launcherAlias.FirstLauncherAlias"
                        ),
                        PackageManager.COMPONENT_ENABLED_STATE_DISABLED,
                        PackageManager.DONT_KILL_APP
                    )
                }

            }
        } catch (e: Exception) {
            print(e)
        }
    }
}


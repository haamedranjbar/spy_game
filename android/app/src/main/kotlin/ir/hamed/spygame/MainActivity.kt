package ir.hamed.spygame

import android.content.pm.PackageManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

/// نقطه ورود اندروید — کانال IAP بازار (مایکت از پلاگین myket_iap)
class MainActivity : FlutterActivity() {

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        registerAppChannel(flutterEngine)

        if (BuildConfig.FLAVOR == "bazaar") {
            registerBazaarChannel(flutterEngine)
        }
    }

    /// کانال عمومی — ارسال flavor بیلد به Flutter
    private fun registerAppChannel(flutterEngine: FlutterEngine) {
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "ir.hamed.spygame/app",
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "getFlavor" -> result.success(BuildConfig.FLAVOR)
                "isMyketInstalled" -> result.success(isPackageInstalled("ir.mservices.market"))
                "isBazaarInstalled" -> result.success(isPackageInstalled("com.farsitel.bazaar"))
                else -> result.notImplemented()
            }
        }
    }

    // --- کافه‌بازار — stub تا اتصال Poolakey ---
    private fun registerBazaarChannel(flutterEngine: FlutterEngine) {
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "ir.hamed.spygame/bazaar_iap",
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "initialize" -> result.success(null)
                "isAvailable" -> result.success(isBazaarAvailable())
                "getProduct" -> {
                    if (!isBazaarAvailable()) {
                        result.success(null)
                        return@setMethodCallHandler
                    }
                    val productId = call.argument<String>("productId") ?: "golden_edition"
                    result.success(
                        mapOf(
                            "productId" to productId,
                            "title" to "نسخه طلایی",
                            "price" to if (BuildConfig.DEBUG) "تست" else "",
                            "isAvailable" to BuildConfig.DEBUG,
                        ),
                    )
                }
                "purchase" -> {
                    if (BuildConfig.DEBUG) {
                        result.success("success")
                    } else {
                        result.success("unavailable")
                    }
                }
                "restore" -> {
                    if (BuildConfig.DEBUG) {
                        result.success("success")
                    } else {
                        result.success("unavailable")
                    }
                }
                else -> result.notImplemented()
            }
        }
    }

    private fun isBazaarAvailable(): Boolean {
        return isPackageInstalled("com.farsitel.bazaar")
    }

    private fun isPackageInstalled(packageName: String): Boolean {
        return try {
            packageManager.getPackageInfo(packageName, 0)
            true
        } catch (_: PackageManager.NameNotFoundException) {
            false
        }
    }
}

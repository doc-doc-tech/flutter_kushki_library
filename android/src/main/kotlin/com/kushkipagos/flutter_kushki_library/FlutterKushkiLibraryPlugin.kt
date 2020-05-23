package com.kushkipagos.flutter_kushki_library

import android.os.AsyncTask
import androidx.annotation.NonNull;
import com.kushkipagos.android.*

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar

/** FlutterKushkiLibraryPlugin */
public class FlutterKushkiLibraryPlugin: FlutterPlugin, MethodCallHandler {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel : MethodChannel

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.getFlutterEngine().getDartExecutor(), "flutter_kushki_library")
    channel.setMethodCallHandler(this);
  }

  // This static function is optional and equivalent to onAttachedToEngine. It supports the old
  // pre-Flutter-1.12 Android projects. You are encouraged to continue supporting
  // plugin registration via this function while apps migrate to use the new Android APIs
  // post-flutter-1.12 via https://flutter.dev/go/android-project-migration.
  //
  // It is encouraged to share logic between onAttachedToEngine and registerWith to keep
  // them functionally equivalent. Only one of onAttachedToEngine or registerWith will be called
  // depending on the user's project. onAttachedToEngine or registerWith must both be defined
  // in the same class.
  companion object {
    @JvmStatic
    fun registerWith(registrar: Registrar) {
      val channel = MethodChannel(registrar.messenger(), "flutter_kushki_library")
      channel.setMethodCallHandler(FlutterKushkiLibraryPlugin())
    }
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    if (call.method == "getPlatformVersion") {
      result.success("Android ${android.os.Build.VERSION.RELEASE}")
    } else if (call.method == "requestSubscriptionToken") {
      val publicMerchantId: String? = call.argument<String>("publicMerchantId")
      val name: String? = call.argument<String>("name")
      val number: String? = call.argument<String>("number")
      val cvv: String? = call.argument<String>("cvv")
      val expiryMonth: String? = call.argument<String>("expiryMonth")
      val expiryYear: String? = call.argument<String>("expiryYear")
      val currency: String = call.argument<String>("currency") ?: "USD"
      val environment: String = call.argument<String>("environment") ?: "TESTING"

      val env: KushkiEnvironment

      env = when(environment){
        "CI"-> KushkiEnvironment.CI
        "PRODUCTION"-> KushkiEnvironment.PRODUCTION
        "QA"-> KushkiEnvironment.QA
        "PRODUCTION_REGIONAL"-> KushkiEnvironment.PRODUCTION_REGIONAL
        "STAGING"-> KushkiEnvironment.STAGING
        "UAT_REGIONAL"-> KushkiEnvironment.UAT_REGIONAL
        else -> KushkiEnvironment.TESTING
      }

      if (name != null && number != null && cvv != null && expiryMonth != null && expiryYear != null && publicMerchantId != null) {
        val kushki = Kushki(publicMerchantId, currency, env, false)
        val card = Card(name, number, cvv, expiryMonth, expiryYear)
        try {
          (object: AsyncTask<Void, Void, Transaction?>() {

            override fun doInBackground(vararg p0: Void): Transaction? {
              return kushki.requestSubscriptionToken(card)
            }

            override fun onPostExecute(response: Transaction?) {
              val isSuccessful = response?.isSuccessful ?: false
              val responseCode = response?.code ?: ""
              val token = response?.token ?: ""
              val message = response?.message ?: ""
              var code = if (isSuccessful && responseCode == "000") "SUCCESS" else "ERROR"
              val responseData  = mapOf<String, Any?>("code" to code, "token" to token, "message" to message)
              result.success(responseData)
            }
          }).execute()
        } catch (e: KushkiException) {
          println("--------------- kushki error message")
          println(e.message)
          val responseData  = mapOf<String, Any?>("code" to "ERROR", "token" to "", "message" to e.message)
          result.success(responseData)
        }
      }


    }
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }
}

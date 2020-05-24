import Flutter
import UIKit

public class SwiftFlutterKushkiLibraryPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "flutter_kushki_library", binaryMessenger: registrar.messenger())
    let instance = SwiftFlutterKushkiLibraryPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    if call.method == "getPlatformVersion" {
        let platformVersion = UIDevice.current.systemVersion
        result("iOS " + platformVersion)
    } else if call.method == "requestSubscriptionToken" {
        guard let args = call.arguments as? [String: Any] else {
            let response: [String: Any] = ["code": "ERROR", "message": "There are no arguments"]
            result(response)
            return
        }
        let response: [String: Any] = ["code": "ERROR", "message": "Unexpected error"]
        let publicMerchantId = args["publicMerchantId"] as! String
        let name = args["name"] as! String
        let number = args["number"] as! String
        let cvv = args["cvv"] as! String
        let expiryMonth = args["expiryMonth"] as! String
        let expiryYear = args["expiryYear"] as! String
        let currency = args["currency"] as! String
    }
  }
    
    private func initKushki(privateKey: String, publicKey: String, env: String) {
        
    }
    
    private func requestSubscriptionToken() {
        
    }
    
    private func getKushkiEnv(env: String) {
        
    }
    
}

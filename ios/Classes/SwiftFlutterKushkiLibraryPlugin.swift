import Flutter
import UIKit
import Kushki

public class SwiftFlutterKushkiLibraryPlugin: NSObject, FlutterPlugin {
    
    private var kushki: Kushki? = nil
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "flutter_kushki_library", binaryMessenger: registrar.messenger())
        let instance = SwiftFlutterKushkiLibraryPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if call.method == "getPlatformVersion" {
            let platformVersion = UIDevice.current.systemVersion
            result("iOS " + platformVersion)
        } else if call.method == "initKuhski" {
            guard let args = call.arguments as? [String: Any] else {
                let response = self.createResponse(code: "ERROR",
                                                   message: "There are no arguments")
                result(response)
                return
            }
            let publicMerchantId = args["publicMerchantId"] as! String
            let env = args["environment"] as! String
            let currency = args["currency"] as! String
            let kushkiEnv = self.getKushkiEnv(env: env)
            self.initKushki(publicKey: publicMerchantId,
                            currency: currency, env: kushkiEnv)
            let response = self.createResponse(code: "SUCCESS",
                                               message: "Kushki initialized")
            result(response)
        } else if call.method == "requestSubscriptionToken" {
            guard let args = call.arguments as? [String: Any] else {
                let response = self.createResponse(code: "ERROR",
                                                   message: "There are no arguments")
                result(response)
                return
            }
            let name = args["name"] as! String
            let number = args["number"] as! String
            let cvv = args["cvv"] as! String
            let expiryMonth = args["expiryMonth"] as! String
            let expiryYear = args["expiryYear"] as! String
            let card = Card(name: name, number: number,
                            cvv: cvv, expiryMonth: expiryMonth,
                            expiryYear: expiryYear)
            guard let kush = self.kushki else {
                let response = self.createResponse(code: "ERROR", message: "Kushki not initialized")
                result(response)
                return
            }
            kush.requestSubscriptionToken(card: card) { (transaction) in
                if transaction.isSuccessful() && transaction.code == "000" {
                    let response = self.createResponse(code: "SUCCESS", message: transaction.message, token: transaction.token)
                    result(response)
                    return
                } else {
                    let response = self.createResponse(code: "ERROR", message: transaction.message)
                    result(response)
                    return
                }
            }
        }
    }
    
    private func initKushki(publicKey: String,
                            currency: String,
                            env: KushkiEnvironment) {
        if self.kushki == nil {
            self.kushki = Kushki(publicMerchantId: publicKey,
                                 currency: currency,
                                 environment: env)
        }
    }
    
    private func getKushkiEnv(env: String) -> KushkiEnvironment {
        switch env {
        case "CI":
            return .testing_ci
        case "QA":
            return .testing_qa
        case "PRODUCTION":
            return .production
        case "PRODUCTION_REGIONAL":
            return .production_regional
        case "UAT_REGIONAL":
            return .testing_regional
        default:
            return .testing
        }
    }
    
    private func createResponse(code: String,
                                message: String,
                                token: String = "") -> [String: Any] {
        return ["code": code, "message": message, "token": token]
    }
    
}

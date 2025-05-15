import 'dart:async';
// In order to *not* need this ignore, consider extracting the "web" version
// of your plugin as a separate package, instead of inlining it in the same
// package as the core of your plugin.
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'dart:js';
//import 'package:js/js.dart';

import 'package:flutter/services.dart';
import 'package:flutter_kushki_library/src/kushki_request.dart';
//import 'package:flutter_kushki_library/src/kushki.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

import 'src/kushki_card.dart';
import 'src/kushki_response.dart';

/// A web implementation of the FlutterKushkiLibrary plugin.
class FlutterKushkiLibraryWeb {
  late String currency;
  late bool isTesting;
  late JsObject kushki;

  static void registerWith(Registrar registrar) {
    final MethodChannel channel = MethodChannel(
      'flutter_kushki_library',
      const StandardMethodCodec(),
      registrar.messenger,
    );

    var script = html.ScriptElement()
      ..src = 'src/js_utilities/kushki_provider.js'
      ..type = 'application/javascript';

    final pluginInstance = FlutterKushkiLibraryWeb();
    channel.setMethodCallHandler(pluginInstance.handleMethodCall);
  }

  /// Handles method calls over the MethodChannel of this plugin.
  /// Note: Check the "federated" architecture for a new way of doing this:
  /// https://flutter.dev/go/federated-plugins
  Future<dynamic> handleMethodCall(MethodCall call) async {
    switch (call.method) {
      case 'getPlatformVersion':
        return getPlatformVersion();
        break;
      case 'initKushki':
        final env = call.arguments['environment'] ?? 'TESTING';
        final publicMerchantId = call.arguments['publicMerchantId'];
        this.currency = call.arguments['currency'] ?? 'USD';
        this.isTesting = env == 'TESTING';
        final response = initKushki(publicMerchantId);
        return response;
        break;
      case 'requestSubscriptionToken':
        final name = call.arguments['name'];
        final number = call.arguments['number'];
        final cvc = call.arguments['cvv'];
        final expiryMonth = call.arguments['expiryMonth'];
        final expiryYear = call.arguments['expiryYear'];
        final response = await this.requestSubscriptionToken(
            name, number, cvc, expiryMonth, expiryYear);
        return response;
        break;
      default:
        throw PlatformException(
          code: 'Unimplemented',
          details:
              'flutter_kushki_library for web doesn\'t implement \'${call.method}\'',
        );
    }
  }

  /// Returns a [String] containing the version of the platform.
  Future<String> getPlatformVersion() {
    final version = html.window.navigator.userAgent;
    return Future.value(version);
  }

  /// Should be called before any other process.
  /// This initializer requires your account public merchant id
  /// currency default = USD
  /// env (environment) default = TESTING
  /// return KushkiResponse {code SUCCESS|ERROR, message String}
  Map<String, dynamic> initKushki(String publicMerchantId) {
    try {
      final params = JsObject.jsify({
        'merchantId': publicMerchantId,
        'inTestEnvironment': this.isTesting
      });
      this.kushki = JsObject(context['Kushki'], [params]);
      return {"code": "SUCCESS", "token": "", "message": "Kushki initialized"};
    } catch (e) {
      return {
        'code': 'ERROR',
        'token': '',
        'message': 'Kushki initialize error'
      };
    }
  }

  /// Should be used to return a subscription card token
  /// Requieres initKushki to be already called
  /// KushkiCard card {name, number, cvv, expiryMonth, expiryYear}
  /// return KushkiResponse {code SUCCESS|ERROR, token String, message String}
  Future<Map<String, dynamic>> requestSubscriptionToken(
      String? name,
      String? number,
      String? cvc,
      String? expiryMonth,
      String? expiryYear) async {
    final completer = Completer<Map<String, dynamic>>();
    context['callback'] = allowInterop((JsObject event) {
      final response = {
        'code': event['code'] ?? 'SUCCESS',
        'token': event['token'],
        'message': event['message']
      };
      print(response['token']);
      completer.complete(response);
    });

    if (name != null &&
        number != null &&
        cvc != null &&
        expiryMonth != null &&
        expiryYear != null) {
      final card = JsKushkiCard(
          name: name,
          number: number,
          cvc: cvc,
          expiryMonth: expiryMonth,
          expiryYear: expiryYear);
      final domain = JsObject.jsify(
          JsKushkiTokenRequest(currency: this.currency, card: card).toMap());
      this.kushki.callMethod(
          'requestSubscriptionToken', [domain, context['callback']]);
    } else {
      completer.complete(
          {'code': 'ERROR', 'token': '', 'message': 'Incomplete data'});
    }
    return completer.future;
  }
}

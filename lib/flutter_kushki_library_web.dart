import 'dart:async';
// In order to *not* need this ignore, consider extracting the "web" version
// of your plugin as a separate package, instead of inlining it in the same
// package as the core of your plugin.
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'package:js/js.dart';


import 'package:flutter/services.dart';
import 'package:flutter_kushki_library/src/Kushki.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

import 'src/kushki_card.dart';
import 'src/kushki_response.dart';

/// A web implementation of the FlutterKushkiLibrary plugin.
class FlutterKushkiLibraryWeb {
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
    bool isTesting;
    switch (call.method) {
      case 'getPlatformVersion':
        return getPlatformVersion();
        break;
      case 'initKushki':
        final publicMerchantId = call.arguments['publicMerchantId'];
        final currency = call.arguments['currency'] ?? 'USD';
        final env = call.arguments['environment'] ?? 'TESTING';
        isTesting = env == 'TESTING';
        this.initKushki(publicMerchantId, isTesting);
        break;
      default:
        throw PlatformException(
          code: 'Unimplemented',
          details: 'flutter_kushki_library for web doesn\'t implement \'${call.method}\'',
        );
    }
  }

  /// Returns a [String] containing the version of the platform.
  Future<String> getPlatformVersion() {
    final version = html.window.navigator.userAgent;
    return Future.value(version);
  }

  void initKushki(String publicMerchantId, bool isTesting ){
    void _responseCallBack(KushkiResponse kr){
      print(kr.token);
    }

    final params = KushkiParams(merchantId: publicMerchantId, inTestEnvironment: isTesting);
    final k = Kushki(params);
    final card = KushkiCard();
    card.name = 'Aagtje Blokland';
    card.number = '377815539842437';
    card.cvv = '267';
    card.expiryMonth = '12';
    card.expiryYear = '21';
    final domain = KushkiTokenRequestDomain(amount: '0', currency: 'COP', card: card);

    k.requestToken(domain, allowInterop(_responseCallBack));
  }
}


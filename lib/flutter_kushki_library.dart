import 'dart:async';

import 'package:flutter/services.dart';

class FlutterKushkiLibrary {
  static const MethodChannel _channel =
      const MethodChannel('flutter_kushki_library');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<String> requestSubscriptionToken() async {
    final value = await _channel.invokeMethod('requestSubscriptionToken', <String, dynamic>{
      'publicMerchantId': 'a4bc5f4792e24bb58fe964f51d274d43',
      'name': 'Aagtje Blokland',
      'number': '377815539842437',
      'cvv': '267',
      'expiryMonth': '12',
      'expiryYear': '21',
      'currency': 'COP',
      'environment': 'TESTING',
    });
    return value;
  }

}

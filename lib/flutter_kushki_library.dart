import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_kushki_library/src/kushki_card.dart';
import 'package:flutter_kushki_library/src/kushki_currency_enum.dart';
import 'package:flutter_kushki_library/src/kushki_env_enum.dart';
import 'package:flutter_kushki_library/src/kushki_response.dart';

export 'src/kushki_card.dart';
export 'src/kushki_currency_enum.dart';
export 'src/kushki_env_enum.dart';
export 'src/kushki_response.dart';

class FlutterKushkiLibrary {
  static const MethodChannel _channel =
      const MethodChannel('flutter_kushki_library');

  /// Should be called before any other process.
  /// This initializer requires your account public merchant id
  /// currency default = USD
  /// end (environment) default = TESTING
  /// return KushkiResponse {code SUCCESS|ERROR, message String}
  static Future<KushkiResponse> initKushki(String publicMerchantId,
      {KushkiCurrency currency = KushkiCurrency.USD,
      KushkiEnv env = KushkiEnv.TESTING}) async {
    final Map<dynamic, dynamic> map =
        await _channel.invokeMethod('initKushki', <String, dynamic>{
      'publicMerchantId': publicMerchantId,
      'currency': _kushkiCurrencyToString(currency),
      'environment': _kushkiEnvToString(env),
    });

    final mapCast = map.cast<String, dynamic>();

    return KushkiResponse.fromMap(mapCast);
  }

  /// Should be used to return a subscription card token
  /// Requieres initKushki to be already called
  /// KushkiCard card {name, number, cvv, expiryMonth, expiryYear}
  /// return KushkiResponse {code SUCCESS|ERROR, token String, message String}
  static Future<KushkiResponse> requestSubscriptionToken(
      KushkiCard card) async {
    final Map<dynamic, dynamic> map = await _channel
        .invokeMethod('requestSubscriptionToken', <String, dynamic>{
      'name': card.name,
      'number': card.number,
      'cvv': card.cvv,
      'expiryMonth': card.expiryMonth,
      'expiryYear': card.expiryYear
    });

    final mapCast = map.cast<String, dynamic>();

    return KushkiResponse.fromMap(mapCast);
  }

  static String _kushkiEnvToString(KushkiEnv env) {
    switch (env) {
      case KushkiEnv.CI:
        return 'CI';
      case KushkiEnv.QA:
        return 'QA';
      case KushkiEnv.PRODUCTION:
        return 'PRODUCTION';
      case KushkiEnv.PRODUCTION_REGIONAL:
        return 'PRODUCTION_REGIONAL';
      case KushkiEnv.STAGING:
        return 'STAGING';
      case KushkiEnv.TESTING:
        return 'TESTING';
      case KushkiEnv.UAT_REGIONAL:
        return 'UAT_REGIONAL';
    }
    return '';
  }

  static String _kushkiCurrencyToString(KushkiCurrency currency) {
    switch (currency) {
      case KushkiCurrency.USD:
        return 'USD';
      case KushkiCurrency.COP:
        return 'COP';
      case KushkiCurrency.CLP:
        return 'CLP';
      case KushkiCurrency.UF:
        return 'UF';
      case KushkiCurrency.PEN:
        return 'PEN';
    }
    return '';
  }
}

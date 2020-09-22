import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_kushki_library/flutter_kushki_library.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  String _cardToken = 'Unknown';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    String initResult;
    KushkiResponse response;
    try {
      final init = await FlutterKushkiLibrary.initKushki('merchant-id', currency: KushkiCurrency.COP);
      initResult = init.code == KushkiReponceCode.SUCCESS ? "SUCCESS" : "ERROR";
      KushkiCard card = KushkiCard();
      card.name = 'Aagtje Blokland';
      card.number = '377815539842437';
      card.cvv = '267';
      card.expiryMonth = '12';
      card.expiryYear = '21';
      response = await FlutterKushkiLibrary.requestSubscriptionToken(card);
      print('response: $response');
    } on PlatformException {
      print('error');
      initResult = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = initResult;
      try {
        _cardToken = response?.token ?? 'again unknown';
      } catch(e) {
        print('error 2');
        print('error 2: $e');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Kushki Library Plugin'),
        ),
        body: Center(
          child: Text('Kushki init result: $_platformVersion\n token: $_cardToken'),
        ),
      ),
    );
  }
}

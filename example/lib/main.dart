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
  String _responseCode = 'Unknown';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    dynamic response;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await FlutterKushkiLibrary.platformVersion;
      response = await FlutterKushkiLibrary.requestSubscriptionToken();
      print('response: $response');
    } on PlatformException {
      print('error');
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
      try {
        _responseCode = response?.code ?? 'aja unknown';
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
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Text('Running on: $_platformVersion\n responseCode: $_responseCode'),
        ),
      ),
    );
  }
}

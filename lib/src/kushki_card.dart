import 'package:flutter/material.dart';

class KushkiCard {

  String name;
  String number;
  String cvv;
  String expiryMonth;
  String expiryYear;

  KushkiCard({
    required this.name,
    required this.number,
    required this.cvv,
    required this.expiryMonth,
    required this.expiryYear,
  });
}

class JsKushkiCard{
  final String name;
  final String number;
  final String cvc;
  final String expiryMonth;
  final String expiryYear;
  JsKushkiCard({required this.name, required this.number, required this.cvc, required this.expiryMonth, required this.expiryYear});

  Map<String, dynamic> toMap(){
    return{
      'name': name,
      'number': number,
      'cvc': cvc,
      'expiryMonth': expiryMonth,
      'expiryYear': expiryYear,
    };
  }
}
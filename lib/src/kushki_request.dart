import 'kushki_card.dart';

class JsKushkiTokenRequest{
  final String amount;
  final String currency;
  final JsKushkiCard card;
  JsKushkiTokenRequest({this.amount, this.currency, this.card});

  Map<String, dynamic> toMap(){
    return{
      'amount': amount,
      'currency': currency,
      'card': card.toMap(),
    };
  }
}
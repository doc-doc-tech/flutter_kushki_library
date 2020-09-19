@JS('Kushki')
library Kushki;

import 'package:js/js.dart';

import '../flutter_kushki_library.dart';
import 'kushki_response.dart';

@JS('Kushki')
class Kushki {

  external factory Kushki(KushkiParams params);

  external void requestToken(
      KushkiTokenRequestDomain data, Function(KushkiResponse) response);
}

@JS()
@anonymous
class KushkiParams {
  external String get merchantId;
  external bool get inTestEnvironment;

  external factory KushkiParams({String merchantId, bool inTestEnvironment});
}

@JS()
@anonymous
class KushkiTokenRequestDomain {
  String amount;
  String currency;
  KushkiCard card;

  external factory KushkiTokenRequestDomain(
      {String amount, String currency, KushkiCard card});
}

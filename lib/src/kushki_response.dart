class KushkiResponse {

  final KushkiReponceCode code;
  final String token;
  final String message;

  KushkiResponse(this.code, this.token, this.message);

  factory KushkiResponse.fromMap(Map<String, dynamic> map) {
    final incominCode = map['code'];
    final code = incominCode == 'SUCCESS' ? KushkiReponceCode.SUCCESS : KushkiReponceCode.ERROR;
    return KushkiResponse(
        code, map['token'], map['message']
    );
  }

}

enum KushkiReponceCode {
  SUCCESS, ERROR
}
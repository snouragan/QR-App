class QRCode {
  final String text;
  final String code;
  final DateTime start;
  final DateTime end;

  const QRCode(
      {required this.text,
      required this.code,
      required this.start,
      required this.end});

  factory QRCode.fromJson(Map<String, dynamic> json) {
    return QRCode(
      text: json['text'],
      code: json['code'],
      start: DateTime.parse(json['start']),
      end: DateTime.parse(json['end']),
    );
  }

  Map<String, dynamic> toJson() => {
        'text': text,
        'code': code,
        'start': start.toString(),
        'end': end.toString()
      };
}

class Lab {
  final String code;
  final String name;
  final String owner;
  final List<String> participants;
  final List<String> pending;
  final DateTime start;
  final DateTime end;

  const Lab(
      {required this.code,
      required this.name,
      required this.owner,
      required this.participants,
      required this.pending,
      required this.start,
      required this.end});

  factory Lab.fromJson(Map<String, dynamic> json) {
    return Lab(
      code: json['code'],
      name: json['name'],
      owner: json['owner'],
      participants:
          (json['participants'] as List).map((x) => x as String).toList(),
      pending:
          (json['pending'] as List).map((x) => x as String).toList(),
      start: DateTime.parse(json['start']),
      end: DateTime.parse(json['end']),
    );
  }

  Map<String, dynamic> toJson() => {
        'code': code,
        'name': name,
        'owner': owner,
        'participants': participants,
        'pending': pending,
        'start': start.toString(),
        'end': end.toString()
      };
}

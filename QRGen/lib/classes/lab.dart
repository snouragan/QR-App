class Lab {
  final int id;
  final String name;
  final String owner;
  final List<String> participants;
  final DateTime start;
  final DateTime end;

  const Lab(
      {required this.id,
      required this.name,
      required this.owner,
      required this.participants,
      required this.start,
      required this.end});

  factory Lab.fromJson(Map<String, dynamic> json) {
    return Lab(
      id: json['id'],
      name: json['name'],
      owner: json['owner'],
      participants:
          (json['participants'] as List).map((x) => x as String).toList(),
      start: DateTime.parse(json['start']),
      end: DateTime.parse(json['end']),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'owner': owner,
        'participants': participants,
        'start': start.toString(),
        'end': end.toString()
      };
}

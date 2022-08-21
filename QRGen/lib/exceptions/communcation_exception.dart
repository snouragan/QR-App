class CommunicationException implements Exception {

  final String message;

  const CommunicationException({required this.message});

  @override
  String toString() {
    return message;
  }
}
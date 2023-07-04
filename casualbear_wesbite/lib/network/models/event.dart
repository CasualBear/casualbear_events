class Event {
  final int id;
  final String name;
  final String description;
  final int selectedColor;
  final String rawUrl;
  final DateTime createdAt;
  final DateTime updatedAt;

  Event({
    required this.id,
    required this.name,
    required this.description,
    required this.selectedColor,
    required this.rawUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    final eventJson = json['event'];
    return Event(
      id: eventJson['id'],
      name: eventJson['name'],
      description: eventJson['description'],
      selectedColor: eventJson['selectedColor'],
      rawUrl: eventJson['rawUrl'],
      createdAt: DateTime.parse(eventJson['createdAt']),
      updatedAt: DateTime.parse(eventJson['updatedAt']),
    );
  }
}

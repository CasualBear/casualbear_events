import 'dart:html';

class Event {
  final int id;
  final String name;
  final String description;
  final int selectedColor;
  final File iconFile;
  final int createdAt;

  Event(this.id, this.name, this.description, this.selectedColor, this.iconFile, this.createdAt);
}

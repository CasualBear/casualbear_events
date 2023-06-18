import 'package:json_annotation/json_annotation.dart';

part 'event.g.dart';

@JsonSerializable()
class Event {
  final int id;
  final String name;
  final String description;
  final int selectedColor;
  final String? rawUrl;
  final String createdAt;

  Event(this.id, this.name, this.description, this.selectedColor, this.rawUrl, this.createdAt);

  factory Event.fromJson(Map<String, dynamic> json) => _$EventFromJson(json);
  Map<String, dynamic> toJson() => _$EventToJson(this);
}

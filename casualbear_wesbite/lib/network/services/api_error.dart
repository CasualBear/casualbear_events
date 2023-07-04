import 'package:json_annotation/json_annotation.dart';

part 'api_error.g.dart';

@JsonSerializable()
class ApiError implements Exception {
  String message;
  List<dynamic>? details;

  ApiError({required this.message, this.details});

  factory ApiError.fromJson(Map<String, dynamic> json) => _$ApiErrorFromJson(json);

  Map<String, dynamic> toJson() => _$ApiErrorToJson(this);

  static String get defaultErrorMessage => 'Something went wrong.'; // TODO: Revise copy?
}

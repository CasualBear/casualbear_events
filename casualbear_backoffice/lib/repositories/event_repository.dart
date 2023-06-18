import 'package:casualbear_backoffice/network/services/api_service.dart';
import '../network/services/api_error.dart';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';

class EventRepository {
  final ApiService apiService;

  EventRepository(this.apiService);

  createEvent(List<int> file, String fileName, String name, String description, String color) async {
    try {
      FormData formData = FormData.fromMap({
        "file": MultipartFile.fromBytes(
          file,
          filename: fileName,
          contentType: MediaType("image", "png"),
        ),
        "name": name,
        "description": description,
        "selectedColor": color,
      });
      await apiService.post("/api/event/upload-event", body: formData);
    } on DioException catch (e) {
      if (e.response != null) {
        throw ApiError.fromJson(e.response!.data['error']);
      } else {
        rethrow;
      }
    }
  }
}

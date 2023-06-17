import 'dart:html' as html;
import 'package:casualbear_backoffice/network/services/api_service.dart';
import 'package:dio/dio.dart';
import '../network/services/api_error.dart';

class EventRepository {
  final ApiService apiService;

  EventRepository(this.apiService);

  createFile(html.FormData formData) async {
    try {
      await apiService.post('/api/event/createFile', body: formData);
      return true;
    } on DioException catch (e) {
      if (e.response != null) {
        throw ApiError.fromJson(e.response!.data['error']);
      } else {
        rethrow;
      }
    }
  }
}

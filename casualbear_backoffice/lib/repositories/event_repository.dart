import 'package:casualbear_backoffice/network/models/event.dart';
import 'package:casualbear_backoffice/network/services/api_service.dart';
import '../network/services/api_error.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class EventRepository {
  final ApiService apiService;

  EventRepository(this.apiService);

  createEvent(List<int> selectedFile, String name, String description, String color) async {
    try {
      var url = Uri.parse("https://casuabearapi.herokuapp.com/api/event/upload-event");
      var request = http.MultipartRequest("POST", url);
      request.files.add(await http.MultipartFile.fromBytes('iconFile', selectedFile,
          contentType: MediaType('application', 'json'), filename: "icon"));

      request.fields['name'] = name; // Add name field
      request.fields['description'] = description;
      request.fields['selectedColor'] = color;
      await request.send();
    } on DioException catch (e) {
      if (e.response != null) {
        throw ApiError.fromJson(e.response!.data['error']);
      } else {
        rethrow;
      }
    }
  }

  Future<List<Event>> getEvent() async {
    try {
      final response = await apiService.get('/api/event/events');
      var listOfEvents = List<Event>.from(response.data['events'].map((i) => Event.fromJson(i)));
      return listOfEvents;
    } catch (e) {
      print(e);
      return [];
    }
  }
}

import 'package:casualbear_website/network/models/event.dart';
import 'package:casualbear_website/network/services/api_service.dart';

class GenericRepository {
  final ApiService apiService;

  GenericRepository(this.apiService);

  Future<Event> getEventDetails(String eventId) async {
    try {
      final response = await apiService.get('/api/event/events/$eventId');
      var event = Event.fromJson(response.data);
      return event;
    } catch (e) {
      throw Exception('Failed to fetch event details');
    }
  }
}

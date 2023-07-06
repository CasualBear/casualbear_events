import 'dart:convert';
import 'package:casualbear_backoffice/network/services/api_service.dart';

class AuthenticationRepository {
  final ApiService apiService;

  AuthenticationRepository(this.apiService);

  Future<String> login(String username, String password) async {
    try {
      final body = jsonEncode({'email': username, 'password': password});
      final response = await apiService.post('/api/user/login', body: body);
      final String token = response.data['token'];
      return token;
    } catch (e) {
      print(e);
      throw Exception();
    }
  }
}

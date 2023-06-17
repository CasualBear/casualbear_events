import 'package:dio/dio.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

import 'dio_logger.dart';

final Dio dio = Dio();

class ApiNetworkInterceptor extends Interceptor {
  static String tag = 'services_base_api';
  String? token;

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    Map<String, dynamic> headers = {
      'Accept': 'application/json',
      'content-type': 'application/json',
    };

    if (token != null && JwtDecoder.isExpired(token!)) {
      _logout();
    } else if (token != null) {
      options.headers.addAll({...headers, 'Authorization': 'Bearer $token'});
    } else {
      options.headers.addAll(headers); //authentication phase doesn't have a token yet
    }
    handler.next(options);
    // super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    DioLogger.onSuccess(tag, response);
    super.onResponse(response, handler);
  }

  @override
  dynamic onError(DioException err, ErrorInterceptorHandler handler) {
    DioLogger.onError(tag, err);
    if (err.response?.statusCode == 401) {
      _logout(performApiLogout: false);
    }
    throw err;
  }

  _logout({bool performApiLogout = true}) async {
    try {
      if (performApiLogout) {
        await ApiService.shared.post('/auth/logout');
      }
    } catch (e) {
      throw Exception('Error while logging out');
    }
  }
}

class ApiService {
  static String baseURL = 'http://localhost:8000'; //default value for testing
  static const apiVersion = '1';
  static const tokenKey = 'bedrock_token'; // This is used for local token storage

  static ApiService shared = ApiService();

  static setBaseURL(String url) {
    baseURL = url;
  }

  static String imageUrl(String hash) {
    return '$baseURL/$apiVersion/uploads/$hash/image';
  }

  ApiService() {
    if (dio.interceptors.whereType<ApiNetworkInterceptor>().isEmpty) {
      dio.interceptors.add(ApiNetworkInterceptor());
    }

    dio.options.baseUrl = '$baseURL/$apiVersion';
    dio.options.connectTimeout = const Duration(milliseconds: 10000);
    dio.options.receiveTimeout = const Duration(milliseconds: 10000);
    dio.options.sendTimeout = const Duration(milliseconds: 10000);
  }

  Future<dynamic> post(String url, {dynamic body, Map<String, dynamic>? queryParams}) async {
    return await dio.post(url, data: body, queryParameters: queryParams);
  }

  Future<dynamic> get(String url, {Map<String, dynamic>? queryParameters}) async {
    return await dio.get(url, queryParameters: queryParameters);
  }

  Future<dynamic> put(String url, {dynamic body}) async {
    return await dio.put(url, data: body);
  }

  Future<dynamic> patch(String url, {dynamic body}) async {
    return await dio.patch(url, data: body);
  }

  Future<dynamic> delete(String url) async {
    return await dio.delete(url);
  }
}

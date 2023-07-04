import 'dart:convert';
import 'dart:developer';
import 'package:casualbear_website/network/services/api_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

// ignore_for_file: avoid_print
class DioLogger {
  static void onSend(String tag, RequestOptions options) {
    if (kDebugMode) {
      log('$tag - Request Path : [${options.method}] ${options.baseUrl}${options.path}${options.queryParameters}');

      log('$tag - Request Data : ${options.data.toString()}');
    }
  }

  static void onSuccess(String tag, Response response) {
    if (kDebugMode) {
      print('### ON SUCCESS ### \n');
      _printResponse(response);
    }
  }

  static void onError(String tag, DioException error) {
    if (kDebugMode) {
      print('### ON ERROR ###');
      if (null != error.response) {
        _printResponse(error.response!);
      } else {
        print(' Error without response: $error ');
      }
    }
  }

  static void _printResponse(Response response) async {
    String curlRequest = '';
    curlRequest +=
        'curl -H "Content-Type: application/json" -X ${response.requestOptions.method} "${ApiService.baseURL}/${ApiService.apiVersion}${response.requestOptions.path}" ';
    if (response.requestOptions.data != null) {
      final dataMap = json.encode(response.requestOptions.data);
      curlRequest += "-d '$dataMap'";
    }

    log(curlRequest);
    print('RequestURL ${ApiService.baseURL}${response.requestOptions.path} \n');

    print('RequestBody ${response.requestOptions.data.toString()} \n');
    print('Response ${response.data.toString()} \n');
  }
}

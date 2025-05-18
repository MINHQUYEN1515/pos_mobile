import 'package:dio/dio.dart';

import 'api_client.dart';
import 'api_interceptors.dart';

class ApiUtil {
  static Dio? dio;

  static Dio getDio() {
    if (dio == null) {
      dio = Dio();
      dio!.options.connectTimeout = Duration(seconds: 5);
      dio!.interceptors.add(ApiInterceptors());
    }
    return dio!;
  }

  static ApiClient get apiClient {
    final apiClient = ApiClient(getDio(), baseUrl: "http://192.168.88.86:8080");
    return apiClient;
  }
}

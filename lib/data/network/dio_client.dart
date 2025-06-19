// lib/data/network/dio_client.dart
import 'package:dio/dio.dart';

class DioClient {
  late final Dio _dio;

  DioClient() {
    _dio = Dio(
      BaseOptions(
        connectTimeout: Duration(seconds: 5), // 5 seconds
        receiveTimeout: Duration(seconds: 5), // 5 seconds
        // You could set a base URL here if all requests share it,
        // but Spotify and lrclib.net have different base URLs.
        // So, we'll specify full URLs in the data source methods.
      ),
    );

    // Example of adding an interceptor (optional, can be expanded later)
    // _dio.interceptors.add(LogInterceptor(responseBody: true, requestBody: true));
  }

  // Getter to access the Dio instance
  Dio get dio => _dio;
}

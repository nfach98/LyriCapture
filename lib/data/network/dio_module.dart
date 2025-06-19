// lib/data/network/dio_module.dart
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'dio_client.dart'; // Your DioClient

@module
abstract class DioModule {
  @lazySingleton // Or @singleton if you prefer
  DioClient get dioClient => DioClient();

  @lazySingleton // Or @singleton
  Dio dio(DioClient dioClient) => dioClient.dio;
}

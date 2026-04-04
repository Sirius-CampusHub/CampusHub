import 'package:dio/dio.dart';

Dio createAppHttpClient({String? baseUrl}) {
  return Dio(
    BaseOptions(
      baseUrl: baseUrl ?? 'https://api.example.com',
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      headers: const {'Accept': 'application/json'},
    ),
  );
}

import 'package:dio/dio.dart';

Dio createAppHttpClient({String? baseUrl}) {
  return Dio(
    BaseOptions(
      baseUrl: baseUrl ?? 'https://api.example.com',
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: const {'Accept': 'application/json'},
    ),
  );
}

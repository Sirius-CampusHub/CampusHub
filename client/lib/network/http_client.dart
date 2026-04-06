import 'package:client/core/api_config.dart';
import 'package:dio/dio.dart';

Dio createAppHttpClient({String? baseUrl}) {
  return Dio(
    BaseOptions(
      baseUrl: baseUrl ?? '${ApiConfig.baseUrl}/',
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      headers: const {'Accept': 'application/json'},
    ),
  );
}

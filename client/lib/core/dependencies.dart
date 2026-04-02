import 'package:dio/dio.dart';


final class Dependencies {
  const Dependencies({
    required this.dio,
  });

  final Dio dio;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Dependencies &&
          runtimeType == other.runtimeType &&
          dio == other.dio;

  @override
  int get hashCode => dio.hashCode;
}
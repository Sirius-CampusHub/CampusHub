import 'package:dio/dio.dart';
import '../data/repository/news_repository.dart';


final class Dependencies {
  const Dependencies({
    required this.dio,
    required this.newsRepository,
  });

  final Dio dio;
  final NewsRepository newsRepository;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Dependencies &&
          runtimeType == other.runtimeType &&
          dio == other.dio;

  @override
  int get hashCode => dio.hashCode;
}
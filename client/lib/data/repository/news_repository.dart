import 'dart:io';
import 'package:dio/dio.dart';
import 'package:client/domain/model/model.dart';
import 'auth_repository.dart';

class NewsRepository {
  final Dio _dio = Dio();
  final AuthRepository _authRepo;

  static const String _baseUrl = 'https://siriusapi.kod.polytech-schedule.ru/news';

  NewsRepository({required AuthRepository authRepo}) : _authRepo = authRepo;

  Future<Options> _getAuthOptions() async {
    final token = await _authRepo.getToken();
    if (token == null) throw Exception("Пользователь не авторизован");
    return Options(headers: {'Authorization': 'Bearer $token'});
  }

  Future<List<NewsModel>> getAllNews() async {
    try {
      final options = await _getAuthOptions();
      final response = await _dio.get('$_baseUrl/', options: options);

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => NewsModel.fromJson(json)).toList();
      } else {
        throw Exception("Не удалось загрузить новости");
      }
    } on DioException catch (e) {
      throw Exception("Ошибка сети при загрузке новостей: ${e.message}");
    }
  }

  Future<NewsModel> createNews({
    required String title,
    required String content,
    File? imageFile,
  }) async {
    try {
      final options = await _getAuthOptions();

      final formData = FormData.fromMap({
        "title": title,
        "content": content,
      });

      if (imageFile != null) {
        formData.files.add(MapEntry(
          "image",
          await MultipartFile.fromFile(
            imageFile.path,
            filename: imageFile.path.split('/').last,
          ),
        ));
      }

      final response = await _dio.post(
        '$_baseUrl/',
        data: formData,
        options: options,
      );

      return NewsModel.fromJson(response.data);
      
    } on DioException catch (e) {
      if (e.response?.statusCode == 403) {
        throw Exception("Доступ запрещен. Вы не состоите в студсовете.");
      } else if (e.response?.statusCode == 400) {
        throw Exception("Слишком большой файл или неверный формат (макс 2 МБ).");
      }
      final errorDetail = e.response?.data?['detail'] ?? e.message;
      throw Exception("Ошибка создания новости: $errorDetail");
    }
  }

  Future<void> deleteNews(String newsId) async {
    try {
      final options = await _getAuthOptions();
      
      await _dio.delete('$_baseUrl/$newsId', options: options);
      
    } on DioException catch (e) {
      if (e.response?.statusCode == 403) {
        throw Exception("Доступ запрещен. Только студсовет может удалять новости.");
      } else if (e.response?.statusCode == 404) {
        throw Exception("Новость не найдена (возможно, уже удалена).");
      }
      throw Exception("Ошибка удаления: ${e.message}");
    }
  }
}
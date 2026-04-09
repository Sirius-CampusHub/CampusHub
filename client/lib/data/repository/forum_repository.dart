import 'package:client/domain/model/topic_model.dart';
import 'package:dio/dio.dart';

import '../source/firebase_auth_source.dart';

class ForumRepository {
  final FirebaseAuthDataSource _authDataSource;
  final Dio _dio;

  ForumRepository({
    required Dio dio,
    required FirebaseAuthDataSource authDataSource,
  }) : _dio = dio,
       _authDataSource = authDataSource;

  final List<TopicModel> _mockTopics = [
    const TopicModel(
      id: '1',
      title: 'Как начать изучать Flutter в 2026?',
      author: 'Alex',
      repliesCount: 42,
    ),
    const TopicModel(
      id: '2',
      title: 'Где найти хорошую архитектуру?',
      author: 'Bob',
      repliesCount: 15,
    ),
    const TopicModel(
      id: '3',
      title: 'Помогите с ошибкой Provider / BLoC',
      author: 'Charlie',
      repliesCount: 3,
    ),
  ];

  Future<List<TopicModel>> getTopics() async {
    return List.from(_mockTopics);
    try {
      final rawToken = await _authDataSource.getToken();
      if (rawToken == null) {
        await _authDataSource.deleteCurrentUser();
        throw Exception('Не удалось получить токен после регистрации');
      }
      final response = await _dio.get(
        '/forum/topics',
        options: Options(headers: {'Authorization': 'Bearer $rawToken'}),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => TopicModel.fromJson(json)).toList();
      } else {
        throw Exception("Не удалось загрузить топики");
      }
    } on DioException catch (e) {
      throw Exception("Ошибка сети при загрузке топиков: ${e.message}");
    }
  }

  Future<void> createTopic(String title) async {
    _mockTopics.insert(
      0,
      TopicModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: title,
        author: 'Текущий Пользователь',
        repliesCount: 0,
      ),
    );

    // try {
    //   final rawToken = await _authDataSource.getToken();
    //   if (rawToken == null) {
    //     await _authDataSource.deleteCurrentUser();
    //     throw Exception('Не удалось получить токен после регистрации');
    //   }
    //   final formData = FormData.fromMap({
    //     "title": title,
    //   });
    //
    //   await _dio.post(
    //     '/forum/topics/',
    //     data: formData,
    //     options: Options(
    //       headers: {
    //         'Authorization': 'Bearer $rawToken',
    //       },
    //     ),
    //   );
    //
    // } on DioException catch (e) {
    //   if (e.response?.statusCode == 403) {
    //     throw Exception("Доступ запрещен. Вы не состоите в студсовете.");
    //   }
    //   final errorDetail = e.response?.data?['detail'] ?? e.message;
    //   throw Exception("Ошибка создания топика: $errorDetail");
    // }
  }
}

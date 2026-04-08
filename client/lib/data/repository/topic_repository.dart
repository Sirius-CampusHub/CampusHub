import 'package:client/domain/model/comment_model.dart';
import 'package:dio/dio.dart';

import '../source/firebase_auth_source.dart';

class TopicRepository {
  final FirebaseAuthDataSource _authDataSource;
  final Dio _dio;

  TopicRepository({
    required Dio dio,
    required FirebaseAuthDataSource authDataSource,
  }) : _dio = dio, _authDataSource = authDataSource;

  // Временно, далее должно подгружаться из кеша и обновляться от эндпоинта
  // final List<CommentModel> _mockComments = [
  //   const CommentModel(
  //       id: '1',
  //       author: 'Daniel',
  //       content: 'first comment!',
  //       topicId: '1',
  //   ),
  //   const CommentModel(
  //       id: '2',
  //       author: 'Hleb',
  //       content: 'another comment',
  //       topicId: '1',
  //   ),
  //   const CommentModel(
  //       id: '3',
  //       author: 'Varya',
  //       content: 'yet another comment',
  //       topicId: '2',
  //   ),
  // ];

  Future<List<CommentModel>> getComments(String topicId) async {
    // return List.from(_mockComments.where((x) => x.topicId == topicId));
    try {
      final rawToken = await _authDataSource.getToken();
      final response = await _dio.get(
        '/topic/comments',
        queryParameters: {'topic_id': topicId},
        options: Options(
          headers: {
            'Authorization': 'Bearer $rawToken',
          },
        ),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => CommentModel.fromJson(json)).toList();
      } else {
        throw Exception("Не удалось загрузить комментарии");
      }
    } on DioException catch (e) {
      throw Exception("Ошибка сети при загрузке топиков: ${e.message}");
    }
  }

  Future<void> createComment(String content, String topicId) async {
// topic/comments/post topic_id
    // В будущем здесь будет реальный POST-запрос на эндпоинт
    // _mockComments.insert(
    //   0,
    //   CommentModel(
    //       id: DateTime.now().millisecondsSinceEpoch.toString(),
    //       author: 'Текущий Пользователь',
    //       content: content,
    //       topicId: topicId,
    //   )
    // );

    try {
      final rawToken = await _authDataSource.getToken();
      final formData = FormData.fromMap({
        "content": content,
        "topic_id": topicId
      });

      await _dio.post(
        '/forum/topics/',
        data: formData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $rawToken',
          },
        ),
      );

    } on DioException catch (e) {
      if (e.response?.statusCode == 403) {
        throw Exception("Доступ запрещен. Вы не состоите в студсовете.");
      }
      final errorDetail = e.response?.data?['detail'] ?? e.message;
      throw Exception("Ошибка создания топика: $errorDetail");
    }
  }
}

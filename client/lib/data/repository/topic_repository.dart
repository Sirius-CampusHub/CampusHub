import 'dart:async';
import 'package:client/domain/model/comment_model.dart';

class TopicRepository {
  // Временно, далее должно подгружаться из кеша и обновляться от эндпоинта
  final List<CommentModel> _mockComments = [
    const CommentModel(
        id: '1',
        author: 'Daniel',
        content: 'first comment!'
    ),
    const CommentModel(
        id: '2',
        author: 'Hleb',
        content: 'another comment'
    ),
    const CommentModel(
        id: '3',
        author: 'Varya',
        content: 'yet another comment'
    ),
  ];

  Future<List<CommentModel>> getComments(String topicId) async {
    print(["Loading topic with topicId: ", topicId]);
    return List.from(_mockComments);
  }

  Future<void> createComment(String content) async {

    // В будущем здесь будет реальный POST-запрос на эндпоинт
    _mockComments.insert(
      0,
      CommentModel(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          author: 'Текущий Пользователь',
          content: content
      )
    );
  }
}

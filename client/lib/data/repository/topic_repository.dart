import 'package:client/domain/model/comment_model.dart';

class TopicRepository {
  // Временно, далее должно подгружаться из кеша и обновляться от эндпоинта
  final List<CommentModel> _mockComments = [
    const CommentModel(
        id: '1',
        author: 'Daniel',
        content: 'first comment!',
        topicId: '1',
    ),
    const CommentModel(
        id: '2',
        author: 'Hleb',
        content: 'another comment',
        topicId: '1',
    ),
    const CommentModel(
        id: '3',
        author: 'Varya',
        content: 'yet another comment',
        topicId: '2',
    ),
  ];

  Future<List<CommentModel>> getComments(String topicId) async {
    return List.from(_mockComments.where((x) => x.topicId == topicId));
  }

  Future<void> createComment(String content, String topicId) async {

    // В будущем здесь будет реальный POST-запрос на эндпоинт
    _mockComments.insert(
      0,
      CommentModel(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          author: 'Текущий Пользователь',
          content: content,
          topicId: topicId,
      )
    );
  }
}

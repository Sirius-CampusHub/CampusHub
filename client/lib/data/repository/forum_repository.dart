import 'package:client/domain/model/topic_model.dart';

class ForumRepository {
  // Временно, далее должно подгружаться из кеша и обновляться от эндпоинта
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
  }

  Future<void> createTopic(String title, String description) async {

    // В будущем здесь будет реальный POST-запрос на эндпоинт
    _mockTopics.insert(
      0,
      TopicModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: title,
        author: 'Текущий Пользователь',
        repliesCount: 0,
      ),
    );
  }
}

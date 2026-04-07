abstract class ForumEvent {}

class ForumLoadRequested extends ForumEvent {}

class ForumCreateTopicRequested extends ForumEvent {
  final String title;
  final String description;

  ForumCreateTopicRequested({required this.title, required this.description});
}

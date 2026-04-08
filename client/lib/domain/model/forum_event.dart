abstract class ForumEvent {}

class ForumLoadRequested extends ForumEvent {}

class ForumCreateTopicRequested extends ForumEvent {
  final String title;

  ForumCreateTopicRequested({required this.title});
}

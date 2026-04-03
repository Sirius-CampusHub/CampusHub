class TopicModel {
  final String id;
  final String title;
  final String author;
  final int repliesCount;

  const TopicModel({
    required this.id,
    required this.title,
    required this.author,
    required this.repliesCount,
  });

  factory TopicModel.fromJson(Map<String, dynamic> json) {
    return TopicModel(
      id: json['id'] as String,
      title: json['title'] as String,
      author: json['author'] as String,
      repliesCount: json['repliesCount'] as int? ?? 0,
    );
  }
}

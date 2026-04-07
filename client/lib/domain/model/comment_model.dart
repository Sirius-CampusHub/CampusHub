class CommentModel {
  final String id;
  final String author;
  final String content;
  final String topicId;

  const CommentModel({
    required this.id,
    required this.author,
    required this.content,
    required this.topicId,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      id: json['id'] as String,
      author: json['author'] as String,
      content: json['content'] as String,
      topicId: json['topicId'] as String,
    );
  }
}

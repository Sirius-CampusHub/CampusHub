class CommentModel {
  final String id;
  final String author;
  final String content;

  const CommentModel({
    required this.id,
    required this.author,
    required this.content,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      id: json['id'] as String,
      author: json['author'] as String,
      content: json['repliesCount'] as String,
    );
  }
}

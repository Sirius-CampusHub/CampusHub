class CommentModel {
  final String id;
  final String author;
  final String content;
  final String topicId; // не отдают с бека

  const CommentModel({
    required this.id,
    required this.author,
    required this.content,
    required this.topicId,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    final authorRaw =
        json['author'] ?? json['author_name'] ?? json['authorName'];
    final contentRaw = json['content'] ?? json['text'];
    final topicIdRaw = json['topicId'] ?? json['topic_id'] ?? json['topicID'];

    return CommentModel(
      id: (json['id'] ?? json['comment_id'])?.toString() ?? '',
      author: (authorRaw as String?)?.trim() ?? '',
      content: (contentRaw as String?)?.trim() ?? '',
      topicId: topicIdRaw?.toString() ?? '',
    );
  }
}

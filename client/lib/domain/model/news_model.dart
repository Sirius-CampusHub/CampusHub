class NewsModel {
  final String id;
  final String title;
  final String content;
  final String? imageUrl; // Может быть null
  final String authorId;
  final DateTime createdAt;

  static const String _baseUrl = 'https://siriusapi.kod.polytech-schedule.ru';

  NewsModel({
    required this.id,
    required this.title,
    required this.content,
    this.imageUrl,
    required this.authorId,
    required this.createdAt,
  });

  String? get fullImageUrl {
    if (imageUrl == null || imageUrl!.isEmpty) return null;
    return '$_baseUrl$imageUrl';
  }

  factory NewsModel.fromJson(Map<String, dynamic> json) {
    return NewsModel(
      id: json['id'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      imageUrl: json['image_url'] as String?,
      authorId: json['author_id'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }
}
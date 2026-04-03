import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:client/domain/model/news/news_model.dart';

class NewsRepository {

  final Dio _dio;
  NewsRepository({required Dio dio}) : _dio = dio;


  Stream<List<NewsModel>> getNewsStream() {
    var controller = new StreamController<List<NewsModel>>();
    List<NewsModel> news = [
      NewsModel(id: '', title: 'The question of universe, life and everything', content: '42', createdAt: DateTime(0)),
      NewsModel(id: '', title: 'Hallo', content: 'world', createdAt: DateTime(1)),
      NewsModel(id: '', title: 'Long Long Long Long Long Long title', content: 'Long Long Long Long Long Long Long Long Long Long Long Long Long Long Long Long Long Long body', createdAt: DateTime(2))
    ];
    controller.add(news);
    return controller.stream;
  }

  Future<String?> uploadImage(File imageFile) async {
    try {
      final fileName = DateTime.now().millisecondsSinceEpoch.toString();
      //TODO отправить картинку на сервер
      return "uploading file";
    } catch (e) {
      print('Ошибка загрузки изображения: $e');
      return null;
    }
  }

  Future<void> createNews({
    required String title,
    required String content,
    File? imageFile,
  }) async {
    String? imageUrl;
    if (imageFile != null) {
      imageUrl = await uploadImage(imageFile);
    }
    final news = NewsModel(
      id: '',
      title: title,
      content: content,
      imageUrl: imageUrl,
      createdAt: DateTime.now(),
    );
    //TODO отправить новость на сервер
  }

  Future<void> deleteNews(String id) async {
    //TODO удалить новость с сервера
  }
}
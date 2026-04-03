import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:client/domain/model/news_model.dart';

class NewsRepository {
  final Dio _dio;

  NewsRepository({required Dio dio}) : _dio = dio;

  Stream<List<NewsModel>> getNewsStream() async* {
    await Future.delayed(const Duration(milliseconds: 500));
    yield [
      NewsModel(id: '1', title: 'The question of universe, life and everything', content: '42', imageUrl: "https://media.istockphoto.com/id/1487223877/ru/%D0%B2%D0%B5%D0%BA%D1%82%D0%BE%D1%80%D0%BD%D0%B0%D1%8F/%D1%81%D0%B8%D0%BC%D0%BF%D0%B0%D1%82%D0%B8%D1%87%D0%BD%D1%8B%D0%B9-%D0%BC%D1%83%D0%BB%D1%8C%D1%82%D1%8F%D1%88%D0%BD%D1%8B%D0%B9-%D0%BF%D0%B5%D1%80%D1%81%D0%BE%D0%BD%D0%B0%D0%B6-%D0%BA%D1%80%D0%BE%D0%BA%D0%BE%D0%B4%D0%B8%D0%BB%D0%B0.jpg?s=612x612&w=is&k=20&c=EV3-u6l0F1vhyV8TV10ngGe4gkXU-qlt3H0Sga_iq2s=", createdAt: DateTime(0)),
      NewsModel(id: '2', title: 'Hallo', content: 'world', createdAt: DateTime(1)),
      NewsModel(id: '3', title: 'Long Long Long Long Long Long Long Long Long Long Long Long Long Long Long Long title', content: 'Long Long Long Long Long Long Long Long Long Long Long Long Long Long Long Long Long Long body', createdAt: DateTime(2)),
    ];
  }

  Future<String?> uploadImage(File imageFile) async {
    try {
      //TODO отправить картинку на сервер
      return "";
    } catch (e) {
      rethrow;
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
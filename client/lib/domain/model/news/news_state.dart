import 'package:client/domain/model/news/news_model.dart';

abstract class NewsState {}

class NewsInitial extends NewsState {}

class NewsLoading extends NewsState {}

class NewsLoaded extends NewsState {
  final List<NewsModel> newsList;
  NewsLoaded(this.newsList);
}

class NewsError extends NewsState {
  final String message;
  NewsError(this.message);
}

class NewsCreateSuccess extends NewsState {}

class NewsDeleteSuccess extends NewsState {}
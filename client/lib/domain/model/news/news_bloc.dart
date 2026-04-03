import 'package:bloc/bloc.dart';
import 'package:client/data/repository/news_repository.dart';
import 'news_event.dart';
import 'news_state.dart';

class NewsBloc extends Bloc<NewsEvent, NewsState> {
  final NewsRepository _repository;

  NewsBloc(this._repository) : super(NewsInitial()) {
    on<FetchNews>(_onFetchNews);
    on<CreateNews>(_onCreateNews);
    on<DeleteNews>(_onDeleteNews);
  }

  Future<void> _onFetchNews(FetchNews event, Emitter<NewsState> emit) async {
    emit(NewsLoading());
    try {
      // Используем stream для реального времени, но для простоты возьмём одноразовую загрузку
      final snapshot = await _repository.getNewsStream().first;
      emit(NewsLoaded(snapshot));
    } catch (e) {
      emit(NewsError(e.toString()));
    }
  }

  Future<void> _onCreateNews(CreateNews event, Emitter<NewsState> emit) async {
    try {
      await _repository.createNews(
        title: event.title,
        content: event.content,
        imageFile: event.imageFile,
      );
      emit(NewsCreateSuccess());
      add(FetchNews());
    } catch (e) {
      emit(NewsError(e.toString()));
    }
  }

  Future<void> _onDeleteNews(DeleteNews event, Emitter<NewsState> emit) async {
    try {
      await _repository.deleteNews(event.id);
      emit(NewsDeleteSuccess());
      add(FetchNews());
    } catch (e) {
      emit(NewsError(e.toString()));
    }
  }
}
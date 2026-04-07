import 'package:bloc/bloc.dart';

import 'package:client/data/repository/topic_repository.dart';
import 'package:client/domain/model/topic_event.dart';
import 'package:client/domain/model/topic_state.dart';

class TopicBloc extends Bloc<TopicEvent, TopicState> {
  final TopicRepository _repository;

  TopicBloc({required TopicRepository repository})
    : _repository = repository,
      super(TopicInitial()) {
    on<TopicLoadRequested>(_onLoadComments);
    on<TopicCreateCommentRequested>(_onCreateComment);
  }

  Future<void> _onLoadComments(
    TopicLoadRequested event,
    Emitter<TopicState> emit,
  ) async {
    emit(TopicLoading());

    try {
      final comments = await _repository.getComments(event.topicId);
      emit(TopicLoaded(comments: comments));
    } catch (e) {
      emit(TopicError(error: e.toString()));
    }
  }

  Future<void> _onCreateComment(
    TopicCreateCommentRequested event,
    Emitter<TopicState> emit,
  ) async {
    emit(TopicLoading());
    try {
      await _repository.createComment(event.content);
      add(TopicLoadRequested(topicId: event.topicId));
    } catch (e) {
      emit(TopicError(error: e.toString()));
    }
  }
}

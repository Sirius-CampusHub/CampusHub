import 'package:client/domain/model/forum_models/comment_model.dart';

abstract class TopicState {}

class TopicInitial extends TopicState {}

class TopicLoading extends TopicState {}

class TopicLoaded extends TopicState {
  final List<CommentModel> comments;

  TopicLoaded({required this.comments});
}

class TopicError extends TopicState {
  final String error;

  TopicError({required this.error});
}

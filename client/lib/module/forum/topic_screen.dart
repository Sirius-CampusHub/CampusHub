import 'package:client/domain/model/comment_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:client/domain/bloc/topic/topic_event.dart';
import 'package:client/domain/bloc/topic/topic_state.dart';
import 'package:client/domain/bloc/topic/topic_controller.dart';

import '../../core/dependencies.dart';

class TopicScreen extends StatelessWidget {
  final String topicId;
  final String title;
  const TopicScreen({super.key, required this.topicId, required this.title});

  @override
  Widget build(BuildContext context) {
    final topicRepository = context.dependencies.topicRepository;
    return BlocProvider(
      create: (context) =>
          TopicBloc(repository: topicRepository)
            ..add(TopicLoadRequested(topicId: topicId)),
      child: Scaffold(
        appBar: AppBar(title: Text(title)),
        body: Column(
          children: [
            Expanded(child: _TopicView(topicId: topicId)),
            Builder(
              builder: (context) => _CommentInputField(
                onSubmit: (content) {
                  context.read<TopicBloc>().add(
                    TopicCreateCommentRequested(
                      content: content,
                      topicId: topicId,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CommentInputField extends StatefulWidget {
  final void Function(String content) onSubmit;

  const _CommentInputField({required this.onSubmit});

  @override
  State<_CommentInputField> createState() => _CommentInputFieldState();
}

class _CommentInputFieldState extends State<_CommentInputField> {
  final _contentController = TextEditingController();

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.grey[300]!)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 8,
        left: 12,
        right: 12,
        top: 8,
      ),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(width: 1),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: TextField(
                controller: _contentController,
                minLines: 1,
                maxLines: 5,
                maxLength: 200,
                maxLengthEnforcement: MaxLengthEnforcement.enforced,
                decoration: InputDecoration(
                  hintText: 'Ваш комментарий...',
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                ),
                buildCounter:
                    (
                      context, {
                      required currentLength,
                      required maxLength,
                      required isFocused,
                    }) => null,
              ),
            ),
            const SizedBox(width: 8),
            Column(
              children: [
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    final content = _contentController.text.trim();

                    if (content.isNotEmpty) {
                      widget.onSubmit(content);
                      _contentController.clear();
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _TopicView extends StatelessWidget {
  final String topicId;
  const _TopicView({required this.topicId});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TopicBloc, TopicState>(
      builder: (context, state) {
        if (state is TopicInitial || state is TopicLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is TopicLoaded) {
          final comments = state.comments;

          if (comments.isEmpty) {
            return const Center(child: Text('Пока нет сообщений'));
          }

          return RefreshIndicator(
            onRefresh: () async {
              final topicBloc = context.read<TopicBloc>();
              final refreshCompleted = topicBloc.stream.firstWhere(
                (state) => state is TopicLoaded || state is TopicError,
              );

              topicBloc.add(TopicLoadRequested(topicId: topicId));

              await refreshCompleted;
            },
            child: ListView.builder(
              itemCount: comments.length,
              itemBuilder: (context, index) {
                return _Comment(comment: comments[index]);
              },
            ),
          );
        } else if (state is TopicError) {
          return Center(
            child: Text(
              'Ошибка: ${state.error}',
              style: const TextStyle(color: Colors.red),
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}

class _Comment extends StatelessWidget {
  final CommentModel comment;

  const _Comment({required this.comment});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor: Theme.of(
                    context,
                  ).colorScheme.primaryContainer,
                  child: Text(
                    comment.author[0].toUpperCase(),
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  comment.author,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(comment.content),
          ],
        ),
      ),
    );
  }
}

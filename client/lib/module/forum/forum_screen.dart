import 'package:client/module/forum/topic_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:client/data/repository/forum_repository.dart';
import 'package:client/domain/model/forum_event.dart';
import 'package:client/domain/model/forum_state.dart';
import 'package:client/domain/model/topic_model.dart';
import 'package:client/module/forum/forum_controller.dart';

class ForumScreen extends StatelessWidget {
  const ForumScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
      ForumBloc(
        repository: ForumRepository(),
      )
        ..add(ForumLoadRequested()),
      child: Scaffold(
        appBar: AppBar(),
        body: const _ForumView(),
        floatingActionButton: Builder(
          builder: (context) => FloatingActionButton(
            onPressed: () => _showCreateTopicModal(context),
            child: const Icon(Icons.add),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      ),
    );
  }

  void _showCreateTopicModal(BuildContext context) {
    final forumBloc = context.read<ForumBloc>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (modalContext) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(modalContext).viewInsets.bottom,
          left: 16,
          right: 16,
          top: 16,
        ),
        child: _CreateTopicForm(
          onSubmit: (title, description) {
            forumBloc.add(
              ForumCreateTopicRequested(title: title, description: description),
            );
            Navigator.pop(modalContext);
          },
        ),
      ),
    );
  }
}

class _CreateTopicForm extends StatefulWidget {
  final Function(String title, String description) onSubmit;

  const _CreateTopicForm({required this.onSubmit});

  @override
  State<_CreateTopicForm> createState() => _CreateTopicFormState();
}

class _CreateTopicFormState extends State<_CreateTopicForm> {
  final _titleController = TextEditingController();
  final _descController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          'Новый топик',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _titleController,
          decoration: const InputDecoration(
            labelText: 'Заголовок',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _descController,
          maxLines: 3,
          decoration: const InputDecoration(
            labelText: 'Краткое описание',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              final title = _titleController.text.trim();
              final desc = _descController.text.trim();
              if (title.isNotEmpty && desc.isNotEmpty) {
                widget.onSubmit(title, desc);
              }
            },
            child: const Text('Создать'),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}

class _ForumView extends StatelessWidget {
  const _ForumView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ForumBloc, ForumState>(
      builder: (context, state) {
        if (state is ForumInitial || state is ForumLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        else if (state is ForumLoaded) {
          final topics = state.topics;

          if (topics.isEmpty) {
            return const Center(child: Text('Пока нет топиков'));
          }

          return RefreshIndicator(
            onRefresh: () async {
              context.read<ForumBloc>().add(ForumLoadRequested());
            },
            child: ListView.builder(
              itemCount: topics.length,
              itemBuilder: (context, index) {
                return _TopicTile(topic: topics[index]);
              },
            ),
          );
        } else if (state is ForumError) {
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

class _TopicTile extends StatelessWidget {
  final TopicModel topic;

  const _TopicTile({required this.topic});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        title: Text(
          topic.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text('Автор: ${topic.author}'),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.comment, size: 20),
            Text(topic.repliesCount.toString()),
          ],
        ),
        onTap: () {
          // Действие по клику на топик — пока пустое
          // (потом тут будет переход на экран комментариев)
          Navigator.push(context, MaterialPageRoute(builder: (context) => TopicScreen(topicId: topic.id, title: topic.title,)));
        },
      ),
    );
  }
}

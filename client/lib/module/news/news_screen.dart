import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:client/domain/model/news/news_bloc.dart';
import 'package:client/domain/model/user_role.dart';
import 'package:client/domain/model/bloc.dart';
import 'package:client/domain/model/auth_state.dart';
import '../../domain/model/news/news_event.dart';
import '../../domain/model/news/news_state.dart';
import 'news_detail_screen.dart';
import 'create_news_screen.dart';

class NewsScreen extends StatelessWidget {
  const NewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isAdmin = _isAdmin(context);

    return Scaffold(
      body: BlocBuilder<NewsBloc, NewsState>(
        builder: (context, state) {
          if (state is NewsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is NewsLoaded) {
            final newsList = state.newsList;
            if (newsList.isEmpty) {
              return const Center(child: Text('Нет новостей'));
            }
            return ListView.builder(
              itemCount: newsList.length,
              itemBuilder: (context, index) {
                final news = newsList[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: news.imageUrl != null
                          ? Image.network(
                        news.imageUrl!,
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const Icon(Icons.broken_image, size: 60),
                      )
                          : Container(
                        width: 60,
                        height: 60,
                        color: Colors.grey[300],
                        child: const Icon(Icons.image, size: 40),
                      ),
                    ),
                    title: Text(news.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(
                      news.content.length > 80 ? '${news.content.substring(0, 80)}...' : news.content,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    isThreeLine: true,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => NewsDetailScreen(news: news)),
                      );
                    },
                    onLongPress: isAdmin
                        ? () => _confirmDelete(context, news.id)
                        : null,
                  ),
                );
              },
            );
          } else if (state is NewsError) {
            return Center(child: Text('Ошибка: ${state.message}'));
          }
          return const SizedBox();
        },
      ),
      floatingActionButton: isAdmin
          ? FloatingActionButton(
        onPressed: () async {
          final created = await Navigator.push<bool>(
            context,
            MaterialPageRoute(builder: (_) => const CreateNewsScreen()),
          );
          if (created == true) {
            context.read<NewsBloc>().add(FetchNews());
          }
        },
        child: const Icon(Icons.add),
      )
          : null,
    );
  }

  bool _isAdmin(BuildContext context) {
    final authState = context.read<AppBloc>().state;
    if (authState is AuthAuthenticated) {
      return authState.user.role == UserRole.council;
    }
    return false;
  }

  void _confirmDelete(BuildContext context, String id) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Удалить новость?'),
        content: const Text('Это действие нельзя отменить.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Отмена')),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.read<NewsBloc>().add(DeleteNews(id));
            },
            child: const Text('Удалить', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
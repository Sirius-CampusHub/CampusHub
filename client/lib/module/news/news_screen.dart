import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:client/domain/model/user_role.dart';
import '../../domain/bloc/auth/auth_bloc.dart';
import '../../domain/bloc/auth/auth_state.dart';
import '../../domain/bloc/news/news_bloc.dart';
import '../../domain/bloc/news/news_event.dart';
import '../../domain/bloc/news/news_state.dart';
import 'create_news_screen.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  late final ScrollController _scrollController;
  late final ButtonNotifier _buttonNotifier;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _buttonNotifier = ButtonNotifier();
    _scrollController.addListener(_onScroll);
    context.read<NewsBloc>().add(FetchNews());
  }

  void _onScroll() {
    if (_scrollController.hasClients) {
      _buttonNotifier.updateOnScroll(_scrollController.offset);
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _buttonNotifier.dispose();
    super.dispose();
  }

    String _formatDate(DateTime date) {
    final utc = date.isUtc ? date : DateTime.utc(date.year, date.month, date.day, date.hour, date.minute, date.second);
    final local = utc.toLocal();
    return '${local.day.toString().padLeft(2, '0')}.${local.month.toString().padLeft(2, '0')}.${local.year} ${local.hour.toString().padLeft(2, '0')}:${local.minute.toString().padLeft(2, '0')}';  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<NewsBloc, NewsState>(
        listener: (context, state) {
          if (state is NewsError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          if (state is NewsLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final newsList = state is NewsLoaded
              ? state.newsList
              : state is NewsError
                  ? (state.previousNewsList ?? const [])
                  : const [];

          if (newsList.isEmpty) {
            return const Center(child: Text('Нет новостей'));
          }


          return ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: newsList.length,
            itemBuilder: (context, index) {
              final news = newsList[index];

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                elevation: 0,
                shadowColor: Colors.transparent,
                surfaceTintColor: Colors.transparent,
                clipBehavior: Clip.antiAlias,
                child: GestureDetector(
                  onLongPress:(){
                    final isAdmin = context.read<AuthBloc>().state is AuthAuthenticated &&
                        (context.read<AuthBloc>().state as AuthAuthenticated).user.role == UserRole.council;
                    if (isAdmin) _confirmDelete(context, news.id);
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (news.fullImageUrl != null && news.fullImageUrl!.isNotEmpty)
                        CachedNetworkImage(
                          imageUrl: news.fullImageUrl!,
                          width: double.infinity,
                          fit: BoxFit.fitWidth,
                          placeholder: (context, url) => const AspectRatio(
                            aspectRatio: 16 / 9,
                            child: Center(child: CircularProgressIndicator()),
                          ),
                          errorWidget: (context, url, error) => const AspectRatio(
                            aspectRatio: 16 / 9,
                            child: Icon(Icons.broken_image, size: 80),
                          ),
                        ),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              news.title,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 8),
                            Text(
                              news.content,
                              textAlign: TextAlign.justify,
                              style: const TextStyle(fontSize: 15),
                            ),
                            const SizedBox(height: 8),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                _formatDate(news.createdAt),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),


      floatingActionButton: _AdminFab(
        notifier: _buttonNotifier,
        onPressed: () async {
          final created = await Navigator.push<bool>(
            context,
            MaterialPageRoute(builder: (_) => const CreateNewsScreen()),
          );
          if (created == true && context.mounted) {
            context.read<NewsBloc>().add(FetchNews());
          }
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
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

class _AdminFab extends StatelessWidget {
  final ValueListenable<bool> notifier;
  final VoidCallback onPressed;

  const _AdminFab({required this.notifier, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final isAdmin = context.select((AuthBloc bloc) {
      final state = bloc.state;
      return state is AuthAuthenticated && state.user.role == UserRole.council;
    });

    return ValueListenableBuilder<bool>(
      valueListenable: notifier,
      builder: (context, isFabVisible, child) {
        if (!isAdmin || !isFabVisible) {
          return const SizedBox.shrink();
        }
        return FloatingActionButton(
          onPressed: onPressed,
          child: const Icon(Icons.add),
        );
      },
    );
  }
}

class ButtonNotifier extends ChangeNotifier implements ValueListenable<bool> {
  bool _value = true;
  double _lastScrollOffset = 0;

  @override
  bool get value => _value;

  double get lastScrollOffset => _lastScrollOffset;

  void updateOnScroll(double currentOffset) {
    final shouldShow = currentOffset <= 0 || currentOffset < _lastScrollOffset;

    if (shouldShow != _value) {
      _value = shouldShow;
      notifyListeners();
    }

    _lastScrollOffset = currentOffset;
  }
}


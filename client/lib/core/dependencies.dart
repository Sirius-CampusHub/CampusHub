import 'package:client/data/repository/auth_repository.dart';
import 'package:client/data/repository/news_repository.dart';
import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';


final class Dependencies {
  const Dependencies({
    required this.authRepository,
    required this.newsRepository,

  });

  final AuthRepository authRepository;
  final NewsRepository newsRepository;

}

class DependenciesScope extends InheritedWidget {
  const DependenciesScope({
    super.key,
    required this.dependencies,
    required super.child,
  });

  final Dependencies dependencies;

  static Dependencies of(BuildContext context) {
    final scope = context
        .dependOnInheritedWidgetOfExactType<DependenciesScope>();
    assert(scope != null, 'DependenciesScope не найден в дереве');
    return scope!.dependencies;
  }

  @override
  bool updateShouldNotify(DependenciesScope oldWidget) =>
      dependencies != oldWidget.dependencies;
}

extension DependenciesContext on BuildContext {
  Dependencies get dependencies => DependenciesScope.of(this);
}
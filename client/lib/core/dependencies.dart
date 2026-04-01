import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';


final class Dependencies {
  const Dependencies({
    required this.dio,
  });

  final Dio dio;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Dependencies &&
          runtimeType == other.runtimeType &&
          dio == other.dio;

  @override
  int get hashCode => dio.hashCode;
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

  static Dependencies? maybeOf(BuildContext context) {
    return context
        .getInheritedWidgetOfExactType<DependenciesScope>()
        ?.dependencies;
  }

  @override
  bool updateShouldNotify(DependenciesScope oldWidget) =>
      dependencies != oldWidget.dependencies;
}

extension DependenciesContext on BuildContext {
  Dependencies get dependencies => DependenciesScope.of(this);
}

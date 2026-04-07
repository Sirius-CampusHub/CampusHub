import 'dart:collection';

import 'package:client/domain/model/model.dart';
import 'package:flutter/cupertino.dart';

class ScheduleController extends InheritedWidget {
  final Map<int, WeekScheduleModel> history;
  final WeekScheduleModel scheduleModel;
  final int currentWeek;
  final void Function(String) updateWeek;

  const ScheduleController({
    super.key,
    required super.child,
    required this.scheduleModel,
    required this.updateWeek,
    required this.history,
    required this.currentWeek,
  });

  static WeekScheduleModel of(BuildContext context) {
    final scope = context
        .dependOnInheritedWidgetOfExactType<ScheduleController>();
    assert(scope != null, 'Сегодня выходной');
    return scope!.scheduleModel;
  }

  @override
  Widget get child => super.child;

  @override
  bool updateShouldNotify(covariant ScheduleController oldWidget) {
    return oldWidget.scheduleModel != scheduleModel;
  }
}

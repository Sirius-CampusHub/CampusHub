import 'package:client/domain/bloc/auth/auth_bloc.dart';
import 'package:client/domain/bloc/auth/auth_state.dart';
import 'package:client/domain/bloc/schedule/schedule_bloc.dart';
import 'package:client/module/schedule/schedule_controller.dart';
import 'package:flutter/material.dart';
import 'package:client/domain/model/model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/bloc/schedule/schedule_event.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  // Local variables
  WeekScheduleModel _weekScheduleModel = WeekScheduleModel(lessonModel: [DayScheduleModel(lessons: [LessonModel(name: 'name', classroom: 'classroom', lessonType: LessonType.exam, endTime: 'endTime', startTime: 'startTime', discipline: 'discipline', numberPair: 1)], date: '134.34', dayWeek: 'Mn', len: 1)], days: 1);
  Map<int, WeekScheduleModel> _history = {};
  int _currentWeek = 0;

  // Overrides
  @override
  void initState() {
    super.initState();
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthAuthenticated) {
      
    }
  }

  // Functions
  void _updateWeek(String method) {
    switch (method) {
      case 'nextWeek':
          _currentWeek += 1;
      case 'previousWeek':
          _currentWeek -= 1;
    }
    if (_history.containsKey(_currentWeek)) {
      setState(() {
        _weekScheduleModel = _history[_currentWeek]!;
        _currentWeek = _currentWeek;
      });
    } else {
      // TODO обратиться в репозиторий
    }
  }

  // Widgets
  @override
  Widget build(BuildContext context) {
    return ScheduleController(
      scheduleModel: _weekScheduleModel,
      history: _history,
      currentWeek: _currentWeek,
      updateWeek: _updateWeek,
      child: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 5,),
            Row(
              children: [
                IconButton(onPressed: () {}, icon: Icon(Icons.arrow_left)),
                Expanded(
                  child: SizedBox(
                    height: 60,
                      child: Center(child: ListView.separated(
                            separatorBuilder: (context, index) => SizedBox(width: index != 5 ? 6 : 0,),
                            scrollDirection: Axis.horizontal,
                            itemCount: 6,
                            itemBuilder: (context, index) {
                              return Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.grey,
                                ),
                              );
                        }),
                      ),
                  ),
                ),
                IconButton(onPressed: () {}, icon: Icon(Icons.arrow_right)),
              ],
            ),
            Expanded(child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: ListView.separated(
                  separatorBuilder: (context, index) => SizedBox(height: 15,),
                  itemCount: 8,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return SizedBox(height: 15,);
                    } else if (index % 2 == 1) {
                      return Container(
                        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('1. Семинар', style: TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.w600),),
                                Text('10:20 - 11:40', style: TextStyle(color: Colors.white),),
                              ],
                            ),
                            SizedBox(height: 11,),
                            Text('Элективные дисциплины по физической культуре и спорту (Физическая культура)',  style: TextStyle(color: Colors.white),),
                            SizedBox(height: 7,),
                            Divider(height: 1, thickness: 1, color: Colors.lightBlue,),
                            SizedBox(height: 7,),
                            Text('Фёдоров Глеб Владимирович', style: TextStyle(color: Colors.white),),
                            SizedBox(height: 7,),
                            Divider(height: 1, thickness: 1, color: Colors.lightBlue,),
                            SizedBox(height: 7,),
                            Text('«спортивный зал Айсберг»', style: TextStyle(color: Colors.white),),
                          ],
                        ),
                      );
                    } else {
                      return Container(
                        color: Colors.grey,
                        height: 60,
                        width: double.infinity,
                      );
                    }
              }),
            ),
            ),
          ],
        ),
      ),
    );
  }
}

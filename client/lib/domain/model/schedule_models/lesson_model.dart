class LessonModel {
  final int numberPair;
  final String name;
  final String discipline;
  final LessonType lessonType;
  final String classroom;
  final String startTime;
  final String endTime;

  const LessonModel({
    required this.name,
    required this.classroom,
    required this.lessonType,
    required this.endTime,
    required this.startTime,
    required this.discipline,
    required this.numberPair,
  });

  factory LessonModel.fromJson(Map<String, dynamic> json){
    return LessonModel(
      name: json['teachers']['fio'],
      classroom: json['classroom'],
      lessonType: json['group_type'] ?? LessonType.fromString(json['group_type']),
      endTime: json['end_time'],
      startTime: json['start_time'],
      discipline: json['discipline'],
      numberPair: json['number_pair'],
    );
  }
}

enum LessonType {
  lecture('Лекции'),
  seminar('Семинары'),
  practise('Практические занятия'),
  exam('Зачет дифференцированный'),
  lab('Лабораторные занятия'),
  other('Внеучебное мероприятие');

  final String russian;

  const LessonType(this.russian);

  static LessonType? fromString(String type) =>
      LessonType.values
          .where((element) => element.russian == type)
          .firstOrNull;
}


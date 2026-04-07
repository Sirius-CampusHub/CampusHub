import 'package:client/domain/model/model.dart';
import 'package:dio/dio.dart';

class ScheduleRepository {
  final Dio _dio;

  ScheduleRepository({required Dio dio}) : _dio = dio;

  static const String _url = 'schedule';

  Future<WeekScheduleModel> getSchedule(String group, int weekOffset) async {
    String url = _createLink([group, weekOffset]);
    try {
      final response = await _dio.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return WeekScheduleModel.fromJson(data);
      } else if (response.statusCode == 422) {
        throw Exception('Неправильный запрос: ${response.data['detail']['msg']}');
      } else {
        throw Exception("Ошибка при запросе на получение расписания группы ${group}. Код ошибки: ${response.statusCode}");
      }
    } on DioException catch (e) {
      // TODO log error
      print(e);
      rethrow;
    } catch (e) {
      // TODO log error
      rethrow;
    }
  }

  String _createLink(List<Object> args) {
    String link = _url + '/?';
    args.forEach((e) {link += "${e}&";});
    return link;
  }
}
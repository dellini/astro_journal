import 'package:astro_journal/date_extensions.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';

Future<Map<String, DateTime>> requestSunriseSunset({
  required double latitude,
  required double longitude,
  DateTime? date,
}) async {
  try {
    final targetDate = (date ?? DateTime.now()).date;
    final url = Uri.parse('https://api.sunrise-sunset.org/json').replace(
      queryParameters: <String, String>{
        'lat': latitude.toString(),
        'lng': longitude.toString(),
        'date': DateFormat('yyyy-MM-dd').format(targetDate),
      },
    );
    final responseData =
        (await Dio().get<dynamic>(url.toString())).data as Map<String, dynamic>;
    final data = responseData['results'] as Map<String, dynamic>;

    final parser = DateFormat('hh:mm:ss a');
    final sunrise = parser.parse(data['sunrise'] as String);
    final sunset = parser.parse(data['sunset'] as String);
    return {
      'sunrise': DateTime(
        targetDate.year,
        targetDate.month,
        targetDate.day,
        sunrise.hour,
        sunrise.minute,
      ),
      'sunset': DateTime(
        targetDate.year,
        targetDate.month,
        targetDate.day,
        sunset.hour,
        sunset.minute,
      ),
    };
  } on Exception catch (e) {
    // ignore: avoid_print
    print(e);
  }
  return {};
}

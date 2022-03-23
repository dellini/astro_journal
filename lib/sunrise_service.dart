import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'date_extensions.dart';

void main() async {
  getSunriseSunset(latitude: 45.037874, longitude: 38.975054);
}

Future<Map<String, DateTime>> getSunriseSunset({
  required double latitude,
  required double longitude,
  DateTime? date,
}) async {
  try {
    final targetDate = (date ?? DateTime.now()).date;
    final url = Uri.parse('https://api.sunrise-sunset.org/json').replace(
      queryParameters: <String, String>{
        "lat": latitude.toString(),
        "lng": longitude.toString(),
        "date": DateFormat("yyyy-MM-dd").format(targetDate),
      },
    );
    var response = await Dio().get('https://api.sunrise-sunset.org/json');
    final parser = DateFormat("hh:mm:ss a");
    final sunrise = parser.parse(response.data["results"]["sunrise"]);
    final sunset = parser.parse(response.data["results"]["sunset"]);
    return {
      "sunrise": DateTime(targetDate.year, targetDate.month, targetDate.day,
          sunrise.hour, sunrise.minute),
      "sunset": DateTime(targetDate.year, targetDate.month, targetDate.day,
          sunset.hour, sunset.minute),
    };
  } catch (e) {
    print(e);
  }
  return {};
}

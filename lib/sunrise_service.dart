import 'package:dio/dio.dart';

void main() async {
  getSunriseSunset(latitude: 45.037874, longitude: 38.975054);
}

Future<Map<String, DateTime>> getSunriseSunset({
  required double latitude,
  required double longitude,
  DateTime? date,
}) async {
  try {
    var response = await Dio().get('https://api.sunrise-sunset.org/json');
    print(response);
    return response.data;
  } catch (e) {
    print(e);
  }
  return {};
}

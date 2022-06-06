import 'dart:convert';

import 'package:astro_journal/date_extensions.dart';
import 'package:astro_journal/modules/calendar/planet_hours/planet_hours_data.dart';

import 'package:dio/dio.dart';
import 'package:intl/intl.dart';

double computeDayPlanetHours({
  required DateTime sunriseToday,
  required DateTime sunsetToday,
}) {
  final diffDayPlanetHours = sunsetToday.time.difference(sunriseToday.time);
  return diffDayPlanetHours.planetHour;
}

double computeNightPlanetHours({
  required DateTime sunriseTomorrow,
  required DateTime sunsetToday,
}) {
  final sunsetToMidnight = ExtDateTime.midnight.difference(sunsetToday.time);

  final midnightToSunrise =
      Duration(hours: sunriseTomorrow.hour, minutes: sunriseTomorrow.minute);

  final diffNightPlanetHours =
      (sunsetToMidnight + midnightToSunrise).planetHour;
  return diffNightPlanetHours;
}

PlanetHourComputeResult calculatePlanetHoursInPeriod({
  required DateTime startTime,
  required double hourDuration,
  bool isNight = false,
  int weekday = 1,
  Duration localeOffset = Duration.zero,
}) {
  if (weekday > 7 || weekday < 1) {
    throw Exception(
      'День недели не может быть отрицательным, а неделя не может иметь больше 7 дней.',
    );
  }

  final hours = <PlanetHourDuration>[];
  var currentDateTime = startTime.add(localeOffset);
  final planetHourInMicroseconds = (hourDuration * 60000000).toInt();

  for (var i = weekday; i <= weekday + 12; i++) {
    final newDateTime =
        currentDateTime.add(Duration(microseconds: planetHourInMicroseconds));

    hours.add(PlanetHourDuration(
      begin: currentDateTime,
      end: newDateTime,
      planetName: weekdayPlanets[i % 7] ?? '',
    ));

    currentDateTime = newDateTime;
  }

  final result = PlanetHourComputeResult(
    type: isNight ? ComputeType.night : ComputeType.day,
    startDateTime: startTime.add(localeOffset),
    hours: hours,
  );
  return result;
}

Future<MapEntry<DateTime, double>> getNightPlanetHours(
  double lat,
  double lon,
) async {
  final sunriseTomorrow = (await requestSunriseSunset(
    latitude: lat,
    longitude: lon,
    date: DateTime.now().add(const Duration(days: 1)),
  ))['sunrise']!;
  final sunsetToday = (await requestSunriseSunset(
    latitude: lat,
    longitude: lon,
  ))['sunset']!;
  final resultNightPlanetHour = computeNightPlanetHours(
    sunriseTomorrow: sunriseTomorrow,
    sunsetToday: sunsetToday,
  );
  return MapEntry(sunsetToday, resultNightPlanetHour);
}

Future<MapEntry<DateTime, double>> getDayPlanetHours(
  double lat,
  double lon,
) async {
  final sunriseSunset = await requestSunriseSunset(
    latitude: lat,
    longitude: lon,
    date: DateTime.now(),
  );
  final sunriseToday = sunriseSunset['sunrise']!;
  final sunsetToday = sunriseSunset['sunset']!;
  final resultDayPlanetHour = computeDayPlanetHours(
    sunriseToday: sunriseToday,
    sunsetToday: sunsetToday,
  );
  return MapEntry(sunriseToday, resultDayPlanetHour);
}

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

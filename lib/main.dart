import 'dart:async';

import 'package:astro_journal/date_extensions.dart';
import 'package:astro_journal/sunrise_service.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(
    const MaterialApp(
      home: MainPage(),
    ),
  );
}

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [],
      ),
    );
  }
}

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

enum ComputeType {
  day,
  night,
}

class ComputeResult {
  final ComputeType type;
  final DateTime startDateTime;
  final List<PlanetHourDuration> hours;

  ComputeResult({
    required this.type,
    required this.startDateTime,
    this.hours = const [],
  });
  @override
  String toString() {
    return '${type == ComputeType.day ? 'Восход солнца' : 'Заход солнца'}: $startDateTime,'
        '\nРасчёт часов: \n${hours.join('\n')}';
  }
}

class PlanetHourDuration {
  final DateTime begin;
  final DateTime end;
  final String planetName;

  PlanetHourDuration({
    required this.begin,
    required this.end,
    required this.planetName,
  });
  @override
  String toString() {
    return 'Начало часа: $begin, Конец часа: $end, Планета: $planetName';
  }
}

ComputeResult calculatePlanetHoursInPeriod({
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

  final result = ComputeResult(
    type: isNight ? ComputeType.night : ComputeType.day,
    startDateTime: startTime.add(localeOffset),
    hours: hours,
  );
  return result;
}

Future<MapEntry<DateTime, double>> getNightPlanetHours() async {
  final sunriseTomorrow = (await requestSunriseSunset(
    latitude: 45.037874,
    longitude: 38.975054,
    date: DateTime.now().add(const Duration(days: 1)),
  ))['sunrise']!;
  final sunsetToday = (await requestSunriseSunset(
    latitude: 45.037874,
    longitude: 38.975054,
  ))['sunset']!;
  final resultNightPlanetHour = computeNightPlanetHours(
    sunriseTomorrow: sunriseTomorrow,
    sunsetToday: sunsetToday,
  );
  return MapEntry(sunsetToday, resultNightPlanetHour);
}

Future<MapEntry<DateTime, double>> getDayPlanetHours() async {
  final sunriseSunset = await requestSunriseSunset(
    latitude: 45.037874,
    longitude: 38.975054,
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

Map<int, String> weekdayPlanets = {
  0: 'Солнце',
  1: 'Луна',
  2: 'Марс',
  3: 'Меркурий',
  4: 'Юпитер',
  5: 'Венера',
  6: 'Сатурн',
};

import 'dart:async';

import 'package:astro_journal/data/planet_hours.dart';
import 'package:astro_journal/data/tarot_card.dart';
import 'package:astro_journal/date_extensions.dart';
import 'package:astro_journal/firebase_options.dart';
import 'package:astro_journal/sunrise_service.dart';
import 'package:astro_journal/tarot_service.dart';
import 'package:astro_journal/ui/daily_card_screen.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    const MaterialApp(
      home: DailyCardScreen(),
    ),
  );
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

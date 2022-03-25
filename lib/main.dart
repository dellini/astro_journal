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

Future<double?> getNightPlanetHours() async {
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
  return resultNightPlanetHour;
}

Future<double?> getDayPlanetHours() async {
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
  return resultDayPlanetHour;
}

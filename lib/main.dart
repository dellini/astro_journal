import 'package:astro_journal/sunrise_service.dart';
import 'package:flutter/material.dart';
import 'date_extensions.dart';

void main() {
  runApp(
    MaterialApp(
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

double getDayPlanetHours({
  required DateTime sunriseToday,
  required DateTime sunsetToday,
}) {
  final diffDayPlanetHours = sunsetToday.time.difference(sunriseToday.time);
  return diffDayPlanetHours.planetHour;
}

double getNightPlanetHours({
  required DateTime sunriseTomorrow,
  required DateTime sunsetToday,
}) {
  final sunsetToMidnight = ExtDateTime.midnight.difference(sunsetToday.time);
  print(sunsetToMidnight);
  final midnightToSunrise =
      Duration(hours: sunriseTomorrow.hour, minutes: sunriseTomorrow.minute);
  print(midnightToSunrise);
  final diffNightPlanetHours =
      (sunsetToMidnight + midnightToSunrise).planetHour;
  return diffNightPlanetHours;
}

Future<double?> getSunriseTomorrow() async {
  final sunriseTomorrow = (await getSunriseSunset(
    latitude: 45.037874,
    longitude: 38.975054,
    date: DateTime.now().add(
      const Duration(days: 1),
    ),
  ))["sunrise"]!;
  final sunsetToday = (await getSunriseSunset(
      latitude: 45.037874, longitude: 38.975054))["sunset"]!;
  print(sunriseTomorrow);
  print(sunsetToday);
  final resultNightPlanetHour = getNightPlanetHours(
    sunriseTomorrow: sunriseTomorrow,
    sunsetToday: sunsetToday,
  );
  return resultNightPlanetHour;
}

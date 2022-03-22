import 'package:flutter/material.dart';

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
    final midnightToSunrise =
        sunriseTomorrow.difference(DateTime(0, 0, 0, 0, 0, 0, 0, 0));
    final diffNightPlanetHours =
        (sunsetToMidnight + midnightToSunrise).planetHour;
    return diffNightPlanetHours;
  }
}

extension ExtDateTime on DateTime {
  DateTime get time =>
      DateTime(0, 0, 0, hour, minute, second, millisecond, microsecond);
  static DateTime midnight = DateTime(0, 0, 0, 23, 60);
}

extension ExtDuration on Duration {
  /// Возвращает длительность планетарного часа для промежутка времени.
  double get planetHour => inMinutes / 12;
}

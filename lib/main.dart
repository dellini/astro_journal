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
    required DateTime sunrise,
    required DateTime sunset,
  }) {
    final diff = sunset.time.difference(sunrise.time);
    return diff.inMinutes / 12;
  }

  double getNightPlanetHours({
    required DateTime sunriseTomorrow,
    required DateTime sunsetToday,
  }) {}
}

extension ExtDateTime on DateTime {
  DateTime get time =>
      DateTime(0, 0, 0, hour, minute, second, millisecond, microsecond);
}

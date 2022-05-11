import 'package:flutter/material.dart';

enum _TimeOfDay {
  morning,
  afternoon,
  evening,
  night,
}

class GreetingsTextWidget extends StatefulWidget {
  const GreetingsTextWidget({Key? key}) : super(key: key);

  @override
  State<GreetingsTextWidget> createState() => _GreetingsTextWidgetState();
}

class _GreetingsTextWidgetState extends State<GreetingsTextWidget> {
  late final _TimeOfDay timeOfDay;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    if (now.hour >= 0 && now.hour < 5) {
      timeOfDay = _TimeOfDay.night;
    } else if (now.hour >= 5 && now.hour < 12) {
      timeOfDay = _TimeOfDay.morning;
    } else if (now.hour >= 12 && now.hour < 18) {
      timeOfDay = _TimeOfDay.afternoon;
    } else if (now.hour >= 18 && now.hour < 23) {
      timeOfDay = _TimeOfDay.evening;
    } else {
      timeOfDay = _TimeOfDay.night;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (timeOfDay == _TimeOfDay.night) {
      return const Text('Доброй ночи!');
    } else if (timeOfDay == _TimeOfDay.morning) {
      return const Text('Доброе утро!');
    } else if (timeOfDay == _TimeOfDay.afternoon) {
      return const Text('Добрый день!');
    } else {
      return const Text('Добрый вечер!');
    }
  }
}

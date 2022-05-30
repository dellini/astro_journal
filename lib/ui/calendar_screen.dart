import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({Key? key}) : super(key: key);

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TableCalendar<void>(
        focusedDay: DateTime.now(),
        firstDay: DateTime.utc(2022),
        lastDay: DateTime.utc(2022, 12, 31),
      ),
    );
  }
}

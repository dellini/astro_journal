import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({Key? key}) : super(key: key);

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

const _textStyle = TextStyle(
  fontFamily: 'Comfortaa',
  fontSize: 18,
  color: Colors.white,
);

class _CalendarScreenState extends State<CalendarScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 32, 32, 32),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Builder(
            builder: (context) {
              return CalendarCarousel(
                onDayPressed: (day, _) {
                  showBottomSheet<void>(
                    context: context,
                    builder: (context) {
                      return Scaffold(
                        body: Container(
                          height: 56,
                          width: MediaQuery.of(context).size.width,
                          color: Colors.amberAccent,
                        ),
                      );
                    },
                  );
                },
                headerMargin: const EdgeInsets.only(
                  left: 84,
                  right: 84,
                  top: 28,
                  bottom: 28,
                ),
                headerTextStyle: _textStyle.copyWith(
                  color: Colors.amberAccent,
                  fontSize: 22,
                ),
                daysTextStyle: _textStyle,
                weekdayTextStyle: _textStyle,
                weekendTextStyle:
                    _textStyle.copyWith(color: Colors.amberAccent),
                todayButtonColor: Colors.amberAccent,
                todayTextStyle: _textStyle.copyWith(
                  color: const Color.fromARGB(255, 32, 32, 32),
                  fontWeight: FontWeight.bold,
                ),
                prevDaysTextStyle:
                    _textStyle.copyWith(color: Colors.white38, fontSize: 14),
                nextDaysTextStyle:
                    _textStyle.copyWith(color: Colors.white38, fontSize: 14),
                iconColor: Colors.amberAccent,
              );
            },
          ),
        ),
      ),
    );
  }
}

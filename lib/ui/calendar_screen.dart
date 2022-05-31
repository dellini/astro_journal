import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

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
        child: SlidingUpPanel(
          maxHeight: MediaQuery.of(context).size.height * 0.9,
          minHeight: MediaQuery.of(context).size.height * 0.3,
          renderPanelSheet: false,
          panel: ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(512),
              topRight: Radius.circular(512),
            ),
            child: GlassmorphicContainer(
              width: MediaQuery.of(context).size.width,
              height: double.infinity,
              borderRadius: 0,
              linearGradient: LinearGradient(
                colors: [
                  const Color(0xffFFDE59).withOpacity(0.05),
                  const Color(0xffFFDE59).withOpacity(0.4),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              border: 0,
              blur: 8,
              borderGradient: const LinearGradient(
                colors: [
                  Color(0xffFFDE59),
                  Colors.white,
                ],
              ),
            ),
          ),
          // header: Container(
          //   height: 60,
          //   width: 360,
          //   color: Colors.red,
          // ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Builder(
              builder: (context) {
                return CalendarCarousel(
                  locale: 'ru_RU',
                  pageScrollPhysics: const NeverScrollableScrollPhysics(),
                  onDayPressed: (day, _) {},
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
      ),
    );
  }
}

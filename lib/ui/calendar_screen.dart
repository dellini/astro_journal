import 'package:astro_journal/services/planets_service.dart';
import 'package:astro_journal/util/geolocator.dart';
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
  Sign? _sign;

  @override
  void initState() {
    super.initState();
    determinePosition().then((value) async {
      _sign = await requestMoonSign(
        date: DateTime.now(),
        lon: value.longitude,
        lat: value.latitude,
      );
      // ignore: avoid_print
      print(_sign);
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 32, 32, 32),
      body: SafeArea(
        child: Stack(
          children: [
            SlidingUpPanel(
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
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        _sign?.toString() ?? '',
                        textAlign: TextAlign.center,
                        style: _textStyle,
                      ),
                    ),
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
                      onDayPressed: (day, _) async {
                        final position = await determinePosition();
                        final sign = await requestMoonSign(
                          date: day,
                          lon: position.longitude,
                          lat: position.latitude,
                        );
                        // ignore: avoid_print
                        print(_sign);
                        setState(() {
                          _sign = sign;
                        });
                      },
                      headerMargin: const EdgeInsets.only(
                        left: 64,
                        right: 64,
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
                      prevDaysTextStyle: _textStyle.copyWith(
                        color: Colors.white38,
                        fontSize: 14,
                      ),
                      nextDaysTextStyle: _textStyle.copyWith(
                        color: Colors.white38,
                        fontSize: 14,
                      ),
                      iconColor: Colors.amberAccent,
                    );
                  },
                ),
              ),
            ),
            Positioned(
              left: 16,
              top: 16,
              child: SafeArea(
                child: IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(
                    Icons.arrow_back_rounded,
                    color: Colors.amberAccent,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:astro_journal/date_extensions.dart';
import 'package:astro_journal/modules/calendar/diary/diary_cubit.dart';
import 'package:astro_journal/modules/calendar/planet_hours/planet_hours_controller.dart';
import 'package:astro_journal/modules/calendar/planets_service.dart';
import 'package:astro_journal/modules/shared/app_text_styles.dart';
import 'package:astro_journal/util/geolocator.dart';
import 'package:astro_journal/util/lunar_phase.dart';
import 'package:astro_journal/widgets/export.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:intl/intl.dart';
import 'package:moon_phase/moon_phase.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class CalendarScreen extends StatefulWidget {
  final VoidCallback? onGoPlanetHours;
  final VoidCallback? onGoDiary;

  const CalendarScreen({
    Key? key,
    this.onGoPlanetHours,
    this.onGoDiary,
  }) : super(key: key);

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen>
    with SingleTickerProviderStateMixin {
  late final DateTime now;
  late final moon = MoonPhase();
  Sign? _sign;
  late DateTime _selectedDay;
  double _currentAngle = -1;

  late AnimationController _bottomIndicatorController;
  late Animation<double> _bottomIndicatorAnimation;

  @override
  void initState() {
    super.initState();
    now = DateTime.now();
    _selectedDay = now;
    _currentAngle = moon.getPhaseAngle(_selectedDay);

    _bottomIndicatorController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _bottomIndicatorAnimation =
        Tween<double>(begin: 0, end: 12).animate(_bottomIndicatorController)
          ..addListener(() {
            setState(() {});
          });

    _bottomIndicatorController.repeat(reverse: true);

    determinePosition().then((value) async {
      _sign = await requestMoonSign(
        date: now,
        lon: value.longitude,
        lat: value.latitude,
      );
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    _bottomIndicatorController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 32, 32, 32),
      body: SafeArea(
        child: Stack(
          children: [
            SlidingUpPanel(
              onPanelSlide: (position) {
                if (position == 1) {
                  _bottomIndicatorController
                    ..stop(canceled: false)
                    ..reset();
                } else if (position == 0) {
                  _bottomIndicatorController.repeat(reverse: true);
                }
              },
              maxHeight: MediaQuery.of(context).size.height * 0.66,
              minHeight: MediaQuery.of(context).size.height * 0.33,
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
                  child: Column(
                    children: [
                      const SizedBox(height: 16),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 100),
                        curve: Curves.bounceIn,
                        transform: Transform.translate(
                          offset: Offset(
                            0,
                            _bottomIndicatorAnimation.value,
                          ), // Change -100 for the y offset
                        ).transform,
                        child: const Icon(
                          Icons.arrow_drop_up_rounded,
                          size: 32,
                          color: Colors.amberAccent,
                        ),
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.28,
                        alignment: Alignment.topCenter,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              DateFormat('d MMMM', 'ru').format(_selectedDay),
                              textAlign: TextAlign.center,
                              style: AppTextStyles.secondaryTextStyle.copyWith(
                                fontSize: 30,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.only(left: 18, top: 18),
                                  child: MoonWidget(
                                    date: _selectedDay,
                                    size: 60,
                                    moonColor: Colors.amberAccent,
                                    earthshineColor:
                                        const Color.fromARGB(255, 20, 20, 20),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Column(
                                  children: [
                                    Text(
                                      _sign != null
                                          ? '???????? ${_sign!.declinationName}'
                                          : '',
                                      textAlign: TextAlign.center,
                                      style: AppTextStyles.primaryTextStyle
                                          .copyWith(
                                        fontSize: 24,
                                      ),
                                    ),
                                    Text(
                                      getLunarPhase(
                                        _currentAngle,
                                      ),
                                      style: AppTextStyles.secondaryTextStyle
                                          .copyWith(
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            AppButton(
                              text: '?????????????? ????????????',
                              fontSize: 18,
                              splashFactory: NoSplash.splashFactory,
                              onPressed: () {
                                context
                                    .read<DiaryNotesCubit>()
                                    .loadNotes(_selectedDay);
                                widget.onGoDiary?.call();
                              },
                            ),
                            AppButton(
                              text: '?????????????????????? ????????',
                              fontSize: 18,
                              splashFactory: NoSplash.splashFactory,
                              onPressed: () {
                                context.read<PlanetHoursCubit>()
                                  ..reset()
                                  ..computePlanetHours(
                                    dateTime: _selectedDay,
                                  );
                                widget.onGoPlanetHours?.call();
                              },
                            ),
                            const SizedBox(height: 40),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              body: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Builder(
                  builder: (context) {
                    return Padding(
                      padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height < 700 ? 20 : 50,
                      ),
                      child: CalendarCarousel(
                        locale: 'ru_RU',
                        pageScrollPhysics: const NeverScrollableScrollPhysics(),
                        onDayPressed: (day, _) async {
                          final position = await determinePosition();

                          final sign = await requestMoonSign(
                            date: day,
                            lon: position.longitude,
                            lat: position.latitude,
                          );

                          setState(() {
                            _selectedDay = day;
                            if (_selectedDay.onlyDate == now.onlyDate) {
                              final now = DateTime.now();
                              _selectedDay = DateTime(
                                _selectedDay.year,
                                _selectedDay.month,
                                _selectedDay.day,
                                now.hour,
                                now.minute,
                              );
                            }
                            _currentAngle = moon.getPhaseAngle(_selectedDay);
                            _sign = sign;
                          });
                        },
                        headerMargin: const EdgeInsets.only(
                          left: 64,
                          right: 64,
                          top: 28,
                          bottom: 28,
                        ),
                        headerTextStyle:
                            AppTextStyles.secondaryTextStyle.copyWith(
                          color: Colors.amberAccent,
                          fontSize: 22,
                        ),
                        customDayBuilder: (
                          isSelectable,
                          index,
                          isSelectedDay,
                          isToday,
                          isPrevMonthDay,
                          textStyle,
                          isNextMonthDay,
                          isThisMonthDay,
                          day,
                        ) {
                          if (day.onlyDate == now.onlyDate) {
                            return Container(
                              alignment: Alignment.center,
                              child: Text(
                                day.day.toString(),
                                style:
                                    AppTextStyles.secondaryTextStyle.copyWith(
                                  color: const Color.fromARGB(255, 32, 32, 32),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.amberAccent,
                              ),
                            );
                          }
                          return null;
                        },
                        daysTextStyle: AppTextStyles.secondaryTextStyle,
                        weekdayTextStyle: AppTextStyles.secondaryTextStyle,
                        weekendTextStyle: AppTextStyles.secondaryTextStyle
                            .copyWith(color: Colors.amberAccent),
                        todayButtonColor: Colors.amberAccent,
                        todayTextStyle:
                            AppTextStyles.secondaryTextStyle.copyWith(
                          color: const Color.fromARGB(255, 32, 32, 32),
                          fontWeight: FontWeight.bold,
                        ),
                        prevDaysTextStyle:
                            AppTextStyles.secondaryTextStyle.copyWith(
                          color: Colors.white38,
                          fontSize: 14,
                        ),
                        nextDaysTextStyle:
                            AppTextStyles.secondaryTextStyle.copyWith(
                          color: Colors.white38,
                          fontSize: 14,
                        ),
                        iconColor: Colors.amberAccent,
                      ),
                    );
                  },
                ),
              ),
            ),
            const PositionedBackButton(),
          ],
        ),
      ),
    );
  }
}

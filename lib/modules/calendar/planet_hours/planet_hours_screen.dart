import 'package:astro_journal/modules/calendar/planet_hours/planet_hours_controller.dart';
import 'package:astro_journal/modules/calendar/planet_hours/planet_hours_data.dart';
import 'package:astro_journal/theme.dart';
import 'package:astro_journal/widgets/export.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

const _textStyle = TextStyle(
  fontFamily: 'Lora',
  fontSize: 16,
  color: Colors.amberAccent,
);

final dateFormat = DateFormat('HH:mm', 'ru');

final planetDateFormat = DateFormat('HH:mm', 'ru');

class PlanetHoursScreen extends StatefulWidget {
  const PlanetHoursScreen({Key? key}) : super(key: key);

  @override
  State<PlanetHoursScreen> createState() => _PlanetHoursScreenState();
}

class _PlanetHoursScreenState extends State<PlanetHoursScreen> {
  late final PlanetHoursCubit _cubit = context.read();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(top: 28),
                  child: BlocBuilder<PlanetHoursCubit, void>(
                    bloc: _cubit,
                    builder: (context, snapshot) {
                      if (!_cubit.isLoaded) {
                        return const Center(
                          child: AppCircularProgressIndicator(),
                        );
                      }
                      return Padding(
                        padding: const EdgeInsets.only(left: 70, right: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              'Планетарные часы',
                              style: _textStyle.copyWith(
                                fontFamily: 'TenorSans',
                                fontSize: 24,
                              ),
                            ),
                            Text(
                              DateFormat('d MMMM', 'ru').format(
                                _cubit.computedDate ?? DateTime.now(),
                              ),
                              style: _textStyle.copyWith(
                                color: Colors.white,
                                fontSize: 18,
                                fontFamily: 'TenorSans',
                              ),
                            ),
                            const SizedBox(height: 24),
                            Text(
                              'Восход солнца: ${dateFormat.format(_cubit.dayHours.valueOrNull!.startDateTime)}',
                              style: _textStyle.copyWith(
                                fontSize: 20,
                                fontFamily: 'TenorSans',
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Заход солнца: ${dateFormat.format(_cubit.nightHours.valueOrNull!.startDateTime)}',
                              style: _textStyle.copyWith(
                                fontSize: 20,
                                fontFamily: 'TenorSans',
                              ),
                            ),
                            const SizedBox(height: 24),
                            Text(
                              'Дневные часы',
                              style: _textStyle.copyWith(
                                fontSize: 20,
                                fontFamily: 'TenorSans',
                              ),
                            ),
                            const SizedBox(height: 16),
                            _HoursDetails(hours: _cubit.dayHours.value!.hours),
                            const SizedBox(height: 24),
                            Text(
                              'Ночные часы',
                              style: _textStyle.copyWith(
                                fontSize: 20,
                                fontFamily: 'TenorSans',
                              ),
                            ),
                            const SizedBox(height: 16),
                            _HoursDetails(
                              hours: _cubit.nightHours.value!.hours,
                            ),
                            const SizedBox(height: 40),
                          ],
                        ),
                      );
                    },
                  ),
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

class _HoursDetails extends StatelessWidget {
  final List<PlanetHourDuration> hours;

  const _HoursDetails({
    required this.hours,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      itemCount: hours.length,
      physics: const NeverScrollableScrollPhysics(),
      separatorBuilder: (_, __) => const SizedBox(height: 6),
      itemBuilder: (context, index) {
        final hour = hours[index];

        return Row(
          children: [
            SizedBox(
              width: 50,
              child: Text(
                planetDateFormat.format(hour.begin),
                style: _textStyle.copyWith(
                  color: Colors.white,
                  fontSize: 18,
                ),
                textAlign: TextAlign.right,
              ),
            ),
            const SizedBox(height: 16),
            const SizedBox(
              width: 20,
              child: Text(
                '–',
                style: _textStyle,
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: 50,
              child: Text(
                planetDateFormat.format(hour.end),
                style: _textStyle.copyWith(
                  color: Colors.white,
                  fontSize: 18,
                ),
                textAlign: TextAlign.left,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              hour.planetName,
              style: _textStyle.copyWith(fontSize: 20),
            ),
          ],
        );
      },
    );
  }
}

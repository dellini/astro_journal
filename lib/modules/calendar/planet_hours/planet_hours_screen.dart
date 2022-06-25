import 'package:astro_journal/modules/calendar/planet_hours/planet_hours_controller.dart';
import 'package:astro_journal/modules/calendar/planet_hours/planet_hours_data.dart';
import 'package:astro_journal/modules/shared/app_text_styles.dart';
import 'package:astro_journal/theme.dart';
import 'package:astro_journal/widgets/export.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

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
                              style: AppTextStyles.primaryTextStyle.copyWith(
                                fontSize: 24,
                              ),
                            ),
                            Text(
                              DateFormat('d MMMM', 'ru').format(
                                _cubit.computedDate ?? DateTime.now(),
                              ),
                              style: AppTextStyles.primaryTextStyle.copyWith(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                            const SizedBox(height: 24),
                            Text(
                              'Восход солнца: ${dateFormat.format(_cubit.dayHours.valueOrNull!.startDateTime)}',
                              style: AppTextStyles.primaryTextStyle,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Заход солнца: ${dateFormat.format(_cubit.nightHours.valueOrNull!.startDateTime)}',
                              style: AppTextStyles.primaryTextStyle,
                            ),
                            const SizedBox(height: 24),
                            const Text(
                              'Дневные часы',
                              style: AppTextStyles.primaryTextStyle,
                            ),
                            const SizedBox(height: 16),
                            _HoursDetails(hours: _cubit.dayHours.value!.hours),
                            const SizedBox(height: 24),
                            const Text(
                              'Ночные часы',
                              style: AppTextStyles.primaryTextStyle,
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
                style: AppTextStyles.secondaryTextStyle.copyWith(
                  fontSize: 16,
                ),
                textAlign: TextAlign.right,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: 20,
              child: Text(
                '–',
                style: AppTextStyles.secondaryTextStyle.copyWith(
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: 50,
              child: Text(
                planetDateFormat.format(hour.end),
                style: AppTextStyles.secondaryTextStyle.copyWith(
                  fontSize: 16,
                ),
                textAlign: TextAlign.left,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              hour.planetName,
              style: AppTextStyles.secondaryTextStyle.copyWith(
                fontSize: 16,
              ),
            ),
          ],
        );
      },
    );
  }
}

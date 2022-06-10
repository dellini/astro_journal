import 'dart:math' show Random;

import 'package:astro_journal/modules/calendar/planet_hours/planet_hours_data.dart';
import 'package:astro_journal/modules/calendar/planet_hours/planet_hours_service.dart';
import 'package:astro_journal/util/geolocator.dart';
import 'package:bloc/bloc.dart';
import 'package:rxdart/rxdart.dart';

class PlanetHoursCubit extends Cubit<int> {
  final _dayHours = BehaviorSubject<PlanetHourComputeResult?>();
  final _nightHours = BehaviorSubject<PlanetHourComputeResult?>();

  ValueStream<PlanetHourComputeResult?> get dayHours => _dayHours.stream;
  ValueStream<PlanetHourComputeResult?> get nightHours => _nightHours.stream;

  bool get isLoaded =>
      dayHours.valueOrNull != null &&
      nightHours.valueOrNull != null &&
      _computedDate != null;

  DateTime? get computedDate => _computedDate;
  DateTime? _computedDate;

  static int get _random => Random().nextInt(1000);

  PlanetHoursCubit() : super(_random);

  void dispose() {
    _dayHours.close();
    _nightHours.close();
  }

  Future<void> computePlanetHours({
    DateTime? dateTime,
    Duration localeOffset = const Duration(hours: 3),
  }) async {
    _computedDate = dateTime;
    final position = await determinePosition();
    final nightPlanetHour = await getNightPlanetHours(
      lat: position.latitude,
      lon: position.longitude,
      dateTime: dateTime,
    );
    final dayPlanetHour = await getDayPlanetHours(
      lat: position.latitude,
      lon: position.longitude,
      dateTime: dateTime,
    );
    _nightHours.value = calculatePlanetHoursInPeriod(
      startTime: nightPlanetHour.key,
      hourDuration: nightPlanetHour.value,
      weekday: nightPlanetHour.key.weekday,
      isNight: true,
      localeOffset: localeOffset,
    );
    _dayHours.value = calculatePlanetHoursInPeriod(
      startTime: dayPlanetHour.key,
      hourDuration: dayPlanetHour.value,
      weekday: dayPlanetHour.key.weekday,
      localeOffset: localeOffset,
    );
    emit(_random);
  }

  void reset() {
    _dayHours.value = null;
    _nightHours.value = null;
    emit(_random);
  }
}

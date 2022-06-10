import 'package:astro_journal/modules/calendar/planet_hours/planet_hours_data.dart';
import 'package:astro_journal/modules/calendar/planet_hours/planet_hours_service.dart';
import 'package:astro_journal/util/geolocator.dart';
import 'package:bloc/bloc.dart';
import 'package:rxdart/subjects.dart';

class PlanetHoursCubit extends Cubit<void> {
  final _dayHours = BehaviorSubject<PlanetHourComputeResult?>();
  final _nightHours = BehaviorSubject<PlanetHourComputeResult?>();

  Stream<PlanetHourComputeResult?> get dayHours => _dayHours.stream;
  Stream<PlanetHourComputeResult?> get nightHours => _nightHours.stream;

  PlanetHoursCubit(super.initialState);

  void dispose() {
    _dayHours.close();
    _nightHours.close();
  }

  Future<void> computePlanetHours() async {
    final position = await determinePosition();
    final nightPlanetHour = await getNightPlanetHours(
      position.latitude,
      position.longitude,
    );
    final dayPlanetHour = await getDayPlanetHours(
      position.latitude,
      position.longitude,
    );
    _nightHours.value = calculatePlanetHoursInPeriod(
      startTime: nightPlanetHour.key,
      hourDuration: nightPlanetHour.value,
      isNight: true,
      weekday: nightPlanetHour.key.weekday,
      localeOffset: const Duration(hours: 3),
    );
    _dayHours.value = calculatePlanetHoursInPeriod(
      startTime: dayPlanetHour.key,
      hourDuration: dayPlanetHour.value,
      weekday: dayPlanetHour.key.weekday,
      localeOffset: const Duration(hours: 3),
    );
    emit(null);
  }
}

import 'package:astro_journal/modules/calendar/planet_hours/planet_hours_data.dart';
import 'package:astro_journal/modules/calendar/planet_hours/planet_hours_service.dart';
import 'package:astro_journal/util/geolocator.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class PlanetHoursController extends GetxController {
  final dayHours = Rx<PlanetHourComputeResult?>(null);
  final nightHours = Rx<PlanetHourComputeResult?>(null);

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
    nightHours.value = calculatePlanetHoursInPeriod(
      startTime: nightPlanetHour.key,
      hourDuration: nightPlanetHour.value,
      isNight: true,
      weekday: nightPlanetHour.key.weekday,
      localeOffset: const Duration(hours: 3),
    );
    dayHours.value = calculatePlanetHoursInPeriod(
      startTime: dayPlanetHour.key,
      hourDuration: dayPlanetHour.value,
      weekday: dayPlanetHour.key.weekday,
      localeOffset: const Duration(hours: 3),
    );
  }
}

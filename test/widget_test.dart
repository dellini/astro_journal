import 'package:astro_journal/services/affirmation_service.dart';
import 'package:astro_journal/services/api_requests_service.dart';
import 'package:astro_journal/services/planet_hours_service.dart';
import 'package:astro_journal/services/tarot_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Запрос к API', () async {
    debugPrint((await requestSunriseSunset(
      latitude: 45.037874,
      longitude: 38.975054,
    ))
        .toString());
  });
  test('Ночной планетарный час', () async {
    debugPrint((await getNightPlanetHours()).toString());
  });
  test('Дневной планетарный час', () async {
    debugPrint((await getDayPlanetHours()).toString());
  });

  test('Расчёт часов', () async {
    final nightPlanetHour = await getNightPlanetHours();
    final dayPlanetHour = await getDayPlanetHours();
    final resultNight = calculatePlanetHoursInPeriod(
      startTime: nightPlanetHour.key,
      hourDuration: nightPlanetHour.value,
      isNight: true,
      weekday: nightPlanetHour.key.weekday,
      localeOffset: const Duration(hours: 3),
    );
    final resultDay = calculatePlanetHoursInPeriod(
      startTime: dayPlanetHour.key,
      hourDuration: dayPlanetHour.value,
      weekday: dayPlanetHour.key.weekday,
      localeOffset: const Duration(hours: 3),
    );
    debugPrint(resultDay.toString());
    debugPrint('\n');
    debugPrint(resultNight.toString());
  });
  test('Случайная карта', () async {
    debugPrint((await getRandomTarotCard()).toString());
  });

  test(
    'Аффирмация дня',
    () async {
      debugPrint((await getRandomAffirmation()).toString());
    },
  );
}

import 'package:astro_journal/sunrise_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:astro_journal/main.dart';

void main() {
  test("Запрос к API", () async {
    debugPrint((await requestSunriseSunset(
      latitude: 45.037874,
      longitude: 38.975054,
    ))
        .toString());
  });
  test("Ночной планетарный час", () async {
    debugPrint((await getNightPlanetHours()).toString());
  });
  test("Дневной планетарный час", () async {
    debugPrint((await getDayPlanetHours()).toString());
  });

//   test("Расчёт часов", () async {
//     final nightPlanetHour = await getNightPlanetHours();
//     final dayPlanetHour = await getDayPlanetHours();
//     final resultNight = calculatePlanetHoursInPeriod(
//       startTime: requestSunriseSunset,
//     );
//     final resultDay = calculatePlanetHoursInPeriod();
//   });
}

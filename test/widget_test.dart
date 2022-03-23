import 'package:astro_journal/sunrise_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:astro_journal/main.dart';

void main() {
  test("test", () async {
    debugPrint(
        (await getSunriseSunset(latitude: 45.037874, longitude: 38.975054))
            .toString());
  });
  test("test", () async {
    debugPrint((await getSunriseTomorrow()).toString());
  });
}

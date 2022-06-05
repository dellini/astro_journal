// ignore_for_file: avoid_dynamic_calls

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

Future<Sign> requestMoonSign({
  required DateTime date,
  required double lon,
  required double lat,
}) async {
  const host = 'https://daily-tarot-dellini.herokuapp.com/api/v1/horoscope';
  final args = {
    'time': date.toIso8601String(),
    'latitude': lat,
    'longitude': lon,
  };
  final response = await Dio().get<dynamic>(host, queryParameters: args);
  final signInt = (response.data as Map<String, dynamic>)['data']['astros']
      ['moon']['sign'] as int;
  final result = Sign.of(signInt.abs());
  return result;
}

enum Sign {
  unknown(-1),
  aries(1),
  taurus(2),
  gemini(3),
  cancer(4),
  leo(5),
  virgo(6),
  libra(7),
  scorpio(8),
  sagittarius(9),
  capricorn(10),
  aquarius(11),
  pisces(12),
  ;

  final int signCode;
  const Sign(this.signCode);
  factory Sign.of(int code) => Sign.values.singleWhere(
        (e) => e.signCode == code,
        orElse: () => Sign.unknown,
      );
  String get declinationName {
    switch (signCode) {
      case 1:
        return 'в Овне';
      case 2:
        return 'в Тельце';
      case 3:
        return 'в Близнецах';
      case 4:
        return 'в Раке';
      case 5:
        return 'во Льве';
      case 6:
        return 'в Деве';
      case 7:
        return 'в Весах';
      case 8:
        return 'в Скорпионе';
      case 9:
        return 'в Стрельце';
      case 10:
        return 'в Козероге';
      case 11:
        return 'в Водолее';
      case 12:
        return 'в Рыбах';
      default:
        return '';
    }
  }
}

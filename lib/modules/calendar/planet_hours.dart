enum ComputeType {
  day,
  night,
}

class PlanetHourComputeResult {
  final ComputeType type;
  final DateTime startDateTime;
  final List<PlanetHourDuration> hours;

  PlanetHourComputeResult({
    required this.type,
    required this.startDateTime,
    this.hours = const [],
  });
  @override
  String toString() {
    return '${type == ComputeType.day ? 'Восход солнца' : 'Заход солнца'}: $startDateTime,'
        '\nРасчёт часов: \n${hours.join('\n')}';
  }
}

class PlanetHourDuration {
  final DateTime begin;
  final DateTime end;
  final String planetName;

  PlanetHourDuration({
    required this.begin,
    required this.end,
    required this.planetName,
  });
  @override
  String toString() {
    return 'Начало часа: $begin, Конец часа: $end, Планета: $planetName';
  }
}

Map<int, String> weekdayPlanets = {
  0: 'Солнце',
  1: 'Луна',
  2: 'Марс',
  3: 'Меркурий',
  4: 'Юпитер',
  5: 'Венера',
  6: 'Сатурн',
};

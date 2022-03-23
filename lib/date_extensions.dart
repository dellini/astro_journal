extension ExtDateTime on DateTime {
  DateTime get time =>
      DateTime(0, 0, 0, hour, minute, second, millisecond, microsecond);

  static DateTime midnight = DateTime(0, 0, 0, 23, 60);

  DateTime get date => DateTime(year, month, day, 0, 0, 0, 0, 0);
}

extension ExtDuration on Duration {
  /// Возвращает длительность планетарного часа для промежутка времени.
  double get planetHour => inMinutes / 12;
}

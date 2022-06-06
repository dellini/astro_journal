import 'dart:math' as math;

String getLunarPhase(double rad) {
  var result = '';
  final angle = ((rad * 180) / math.pi).round();
  // ignore: avoid_print
  print(angle);

  if (angle <= 9 || angle > 356) {
    result = 'Полнолуние';
  } else if (angle > 174 && angle <= 186) {
    result = 'Новолуние';
  } else if (angle > 186 && angle <= 356) {
    result = 'Убывающая';
  } else if (angle > 9 && angle <= 174) {
    result = 'Растущая';
  }
  return result;
}

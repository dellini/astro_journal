import 'package:astro_journal/modules/daily_card/daily_card_cubit.dart';
import 'package:get/get.dart';

class DailyCardController extends GetxController {
  final DailyCardCubit dailyCardCubit;

  DailyCardController({
    required this.dailyCardCubit,
  });
}

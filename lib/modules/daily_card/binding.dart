import 'package:astro_journal/modules/daily_card/daily_card_controller.dart';
import 'package:get/get.dart';

class DailyCardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => DailyCardController(
          dailyCardCubit: Get.find(),
        ));
  }
}

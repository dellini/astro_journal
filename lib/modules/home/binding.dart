import 'dart:async';

import 'package:astro_journal/modules/home/affirmation/affirmation_cubit.dart';
import 'package:astro_journal/modules/home/home_controller.dart';
import 'package:get/get.dart';

class HomeBinding extends Bindings {
  @override
  Future<void> dependencies() async {
    Get.lazyPut(() => HomeController(AffirmationCubit()..getAffirmation()));
  }
}

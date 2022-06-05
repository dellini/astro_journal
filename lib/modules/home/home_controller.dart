import 'package:astro_journal/modules/home/affirmation/affirmation_cubit.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  final AffirmationCubit _affirmationCubit;
  Stream<AffirmationState> get affirmationState => _affirmationCubit.stream;

  HomeController(this._affirmationCubit);

  @override
  void onInit() {
    super.onInit();
    _affirmationCubit.getAffirmation();
  }
}

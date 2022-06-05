import 'package:astro_journal/modules/home/affirmation/affirmation_service.dart';
import 'package:bloc/bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class AffirmationState {}

class AffirmationResult extends AffirmationState {
  final String affirmation;
  AffirmationResult(this.affirmation);
}

class AffirmationInitial extends AffirmationState {}

class AffirmationCubit extends Cubit<AffirmationState> {
  late final now = DateTime.now();
  String get todayKey => 'affirmation_${now.year}_${now.month}_${now.day}';

  AffirmationCubit() : super(AffirmationInitial());

  Future<void> getAffirmation() async {
    final prefs = await SharedPreferences.getInstance();
    final id = todayKey;
    final savedValue = prefs.getString(id);
    if (savedValue == null) {
      final affirmation = await getRandomAffirmation();
      if (affirmation.isNotEmpty) {
        emit(AffirmationResult(affirmation));
        await prefs.setString(id, affirmation);
      } else {
        emit(AffirmationResult('отсутствует интернет...'));
      }
    } else {
      emit(AffirmationResult(savedValue));
    }
  }

  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(todayKey);
    emit(AffirmationInitial());
  }
}

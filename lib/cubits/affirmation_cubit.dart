import 'package:astro_journal/services/affirmation_service.dart';
import 'package:bloc/bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class AffirmationState {}

class AffirmationResult extends AffirmationState {
  final String affirmation;
  AffirmationResult(this.affirmation);
}

class AffirmationInitial extends AffirmationState {}

class AffirmationCubit extends Cubit<AffirmationState> {
  AffirmationCubit() : super(AffirmationInitial());

  Future<void> getAffirmation() async {
    final prefs = await SharedPreferences.getInstance();
    final now = DateTime.now();
    final id = 'affirmation_${now.year}_${now.month}_${now.day}';
    final savedValue = prefs.getString(id);
    if (savedValue == null) {
      final affirmation = await getRandomAffirmation();
      emit(AffirmationResult(affirmation));
      await prefs.setString(id, affirmation);
    } else {
      emit(AffirmationResult(savedValue));
    }
  }
}

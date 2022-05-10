import 'package:bloc/bloc.dart';
import 'package:astro_journal/affirmation_service.dart';

abstract class AffirmationState {}

class AffirmationResult extends AffirmationState {
  final String affirmation;
  AffirmationResult(this.affirmation);
}

class AffirmationInitial extends AffirmationState {}

class AffirmationCubit extends Cubit<AffirmationState> {
  AffirmationCubit() : super(AffirmationInitial());
  Future<void> getRandomAffirmation() async {}
}

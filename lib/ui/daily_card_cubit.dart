import 'package:astro_journal/data/tarot_card.dart';
import 'package:astro_journal/tarot_service.dart';
import 'package:bloc/bloc.dart';
import 'package:firebase_storage/firebase_storage.dart';

abstract class DailyCardState {}

class DailyCardInProgress extends DailyCardState {}

class DailyCardResult extends DailyCardState {
  final TarotCard dailyCard;

  DailyCardResult(this.dailyCard);
}

class DailyCardInitial extends DailyCardState {}

class DailyCardCubit extends Cubit<DailyCardState> {
  DailyCardCubit() : super(DailyCardInitial());
  Future<void> getRandomCard() async {
    if (state is DailyCardInProgress) {
      return;
    }
    emit(DailyCardInProgress());

    final card = await getRandomTarotCard();
    if (card != null) {
      final imageUrl =
          'gs://astrojournal-2b048.appspot.com/tarot/${card.nameShort}.jpg';
      await Future<void>.delayed(const Duration(seconds: 1));
      emit(DailyCardResult(card.copyWith(
        imageUrl: imageUrl,
      )));
    }
  }

  void resetCard() {
    emit(DailyCardInitial());
  }
}

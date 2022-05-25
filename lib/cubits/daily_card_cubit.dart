import 'package:astro_journal/data/tarot_card.dart';
import 'package:astro_journal/services/tarot_service.dart';
import 'package:bloc/bloc.dart';
import 'package:hive/hive.dart';

abstract class DailyCardState {}

class DailyCardInProgress extends DailyCardState {}

class DailyCardResult extends DailyCardState {
  final TarotCard dailyCard;

  DailyCardResult(this.dailyCard);
}

class DailyCardInitial extends DailyCardState {}

class DailyCardCubit extends Cubit<DailyCardState> {
  final Box<TarotCard> hiveBox;

  DailyCardCubit(this.hiveBox) : super(DailyCardInitial());
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

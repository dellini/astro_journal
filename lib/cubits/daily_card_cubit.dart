import 'dart:async';

import 'package:astro_journal/data/tarot_card.dart';
import 'package:astro_journal/data/tarot_card_dto.dart';
import 'package:astro_journal/repositories/hive_tarot_history_repository.dart';
import 'package:astro_journal/services/tarot_service.dart';
import 'package:bloc/bloc.dart';
import 'package:hive/hive.dart';
import 'package:rxdart/rxdart.dart';

abstract class DailyCardState {}

class DailyCardInProgress extends DailyCardState {}

class DailyCardResult extends DailyCardState {
  final TarotCard dailyCard;

  DailyCardResult(this.dailyCard);
}

class DailyCardInitial extends DailyCardState {}

class DailyCardFailure extends DailyCardState {}

class DailyCardCubit extends Cubit<DailyCardState> {
  final TarotHistoryRepositoryHive historyRepository;
  late final BehaviorSubject<List<TarotCardDTO>> _history = BehaviorSubject();

  Stream<List<TarotCardDTO>> get history => _history.stream;

  DailyCardCubit({
    required this.historyRepository,
  }) : super(DailyCardInitial()) {
    historyRepository.tarotCardHistory.then<void>(_history.add);
  }

  Future<void> getRandomCard() async {
    if (state is DailyCardInProgress) {
      return;
    }
    emit(DailyCardInProgress());

    final card = await getRandomTarotCard();

    if (card != null) {
      final imageUrl =
          'gs://astrojournal-2b048.appspot.com/tarot/${card.nameShort}.jpg';
      final cardWithImage = card.copyWith(imageUrl: imageUrl);

      await historyRepository.addCardToHistory(cardWithImage);
      _history.sink.add(await historyRepository.tarotCardHistory);
      setCard(cardWithImage);
    } else {
      emit(DailyCardFailure());
    }
  }

  void setCard(TarotCard card) {
    emit(DailyCardResult(card));
  }

  void resetCard() {
    emit(DailyCardInitial());
  }

  void dispose() {
    _history.close();
  }
}

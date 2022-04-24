import 'package:astro_journal/data/tarot_card.dart';
import 'package:astro_journal/tarot_service.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

class DailyCardCubit extends Cubit<TarotCard?> {
  DailyCardCubit() : super(TarotCard.fromJson(<String, dynamic>{}));
  Future<void> getRandomCard() async {
    final card = await getRandomTarotCard();
    if (card != null) {
      emit(card);
    }
  }

  void resetCard() {
    emit(null);
  }
}

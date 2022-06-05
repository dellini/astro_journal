import 'dart:async';

import 'package:astro_journal/data/export.dart';
import 'package:astro_journal/date_extensions.dart';
import 'package:astro_journal/modules/daily_card/daily_card_cubit.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class CardHistoryController extends GetxController with ScrollMixin {
  late final now = DateTime.now().date;

  final DailyCardCubit dailyCardCubit;
  final RxMap<DateTime, List<TarotCardDTO>> _history = RxMap();

  RxMap<DateTime, List<TarotCardDTO>> get history =>
      RxMap.unmodifiable(_history);

  StreamSubscription<List<TarotCardDTO>>? _historyListen;

  CardHistoryController({
    required this.dailyCardCubit,
  });

  @override
  Future<void> onInit() async {
    super.onInit();

    _historyListen = dailyCardCubit.history.listen((cards) {
      final grouped = <DateTime, List<TarotCardDTO>>{};
      for (final card in cards) {
        grouped.putIfAbsent(card.createdAt.date, () => []).add(card);
      }
      _history.addAll(grouped);
      scroll.animateTo(
        0,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
      );
      update();
    });
  }

  @override
  void onClose() {
    super.onClose();
    _historyListen?.cancel();
  }

  @override
  Future<void> onEndScroll() async {}

  @override
  Future<void> onTopScroll() async {}
}

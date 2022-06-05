import 'package:astro_journal/data/export.dart';
import 'package:astro_journal/date_extensions.dart';
import 'package:astro_journal/modules/history/card_history_controller.dart';
import 'package:astro_journal/routes.dart';
import 'package:astro_journal/widgets/export.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

const _textStyle = TextStyle(
  fontFamily: 'TenorSans',
  fontSize: 24,
  color: Colors.amberAccent,
);

class CardHistoryScreen extends GetView<CardHistoryController> {
  @override
  final controller = Get.put(CardHistoryController(dailyCardCubit: Get.find()));

  CardHistoryScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 32, 32, 32),
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: Obx(() {
                final data = controller.history.entries.toList()
                  ..sort((a, b) => a.key.compareTo(b.key) * -1);

                return ListView.separated(
                  shrinkWrap: true,
                  padding: const EdgeInsets.only(top: 50),
                  itemCount: data.length,
                  controller: controller.scroll,
                  separatorBuilder: (_, __) => const SizedBox(height: 20),
                  itemBuilder: (context, index) {
                    final day = data[index];
                    final cards = day.value.reversed.toList();

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 8,
                            bottom: 8,
                            left: 65,
                            right: 20,
                          ),
                          child: RichText(
                            text: TextSpan(
                              style: _textStyle.copyWith(
                                fontFamily: 'Lora',
                                color: Colors.white,
                                fontSize: 21,
                              ),
                              children: [
                                if (day.key.date == controller.now)
                                  const TextSpan(text: 'сегодня, '),
                                TextSpan(
                                  text: DateFormat('d MMMM', 'ru')
                                      .format(day.key),
                                ),
                              ],
                            ),
                          ),
                        ),
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: cards.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 0),
                          itemBuilder: (context, index) {
                            final card = cards[index];
                            return _CardHistoryListItem(
                              card: card,
                              onTap: () {
                                controller.dailyCardCubit
                                    .setCard(card.tarotCard);
                                Get.toNamed<void>(Routes.dailyCard.name);
                              },
                            );
                          },
                        ),
                      ],
                    );
                  },
                );
              }),
            ),
            const PositionedBackButton(),
          ],
        ),
      ),
    );
  }
}

class _CardHistoryListItem extends StatelessWidget {
  final TarotCardDTO card;
  final VoidCallback? onTap;

  const _CardHistoryListItem({
    required this.card,
    this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.only(
              top: 8,
              bottom: 8,
              left: 55,
              right: 20,
            ),
            child: ListTile(
              title: RichText(
                text: TextSpan(
                  text: card.tarotCard.name,
                  style: _textStyle,
                  children: [
                    const TextSpan(text: '  '),
                    TextSpan(
                      text: DateFormat('H:mm', 'ru').format(card.createdAt),
                      style: const TextStyle(
                        fontFamily: 'Lora',
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

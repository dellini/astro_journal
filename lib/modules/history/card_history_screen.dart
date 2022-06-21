import 'package:astro_journal/data/export.dart';
import 'package:astro_journal/date_extensions.dart';
import 'package:astro_journal/modules/daily_card/daily_card_cubit.dart';
import 'package:astro_journal/routes.dart';
import 'package:astro_journal/widgets/export.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

const _textStyle = TextStyle(
  fontFamily: 'TenorSans',
  fontSize: 24,
  color: Colors.amberAccent,
);

class CardHistoryScreen extends StatelessWidget {
  const CardHistoryScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dailyCardCubit = context.read<DailyCardCubit>();
    final now = DateTime.now();

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 32, 32, 32),
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: StreamBuilder<Map<DateTime, List<TarotCardDTO>>>(
                stream: dailyCardCubit.history,
                builder: (context, snapshot) {
                  final data = snapshot.data!.entries.toList()
                    ..sort((a, b) => a.key.compareTo(b.key) * -1);

                  return ListView.separated(
                    shrinkWrap: true,
                    padding: const EdgeInsets.only(top: 50),
                    itemCount: data.length,
                    // controller: controller.scroll,
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
                                  if (day.key.onlyDate == now.onlyDate)
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
                                  dailyCardCubit.setCard(card.tarotCard);
                                  context.push(Routes.dailyCard.path);
                                },
                              );
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
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

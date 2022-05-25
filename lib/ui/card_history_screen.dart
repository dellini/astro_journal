import 'package:astro_journal/cubits/daily_card_cubit.dart';
import 'package:astro_journal/data/tarot_card_dto.dart';
import 'package:astro_journal/ui/daily_card_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class CardHistoryScreen extends StatefulWidget {
  const CardHistoryScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<CardHistoryScreen> createState() => _CardHistoryScreenState();
}

class _CardHistoryScreenState extends State<CardHistoryScreen> {
  late final DailyCardCubit dailyCardCubit = context.read();
  late final _scrollController = ScrollController();
  late final _listenUpdates = dailyCardCubit.history.listen((_) {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
    );
  });

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
    _listenUpdates.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: StreamBuilder<List<TarotCardDTO>>(
          stream: dailyCardCubit.history,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const SizedBox();
            }

            final data = snapshot.data!.reversed.toList();

            return ListView.builder(
              itemCount: data.length,
              controller: _scrollController,
              itemBuilder: (context, index) {
                final card = data[index];
                return _CardHistoryListItem(
                  card: card,
                  onTap: () {
                    dailyCardCubit.setCard(card.tarotCard);
                    Navigator.of(context).push(MaterialPageRoute<void>(
                      builder: (context) => const DailyCardScreen(),
                    ));
                  },
                );
              },
            );
          },
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
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: ListTile(
          title: Text(card.tarotCard.name),
          subtitle:
              Text(DateFormat('d MMM в H:m', 'ru').format(card.createdAt)),
        ),
      ),
    );
  }
}

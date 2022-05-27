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

const _textStyle = TextStyle(
  fontFamily: 'TenorSans',
  fontSize: 24,
  color: Colors.amberAccent,
);

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
      backgroundColor: const Color.fromARGB(255, 32, 32, 32),
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        iconTheme: const IconThemeData(color: Colors.amberAccent),
        backgroundColor: Colors.transparent,
        shadowColor: Colors.black12,
      ),
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
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: ListTile(
              title: Text(
                card.tarotCard.name,
                style: _textStyle,
                textAlign: TextAlign.center,
              ),
              subtitle: Text(
                DateFormat('d MMM в H:m', 'ru').format(card.createdAt),
                style: const TextStyle(
                  fontFamily: 'Comfortaa',
                  fontSize: 16,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

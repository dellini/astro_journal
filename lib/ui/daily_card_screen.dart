import 'package:astro_journal/data/tarot_card.dart';
import 'package:flutter/material.dart';

class DailyCardScreen extends StatelessWidget {
  final TarotCard tarotCard;
  const DailyCardScreen({
    Key? key,
    required this.tarotCard,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Карта дня'),
      ),
      body: ListView(
        children: [
          Text(tarotCard.toString()),
        ],
      ),
    );
  }
}

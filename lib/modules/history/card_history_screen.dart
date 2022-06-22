import 'package:astro_journal/data/export.dart';
import 'package:astro_journal/modules/daily_card/daily_card_cubit.dart';
import 'package:astro_journal/modules/shared/list_by_day.dart';
import 'package:astro_journal/routes.dart';
import 'package:astro_journal/widgets/export.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class CardHistoryScreen extends StatelessWidget {
  const CardHistoryScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dailyCardCubit = context.read<DailyCardCubit>();

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

                  return ListViewByDay<TarotCardDTO>(
                    data: Map.fromEntries(data),
                    itemBuilder: (item) {
                      return SimpleListItem(
                        title: item.tarotCard.name,
                        date: item.createdAt,
                        onTap: () {
                          dailyCardCubit.setCard(item.tarotCard);
                          context.push(Routes.dailyCard.path);
                        },
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

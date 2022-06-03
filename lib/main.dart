import 'package:astro_journal/cubits/affirmation_cubit.dart';
import 'package:astro_journal/cubits/daily_card_cubit.dart';
import 'package:astro_journal/data/tarot_card.dart';
import 'package:astro_journal/data/tarot_card_dto.dart';
import 'package:astro_journal/firebase_options.dart';
import 'package:astro_journal/repositories/hive_tarot_history_repository.dart';
import 'package:astro_journal/routes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:intl/intl_standalone.dart';
import 'package:surf_lint_rules/surf_lint_rules.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  Hive
    ..registerAdapter<TarotCard>(TarotCardAdapter())
    ..registerAdapter<TarotCardDTO>(TarotCardDTOAdapter());

  await Hive.initFlutter();
  final historyBox =
      await Hive.openBox<TarotCardDTO>(TarotHistoryRepositoryHive.boxName);

  final historyRepository = TarotHistoryRepositoryHive(historyBox);

  final dailyCardCubit = DailyCardCubit(historyRepository: historyRepository);
  final affirmationCubit = AffirmationCubit();
  unawaited(affirmationCubit.getAffirmation());

  await initializeDateFormatting('ru');
  Intl.systemLocale = await findSystemLocale();

  Get
    ..put(dailyCardCubit)
    ..put(affirmationCubit)
    ..put(historyRepository);

  runApp(
    GetMaterialApp(
      theme: ThemeData(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        hoverColor: Colors.transparent,
      ),
      initialRoute: Routes.main.name,
      getPages: Routes.routes,
    ),
  );
}

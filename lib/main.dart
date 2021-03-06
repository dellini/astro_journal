import 'dart:async';

import 'package:astro_journal/data/diary_note.dart';
import 'package:astro_journal/data/export.dart';
import 'package:astro_journal/firebase_options.dart';
import 'package:astro_journal/modules/calendar/diary/diary_cubit.dart';
import 'package:astro_journal/modules/calendar/diary/hive_diary_note_repository.dart';
import 'package:astro_journal/modules/calendar/planet_hours/planet_hours_controller.dart';
import 'package:astro_journal/modules/daily_card/daily_card_cubit.dart';
import 'package:astro_journal/modules/history/hive_card_history_repository.dart';
import 'package:astro_journal/modules/home/affirmation/affirmation_cubit.dart';
import 'package:astro_journal/routes.dart';
import 'package:astro_journal/theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:intl/intl_standalone.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  unawaited(SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]));
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
    // iOS
    statusBarColor: AppColors.backgroundColor,
    statusBarBrightness: Brightness.dark,

    // Android
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarColor: AppColors.backgroundColor,
    systemNavigationBarDividerColor: AppColors.backgroundColor,
    systemNavigationBarIconBrightness: Brightness.light,
  ));

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  Hive
    ..registerAdapter<TarotCard>(TarotCardAdapter())
    ..registerAdapter<TarotCardDTO>(TarotCardDTOAdapter())
    ..registerAdapter<DiaryNote>(DiaryNoteAdapter());

  await Hive.initFlutter();
  final historyBox =
      await Hive.openBox<TarotCardDTO>(TarotHistoryRepositoryHive.boxName);
  final diaryNotesBox =
      await Hive.openBox<DiaryNote>(DiaryNoteRepositoryHive.boxName);

  final historyRepository = TarotHistoryRepositoryHive(historyBox);
  final diaryRepository = DiaryNoteRepositoryHive(diaryNotesBox);

  final dailyCardCubit = DailyCardCubit(
    historyRepository: historyRepository,
    firebaseStorage: FirebaseStorage.instance,
  );
  await dailyCardCubit.fixCardsUrls();

  final affirmationCubit = AffirmationCubit();
  unawaited(affirmationCubit.getAffirmation());

  final planetHoursCubit = PlanetHoursCubit();
  final diaryNotesCubit = DiaryNotesCubit(
    diaryNotesRepository: diaryRepository,
  );

  await initializeDateFormatting('ru');
  Intl.systemLocale = await findSystemLocale();

  await SentryFlutter.init(
    (options) {
      options.dsn =
          'https://328ede910a724b9f9f7afa329e31d407@o358023.ingest.sentry.io/6528582';
    },
    appRunner: () => runApp(
      MultiRepositoryProvider(
        providers: [
          RepositoryProvider.value(value: diaryRepository),
        ],
        child: MultiBlocProvider(
          providers: [
            BlocProvider.value(value: dailyCardCubit),
            BlocProvider.value(value: affirmationCubit),
            BlocProvider.value(value: planetHoursCubit),
            BlocProvider.value(value: diaryNotesCubit),
          ],
          child: MaterialApp.router(
            theme: ThemeData(
              splashFactory: NoSplash.splashFactory,
            ),
            routeInformationParser: Routes.router.routeInformationParser,
            routerDelegate: Routes.router.routerDelegate,
          ),
        ),
      ),
    ),
  );
}

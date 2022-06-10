import 'dart:async';

import 'package:astro_journal/data/export.dart';
import 'package:astro_journal/firebase_options.dart';
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
    ..registerAdapter<TarotCardDTO>(TarotCardDTOAdapter());

  await Hive.initFlutter();
  final historyBox =
      await Hive.openBox<TarotCardDTO>(TarotHistoryRepositoryHive.boxName);

  final historyRepository = TarotHistoryRepositoryHive(historyBox);

  final dailyCardCubit = DailyCardCubit(
    historyRepository: historyRepository,
    firebaseStorage: FirebaseStorage.instance,
  );
  await dailyCardCubit.fixCardsUrls();

  final affirmationCubit = AffirmationCubit();
  unawaited(affirmationCubit.getAffirmation());

  final planetHoursCubit = PlanetHoursCubit();

  await initializeDateFormatting('ru');
  Intl.systemLocale = await findSystemLocale();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider.value(value: dailyCardCubit),
        BlocProvider.value(value: affirmationCubit),
        BlocProvider.value(value: planetHoursCubit),
      ],
      child: MaterialApp.router(
        theme: ThemeData(
          splashFactory: NoSplash.splashFactory,
        ),
        routeInformationParser: Routes.router.routeInformationParser,
        routerDelegate: Routes.router.routerDelegate,
      ),
    ),
  );
}

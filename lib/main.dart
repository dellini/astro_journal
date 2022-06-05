import 'dart:async';

import 'package:astro_journal/data/export.dart';
import 'package:astro_journal/firebase_options.dart';
import 'package:astro_journal/modules/daily_card/daily_card_cubit.dart';
import 'package:astro_journal/modules/history/hive_card_history_repository.dart';
import 'package:astro_journal/routes.dart';
import 'package:astro_journal/theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
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

  await initializeDateFormatting('ru');
  Intl.systemLocale = await findSystemLocale();

  Get
    ..put(dailyCardCubit)
    ..put(historyRepository);

  runApp(
    GetMaterialApp(
      theme: ThemeData(
        splashFactory: NoSplash.splashFactory,
        // splashColor: Colors.transparent,
        // highlightColor: Colors.transparent,
        // hoverColor: Colors.transparent,
      ),
      initialRoute: Routes.main.name,
      getPages: Routes.routes,
    ),
  );
}

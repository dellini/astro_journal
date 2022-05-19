import 'package:astro_journal/data/tarot_card.dart';
import 'package:astro_journal/data/tarot_card_dto.dart';
import 'package:astro_journal/firebase_options.dart';
import 'package:astro_journal/ui/home_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  Hive
    ..registerAdapter<TarotCard>(TarotCardAdapter())
    ..registerAdapter<TarotCardDTO>(TarotCardDTOAdapter());

  await Hive.initFlutter();
  await Hive.openBox<TarotCard>(tarotHistoryBoxName);

  runApp(
    const MaterialApp(
      home: HomeScreen(),
    ),
  );
}

const String tarotHistoryBoxName = 'tarotHistoryBoxName';

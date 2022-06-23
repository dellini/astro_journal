import 'package:astro_journal/data/diary_note.dart';
import 'package:astro_journal/modules/calendar/calendar_screen.dart';
import 'package:astro_journal/modules/calendar/diary/diary_create_screen.dart';
import 'package:astro_journal/modules/calendar/diary/diary_cubit.dart';
import 'package:astro_journal/modules/calendar/diary/diary_screen.dart';
import 'package:astro_journal/modules/calendar/planet_hours/planet_hours_screen.dart';
import 'package:astro_journal/modules/daily_card/daily_card_screen.dart';
import 'package:astro_journal/modules/history/card_history_screen.dart';
import 'package:astro_journal/modules/home/home_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

abstract class Routes {
  static final router = GoRouter(
    initialLocation: main.path,
    routes: [
      main,
      dailyCard,
      cardHistory,
      calendar,
      planetHours,
      diary,
      diaryEdit,
    ],
  );

  static final main = GoRoute(
    path: '/',
    builder: (_, __) => HomeScreen(
      onGoCardHistory: () => router.push(cardHistory.path),
      onGoDailyTarot: () => router.push(dailyCard.path),
      onGoLunarCalendar: () => router.push(calendar.path),
      onGoDiary: () {
        _.read<DiaryNotesCubit>().loadNotes();
        router.push(diary.path);
      },
    ),
  );
  static final dailyCard = GoRoute(
    path: '/dailyCard',
    builder: (_, __) => const DailyCardScreen(),
  );
  static final cardHistory = GoRoute(
    path: '/cardHistory',
    builder: (_, __) => const CardHistoryScreen(),
  );
  static final calendar = GoRoute(
    path: '/calendar',
    builder: (_, __) => CalendarScreen(
      onGoPlanetHours: () => router.push(planetHours.path),
      onGoDiary: () => router.push(diary.path),
    ),
  );
  static final planetHours = GoRoute(
    path: '/planetHours',
    builder: (_, __) => const PlanetHoursScreen(),
  );
  static final diary = GoRoute(
    path: '/diaryScreen',
    builder: (_, __) => const DiaryScreen(),
  );
  static final diaryEdit = GoRoute(
    path: '${diary.path}/edit',
    builder: (_, __) {
      final args = __.extra != null ? __.extra as DiaryArgs? : null;
      return DiaryEditScreen(
        initial: args?.note,
        dateTime: args?.date,
      );
    },
  );
}

class DiaryArgs {
  final DiaryNote? note;
  final DateTime? date;

  DiaryArgs({
    this.note,
    this.date,
  });
}

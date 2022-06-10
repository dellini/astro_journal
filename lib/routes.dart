import 'package:astro_journal/modules/calendar/calendar_screen.dart';
import 'package:astro_journal/modules/daily_card/daily_card_screen.dart';
import 'package:astro_journal/modules/history/card_history_screen.dart';
import 'package:astro_journal/modules/home/home_screen.dart';
import 'package:go_router/go_router.dart';

abstract class Routes {
  static final router = GoRouter(
    routes: [main, dailyCard, cardHistory, calendar],
    initialLocation: main.path,
  );

  static final main = GoRoute(
    path: '/',
    builder: (_, __) => HomeScreen(
      onGoCardHistory: () => router.push(cardHistory.path),
      onGoDailyTarot: () => router.push(dailyCard.path),
      onGoLunarCalendar: () => router.push(calendar.path),
      onGoDiary: () {},
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
    builder: (_, __) => const CalendarScreen(),
  );
}

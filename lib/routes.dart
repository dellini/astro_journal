import 'package:astro_journal/ui/calendar_screen.dart';
import 'package:astro_journal/ui/card_history_screen.dart';
import 'package:astro_journal/ui/daily_card_screen.dart';
import 'package:astro_journal/ui/home_screen.dart';
import 'package:get/get.dart';

abstract class Routes {
  static final main = GetPage<dynamic>(
    name: '/main',
    page: () => const HomeScreen(),
  );
  static final dailyCard = GetPage<dynamic>(
    name: '/dailyCard',
    page: () => const DailyCardScreen(),
  );
  static final cardHistory = GetPage<dynamic>(
    name: '/cardHistory',
    page: () => const CardHistoryScreen(),
  );
  static final calendar = GetPage<dynamic>(
    name: '/calendar',
    page: () => const CalendarScreen(),
  );

  static final routes = [
    main,
    dailyCard,
    cardHistory,
    calendar,
  ];
}

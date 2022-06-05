import 'package:astro_journal/modules/calendar/calendar_screen.dart';
import 'package:astro_journal/modules/daily_card/binding.dart';
import 'package:astro_journal/modules/daily_card/daily_card_screen.dart';
import 'package:astro_journal/modules/history/card_history_screen.dart';
import 'package:astro_journal/modules/home/binding.dart';
import 'package:astro_journal/modules/home/home_screen.dart';
import 'package:get/get.dart';

abstract class Routes {
  static final main = GetPage<dynamic>(
    name: '/main',
    binding: HomeBinding(),
    page: () => HomeScreen(
      onGoCardHistory: () => Get.toNamed<void>(cardHistory.name),
      onGoDailyTarot: () => Get.toNamed<void>(dailyCard.name),
      onGoLunarCalendar: () => Get.toNamed<void>(calendar.name),
      onGoDiary: () {},
    ),
  );
  static final dailyCard = GetPage<dynamic>(
    name: '/dailyCard',
    binding: DailyCardBinding(),
    page: () => const DailyCardScreen(),
  );
  static final cardHistory = GetPage<dynamic>(
    name: '/cardHistory',
    page: CardHistoryScreen.new,
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

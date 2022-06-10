import 'package:astro_journal/modules/home/affirmation/affirmation_cubit.dart';
import 'package:astro_journal/widgets/export.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatelessWidget {
  final VoidCallback? onGoDailyTarot;
  final VoidCallback? onGoCardHistory;
  final VoidCallback? onGoLunarCalendar;
  final VoidCallback? onGoDiary;

  const HomeScreen({
    Key? key,
    this.onGoDailyTarot,
    this.onGoCardHistory,
    this.onGoLunarCalendar,
    this.onGoDiary,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/home_background.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 32),
                    const GreetingsTextWidget(),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'аффирмация дня',
                            style: TextStyle(
                              fontFamily: 'Lora',
                              color: Colors.amberAccent,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 36),
                            child:
                                BlocBuilder<AffirmationCubit, AffirmationState>(
                              builder: (context, state) {
                                if (state is AffirmationResult) {
                                  return Text(
                                    state.affirmation,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontFamily: 'Lora',
                                      fontSize: 22,
                                      color: Colors.white,
                                    ),
                                  );
                                } else {
                                  return const AppCircularProgressIndicator();
                                }
                              },
                            ),
                          ),
                          const SizedBox(height: 34),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  AppButton(
                    text: 'КАРТА ДНЯ',
                    fontSize: 18,
                    onPressed: onGoDailyTarot,
                  ),
                  const SizedBox(height: 24),
                  AppButton(
                    text: 'ПОЛУЧЕННЫЕ КАРТЫ',
                    fontSize: 18,
                    fontColor: const Color.fromARGB(255, 20, 20, 20),
                    onPressed: onGoCardHistory,
                  ),
                  const SizedBox(height: 24),
                  AppButton(
                    text: 'ЛУННЫЙ КАЛЕНДАРЬ',
                    fontSize: 18,
                    onPressed: onGoLunarCalendar,
                  ),
                  const SizedBox(height: 24),
                  AppButton(
                    text: 'ДНЕВНИК МЫСЛЕЙ',
                    fontSize: 18,
                    onPressed: onGoDiary,
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

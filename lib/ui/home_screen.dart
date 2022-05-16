import 'package:astro_journal/ui/affirmation_cubit.dart';
import 'package:astro_journal/ui/app_square_button.dart';
import 'package:astro_journal/ui/daily_card_screen.dart';
import 'package:astro_journal/ui/greetings_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final AffirmationCubit affirmationCubit;
  @override
  void initState() {
    super.initState();
    affirmationCubit = AffirmationCubit();
    affirmationCubit.getAffirmation();
  }

  @override
  void dispose() {
    super.dispose();
    affirmationCubit.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff202020),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Column(
                // ignore: avoid_redundant_argument_values
                crossAxisAlignment: CrossAxisAlignment.stretch,
                // ignore: prefer_const_literals_to_create_immutables
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
                            fontFamily: 'Comfortaa',
                            color: Colors.amberAccent,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 36),
                          child:
                              BlocBuilder<AffirmationCubit, AffirmationState>(
                            bloc: affirmationCubit,
                            builder: (context, state) {
                              if (state is AffirmationResult) {
                                return Text(
                                  state.affirmation,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontFamily: 'Comfortaa',
                                    fontSize: 18,
                                    color: Colors.white,
                                  ),
                                );
                              } else {
                                return const SizedBox();
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
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(builder: (context) {
                        return const DailyCardScreen();
                      }),
                    );
                  },
                ),
                const SizedBox(height: 24),
                AppButton(
                  text: 'ПОЛУЧЕННЫЕ КАРТЫ',
                  fontSize: 18,
                  fontColor: const Color.fromARGB(255, 20, 20, 20),
                  onPressed: () {},
                ),
                const SizedBox(height: 24),
                AppButton(
                  text: 'ЛУННЫЙ КАЛЕНДАРЬ',
                  fontSize: 18,
                  onPressed: () {},
                ),
                const SizedBox(height: 24),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

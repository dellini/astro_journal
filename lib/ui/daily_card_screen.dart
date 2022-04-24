import 'package:astro_journal/data/tarot_card.dart';
import 'package:astro_journal/ui/daily_card_cubit.dart';
import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DailyCardScreen extends StatefulWidget {
  final TarotCard tarotCard;
  const DailyCardScreen({
    Key? key,
    required this.tarotCard,
  }) : super(key: key);

  @override
  State<DailyCardScreen> createState() => _DailyCardScreenState();
}

class _DailyCardScreenState extends State<DailyCardScreen> {
  late final cubit = DailyCardCubit();
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DailyCardCubit, TarotCard?>(
      bloc: cubit,
      builder: (context, snapshot) {
        return Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/background.png'),
              fit: BoxFit.fitWidth,
            ),
          ),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Stack(
              fit: StackFit.expand,
              children: [
                Positioned(
                  bottom: 0,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(512),
                      topRight: Radius.circular(512),
                    ),
                    child: GlassmorphicContainer(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.551,
                      borderRadius: 0,
                      linearGradient: LinearGradient(
                        colors: [
                          const Color(0xffFFDE59).withOpacity(0.05),
                          const Color(0xffFFDE59).withOpacity(0.4),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      border: 0,
                      blur: 8,
                      borderGradient: const LinearGradient(
                        colors: [
                          Color(0xffFFDE59),
                          Colors.white,
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: MediaQuery.of(context).size.height * 0.25 - 75,
                  height: 156,
                  child: Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                          const Color.fromARGB(255, 41, 41, 41),
                        ),
                        elevation: MaterialStateProperty.all(10),
                        fixedSize: MaterialStateProperty.all(
                          const Size(156, 156),
                        ),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(150),
                          ),
                        ),
                      ),
                      child: const Text(
                        'ПОЛУЧИТЬ\nКАРТУ ДНЯ',
                        style: TextStyle(
                          fontFamily: 'TenorSans',
                          fontSize: 19,
                          color: Colors.amberAccent,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 16,
                  top: 16,
                  child: SafeArea(
                    child: IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: Colors.amberAccent,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

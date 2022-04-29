import 'package:astro_journal/data/tarot_card.dart';
import 'package:astro_journal/tarot_service.dart';
import 'package:astro_journal/ui/daily_card_cubit.dart';
import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DailyCardScreen extends StatefulWidget {
  const DailyCardScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<DailyCardScreen> createState() => _DailyCardScreenState();
}

class _DailyCardScreenState extends State<DailyCardScreen> {
  static const _textStyle = TextStyle(
    fontFamily: 'TenorSans',
    fontSize: 16,
    color: Colors.amberAccent,
  );
  late final cubit = DailyCardCubit();
  @override
  void dispose() {
    super.dispose();
    cubit.close();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DailyCardCubit, DailyCardState>(
      bloc: cubit,
      builder: (context, state) {
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
                if (state is! DailyCardResult)
                  Positioned(
                    bottom: MediaQuery.of(context).size.height * 0.25 - 75,
                    height: 156,
                    child: Container(
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width,
                      child: ElevatedButton(
                        onPressed: cubit.getRandomCard,
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
                        //ignore:avoid-returning-widgets
                        child: buildButton(state),
                      ),
                    ),
                  ),
                if (state is DailyCardResult)
                  Positioned(
                    //ignore:avoid-returning-widgets
                    child: buildContent(state.dailyCard),
                    bottom: 0,
                    height: MediaQuery.of(context).size.height * 0.4,
                    left: 0,
                    right: 0,
                  ),
                Positioned(
                  left: 16,
                  top: 16,
                  child: SafeArea(
                    child: IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.arrow_back_rounded,
                        color: Colors.amberAccent,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  right: 16,
                  top: 16,
                  child: SafeArea(
                    child: IconButton(
                      onPressed: cubit.resetCard,
                      icon: const Icon(
                        Icons.refresh_rounded,
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

  Widget buildContent(TarotCard randomCard) {
    const textColor = Colors.amberAccent;
    const textWeight = FontWeight.bold;
    const shadows = <Shadow>[
      Shadow(
        offset: Offset(0, 0.1),
        blurRadius: 3.0,
        color: Color.fromARGB(155, 9, 9, 9),
      ),
      Shadow(
        offset: Offset(0, 2),
        blurRadius: 8.0,
        color: Color.fromARGB(155, 9, 9, 9),
      ),
    ];
    return Padding(
      padding: const EdgeInsets.all(26.0),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            Text(
              'Аркан: ${randomCard.arcane}',
              style: _textStyle.copyWith(
                color: textColor,
                fontWeight: textWeight,
                shadows: shadows,
              ),
            ),
            Text(
              'Название: ${randomCard.name}',
              style: _textStyle.copyWith(
                color: textColor,
                fontWeight: textWeight,
                shadows: shadows,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              randomCard.meaning,
              style: _textStyle.copyWith(
                color: Color.fromARGB(192, 16, 16, 16),
                fontWeight: FontWeight.lerp(
                  FontWeight.w500,
                  FontWeight.w700,
                  0.6,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildButton(DailyCardState state) {
    if (state is DailyCardInitial) {
      return const Text(
        'ПОЛУЧИТЬ\nКАРТУ ДНЯ',
        style: _textStyle,
        textAlign: TextAlign.center,
      );
    } else if (state is DailyCardInProgress) {
      return const CircularProgressIndicator(
        color: Colors.amberAccent,
      );
    } else {
      return const SizedBox();
    }
  }
}

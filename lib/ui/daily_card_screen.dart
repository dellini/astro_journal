import 'package:astro_journal/data/tarot_card.dart';
import 'package:astro_journal/tarot_service.dart';
import 'package:astro_journal/ui/daily_card_cubit.dart';
import 'package:firebase_image/firebase_image.dart';
import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

class DailyCardScreen extends StatefulWidget {
  const DailyCardScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<DailyCardScreen> createState() => _DailyCardScreenState();
}

const _textStyle = TextStyle(
  fontFamily: 'TenorSans',
  fontSize: 16,
  color: Colors.amberAccent,
);

class _DailyCardScreenState extends State<DailyCardScreen> {
  late final cubit = DailyCardCubit();
  @override
  void initState() {
    super.initState();
    FlutterNativeSplash.remove();
  }

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
        return DecoratedBox(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/background.png'),
              fit: BoxFit.cover,
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
                        child: _GetTarotButton(
                          state: state,
                          style: _textStyle,
                        ),
                      ),
                    ),
                  ),
                if (state is DailyCardResult)
                  Positioned(
                    //ignore:avoid-returning-widgets
                    child: _TarotCardDescription(
                      card: state.dailyCard,
                      style: _textStyle,
                    ),
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
                if (state is DailyCardResult)
                  Positioned(
                    left: MediaQuery.of(context).size.width * 0.2,
                    right: MediaQuery.of(context).size.width * 0.2,
                    top: MediaQuery.of(context).size.height * 0.12,
                    child: FadeInImage(
                      placeholder: MemoryImage(kTransparentImage),
                      image: FirebaseImage(state.dailyCard.imageUrl),
                      width: MediaQuery.of(context).size.width * 0.5,
                      height: MediaQuery.of(context).size.height * 0.45,
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

class _GetTarotButton extends StatelessWidget {
  final DailyCardState state;
  final TextStyle? style;

  const _GetTarotButton({
    Key? key,
    required this.state,
    this.style,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (state is DailyCardInitial) {
      return Text(
        'ПОЛУЧИТЬ\nКАРТУ ДНЯ',
        style: style,
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

class _TarotCardDescription extends StatelessWidget {
  final TarotCard card;
  final TextStyle? style;
  const _TarotCardDescription({
    Key? key,
    required this.card,
    this.style,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
              'Аркан: ${card.arcane}',
              style: style?.copyWith(
                color: textColor,
                fontWeight: textWeight,
                shadows: shadows,
              ),
            ),
            Text(
              'Название: ${card.name}',
              style: style?.copyWith(
                color: textColor,
                fontWeight: textWeight,
                shadows: shadows,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              card.meaning,
              style: style?.copyWith(
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
}

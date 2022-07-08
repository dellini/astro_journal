import 'package:astro_journal/data/export.dart';
import 'package:astro_journal/modules/daily_card/daily_card_cubit.dart';
import 'package:astro_journal/modules/shared/app_text_styles.dart';
import 'package:astro_journal/widgets/export.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_image/firebase_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:transparent_image/transparent_image.dart';

class DailyCardScreen extends StatelessWidget {
  const DailyCardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DailyCardCubit, DailyCardState>(
      builder: (context, state) {
        final dailyCardCubit = context.read<DailyCardCubit>();
        final size = MediaQuery.of(context).size;

        return DecoratedBox(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/tarot_background.png'),
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
                      child: BouncingWidget(
                        child: ElevatedButton(
                          onPressed:
                              context.read<DailyCardCubit>().getRandomCard,
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                              const Color.fromARGB(255, 20, 20, 20),
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
                            splashFactory: NoSplash.splashFactory,
                          ),
                          //ignore:avoid-returning-widgets
                          child: _GetTarotButtonContent(
                            state: state,
                            style: AppTextStyles.primaryTextStyle.copyWith(
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                if (state is DailyCardResult)
                  Positioned(
                    //ignore:avoid-returning-widgets
                    child: _TarotCardDescription(
                      card: state.dailyCard,
                      style: AppTextStyles.primaryTextStyle.copyWith(
                        fontSize: 16,
                      ),
                    ),
                    bottom: 0,
                    height: size.height * 0.4,
                    left: 0,
                    right: 0,
                  ),
                const PositionedBackButton(),
                if (dailyCardCubit.state is DailyCardResult)
                  Positioned(
                    right: 16,
                    top: 16,
                    child: SafeArea(
                      child: IconButton(
                        onPressed: dailyCardCubit.resetCard,
                        icon: const Icon(
                          Icons.refresh_rounded,
                          color: Colors.amberAccent,
                        ),
                      ),
                    ),
                  ),
                if (state is DailyCardResult)
                  Positioned(
                    left: size.width * 0.2,
                    right: size.width * 0.2,
                    top: size.height * 0.12,
                    child: FadeInImage(
                      placeholder: MemoryImage(kTransparentImage),
                      image: FirebaseImage(
                        state.dailyCard.imageUrl,
                        firebaseApp: Firebase.app(),
                      ),
                      width: size.width * 0.5,
                      height: size.height * 0.45,
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

class _GetTarotButtonContent extends StatelessWidget {
  final DailyCardState state;
  final TextStyle? style;

  const _GetTarotButtonContent({
    required this.state,
    Key? key,
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
      return const AppCircularProgressIndicator();
    } else {
      return const SizedBox();
    }
  }
}

class _TarotCardDescription extends StatelessWidget {
  final TarotCard card;
  final TextStyle? style;
  const _TarotCardDescription({
    required this.card,
    Key? key,
    this.style,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const textColor = Colors.amberAccent;
    const textWeight = FontWeight.bold;
    final size = MediaQuery.of(context).size;
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
    final textStyle = style?.copyWith(
      color: textColor,
      fontWeight: textWeight,
      shadows: shadows,
    );
    return Padding(
      padding: const EdgeInsets.all(26.0),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            Text(
              'Аркан: ${card.arcane}',
              style: textStyle,
            ),
            Text(
              'Название: ${card.name}',
              style: textStyle,
            ),
            SizedBox(height: size.height * 0.05),
            Container(
              width: size.width <= 500 ? size.width * 0.8 : size.width * 0.7,
              alignment: Alignment.center,
              child: Text(
                card.meaning,
                style: AppTextStyles.secondaryTextStyle.copyWith(
                  color: const Color.fromARGB(255, 32, 32, 32),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

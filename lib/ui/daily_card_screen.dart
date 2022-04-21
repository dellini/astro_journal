import 'package:astro_journal/data/tarot_card.dart';
import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';

class DailyCardScreen extends StatelessWidget {
  final TarotCard tarotCard;
  const DailyCardScreen({
    Key? key,
    required this.tarotCard,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                    fixedSize: MaterialStateProperty.all(
                      const Size(156, 156),
                    ),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(150),
                      ),
                    ),
                  ),
                  child: const Text('Получить\nкарту дня'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

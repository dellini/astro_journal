import 'package:astro_journal/ui/widgets/bouncing_button.dart';
import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final double fontSize;
  final FontWeight fontWeight;
  final Color fontColor;
  const AppButton({
    required this.text,
    this.fontWeight = FontWeight.bold,
    this.fontColor = Colors.amberAccent,
    this.fontSize = 22,
    this.onPressed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 36),
      child: BouncingWidget(
        child: InkWell(
          borderRadius: BorderRadius.circular(50),
          onTap: onPressed,
          child: GlassmorphicContainer(
            blur: 8,
            border: 0,
            width: MediaQuery.of(context).size.width,
            height: 60,
            borderGradient: LinearGradient(
              colors: [
                const Color(0xffFFDE59).withOpacity(0.05),
                const Color(0xffFFDE59).withOpacity(0.4),
              ],
            ),
            borderRadius: 50,
            linearGradient: LinearGradient(
              colors: [
                const Color(0xffFFDE59).withOpacity(0.05),
                const Color(0xffFFDE59).withOpacity(0.4),
              ],
            ),
            child: Center(
              child: Text(
                text,
                style: TextStyle(
                  fontFamily: 'TenorSans',
                  fontSize: fontSize,
                  color: fontColor,
                  fontWeight: fontWeight,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:astro_journal/routes.dart';
import 'package:flutter/material.dart';

class PositionedBackButton extends StatelessWidget {
  const PositionedBackButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 16,
      top: 16,
      child: SafeArea(
        child: IconButton(
          onPressed: Routes.router.pop,
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: Colors.amberAccent,
          ),
        ),
      ),
    );
  }
}

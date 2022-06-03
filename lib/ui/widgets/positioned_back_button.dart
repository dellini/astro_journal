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
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: Colors.amberAccent,
          ),
        ),
      ),
    );
  }
}

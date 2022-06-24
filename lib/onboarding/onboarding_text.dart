import 'package:flutter/material.dart';
class OnboardingText extends StatelessWidget {
  final String text;
  const OnboardingText({
    Key key,
    this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 40,
          fontFamily: 'RedHatDisplay',
          fontWeight: FontWeight.w800,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}

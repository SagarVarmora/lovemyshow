import 'package:flutter/material.dart';

class GradientBackground extends StatelessWidget {
  final Widget child;

  const GradientBackground({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFFE1BEE7),
            Color(0xFFF8BBD9),
            Color(0xFFF48FB1),
          ],
          stops: [0.0, 0.6, 1.0],
        ),
      ),
      child: child,
    );
  }
}
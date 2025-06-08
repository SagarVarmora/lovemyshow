import 'package:flutter/material.dart';

class LoveMyShowLogo extends StatelessWidget {
  final double? width;
  final double? height;

  const LoveMyShowLogo({
    Key? key,
    this.width,
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Image.asset(
        'assets/images/logo.png',
        width: width ?? 200,
        height: height ?? 80,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          return _buildFallbackLogo();
        },
      ),
    );
  }

  Widget _buildFallbackLogo() {
    return Container(
      width: width ?? 200,
      height: height ?? 80,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.white.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Center(
        child: Text(
          'LOGO',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.white.withOpacity(0.8),
          ),
        ),
      ),
    );
  }
}
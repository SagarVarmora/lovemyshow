import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lovemyshow/Controller/SplashController.dart';
import 'package:lovemyshow/Widgets/GradientBackground.dart';
import 'package:lovemyshow/Widgets/LoveMyShowLogo.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final SplashController controller = Get.find<SplashController>();

    return Scaffold(
      body: GradientBackground(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              LoveMyShowLogo(
                width: 250,
                height: 100,
              ),
              const SizedBox(height: 20),
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  Colors.white.withOpacity(0.8),
                ),
                strokeWidth: 2,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lovemyshow/Controller/AuthController.dart';
import 'package:lovemyshow/Controller/CityController.dart';
import 'package:lovemyshow/Controller/CountryController.dart';
import 'package:lovemyshow/Controller/OtpController.dart';
import 'package:lovemyshow/Controller/SplashController.dart';
import 'package:lovemyshow/Screens/CountrySelectionScreen.dart';
import 'package:lovemyshow/Screens/OtpVerificationScreen.dart';
import 'package:lovemyshow/Screens/SignInScreen.dart';
import 'package:lovemyshow/Screens/SplashScreen.dart';
import 'Controller/HomeController.dart';
import 'Controller/NavigationController.dart';
import 'Screens/CitySelectionScreen.dart';
import 'Screens/MainNavigationScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Love My Show',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.pink,
        fontFamily: 'Roboto',
        primaryColor: const Color(0xFFE91E63),
      ),
      initialRoute: '/splash',
      getPages: [
        GetPage(
          name: '/splash',
          page: () => SplashScreen(),
          binding: BindingsBuilder(() {
            Get.put(SplashController());
          }),
        ),
        GetPage(
          name: '/signin',
          page: () => SignInScreen(),
          binding: BindingsBuilder(() {
            Get.put(AuthController());
          }),
        ),
        GetPage(
          name: '/otp',
          page: () => OtpVerificationScreen(),
          binding: BindingsBuilder(() {
            Get.put(OtpController());
          }),
        ),
        GetPage(
          name: '/country',
          page: () => CountrySelectionScreen(),
          binding: BindingsBuilder(() {
            Get.put(CountryController());
          }),
        ),
        GetPage(
          name: '/city',
          page: () => CitySelectionScreen(),
          binding: BindingsBuilder(() {
            Get.put(CityController());
          }),
        ),
        GetPage(
          name: '/home',
          page: () => MainNavigationScreen(),
          binding: BindingsBuilder(() {
            Get.put(NavigationController());
            Get.put(HomeController());
          }),
        ),
      ],
    );
  }
}
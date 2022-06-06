import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:msg/screens/history.dart';
import 'package:msg/screens/login.dart';
import 'package:msg/screens/pin.dart';
import 'package:msg/services/storage_service.dart';
import 'package:page_transition/page_transition.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  Widget getNextScreen() {
    // StorageService.setLoggedIn(false);
    if (StorageService.isLoggedIn()!) {
      return const PinPage(changingPin: false);
    } else {
      return const LoginPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      splash: Column(
        children: [
          Image.asset(
            "assets/images/msg-logo.png",
            width: 500,
          ),
        ],
      ),
      nextScreen: getNextScreen(),
      splashIconSize: 250,
      duration: 1000,
      animationDuration: const Duration(milliseconds: 800),
      splashTransition: SplashTransition.fadeTransition,
      pageTransitionType: PageTransitionType.fade,
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SplashScreen();
  }
}

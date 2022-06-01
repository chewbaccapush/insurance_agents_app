import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:msg/screens/history.dart';
import 'package:page_transition/page_transition.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: Column(
        children: [
          Image.asset(
            "assets/images/msg-logo.png",
            width: 500,
          ),
        ],
      ),
      nextScreen: const HistoryPage(),
      splashIconSize: 250,
      duration: 2000,
      animationDuration: const Duration(milliseconds: 1500),
      splashTransition: SplashTransition.slideTransition,
      pageTransitionType: PageTransitionType.rightToLeft,
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: const SplashScreen()),
    );
  }
}

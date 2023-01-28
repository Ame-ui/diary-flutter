import 'dart:async';

import 'package:diary/resources/my_app_theme.dart';
import 'package:diary/route/route_names.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
        const Duration(seconds: 3),
        (() => Navigator.of(context).pushReplacementNamed(
              RouteNames.onboardingScreen,
            )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyAppTheme.primaryColor,
      body: const Center(
        child: Image(
          image: AssetImage('assets/diary_logo.png'),
          width: 300,
          height: 300,
        ),
      ),
    );
  }
}

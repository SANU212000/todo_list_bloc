import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_list/controller/constants.dart';
import 'package:todo_list/navigator/navigatorBloc.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  _IntroScreenState createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      context.read<NavigationBloc>().add(NavigateToHome());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.5, end: 2.0),
              duration: const Duration(seconds: 3),
              curve: Curves.bounceOut,
              builder: (context, scaleValue, child) {
                return Transform.scale(
                  scale: scaleValue,
                  child: const Text(
                    "Pandora",
                    style: TextStyle(
                      fontFamily: "intro",
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 5),
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: const Duration(seconds: 2),
              builder: (context, opacityValue, child) {
                return Opacity(
                  opacity: opacityValue,
                  child: const Text(
                    "stability for your time",
                    style: TextStyle(
                      fontFamily: "intro",
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      backgroundColor: kPrimaryColor,
    );
  }
}

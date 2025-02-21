import 'dart:async'; // Importing for Timer functionality
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_list/screens/constants.dart'; // Importing constants for colors
import 'package:todo_list/navigator/navigator_bloc.dart'; // Importing NavigationBloc for state management

// ✅ StatefulWidget for IntroScreen to manage animations and timed navigation
class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  IntroScreenState createState() => IntroScreenState(); // ✅ No underscore (public class)
}

// ✅ State class for IntroScreen
class IntroScreenState extends State<IntroScreen> {
  @override
  void initState() {
    super.initState();
    
    // ⏳ Timer to delay navigation for 3 seconds
    Timer(const Duration(seconds: 3), () {
      context.read<NavigationBloc>().add(NavigateToHome()); // 🚀 Dispatch event to navigate
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center( // ✅ Centers content
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // ✅ Aligns vertically to center
          children: [
            // 🔥 Animated Scaling Text - "Pandora"
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.5, end: 2.0), // 🔄 Starts small, grows to full size
              duration: const Duration(seconds: 3), // ⏳ 3-second animation
              curve: Curves.bounceOut, // 🎭 Adds bounce effect
              builder: (context, scaleValue, child) {
                return Transform.scale( // 🔍 Scales text
                  scale: scaleValue,
                  child: const Text(
                    "Pandora",
                    style: TextStyle(
                      fontFamily: "intro", // ✅ Custom font
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.white, // 🎨 White color
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 5), // 🏗 Adds spacing

            // ✨ Animated Opacity Text - "stability for your time"
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0), // 🔄 Fades in
              duration: const Duration(seconds: 2), // ⏳ 2-second animation
              builder: (context, opacityValue, child) {
                return Opacity( // 👀 Controls opacity
                  opacity: opacityValue,
                  child: const Text(
                    "stability for your time",
                    style: TextStyle(
                      fontFamily: "intro", // ✅ Custom font
                      fontSize: 16,
                      color: Colors.white70, // 🎨 Slightly faded white
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      backgroundColor: kPrimaryColor, // 🎨 Background color from constants
    );
  }
}

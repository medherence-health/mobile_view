import 'dart:async';
import 'package:flutter/material.dart';
import 'package:medherence/features/dashboard_feature/view/dashboard_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/utils/color_utils.dart';
import '../onboarding/onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  // Function to check if password has been successfully changed
  Future<bool> isUserSignedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isSignedIn') ?? false;
  }

  // Function to show password change prompt if necessary
  void checkPasswordChangePrompt() async {
    bool passwordChanged = await isUserSignedIn();
    if (!passwordChanged) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const OnboardingView()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const DashboardView()),
      );
    }
  }

  @override
  void initState() {
    super.initState();

    // Animation controller
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    // Animation
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );

    // Start animation
    _animationController.forward();
    _animationController.addListener(() {
      setState(() {});
    });
    Timer(const Duration(milliseconds: 2500), () {
      checkPasswordChangePrompt();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.navBarColor,
      body: Center(
        child: Stack(
          children: [
            // Animated image
            AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(
                      0, 200 * (1 - _animation.value)), // Slide down animation
                  child: Transform.scale(
                    scale: 0.5 + (_animation.value * 0.5), // Enlarge animation
                    child: Opacity(
                      opacity: _animation.value, // Fade animation
                      child: child,
                    ),
                  ),
                );
              },
              child:
                  Image.asset('assets/images/vector.png'), // Your image asset
            ),
          ],
        ),
      ),
    );
  }
}

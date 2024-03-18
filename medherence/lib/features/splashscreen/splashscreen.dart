import 'dart:async';
import 'package:flutter/material.dart';

import 'package:medherence/features/dashboard_feature/view/dashboard.dart';

import '../../core/constants_utils/color_utils.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
 late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    // Animation controller
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    // Animation
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );

    // Start animation
    _animationController.forward();

    Timer(const Duration(seconds: 5), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const DashboardView()),
      );
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
                  offset: Offset(0, 200 * (1 - _animation.value)), // Slide down animation
                  child: Transform.scale(
                    scale: 0.5 + (_animation.value * 0.5), // Enlarge animation
                    child: Opacity(
                      opacity: _animation.value, // Fade animation
                      child: child,
                    ),
                  ),
                );
              },
              child: Image.asset('assets/images/vector.png'), // Your image asset
            ),
          ],
        ),
      ),
    );
  }
}

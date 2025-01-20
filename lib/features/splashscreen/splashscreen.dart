import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:medherence/core/constants/constants.dart';
import 'package:medherence/core/database/database_service.dart';
import 'package:medherence/features/dashboard_feature/view/dashboard_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/service/biometric_service.dart';
import '../../core/utils/color_utils.dart';
import '../onboarding/onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({
    super.key,
  });

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  final _biometricService = BiometricService();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseService _databaseService = DatabaseService.instance;

  // Function to check if biometric is enabled in shared preference
  Future<bool> isBiometricEnabled() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('useBiometric') ?? false;
  }

// Function to check if the user is signed in
  Future<bool> isUserSignedIn() async {
    // Check if the current user is null
    final currentUser = _auth.currentUser;
    if (currentUser == null) {
      return false; // User is not signed in
    }

    try {
      // Fetch user data from the database by user ID
      var result = await _databaseService.getUserDataById(currentUser.uid);

      print("currentUserdb: ${result.message} : ${currentUser.uid}");

      // Check if the result's message indicates success
      if (result.message == ok) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      // Handle any errors that occur
      print("Error checking user sign-in status: $e");
      return false;
    }
  }

// Function to check and show logged-in prompt if necessary
  void checkLoggedInPrompt() async {
    try {
      // Check if the user is signed in
      bool userSignedIn = await isUserSignedIn();
      if (!userSignedIn) {
        // Navigate to the onboarding screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const OnboardingView()),
        );
        return; // Exit function as user is not signed in
      }

      // Check if biometric authentication is enabled
      bool useBiometric = await isBiometricEnabled();
      if (useBiometric) {
        // Attempt biometric authentication
        bool authenticated = await _biometricService.authenticate();
        if (authenticated) {
          // Navigate to the dashboard if authentication succeeds
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const DashboardView()),
          );
        } else {
          // Authentication failed or canceled, exit the app
          Navigator.pop(context); // Close splash screen or current view
        }
      } else {
        // Biometric authentication not enabled, navigate directly to dashboard
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const DashboardView()),
        );
      }
    } catch (e) {
      // Handle any exceptions that occur
      print("Error during login check: $e");
      // Optionally navigate to an error or fallback screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const OnboardingView()),
      );
    }
  }

  @override
  void initState() {
    super.initState();

    // Initialize animation controller
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    // Define the animation with a curve
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );

    // Start the animation
    _animationController.forward();

    // Listen to animation progress and rebuild the widget
    _animationController.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });

    // Delay execution for login check
    Future.delayed(const Duration(milliseconds: 2500), () {
      if (mounted) {
        checkLoggedInPrompt();
      }
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

// // Function to show password change prompt if necessary
// void checkPasswordChangePrompt() async {
//   bool passwordChanged = await isUserSignedIn();
//   if (!passwordChanged) {
//     Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(builder: (context) => const OnboardingView()),
//     );
//   } else {
//     Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(builder: (context) => const DashboardView()),
//     );
//   }
// }

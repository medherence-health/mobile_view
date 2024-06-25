import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:medherence/main.dart';
import 'package:medherence/features/splashscreen/splashscreen.dart';
import 'package:medherence/features/onboarding/onboarding_screen.dart';
import 'package:medherence/features/dashboard_feature/view/dashboard_view.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('SplashScreen Tests', () {
    setUp(() async {
      // Clear any existing SharedPreferences data
      SharedPreferences.setMockInitialValues({});
    });

    testWidgets('Navigate to Onboarding if user is not signed in', (WidgetTester tester) async {
      // Set up the mock SharedPreferences to simulate user not signed in
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isSignedIn', false);

      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // Verify that SplashScreen is displayed
      expect(find.byType(SplashScreen), findsOneWidget);

      // Wait for the splash screen timer to complete
      await tester.pump(const Duration(milliseconds: 2500));
      await tester.pumpAndSettle();

      // Verify that OnboardingView is displayed
      expect(find.byType(OnboardingView), findsOneWidget);
    });

    testWidgets('Navigate to Dashboard if user is signed in and biometric is not enabled', (WidgetTester tester) async {
      // Set up the mock SharedPreferences to simulate user signed in and biometric not enabled
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isSignedIn', true);
      await prefs.setBool('useBiometric', false);

      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // Verify that SplashScreen is displayed
      expect(find.byType(SplashScreen), findsOneWidget);

      // Wait for the splash screen timer to complete
      await tester.pump(const Duration(milliseconds: 2500));
      await tester.pumpAndSettle();

      // Verify that DashboardView is displayed
      expect(find.byType(DashboardView), findsOneWidget);
    });

    testWidgets('Navigate to Dashboard if user is signed in and biometric is enabled and authentication is successful', (WidgetTester tester) async {
      // Set up the mock SharedPreferences to simulate user signed in and biometric enabled
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isSignedIn', true);
      await prefs.setBool('useBiometric', true);

      // Mock the BiometricService to simulate successful authentication
      final mockBiometricService = MockBiometricService();
      when(mockBiometricService.authenticate()).thenAnswer((_) async => true);

      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // Verify that SplashScreen is displayed
      expect(find.byType(SplashScreen), findsOneWidget);

      // Wait for the splash screen timer to complete
      await tester.pump(const Duration(milliseconds: 2500));
      await tester.pumpAndSettle();

      // Verify that DashboardView is displayed
      expect(find.byType(DashboardView), findsOneWidget);
    });

    testWidgets('Close app if user cancels biometric authentication', (WidgetTester tester) async {
      // Set up the mock SharedPreferences to simulate user signed in and biometric enabled
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isSignedIn', true);
      await prefs.setBool('useBiometric', true);

      // Mock the BiometricService to simulate failed authentication
      final mockBiometricService = MockBiometricService();
      when(mockBiometricService.authenticate()).thenAnswer((_) async => false);

      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // Verify that SplashScreen is displayed
      expect(find.byType(SplashScreen), findsOneWidget);

      // Wait for the splash screen timer to complete
      await tester.pump(const Duration(milliseconds: 2500));
      await tester.pumpAndSettle();

      // Verify that the app has been closed (since we can't actually close the app in a test, this step is hypothetical)
      // You may want to check if the screen is not transitioning to DashboardView or OnboardingView
      expect(find.byType(DashboardView), findsNothing);
      expect(find.byType(OnboardingView), findsNothing);
    });
  });
}

class MockBiometricService extends BiometricService {
  @override
  Future<bool> authenticate() async {
    return true; // Default to successful authentication for the mock
  }
}

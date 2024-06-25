import 'package:flutter_test/flutter_test.dart';
import 'package:medherence/core/service/biometric_service.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:medherence/main.dart';
import 'package:medherence/features/splashscreen/splashscreen.dart';
import 'package:medherence/features/onboarding/onboarding_screen.dart';
import 'package:medherence/features/dashboard_feature/view/dashboard_view.dart';
import 'package:fake_async/fake_async.dart';

class MockBiometricService extends Mock implements BiometricService {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('SplashScreen Tests', () {
    setUp(() async {
      // Clear any existing SharedPreferences data
      SharedPreferences.setMockInitialValues({});
    });

    testWidgets('Navigate to Onboarding if user is not signed in',
        (WidgetTester tester) async {
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

    testWidgets(
        'Navigate to Dashboard if user is signed in and biometric is not enabled',
        (WidgetTester tester) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isSignedIn', true);
      await prefs.setBool('useBiometric', false);

      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // Verify that SplashScreen is displayed
      expect(find.byType(SplashScreen), findsOneWidget);

      // Simulate a long-running operation with fake_async
      await fakeAsync((fakeAsync) async {
        // Wait for the splash screen timer to complete
        await tester.pump(const Duration(milliseconds: 2500));

        // Verify that DashboardView is eventually displayed
        await tester.pumpAndSettle();

        // Verify that DashboardView is displayed
        expect(find.byType(DashboardView), findsOneWidget);

        // Flush microtasks to ensure all async operations complete
        fakeAsync.flushMicrotasks();
      });
    });
  });
}

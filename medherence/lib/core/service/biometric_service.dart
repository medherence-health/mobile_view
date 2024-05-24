import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

class BiometricService {
  final LocalAuthentication _localAuthentication = LocalAuthentication();

  Future<bool> authenticate() async {
    try {
      bool canCheckBiometrics = await _localAuthentication.canCheckBiometrics;
      if (!canCheckBiometrics) {
        throw PlatformException(
          code: 'NotAvailable',
          message: 'Biometric authentication is not available on this device.',
        );
      }

      List<BiometricType> availableBiometrics =
          await _localAuthentication.getAvailableBiometrics();
      if (availableBiometrics.isEmpty) {
        throw PlatformException(
          code: 'NotAvailable',
          message: 'No biometric methods are available on this device.',
        );
      }

      return await _localAuthentication.authenticate(
        localizedReason: 'Please authenticate to confirm.',
        options: const AuthenticationOptions(
          biometricOnly: true,
          useErrorDialogs: true,
          stickyAuth: true,
        ),
      );
    } on PlatformException catch (e) {
      print('Authentication failed: ${e.message}');
      return false;
    }
  }
}

import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

class BiometricService {
  static bool isEnabled = false;
  //initialize Local Authentication plugin.
  final LocalAuthentication _localAuthentication = LocalAuthentication();
  //status of authentication.
  bool isAuthenticated = false;
  //check if device supports biometrics authentication.

  Future<bool> authenticate() async {
    try {
      // bool isBiometricSupported =
      //     await _localAuthentication.isDeviceSupported();
      bool canCheckBiometrics = await _localAuthentication.canCheckBiometrics;
      if (!canCheckBiometrics) {
        throw PlatformException(
          code: 'NotAvailable',
          message: 'Biometric authentication is not available on this device.',
        );
      }

      // List<BiometricType> availableBiometrics =
      //     await _localAuthentication.getAvailableBiometrics();
      // availableBiometrics = <BiometricType>[];
      // if (availableBiometrics.isEmpty) {
      //   throw PlatformException(
      //     code: 'NotAvailable',
      //     message: 'No biometric methods are available on this device.',
      //   );
      // }
      if (canCheckBiometrics) {
        isAuthenticated = await _localAuthentication.authenticate(
          localizedReason: 'Please authenticate to confirm.',
          options: const AuthenticationOptions(
            biometricOnly: true,
            useErrorDialogs: true,
            stickyAuth: true,
          ),
        );
      }
      return isAuthenticated;
    } on PlatformException catch (e) {
      print('Authentication failed: ${e.message}');
      return false;
    }
  }
}

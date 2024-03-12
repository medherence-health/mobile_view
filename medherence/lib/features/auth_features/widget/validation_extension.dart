extension StringExtension on String? {
  String? nameValidation() {
    if (this == null || this!.isEmpty) {
      return 'Name cannot be empty';
    }
    return null;
  }

  String? emailValidation() {
    if (this == null || this!.isEmpty) {
      return 'Email cannot be empty';
    }
    return null;
  }

  String? phoneNumberValidation() {
    if (this == null || this!.isEmpty) {
      return 'Phone number cannot be empty';
    }
    if (this!.length < 11) {
      return 'Phone number cannot be less than 11 numbers';
    }
    return null;
  }

  String? validatePassword() {
    if (this == null || this!.isEmpty) {
      return 'Password is required.';
    }

    if (this!.length < 8) {
      return 'Password must be at least 8 characters long.';
    }
    // You can add more specific password validation rules here
    return null;
  }

}

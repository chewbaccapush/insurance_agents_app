import 'package:validators/validators.dart';

class Validators {
  
  // Checks only if input field is empty
  static String? defaultValidator(String value) {
    if (value.isEmpty) {
      return 'Please fill this field';
    }
    return null;
  }

  static String? intValidator(String value) {
    if (defaultValidator(value) != null) {
      return defaultValidator(value);
    }
    if (!isInt(value)) {
      return 'Number must be an Integer';
    }
    return null;
  }

  static String? floatValidator(String value) {
    if (defaultValidator(value) != null) {
      return defaultValidator(value);
    }
    if (!isFloat(value)) {
      return 'Enter a number';
    }
    return null;
  }

  static String? numberOfApartmentsValidator(String value) {
    if (defaultValidator(value) != null) {
      return null;
    } else {
      return intValidator(value);
    }
  }

  static String? measurementValidator(String value) {
    if (defaultValidator(value) != null) {
      return null;
    } else {
      return floatValidator(value);
    }
  }

  static bool isEmpty(String value) {
    if (value == null || value.isEmpty) {
      return true;
    }
    return false;
  }
}
class Validators {
  /// Validate required string field
  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return "Please enter $fieldName";
    }
    return null;
  }

  /// Validate positive integer field
  static String? validatePositiveNumber(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return "Please enter $fieldName";
    }
    final numValue = int.tryParse(value.trim());
    if (numValue == null || numValue <= 0) {
      return "$fieldName must be greater than 0";
    }
    return null;
  }

  /// Validate height in cm
  static String? validateHeight(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Please enter height";
    }
    final height = double.tryParse(value.trim());
    if (height == null || height < 50 || height > 250) {
      return "Enter valid height (50 - 250 cm)";
    }
    return null;
  }

  /// Validate weight in kg
  static String? validateWeight(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Please enter weight";
    }
    final weight = double.tryParse(value.trim());
    if (weight == null || weight < 20 || weight > 300) {
      return "Enter valid weight (20 - 300 kg)";
    }
    return null;
  }
}

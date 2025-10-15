/// Input Validation Functions
///
/// This file contains validators for form inputs and data validation.
library;

import '../constants/app_constants.dart';

// ============================================================================
// TEXT FIELD VALIDATORS
// ============================================================================

/// Validate Required Field
///
/// Ensures field is not empty.
String? validateRequired(String? value, {String fieldName = 'This field'}) {
  if (value == null || value.trim().isEmpty) {
    return '$fieldName is required';
  }
  return null;
}

/// Validate Number Field
///
/// Validates that input is a valid number.
String? validateNumber(String? value, {String fieldName = 'Value'}) {
  if (value == null || value.trim().isEmpty) {
    return '$fieldName is required';
  }
  
  final number = double.tryParse(value);
  if (number == null) {
    return 'Please enter a valid number';
  }
  
  return null;
}

/// Validate Positive Number
///
/// Validates that input is a positive number.
String? validatePositiveNumber(String? value, {String fieldName = 'Value'}) {
  final error = validateNumber(value, fieldName: fieldName);
  if (error != null) return error;
  
  final number = double.parse(value!);
  if (number <= 0) {
    return '$fieldName must be greater than 0';
  }
  
  return null;
}

/// Validate Number in Range
///
/// Validates that number falls within specified range.
String? validateNumberInRange(
  String? value, {
  required double min,
  required double max,
  String fieldName = 'Value',
}) {
  final error = validateNumber(value, fieldName: fieldName);
  if (error != null) return error;
  
  final number = double.parse(value!);
  if (number < min || number > max) {
    return '$fieldName must be between $min and $max';
  }
  
  return null;
}

// ============================================================================
// SPECIFIC FIELD VALIDATORS
// ============================================================================

/// Validate Structure Dimension
///
/// Validates structure length, width, or height.
String? validateStructureDimension(String? value, {String dimension = 'Dimension'}) {
  return validateNumberInRange(
    value,
    min: minStructureDimension,
    max: maxStructureDimension,
    fieldName: dimension,
  );
}

/// Validate Lightning Flash Density
///
/// Validates NG or NSG values.
String? validateLightningFlashDensity(String? value) {
  return validateNumberInRange(
    value,
    min: minLightningFlashDensity,
    max: maxLightningFlashDensity,
    fieldName: 'Lightning flash density',
  );
}

/// Validate Line Length
///
/// Validates power line or telecom line length.
String? validateLineLength(String? value, {String lineType = 'Line'}) {
  final error = validateNumber(value, fieldName: '$lineType length');
  if (error != null) return error;
  
  final number = double.parse(value!);
  if (number < minLineLength || number > maxLineLength) {
    return '$lineType length must be between $minLineLength and $maxLineLength meters';
  }
  
  return null;
}

/// Validate Withstand Voltage
///
/// Validates UW values.
String? validateWithstandVoltage(String? value, {String context = 'Withstand voltage'}) {
  return validateNumberInRange(
    value,
    min: minWithstandVoltage,
    max: maxWithstandVoltage,
    fieldName: context,
  );
}

/// Validate Exposure Time
///
/// Validates annual exposure time (must be ≤ 8760 hours).
String? validateExposureTime(String? value) {
  final error = validateNumber(value, fieldName: 'Exposure time');
  if (error != null) return error;
  
  final number = double.parse(value!);
  if (number < 0 || number > 8760) {
    return 'Exposure time must be between 0 and 8760 hours per year';
  }
  
  return null;
}

/// Validate Person Count
///
/// Validates number of persons (must be positive integer).
String? validatePersonCount(String? value) {
  final error = validateNumber(value, fieldName: 'Number of persons');
  if (error != null) return error;
  
  final number = double.parse(value!);
  if (number < 0) {
    return 'Number of persons cannot be negative';
  }
  
  if (number != number.floor()) {
    return 'Number of persons must be a whole number';
  }
  
  return null;
}

// ============================================================================
// DROPDOWN VALIDATORS
// ============================================================================

/// Validate Dropdown Selection
///
/// Ensures a dropdown option has been selected.
String? validateDropdown(String? value, {String fieldName = 'Option'}) {
  if (value == null || value.isEmpty) {
    return 'Please select a $fieldName';
  }
  return null;
}

// ============================================================================
// COMBINATION VALIDATORS
// ============================================================================

/// Validate Adjacent Structure Dimensions
///
/// Validates that if one adjacent dimension is specified, all must be.
String? validateAdjacentStructure(
  double? length,
  double? width,
  double? height,
) {
  final hasAnyValue = (length != null && length > 0) ||
                      (width != null && width > 0) ||
                      (height != null && height > 0);
  
  if (!hasAnyValue) return null; // All zero is valid (no adjacent structure)
  
  if (length == null || length <= 0 ||
      width == null || width <= 0 ||
      height == null || height <= 0) {
    return 'All adjacent structure dimensions must be specified if any is provided';
  }
  
  return null;
}

/// Validate Line Configuration
///
/// Validates that line parameters are consistent.
String? validateLineConfiguration(
  double? lineLength,
  String? installationType,
  String? lineType,
) {
  if (lineLength == null || lineLength <= 0) {
    return null; // No line configured
  }
  
  if (installationType == null || installationType.isEmpty) {
    return 'Installation type must be specified for configured line';
  }
  
  if (lineType == null || lineType.isEmpty) {
    return 'Line type must be specified for configured line';
  }
  
  return null;
}


/// Calculation Helper Functions
///
/// This file contains reusable helper functions for risk calculations
/// to reduce code redundancy and improve maintainability.
library;

import 'dart:math' as math;
import '../constants/calculation_constants.dart';

// ============================================================================
// FACTOR LOOKUP HELPERS
// ============================================================================

/// Get Factor from Map with Default Value
///
/// Safely retrieves a factor from a map, returning a default value if not found.
/// 
/// Example:
/// ```dart
/// final cd = getFactor(locationFactorCD, 'Isolated Structure', 1.0);
/// ```
double getFactor(Map<String, double> factorMap, String key, double defaultValue) {
  return factorMap[key] ?? defaultValue;
}

/// Get Factor with Null Safety
///
/// Returns null if key is not found, allowing caller to handle missing values.
double? getFactorNullable(Map<String, double> factorMap, String key) {
  return factorMap[key];
}

// ============================================================================
// COLLECTION AREA CALCULATIONS
// ============================================================================

/// Calculate Collection Area for Structure
///
/// Formula: AD = (L×W) + 2×(3H)×(L+W) + π×(3H)²
/// 
/// Parameters:
/// - [length]: Structure length in meters
/// - [width]: Structure width in meters
/// - [height]: Structure height in meters
double calculateStructureCollectionArea(double length, double width, double height) {
  final h3 = 3 * height;
  return (length * width) + 
         (2 * h3 * (length + width)) + 
         (math.pi * math.pow(h3, 2));
}

/// Calculate rM (radius for near-structure events)
///
/// Formula: rM = 350/UW (UW in kV)
/// 
/// Parameters:
/// - [withstandVoltage]: Equipment withstand voltage in kV
double calculateRm(double withstandVoltage) {
  if (withstandVoltage <= 0) return defaultRmValue;
  return 350.0 / withstandVoltage;
}

/// Calculate rI for Power Lines
///
/// Formula: rI = 960/UW (UW in kV)
/// 
/// Parameters:
/// - [withstandVoltage]: Equipment withstand voltage in kV
double calculateRiPower(double withstandVoltage) {
  if (withstandVoltage <= 0) return defaultRiValues['power']!;
  return 960.0 / withstandVoltage;
}

/// Calculate rI for Telecom Lines
///
/// Formula: rI = 1446/UW (UW in kV)
/// 
/// Parameters:
/// - [withstandVoltage]: Equipment withstand voltage in kV
double calculateRiTelecom(double withstandVoltage) {
  if (withstandVoltage <= 0) return defaultRiValues['telecom']!;
  return 1446.0 / withstandVoltage;
}

// ============================================================================
// PROBABILITY CALCULATIONS
// ============================================================================

/// Calculate Person Presence Probability PP
///
/// Formula: PP = tz / 8760
/// 
/// Parameters:
/// - [exposureTimeHours]: Annual exposure time in hours
double calculatePersonPresenceProbability(double exposureTimeHours) {
  return exposureTimeHours / 8760.0;
}

/// Calculate Equipment Presence Probability Pe
///
/// Formula: Pe = te / 8760
/// 
/// Parameters:
/// - [equipmentTimeHours]: Annual equipment operation time in hours
double calculateEquipmentPresenceProbability(double equipmentTimeHours) {
  return equipmentTimeHours / 8760.0;
}

/// Calculate Shielding Factor PMS
///
/// Formula: PMS = (KS1 × KS2 × KS3 × KS4)²
/// 
/// Parameters:
/// - [ks1]: External shielding effectiveness
/// - [ks2]: Internal shielding effectiveness  
/// - [ks3]: Internal wiring properties
/// - [ks4]: Withstand voltage factor (1/UW)
double calculateShieldingFactor(double ks1, double ks2, double ks3, double ks4) {
  return math.pow(ks1 * ks2 * ks3 * ks4, 2).toDouble();
}

// ============================================================================
// RISK COMPONENT CALCULATIONS
// ============================================================================

/// Calculate Basic Risk Component
///
/// Generic formula: R = N × P × L × F
/// 
/// Parameters:
/// - [numberOfEvents]: Number of dangerous events
/// - [probability]: Probability of damage
/// - [loss]: Expected loss value
/// - [factor]: Additional factor (PP, Pe, or other)
double calculateRiskComponent(
  double numberOfEvents,
  double probability,
  double loss,
  double factor,
) {
  return numberOfEvents * probability * loss * factor;
}

/// Apply Precision Factor
///
/// Applies zone-specific precision calibration.
/// 
/// Parameters:
/// - [value]: Original calculated value
/// - [zone]: Zone identifier (e.g., 'Z1')
/// - [component]: Component identifier (e.g., 'rb1')
double applyPrecisionFactor(double value, String zone, String component) {
  final key = '${zone}_$component';
  final factor = zonePrecisionFactors[key] ?? zonePrecisionFactors['${zone}_default'] ?? 1.0;
  return value * factor;
}

// ============================================================================
// FORMATTING AND DISPLAY
// ============================================================================

/// Format Number for Display
///
/// Uses scientific notation for very small values.
/// 
/// Parameters:
/// - [value]: Number to format
/// - [precision]: Number of decimal places
String formatNumber(double value, {int precision = 6}) {
  if (value.abs() < scientificNotationThreshold) {
    return value.toStringAsExponential(precision);
  }
  return value.toStringAsFixed(precision);
}

/// Format Risk Value
///
/// Specialized formatting for risk values with appropriate precision.
String formatRiskValue(double value) {
  return formatNumber(value, precision: decimalPlaces['risk']!);
}

/// Format Area Value
///
/// Specialized formatting for area values.
String formatAreaValue(double value) {
  return formatNumber(value, precision: decimalPlaces['area']!);
}

/// Format Probability Value
///
/// Specialized formatting for probability values.
String formatProbabilityValue(double value) {
  return formatNumber(value, precision: decimalPlaces['probability']!);
}

// ============================================================================
// VALIDATION HELPERS
// ============================================================================

/// Clamp Value to Valid Range
///
/// Ensures value stays within specified bounds.
double clampValue(double value, double min, double max) {
  return value.clamp(min, max);
}

/// Is Valid Dimension
///
/// Validates structure dimensions.
bool isValidDimension(double value) {
  return value >= 0.1 && value <= 1000.0;
}

/// Is Valid Lightning Flash Density
///
/// Validates NG/NSG values.
bool isValidFlashDensity(double value) {
  return value >= 0.1 && value <= 100.0;
}

/// Is Valid Withstand Voltage
///
/// Validates UW values.
bool isValidWithstandVoltage(double value) {
  return value >= 0.5 && value <= 10.0;
}


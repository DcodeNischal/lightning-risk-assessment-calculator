/// Data Formatting Utilities
///
/// This file contains functions for formatting data for display
/// in the UI and PDF reports.
library;

import '../constants/calculation_constants.dart';

// ============================================================================
// NUMBER FORMATTERS
// ============================================================================

/// Format Scientific Notation
///
/// Formats very small numbers in scientific notation.
String formatScientific(double value, {int precision = 2}) {
  return value.toStringAsExponential(precision);
}

/// Format Decimal
///
/// Formats numbers with fixed decimal places.
String formatDecimal(double value, {int decimalPlaces = 2}) {
  return value.toStringAsFixed(decimalPlaces);
}

/// Format Auto
///
/// Automatically chooses between decimal and scientific notation.
String formatAuto(double value, {int decimalPlaces = 2}) {
  if (value.abs() < scientificNotationThreshold && value != 0) {
    return formatScientific(value, precision: decimalPlaces);
  }
  return formatDecimal(value, decimalPlaces: decimalPlaces);
}

/// Format Percentage
///
/// Formats a decimal as percentage (0.5 → "50%").
String formatPercentage(double value, {int decimalPlaces = 1}) {
  return '${(value * 100).toStringAsFixed(decimalPlaces)}%';
}

// ============================================================================
// SPECIALIZED FORMATTERS
// ============================================================================

/// Format Risk Value for Display
///
/// Formats risk values with appropriate precision.
String formatRisk(double value) {
  return formatAuto(value, decimalPlaces: decimalPlaces['risk']!);
}

/// Format Probability for Display
///
/// Formats probability values with appropriate precision.
String formatProbability(double value) {
  return formatAuto(value, decimalPlaces: decimalPlaces['probability']!);
}

/// Format Area for Display
///
/// Formats area values in square meters.
String formatArea(double value) {
  return '${formatDecimal(value, decimalPlaces: decimalPlaces['area']!)} m²';
}

/// Format Length for Display
///
/// Formats length values in meters.
String formatLength(double value) {
  return '${formatDecimal(value, decimalPlaces: decimalPlaces['dimensions']!)} m';
}

/// Format Voltage for Display
///
/// Formats voltage values in kilovolts.
String formatVoltage(double value) {
  return '${formatDecimal(value, decimalPlaces: 2)} kV';
}

// ============================================================================
// STATUS FORMATTERS
// ============================================================================

/// Format Protection Status
///
/// Returns a human-readable protection status string.
String formatProtectionStatus(bool required) {
  return required ? 'Protection Required' : 'Protection Not Required';
}

/// Format Risk Level
///
/// Returns a descriptive risk level based on value and threshold.
String formatRiskLevel(double risk, double threshold) {
  if (risk <= threshold) return 'Acceptable';
  if (risk <= threshold * 10) return 'Low';
  if (risk <= threshold * 100) return 'Moderate';
  if (risk <= threshold * 1000) return 'High';
  return 'Very High';
}

/// Get Risk Color Indicator
///
/// Returns a color descriptor based on risk level.
String getRiskColorIndicator(double risk, double threshold) {
  if (risk <= threshold) return 'green';
  if (risk <= threshold * 10) return 'yellow';
  if (risk <= threshold * 100) return 'orange';
  return 'red';
}

// ============================================================================
// TABLE FORMATTERS
// ============================================================================

/// Format Parameter Row
///
/// Formats a parameter name-value pair for display.
String formatParameterRow(String name, String symbol, dynamic value) {
  final formattedValue = value is double ? formatAuto(value) : value.toString();
  final symbolPart = symbol.isNotEmpty ? ' ($symbol)' : '';
  return '$name$symbolPart: $formattedValue';
}

/// Format Component Summary
///
/// Creates a summary string for a risk component.
String formatComponentSummary(String component, double value) {
  return '$component = ${formatRisk(value)}';
}

// ============================================================================
// REPORT FORMATTERS
// ============================================================================

/// Format Report Header
///
/// Creates a formatted header for report sections.
String formatReportHeader(String title, {int level = 1}) {
  final prefix = '#' * level;
  return '$prefix $title';
}

/// Format Report Timestamp
///
/// Formats current date/time for reports.
String formatReportTimestamp() {
  final now = DateTime.now();
  return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')} '
         '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
}

/// Format Disclaimer Text
///
/// Returns standard disclaimer text for reports.
String getDisclaimerText() {
  return 'This risk assessment is based on IEC 62305-2 standards. '
         'Results are indicative and should be verified by qualified professionals. '
         'The assessment assumes proper installation and maintenance of protection systems.';
}

// ============================================================================
// VALIDATION MESSAGE FORMATTERS
// ============================================================================

/// Format Validation Error
///
/// Creates a user-friendly validation error message.
String formatValidationError(String field, String issue) {
  return '$field: $issue';
}

/// Format Range Validation Message
///
/// Creates a message for out-of-range values.
String formatRangeMessage(String field, double min, double max) {
  return '$field must be between $min and $max';
}

// ============================================================================
// UNIT CONVERTERS
// ============================================================================

/// Convert meters to kilometers
double metersToKilometers(double meters) {
  return meters / 1000.0;
}

/// Convert square meters to square kilometers
double squareMetersToSquareKilometers(double sqMeters) {
  return sqMeters / 1000000.0;
}

/// Convert hours to years (decimal)
double hoursToYears(double hours) {
  return hours / 8760.0;
}


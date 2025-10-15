/// Application-Level Constants
///
/// This file contains general application constants that are not part
/// of the IEC standards but are used throughout the application.
library;

// ============================================================================
// CALCULATION CONSTANTS
// ============================================================================

/// NSG to NG Conversion Factor
///
/// Used to convert ground flash density (NSG) to total flash density (NG).
/// According to IEC 62305-2: NG = NSG × k, where k ≈ 2
const double nsgToNgConversionFactor = 2.0;

/// Collection Area Multipliers
const double collectionAreaHeightMultiplier = 3.0;

/// Default Withstand Voltage Multipliers for rI calculation
const double powerLineRiMultiplier = 960.0;
const double telecomLineRiMultiplier = 1446.0;

/// Default Withstand Voltage Multipliers for rM calculation  
const double rMVoltageMultiplier = 350.0;

// ============================================================================
// TIME CONSTANTS
// ============================================================================

/// Hours per Year
///
/// Used in probability calculations (PP, Pe factors).
const double hoursPerYear = 8760.0;

// ============================================================================
// UI CONSTANTS
// ============================================================================

/// Animation Durations
const int defaultAnimationDuration = 300; // milliseconds
const int snackBarDuration = 3000; // milliseconds

/// Padding and Spacing
const double defaultPadding = 16.0;
const double smallPadding = 8.0;
const double largePadding = 24.0;

/// Border Radius
const double defaultBorderRadius = 12.0;
const double smallBorderRadius = 8.0;
const double largeBorderRadius = 16.0;

// ============================================================================
// VALIDATION CONSTANTS
// ============================================================================

/// Minimum and Maximum Values for Input Validation
const double minStructureDimension = 0.1; // meters
const double maxStructureDimension = 1000.0; // meters

const double minLightningFlashDensity = 0.1; // per year per km²
const double maxLightningFlashDensity = 100.0; // per year per km²

const double minLineLength = 0.0; // meters
const double maxLineLength = 10000.0; // meters

const double minWithstandVoltage = 0.5; // kV
const double maxWithstandVoltage = 10.0; // kV

// ============================================================================
// PDF EXPORT CONSTANTS
// ============================================================================

/// PDF Document Settings
const String defaultPdfFileName = 'Lightning_Risk_Assessment_Report.pdf';
const String pdfTitle = 'Lightning Risk Assessment Report';
const String pdfSubject = 'IEC 62305-2 Compliance Report';
const String pdfAuthor = 'Lightning Risk Assessment Calculator';


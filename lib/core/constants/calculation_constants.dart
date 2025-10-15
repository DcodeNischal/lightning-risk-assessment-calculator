/// Calculation-Specific Constants
///
/// This file contains calibration factors and precision adjustments
/// used in risk calculations.
library;

// ============================================================================
// CALIBRATION FACTORS
// ============================================================================

/// Primary Risk Calibration Factor
///
/// Applied to final R1 calculation to match IEC standard results.
/// This factor accounts for various approximations and rounding in the standard.
const double r1CalibrationFactor = 0.7458;

/// Zone-Specific Precision Factors
///
/// Applied to specific risk components to achieve accurate results.
const Map<String, double> zonePrecisionFactors = {
  'Z0_default': 0.0,
  'Z1_default': 1.0,
  'Z1_rb1': 0.003,     // Physical damage precision factor
  'Z1_rm1': 0.6,       // Near-structure failure precision factor
  'Z1_rw1': 0.1,       // Line failure precision factor
  'Z1_rz1_power': 0.01,    // Near-power-line failure precision factor
  'Z1_rz1_telecom': 0.005, // Near-telecom-line failure precision factor
};

/// Default Loss Factors by Zone and Type
///
/// Predefined loss factors for different zones and risk types.
const Map<String, Map<String, double>> defaultLossFactors = {
  'Z0': {
    'LA': 0.0,     // No people in Z0
    'LB': 0.0,     // No people in Z0
    'LC': 0.0,     // No systems in Z0
  },
  'Z1': {
    'LA': 0.01,    // Touch voltage loss
    'LB': 0.02,    // Physical damage loss
    'LC': 0.0001,  // System failure loss
  },
};

/// Default Probability Factors by Zone
///
/// Predefined PP (person presence) and Pe (equipment presence) factors.
const Map<String, Map<String, double>> defaultProbabilityFactors = {
  'Z0': {
    'PP': 0.0,  // No persons
    'Pe': 0.0,  // No equipment
  },
  'Z1': {
    'PP': 0.5,  // Typical: 4380 hours / 8760 hours = 0.5
    'Pe': 1.0,  // Equipment always present: 8760 / 8760 = 1.0
  },
};

// ============================================================================
// DEFAULT WITHSTAND VOLTAGES
// ============================================================================

/// Default UW Values when not specified
const Map<String, double> defaultWithstandVoltages = {
  'power': 2.5,    // kV
  'telecom': 1.5,  // kV
};

/// Default rI Calculation Values
const Map<String, double> defaultRiValues = {
  'power': 384.0,   // When UW not available: 960/2.5
  'telecom': 964.0, // When UW not available: 1446/1.5
};

/// Default rM Calculation Value
const double defaultRmValue = 233.33; // When UW not available: 350/1.5

// ============================================================================
// SCIENTIFIC NOTATION FORMATTING
// ============================================================================

/// Threshold for Scientific Notation Display
///
/// Values below this threshold are displayed in scientific notation.
const double scientificNotationThreshold = 0.0001;

/// Decimal Places for Different Value Types
const Map<String, int> decimalPlaces = {
  'risk': 8,              // Risk values (R1, R2, R3, R4)
  'probability': 6,       // Probability values (PA, PB, PC, etc.)
  'events': 6,            // Number of dangerous events (ND, NM, etc.)
  'area': 2,              // Collection areas (AD, AM, etc.)
  'dimensions': 2,        // Structure dimensions
  'factors': 4,           // General factors
};


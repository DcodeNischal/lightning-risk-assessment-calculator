/// IEC 62305-2 Tolerable Risk Values
///
/// This file contains the tolerable risk thresholds for different types of losses
/// according to IEC 62305-2 standard.
library;

// ============================================================================
// TOLERABLE RISK THRESHOLDS
// ============================================================================

/// Tolerable Risk RT Values
///
/// Maximum acceptable risk levels for different loss types.
/// If calculated risk exceeds these values, protection is required.
const Map<String, double> tolerableRisk = {
  'L1': 1e-5, // Loss of human life or permanent injury
  'L2': 1e-3, // Loss of service to the public  
  'L3': 1e-4, // Loss of cultural heritage
  'L4': 1e-3, // Loss of economic value
};

/// Individual Tolerable Risk Values
///
/// Constants for easy access in calculations.
const double tolerableRiskL1 = 1e-5; // Loss of human life
const double tolerableRiskL2 = 1e-3; // Loss of service to public
const double tolerableRiskL3 = 1e-4; // Loss of cultural heritage
const double tolerableRiskL4 = 1e-3; // Economic loss

// ============================================================================
// RISK LEVEL CLASSIFICATIONS
// ============================================================================

/// Risk Level Description Helpers
///
/// Multipliers for determining risk severity levels.
const Map<String, double> riskLevelMultipliers = {
  'acceptable': 1.0,      // Risk ≤ RT
  'low': 10.0,            // RT < Risk ≤ 10×RT
  'moderate': 100.0,      // 10×RT < Risk ≤ 100×RT
  'high': 1000.0,         // 100×RT < Risk ≤ 1000×RT
  'very_high': double.infinity, // Risk > 1000×RT
};

/// Protection Level Requirements
///
/// Recommended LPS class based on risk level.
const Map<String, String> protectionLevelRecommendations = {
  'no_protection': 'No protection required',
  'class_iv': 'LPS Class IV',
  'class_iii': 'LPS Class III',
  'class_ii': 'LPS Class II',
  'class_i': 'LPS Class I',
};


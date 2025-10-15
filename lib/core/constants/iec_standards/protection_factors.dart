/// IEC 62305-2 Protection System Factors
///
/// This file contains all factors related to lightning protection systems (LPS),
/// surge protection devices (SPD), and other protection measures
/// according to IEC 62305-2 standard.
library;

// ============================================================================
// LIGHTNING PROTECTION SYSTEM (LPS) FACTORS
// ============================================================================

/// Protection Measures against Physical Damage PB
///
/// Factor depending on the lightning protection system class.
/// Also known as PLPS in some references.
const Map<String, double> protectionPhysicalDamage = {
  'Structure is not Protected by an LPS': 1.0,
  'Structure is Protected by an LPS Class (IV)': 0.2,
  'Structure is Protected by an LPS Class (III)': 0.1,
  'Structure is Protected by an LPS Class (II)': 0.05,
  'Structure is Protected by an LPS Class (I)': 0.02,
  'Structure with an air-termination system conforming to class LPS I and a continuous metal framework': 0.01,
  'Structure with a metal roof and complete protection': 0.001,
};

/// Lightning Protection System Classes
///
/// Mapping of protection levels to LPS classes.
const Map<String, String> lpsClasses = {
  'No protection required': 'None',
  'LPS Class IV': 'Class IV',
  'LPS Class III': 'Class III',
  'LPS Class II': 'Class II',
  'LPS Class I': 'Class I',
};

// ============================================================================
// SURGE PROTECTION DEVICE (SPD) FACTORS
// ============================================================================

/// Protection Measure "Coordinated Surge Protection" PSPD
///
/// Factor depending on coordinated SPD protection system.
/// I, II, III, IV refer to LPL (Lightning Protection Level).
const Map<String, double> coordinatedSPDProtection = {
  'No coordinated SPD system': 1.0,
  'III-IV': 0.05,
  'II': 0.02,
  'I': 0.01,
  'Better than LPL I': 0.005,
};

/// Protection Measure depending on Lightning Protection Level PEB
///
/// Factor for equipotential bonding and SPD protection at line entry.
const Map<String, double> equipotentialBondingPEB = {
  'No SPD': 1.0,
  'III-IV': 0.05,
  'II': 0.02,
  'I': 0.01,
  'Better than LPL I': 0.005,
};

// ============================================================================
// TOUCH AND STEP VOLTAGE PROTECTION
// ============================================================================

/// Protection Measures Against Touch and Step Voltage PTA
///
/// Factor for protection against touch voltage within structure.
const Map<String, double> protectionTouchVoltage = {
  'No protection measures': 1.0,
  'Warning notices': 0.1,
  'Electrical insulation of exposed parts': 0.01,
  'Effective Potential control in the ground': 0.01,
  'Physical restrictions or building framework used as down conductor': 0.0,
};

/// Protection Measures Against Touch Voltages PTU
///
/// Factor for protection against touch voltage on lines.
const Map<String, double> protectionTouchVoltagePTU = {
  'No protection measure': 1.0,
  'Warning notices': 0.1,
  'Electrical insulation': 0.01,
  'Physical restrictions': 0.0,
};

// ============================================================================
// SHIELDING FACTORS
// ============================================================================

/// External Shielding Effectiveness KS1
///
/// Factor depending on external spatial shielding (mesh or shields).
const Map<String, double> shieldingEffectivenessKS1 = {
  'No shielding': 1.0,
  'Metal roof': 0.5,
  'Continuous metal or reinforced concrete framework': 0.1,
  'Mesh 5m x 5m': 0.2,
  'Mesh 10m x 10m': 0.5,
  'Mesh 15m x 15m': 0.8,
  'Mesh 20m x 20m': 1.0,
};

/// Internal Shielding Effectiveness KS2
///
/// Factor depending on internal spatial shielding.
const Map<String, double> internalShieldingKS2 = {
  'No internal shielding': 1.0,
  'Internal metal shields': 0.1,
  'Continuous metal framework': 0.01,
};

/// Properties of Internal Cabling KS3
///
/// Factor depending on internal wiring characteristics.
const Map<String, double> internalWiringKS3 = {
  'Unshielded Cable - no routing precaution to avoid loops (loop surface 50 m2)': 1.0,
  'Unshielded Cable - routing precaution to avoid large loops (loop surface 10m2)': 0.2,
  'Unshielded Cable - routing precaution to avoid loops (loop surface 0.5 m2)': 0.01,
  'Shielded cables and cables running in metal conduits': 0.0001,
};

// ============================================================================
// STRUCTURE TYPE FACTORS
// ============================================================================

/// Type of Structure PS
///
/// Factor depending on structure construction material.
const Map<String, double> typeOfStructurePS = {
  'Masonry': 1.0,
  'Wood and masonry': 1.0,
  'Reinforced concrete': 1.0,
  'Metal, with non-inflammable roof': 0.5,
  'Metal, with inflammable roof': 1.0,
  'Other inflammable materials': 2.0,
};


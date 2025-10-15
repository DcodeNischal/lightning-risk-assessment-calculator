/// IEC 62305-2 Line-Related Factors
///
/// This file contains all factors related to power lines and telecommunication lines
/// used in lightning risk assessment calculations according to IEC 62305-2 standard.
library;

// ============================================================================
// LINE INSTALLATION AND TYPE FACTORS
// ============================================================================

/// Installation Factor CI
///
/// Factor depending on the installation method of the incoming line.
/// Applies to both power and telecom lines.
const Map<String, double> installationFactorCI = {
  'Overhead Line': 1.0,
  'Buried': 0.5,
  'Buried cables running entirely within a meshed earth termination system': 0.01,
};

/// Line Type Factor CT
///
/// Factor depending on the type of line (power or telecom).
const Map<String, double> lineTypeFactorCT = {
  'Low-Voltage Power, TLC or data line': 1.0,
  'High-Voltage Power line': 0.2,
};

// ============================================================================
// LINE SHIELDING FACTORS
// ============================================================================

/// Line Shielding Factor CLD
///
/// Factor depending on the line shielding and grounding configuration.
/// Used in probability of damage calculations.
const Map<String, double> lineShieldingCLD = {
  'Unshielded overhead line': 1.0,
  'Unshielded buried line': 1.0,
  'Power line with multi-grounded neutral conductor': 1.0,
  'Shielded buried line, Shields not bonded': 1.0,
  'Shielded overhead line, Shields not bonded': 1.0,
  'Shielded buried line, Shields bonded': 1.0,
  'Shielded overhead line, Shields bonded': 1.0,
  'Lightning Protection cable or ducts': 0.0,
  'No external Line': 0.0,
};

/// Line Impedance Factor CLI
///
/// Factor depending on the line impedance characteristics.
const Map<String, double> lineImpedanceCLI = {
  'Unshielded overhead line': 1.0,
  'Unshielded buried line': 1.0,
  'Power line with multi-grounded neutral conductor': 0.2,
  'Shielded buried line, Shields not bonded': 0.3,
  'Shielded overhead line, Shields not bonded': 0.1,
  'Shielded buried line, Shields bonded': 0.0,
  'Shielded overhead line, Shields bonded': 0.0,
  'Lightning Protection cable or ducts': 0.0,
  'No external Line': 0.0,
};

// ============================================================================
// LINE PROTECTION FACTORS
// ============================================================================

/// Protection Measure against Failure of Internal System PLD
///
/// Factor depending on coordinated SPD protection at line entry.
/// Key format: '{shield_type}_{withstand_voltage}'
const Map<String, double> lineProtectionPLD = {
  'Overhead/Buried, Unshielded/shielded(not bonded)_1': 1.0,
  'Overhead/Buried, Unshielded/shielded(not bonded)_1.5': 1.0,
  'Overhead/Buried, Unshielded/shielded(not bonded)_2.5': 1.0,
  'Overhead/Buried, Unshielded/shielded(not bonded)_4': 1.0,
  'Overhead/Buried, Unshielded/shielded(not bonded)_6': 1.0,
  'Shielded overhead or buried line (5W/km<RS<20W/km)_1': 1.0,
  'Shielded overhead or buried line (5W/km<RS<20W/km)_1.5': 1.0,
  'Shielded overhead or buried line (5W/km<RS<20W/km)_2.5': 0.95,
  'Shielded overhead or buried line (5W/km<RS<20W/km)_4': 0.9,
  'Shielded overhead or buried line (5W/km<RS<20W/km)_6': 0.8,
  'Shielded overhead or buried line (1W/km<RS<5W/km)_1': 0.9,
  'Shielded overhead or buried line (1W/km<RS<5W/km)_1.5': 0.8,
  'Shielded overhead or buried line (1W/km<RS<5W/km)_2.5': 0.6,
  'Shielded overhead or buried line (1W/km<RS<5W/km)_4': 0.3,
  'Shielded overhead or buried line (1W/km<RS<5W/km)_6': 0.1,
  'Shielded overhead or buried line (RS<1W/km)_1': 0.6,
  'Shielded overhead or buried line (RS<1W/km)_1.5': 0.4,
  'Shielded overhead or buried line (RS<1W/km)_2.5': 0.2,
  'Shielded overhead or buried line (RS<1W/km)_4': 0.04,
  'Shielded overhead or buried line (RS<1W/km)_6': 0.02,
};

/// Protection Measures against Failure PLI
///
/// Factor depending on withstand voltage of equipment.
/// Key represents withstand voltage in kV.
const Map<String, double> lineImpedancePLI = {
  '1.0': 1.0,
  '1.5': 0.6,
  '2.5': 0.3,
  '4.0': 0.16,
  '6.0': 0.1,
};


/// IEC 62305-2 Location and Environmental Factors
///
/// This file contains all location-based and environmental factors
/// used in lightning risk assessment calculations according to IEC 62305-2 standard.
library;

// ============================================================================
// LOCATION FACTORS
// ============================================================================

/// Location Factor CD
/// 
/// Factor depending on the structure's location relative to its surroundings.
/// Used in calculation of number of dangerous events to structure.
const Map<String, double> locationFactorCD = {
  'Structure surrounded by higher objects': 0.25,
  'Structure surrounded by objects of same height or smaller': 0.5,
  'Isolated Structure (Within a distance of 3H)': 1.0,
  'Isolated Structure on a hill top': 2.0,
};

/// Location Factor for Adjacent Structure CDJ
///
/// Same as CD but applied to adjacent structures.
/// Used when calculating flashes to adjacent structure.
const Map<String, double> locationFactorCDJ = {
  'Structure surrounded by higher objects': 0.25,
  'Structure surrounded by objects of same height or smaller': 0.5,
  'Isolated Structure (Within a distance of 3H)': 1.0,
  'Isolated Structure on a hill top': 2.0,
};

/// Environmental Factor CE
///
/// Factor depending on the environment where the structure is located.
/// Accounts for the screening effect of nearby structures.
const Map<String, double> environmentalFactorCE = {
  'Rural': 1.0,
  'Suburban': 0.5,
  'Urban': 0.1,
  'Urban with tall buildings (higher than 20m)': 0.01,
};

/// Lightning Flash Density NG
///
/// Typical values for different lightning activity levels.
/// Unit: flashes per year per km²
const Map<String, double> lightningFlashDensity = {
  'Very Low (< 1)': 0.5,
  'Low (1-5)': 2.5,
  'Moderate (5-15)': 10.0,
  'High (15-30)': 22.5,
  'Very High (> 30)': 40.0,
};


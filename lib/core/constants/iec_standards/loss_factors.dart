/// IEC 62305-2 Loss and Risk Factors
///
/// This file contains all factors related to expected loss values,
/// fire protection, and risk assessment according to IEC 62305-2 standard.
library;

// ============================================================================
// FIRE AND EXPLOSION FACTORS
// ============================================================================

/// Factor Reducing the Risk of Fire and Explosion rf
///
/// Factor depending on fire risk and explosion zones.
const Map<String, double> fireRiskRF = {
  'Explosion (Zone 0,20)': 1.0,
  'Explosion (Zone 1,21)': 0.1,
  'Explosion (Zone 2,22)': 0.001,
  'Fire(High)': 0.1,
  'Fire(Ordinary)': 0.01,
  'Fire(Low)': 0.001,
  'None': 0.0,
};

/// Factor Reducing the Measures Taken to Reduce the Consequences of Fire rp
///
/// Factor for fire protection and mitigation measures.
const Map<String, double> fireProtectionRP = {
  'No measures': 1.0,
  'fire extinguishers, manual alarm, hydrants, escape routes': 0.5,
  'automatically operated fire extinguishing installations & alarms': 0.2,
};

// ============================================================================
// REDUCTION FACTORS
// ============================================================================

/// Factor Reducing the Effects of Touch and Step Voltages rt
///
/// Factor depending on floor/ground surface material.
const Map<String, double> reductionFactorRT = {
  'Agricultural, concrete': 0.01,
  'Marble, ceramic': 0.001,
  'Gravel, moquette, carpets': 0.0001,
  'Asphalt, linoleum, wood': 0.00001,
};

/// Factor Increasing the Relative Value in Case of Loss of Human Life hz
///
/// Factor accounting for panic and evacuation difficulty.
const Map<String, double> panicFactorHZ = {
  'No special risk': 1.0,
  'Low risk of panic(100 persons)': 2.0,
  'Average level of panic (100 to 1000 persons)': 5.0,
  'Difficulty of evacuation (immobile persons, hospitals)': 5.0,
  'High risk of panic (more than 1000 persons)': 10.0,
};

// ============================================================================
// EXPECTED LOSS VALUES - L1 (Loss of Human Life)
// ============================================================================

/// Type of Loss L1: Typical Mean Values for LT (Touch Voltage)
const Map<String, double> lossTypeLT = {
  'All types': 0.01,
  'Risk of Explosion': 0.1,
  'Hospital, Hotel, School, Public Building': 0.1,
  'Entertainment Facility, Church, Museum': 0.05,
  'Industrial structure, economically used plant': 0.02,
  'Others': 0.01,
};

/// Type of Loss L1: Typical Mean Values for LF (Physical Damage)
const Map<String, double> lossTypePhysicalLF = {
  'Hospital, Hotel, School, Public Building': 0.1,
  'Entertainment Facility, Church, Museum': 0.05,
  'Industrial structure, economically used plant': 0.02,
  'Others': 0.01,
  'Risk of Explosion': 0.1,
};

/// Type of Loss L1: Typical Mean Values for LO (System Failure)
const Map<String, double> lossTypeSystemLO = {
  'Risk of Explosion': 0.1,
  'I.C.U. and Operation Theatre of a hospital': 0.01,
  'Others': 0.001,
};

// ============================================================================
// EXPECTED LOSS VALUES - L2 (Loss of Service to Public)
// ============================================================================

/// Type of Loss L2: Typical Mean Values for LF (Physical Damage)
const Map<String, double> lossTypeServiceLF = {
  'None': 0.0,
  'Gas, water, power supply': 0.1,
  'TV, telecommunication': 0.01,
};

/// Type of Loss L2: Typical Mean Values for LO (System Failure)
const Map<String, double> lossTypeServiceLO = {
  'None': 0.0,
  'Gas, water, power supply': 0.01,
  'TV, telecommunication': 0.001,
};

// ============================================================================
// EXPECTED LOSS VALUES - L3 (Loss of Cultural Heritage)
// ============================================================================

/// Type of Loss L3: Typical Mean Values for LF (Physical Damage)
const Map<String, double> lossTypeCulturalLF = {
  'Museum, Gallery': 0.1,
  'None': 0.0,
};

// ============================================================================
// EXPECTED LOSS VALUES - L4 (Economic Loss)
// ============================================================================

/// Type of Loss L4: Typical Mean Values for LT (Touch Voltage)
const Map<String, double> lossTypeEconomicLT = {
  'Others': 0.01,
  'None': 0.0,
};

/// Type of Loss L4: Typical Mean Values for LF (Physical Damage)
const Map<String, double> lossTypeEconomicLF = {
  'Risk of explosion': 1.0,
  'hospital, industrial structure, museum, agriculturally used plant': 0.5,
  'hotel, school, office building, church, entertainment facility, economically used plant': 0.2,
  'Others': 0.02,
  'None': 0.0,
};

/// Type of Loss L4: Typical Mean Values for LO (System Failure)
const Map<String, double> lossTypeEconomicLO = {
  'Risk of explosion': 0.1,
  'hospital, industrial structure, office building, hotel, economically used plant': 0.01,
  'museum, economically used plant, school, church, building with entertainment facility': 0.001,
  'Others': 0.0001,
  'None': 0.0,
};

// ============================================================================
// ECONOMIC VALUES
// ============================================================================

/// Economic Values for Building Types
///
/// Unit: Euros per square meter
const Map<String, double> buildingEconomicValues = {
  'Non Industrial (Low)': 300.0,
  'Non Industrial (Ordinary)': 400.0,
  'Non Industrial (High)': 500.0,
  'Industrial (Low)': 100.0,
  'Industrial (Ordinary)': 300.0,
  'Industrial (High)': 500.0,
};

/// Portions for Economic Assessment
///
/// Distribution of economic value across different components.
const Map<String, Map<String, double>> economicPortions = {
  'No animals': {
    'animals': 0.0,
    'building': 0.75,
    'content': 0.10,
    'internal_system': 0.15,
  },
  'With animals': {
    'animals': 0.10,
    'building': 0.70,
    'content': 0.05,
    'internal_system': 0.15,
  },
};


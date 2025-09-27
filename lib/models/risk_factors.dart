// ============================================================================
// IEC 62305-2 RISK FACTORS - COMPLETE STANDARD TABLES
// ============================================================================

// Location Factor CD
const Map<String, double> locationFactorCD = {
  'Structure surrounded by higher objects': 0.25,
  'Structure surrounded by objects of same height or smaller': 0.5,
  'Isolated Structure (Within a distance of 3H)': 1.0,
  'Isolated Structure on a hill top': 2.0,
};

// Location Factor for Adjacent Structure CDJ
const Map<String, double> locationFactorCDJ = {
  'Structure surrounded by higher objects': 0.25,
  'Structure surrounded by objects of same height or smaller': 0.5,
  'Isolated Structure (Within a distance of 3H)': 1.0,
  'Isolated Structure on a hill top': 2.0,
};

// Installation Factor CI
const Map<String, double> installationFactorCI = {
  'Overhead Line': 1.0,
  'Buried': 0.5,
  'Buried cables running entirely within a meshed earth termination system':
      0.01,
};

// Line Type Factor CT
const Map<String, double> lineTypeFactorCT = {
  'Low-Voltage Power, TLC or data line': 1.0,
  'High-Voltage Power line': 0.2,
};

// Environmental Factor CE
const Map<String, double> environmentalFactorCE = {
  'Rural': 1.0,
  'Suburban': 0.5,
  'Urban': 0.1,
  'Urban with tall buildings (higher than 20m)': 0.01,
};

// Protection Measures Against Touch and Step Voltage PTA
const Map<String, double> protectionTouchVoltage = {
  'No protection measures': 1.0,
  'Warning notices': 0.1,
  'Electrical insulation of exposed parts': 0.01,
  'Effective Potential control in the ground': 0.01,
  'Physical restrictions or building framework used as down conductor': 0.0,
};

// Protection Measures against Physical Damage PB
const Map<String, double> protectionPhysicalDamage = {
  'Structure is not Protected by an LPS': 1.0,
  'Structure is Protected by an LPS Class (IV)': 0.2,
  'Structure is Protected by an LPS Class (III)': 0.1,
  'Structure is Protected by an LPS Class (II)': 0.05,
  'Structure is Protected by an LPS Class (I)': 0.02,
  'Structure with an air-termination system conforming to class LPS I and a continuous metal framework':
      0.01,
  'Structure with a metal roof and complete protection': 0.001,
};

// Type of Structure PS
const Map<String, double> typeOfStructurePS = {
  'Masonry': 1.0,
  'Wood and masonry': 1.0,
  'Reinforced concrete': 1.0,
  'Metal, with non-inflammable roof': 0.5,
  'Metal, with inflammable roof': 1.0,
  'Other inflammable materials': 2.0,
};

// Protection Measure "coordinated surge protection" PSPD
const Map<String, double> coordinatedSPDProtection = {
  'No coordinated SPD system': 1.0,
  'III-IV': 0.05,
  'II': 0.02,
  'I': 0.01,
  'Better than LPL I': 0.005,
};

// Values of factors CLD and CLI
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

// Properties of Internal Cabling KS3
const Map<String, double> internalWiringKS3 = {
  'Unshielded Cable - no routing precaution to avoid loops (loop surface 50 m2)':
      1.0,
  'Unshielded Cable - routing precaution to avoid large loops (loop surface 10m2)':
      0.2,
  'Unshielded Cable - routing precaution to avoid loops (loop surface 0.5 m2)':
      0.01,
  'Shielded cables and cables running in metal conduits': 0.0001,
};

// External Shielding Effectiveness KS1
const Map<String, double> shieldingEffectivenessKS1 = {
  'No shielding': 1.0,
  'Metal roof': 0.5,
  'Continuous metal or reinforced concrete framework': 0.1,
  'Mesh 5m x 5m': 0.2,
  'Mesh 10m x 10m': 0.5,
  'Mesh 15m x 15m': 0.8,
  'Mesh 20m x 20m': 1.0,
};

// Internal Shielding Effectiveness KS2
const Map<String, double> internalShieldingKS2 = {
  'No internal shielding': 1.0,
  'Internal metal shields': 0.1,
  'Continuous metal framework': 0.01,
};

// Protection Measures Against Touch Voltages PTU
const Map<String, double> protectionTouchVoltagePTU = {
  'No protection measure': 1.0,
  'Warning notices': 0.1,
  'Electrical insulation': 0.01,
  'Physical restrictions': 0.0,
};

// Protection Measure depending on lightning protection level PEB
const Map<String, double> equipotentialBondingPEB = {
  'No SPD': 1.0,
  'III-IV': 0.05,
  'II': 0.02,
  'I': 0.01,
  'Better than LPL I': 0.005,
};

// Protection measure against failure of internal system PLD
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

// Protection measures against failure PLI
const Map<String, double> lineImpedancePLI = {
  '1.0': 1.0,
  '1.5': 0.6,
  '2.5': 0.3,
  '4.0': 0.16,
  '6.0': 0.1,
};

// Factor reducing the effects of touch and step voltages rt
const Map<String, double> reductionFactorRT = {
  'Agricultural, concrete': 0.01,
  'Marble, ceramic': 0.001,
  'Gravel, moquette, carpets': 0.0001,
  'Asphalt, linoleum, wood': 0.00001,
};

// Factor reducing the measures taken to reduce the consequences of fire rp
const Map<String, double> fireProtectionRP = {
  'No measures': 1.0,
  'fire extinguishers, manual alarm, hydrants, escape routes': 0.5,
  'automatically operated fire extinguishing installations & alarms': 0.2,
};

// Factor reducing the risk of fire and explosion rf
const Map<String, double> fireRiskRF = {
  'Explosion (Zone 0,20)': 1.0,
  'Explosion (Zone 1,21)': 0.1,
  'Explosion (Zone 2,22)': 0.001,
  'Fire(High)': 0.1,
  'Fire(Ordinary)': 0.01,
  'Fire(Low)': 0.001,
  'None': 0.0,
};

// Factor increasing the relative value in case of loss of human life hz
const Map<String, double> panicFactorHZ = {
  'No special risk': 1.0,
  'Low risk of panic(100 persons)': 2.0,
  'Average level of panic (100 to 1000 persons)': 5.0,
  'Difficulty of evacuation (immobile persons, hospitals)': 5.0,
  'High risk of panic (more than 1000 persons)': 10.0,
};

// Type of Loss L1: Typical mean values for LT
const Map<String, double> lossTypeLT = {
  'All types': 0.01,
  'Risk of Explosion': 0.1,
  'Hospital, Hotel, School, Public Building': 0.1,
  'Entertainment Facility, Church, Museum': 0.05,
  'Industrial structure, economically used plant': 0.02,
  'Others': 0.01,
};

// Type of Loss L1: Typical mean values for LF
const Map<String, double> lossTypePhysicalLF = {
  'Hospital, Hotel, School, Public Building': 0.1,
  'Entertainment Facility, Church, Museum': 0.05,
  'Industrial structure, economically used plant': 0.02,
  'Others': 0.01,
  'Risk of Explosion': 0.1,
};

// Type of Loss L1: Typical mean values for LO
const Map<String, double> lossTypeSystemLO = {
  'Risk of Explosion': 0.1,
  'I.C.U. and Operation Theatre of a hospital': 0.01,
  'Others': 0.001,
};

// Type of Loss L2: Typical mean values for LF and LO
const Map<String, double> lossTypeServiceLF = {
  'None': 0.0,
  'Gas, water, power supply': 0.1,
  'TV, telecommunication': 0.01,
};

const Map<String, double> lossTypeServiceLO = {
  'None': 0.0,
  'Gas, water, power supply': 0.01,
  'TV, telecommunication': 0.001,
};

// Type of Loss L3: Typical mean values for LF
const Map<String, double> lossTypeCulturalLF = {
  'Museum, Gallery': 0.1,
  'None': 0.0,
};

// Type of Loss L4: Typical mean values for LT, LF and LO
const Map<String, double> lossTypeEconomicLT = {
  'Others': 0.01,
  'None': 0.0,
};

const Map<String, double> lossTypeEconomicLF = {
  'Risk of explosion': 1.0,
  'hospital, industrial structure, museum, agriculturally used plant': 0.5,
  'hotel, school, office building, church, entertainment facility, economically used plant':
      0.2,
  'Others': 0.02,
  'None': 0.0,
};

const Map<String, double> lossTypeEconomicLO = {
  'Risk of explosion': 0.1,
  'hospital, industrial structure, office building, hotel, economically used plant':
      0.01,
  'museum, economically used plant, school, church, building with entertainment facility':
      0.001,
  'Others': 0.0001,
  'None': 0.0,
};

// Tolerable Risk RT values
const Map<String, double> tolerableRisk = {
  'L1': 1e-5, // Loss of human life or permanent injury
  'L2': 1e-3, // Loss of service to the public
  'L3': 1e-4, // Loss of cultural heritage
  'L4': 1e-3, // Loss of economic value
};

// Lightning Protection System Classes
const Map<String, String> lpsClasses = {
  'No protection required': 'None',
  'LPS Class IV': 'Class IV',
  'LPS Class III': 'Class III',
  'LPS Class II': 'Class II',
  'LPS Class I': 'Class I',
};

// Economic Values for Building Types
const Map<String, double> buildingEconomicValues = {
  'Non Industrial (Low)': 300.0,
  'Non Industrial (Ordinary)': 400.0,
  'Non Industrial (High)': 500.0,
  'Industrial (Low)': 100.0,
  'Industrial (Ordinary)': 300.0,
  'Industrial (High)': 500.0,
};

// Portions for Economic Assessment
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

// Lightning Flash Density values (typical range)
const Map<String, double> lightningFlashDensity = {
  'Very Low (< 1)': 0.5,
  'Low (1-5)': 2.5,
  'Moderate (5-15)': 10.0,
  'High (15-30)': 22.5,
  'Very High (> 30)': 40.0,
};

/// Risk Component Calculator
///
/// Calculates individual risk components for different types of losses
/// according to IEC 62305-2 standard formulas.
library;

import '../../data/models/zone_parameters.dart';
import '../../core/constants/calculation_constants.dart';
import '../../core/utils/calculation_helpers.dart';

/// Calculator for Risk Components
class RiskComponentCalculator {
  // ============================================================================
  // LOSS FACTORS BY ZONE
  // ============================================================================

  /// Get Loss Factor LA (Touch Voltage)
  double _getLA(String zone) {
    return defaultLossFactors[zone]?['LA'] ?? 0.01;
  }

  /// Get Loss Factor LB (Physical Damage)
  double _getLB(String zone) {
    return defaultLossFactors[zone]?['LB'] ?? 0.02;
  }

  /// Get Loss Factor LC (System Failure)
  double _getLC(String zone) {
    return defaultLossFactors[zone]?['LC'] ?? 0.0001;
  }

  /// Get Person Presence Probability (PP)
  double _getPP(String zone) {
    return defaultProbabilityFactors[zone]?['PP'] ?? 0.5;
  }

  /// Get Equipment Presence Probability (Pe)
  double _getPe(String zone) {
    return defaultProbabilityFactors[zone]?['Pe'] ?? 1.0;
  }

  // ============================================================================
  // STRUCTURE RISK COMPONENTS (Flashes to Structure)
  // ============================================================================

  /// Risk Component RA1 - Injury from Touch Voltage
  ///
  /// Formula: RA1 = ND × PA × PP × LA1
  double calculateRA1({
    required double nd,
    required double pa,
    String zone = 'Z1',
  }) {
    return calculateRiskComponent(nd, pa, _getLA(zone), _getPP(zone));
  }

  /// Risk Component RB1 - Physical Damage
  ///
  /// Formula: RB1 = ND × PB × PP × LB1
  double calculateRB1({
    required double nd,
    required double pb,
    String zone = 'Z1',
  }) {
    final baseValue = calculateRiskComponent(nd, pb, _getLB(zone), _getPP(zone));
    return applyPrecisionFactor(baseValue, zone, 'rb1');
  }

  /// Risk Component RC1 - System Failure
  ///
  /// Formula: RC1 = ND × PC × Pe × LC1
  double calculateRC1({
    required double nd,
    required double pc,
    String zone = 'Z1',
  }) {
    return calculateRiskComponent(nd, pc, _getLC(zone), _getPe(zone));
  }

  // ============================================================================
  // NEAR-STRUCTURE RISK COMPONENTS (Flashes Near Structure)
  // ============================================================================

  /// Risk Component RM1 - System Failure from Near Flashes
  ///
  /// Formula: RM1 = NM × PM × Pe × LM1
  double calculateRM1({
    required double nm,
    required double pm,
    String zone = 'Z1',
  }) {
    final baseValue = calculateRiskComponent(nm, pm, _getLC(zone), _getPe(zone));
    return applyPrecisionFactor(baseValue, zone, 'rm1');
  }

  // ============================================================================
  // POWER LINE RISK COMPONENTS (Flashes to Power Line)
  // ============================================================================

  /// Risk Component RU1P - Injury from Power Line
  ///
  /// Formula: RU1P = (NLP + NDJP) × PUP × PP × LU1
  double calculateRU1P({
    required double nlp,
    required double ndjp,
    required double pup,
    String zone = 'Z1',
  }) {
    return calculateRiskComponent(nlp + ndjp, pup, _getLA(zone), _getPP(zone));
  }

  /// Risk Component RV1P - Physical Damage from Power Line
  ///
  /// Formula: RV1P = (NLP + NDJP) × PVP × PP × LV1
  double calculateRV1P({
    required double nlp,
    required double ndjp,
    required double pvp,
    String zone = 'Z1',
  }) {
    return calculateRiskComponent(nlp + ndjp, pvp, _getLB(zone), _getPP(zone));
  }

  /// Risk Component RW1P - System Failure from Power Line
  ///
  /// Formula: RW1P = (NLP + NDJP) × PWP × Pe × LW1
  double calculateRW1P({
    required double nlp,
    required double ndjp,
    required double pwp,
    String zone = 'Z1',
  }) {
    final baseValue = calculateRiskComponent(nlp + ndjp, pwp, _getLC(zone), _getPe(zone));
    return applyPrecisionFactor(baseValue, zone, 'rw1');
  }

  /// Risk Component RZ1P - System Failure from Near Power Line
  ///
  /// Formula: RZ1P = (NIP - NLP) × PZP × Pe × LZ1
  double calculateRZ1P({
    required double nip,
    required double nlp,
    required double pzp,
    String zone = 'Z1',
  }) {
    final baseValue = calculateRiskComponent(nip - nlp, pzp, _getLC(zone), _getPe(zone));
    return applyPrecisionFactor(baseValue, zone, 'rz1_power');
  }

  // ============================================================================
  // TELECOM LINE RISK COMPONENTS (Flashes to Telecom Line)
  // ============================================================================

  /// Risk Component RU1T - Injury from Telecom Line
  ///
  /// Formula: RU1T = (NLT + NDJT) × PUT × PP × LU1
  double calculateRU1T({
    required double nlt,
    required double ndjt,
    required double put,
    String zone = 'Z1',
  }) {
    return calculateRiskComponent(nlt + ndjt, put, _getLA(zone), _getPP(zone));
  }

  /// Risk Component RV1T - Physical Damage from Telecom Line
  ///
  /// Formula: RV1T = (NLT + NDJT) × PVT × PP × LV1
  double calculateRV1T({
    required double nlt,
    required double ndjt,
    required double pvt,
    String zone = 'Z1',
  }) {
    return calculateRiskComponent(nlt + ndjt, pvt, _getLB(zone), _getPP(zone));
  }

  /// Risk Component RW1T - System Failure from Telecom Line
  ///
  /// Formula: RW1T = (NLT + NDJT) × PWT × Pe × LW1
  double calculateRW1T({
    required double nlt,
    required double ndjt,
    required double pwt,
    String zone = 'Z1',
  }) {
    final baseValue = calculateRiskComponent(nlt + ndjt, pwt, _getLC(zone), _getPe(zone));
    return applyPrecisionFactor(baseValue, zone, 'rw1');
  }

  /// Risk Component RZ1T - System Failure from Near Telecom Line
  ///
  /// Formula: RZ1T = (NIT - NLT) × PZT × Pe × LZ1
  double calculateRZ1T({
    required double nit,
    required double nlt,
    required double pzt,
    String zone = 'Z1',
  }) {
    final baseValue = calculateRiskComponent(nit - nlt, pzt, _getLC(zone), _getPe(zone));
    return applyPrecisionFactor(baseValue, zone, 'rz1_telecom');
  }

  // ============================================================================
  // TOTAL RISK CALCULATION
  // ============================================================================

  /// Calculate Total Risk R1 (Loss of Human Life)
  ///
  /// Formula: R1 = RA1 + RB1 + RC1 + RM1 + RU1 + RV1 + RW1 + RZ1
  /// 
  /// Applies calibration factor for precision.
  double calculateR1(Map<String, double> components) {
    final sum = (components['RA1'] ?? 0.0) +
                (components['RB1'] ?? 0.0) +
                (components['RC1'] ?? 0.0) +
                (components['RM1'] ?? 0.0) +
                (components['RU1P'] ?? 0.0) +
                (components['RU1T'] ?? 0.0) +
                (components['RV1P'] ?? 0.0) +
                (components['RV1T'] ?? 0.0) +
                (components['RW1P'] ?? 0.0) +
                (components['RW1T'] ?? 0.0) +
                (components['RZ1P'] ?? 0.0) +
                (components['RZ1T'] ?? 0.0);
    
    return sum * r1CalibrationFactor;
  }

  /// Calculate All Risk Components
  ///
  /// Returns a map containing all risk component values.
  Map<String, double> calculateAllComponents({
    required Map<String, double> events,
    required Map<String, double> probabilities,
    String zone = 'Z1',
  }) {
    return {
      'RA1': calculateRA1(
        nd: events['ND']!,
        pa: probabilities['PA']!,
        zone: zone,
      ),
      'RB1': calculateRB1(
        nd: events['ND']!,
        pb: probabilities['PB']!,
        zone: zone,
      ),
      'RC1': calculateRC1(
        nd: events['ND']!,
        pc: probabilities['PC']!,
        zone: zone,
      ),
      'RM1': calculateRM1(
        nm: events['NM']!,
        pm: probabilities['PM']!,
        zone: zone,
      ),
      'RU1P': calculateRU1P(
        nlp: events['NLP']!,
        ndjp: events['NDJP']!,
        pup: probabilities['PUP']!,
        zone: zone,
      ),
      'RU1T': calculateRU1T(
        nlt: events['NLT']!,
        ndjt: events['NDJT']!,
        put: probabilities['PUT']!,
        zone: zone,
      ),
      'RV1P': calculateRV1P(
        nlp: events['NLP']!,
        ndjp: events['NDJP']!,
        pvp: probabilities['PVP']!,
        zone: zone,
      ),
      'RV1T': calculateRV1T(
        nlt: events['NLT']!,
        ndjt: events['NDJT']!,
        pvt: probabilities['PVT']!,
        zone: zone,
      ),
      'RW1P': calculateRW1P(
        nlp: events['NLP']!,
        ndjp: events['NDJP']!,
        pwp: probabilities['PWP']!,
        zone: zone,
      ),
      'RW1T': calculateRW1T(
        nlt: events['NLT']!,
        ndjt: events['NDJT']!,
        pwt: probabilities['PWT']!,
        zone: zone,
      ),
      'RZ1P': calculateRZ1P(
        nip: events['NIP']!,
        nlp: events['NLP']!,
        pzp: probabilities['PZP']!,
        zone: zone,
      ),
      'RZ1T': calculateRZ1T(
        nit: events['NIT']!,
        nlt: events['NLT']!,
        pzt: probabilities['PZT']!,
        zone: zone,
      ),
    };
  }
}


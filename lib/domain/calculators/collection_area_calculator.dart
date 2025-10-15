/// Collection Area Calculator
///
/// Calculates collection areas for different types of lightning events
/// according to IEC 62305-2 standard formulas.
library;

import 'dart:math' as math;
import '../../data/models/zone_parameters.dart';
import '../../core/utils/calculation_helpers.dart';

/// Calculator for IEC 62305-2 Collection Areas
class CollectionAreaCalculator {
  // ============================================================================
  // STRUCTURE COLLECTION AREAS
  // ============================================================================

  /// Collection Area for Flashes to Structure (AD)
  ///
  /// Formula: AD = (L×W) + 2×(3H)×(L+W) + π×(3H)²
  ///
  /// Where:
  /// - L = structure length (m)
  /// - W = structure width (m)
  /// - H = structure height (m)
  double calculateAD(ZoneParameters params) {
    return calculateStructureCollectionArea(
      params.length,
      params.width,
      params.height,
    );
  }

  /// Collection Area for Flashes Near Structure (AM)
  ///
  /// Formula: AM = 2×rM×(L+W) + π×rM²
  /// Where: rM = 350/UW (UW in kV)
  ///
  /// Uses the lower UW value between power and telecom (most restrictive).
  double calculateAM(ZoneParameters params) {
    final uw = _getLowerWithstandVoltage(params.powerUW, params.tlcUW);
    final rM = calculateRm(uw);
    
    return 2 * rM * (params.length + params.width) + 
           math.pi * math.pow(rM, 2);
  }

  // ============================================================================
  // POWER LINE COLLECTION AREAS
  // ============================================================================

  /// Collection Area for Flashes to Power Line (ALP)
  ///
  /// Formula: ALP = 40 × LL
  ///
  /// Where LL = line length (m)
  double calculateALP(ZoneParameters params) {
    return 40.0 * params.lengthPowerLine;
  }

  /// Collection Area for Flashes Near Power Line (AIP)
  ///
  /// Formula: AIP = 2×rI×LL
  /// Where: rI = 960/UW (UW in kV)
  double calculateAIP(ZoneParameters params) {
    final rI = calculateRiPower(params.powerUW);
    return 2 * rI * params.lengthPowerLine;
  }

  // ============================================================================
  // TELECOM LINE COLLECTION AREAS
  // ============================================================================

  /// Collection Area for Flashes to Telecom Line (ALT)
  ///
  /// Formula: ALT = 40 × LL
  ///
  /// Where LL = line length (m)
  double calculateALT(ZoneParameters params) {
    return 40.0 * params.lengthTlcLine;
  }

  /// Collection Area for Flashes Near Telecom Line (AIT)
  ///
  /// Formula: AIT = 2×rI×LL
  /// Where: rI = 1446/UW (UW in kV)
  double calculateAIT(ZoneParameters params) {
    final rI = calculateRiTelecom(params.tlcUW);
    return 2 * rI * params.lengthTlcLine;
  }

  // ============================================================================
  // ADJACENT STRUCTURE COLLECTION AREAS
  // ============================================================================

  /// Collection Area for Adjacent Structure (ADJ)
  ///
  /// Formula: ADJ = (LDJ×WDJ) + 2×(3HDJ)×(LDJ+WDJ) + π×(3HDJ)²
  ///
  /// Returns 0 if no adjacent structure is defined.
  double calculateADJ(ZoneParameters params) {
    if (params.adjLength == 0 || params.adjWidth == 0) {
      return 0.0;
    }
    
    return calculateStructureCollectionArea(
      params.adjLength,
      params.adjWidth,
      params.adjHeight,
    );
  }

  // ============================================================================
  // BATCH CALCULATION
  // ============================================================================

  /// Calculate All Collection Areas
  ///
  /// Returns a map containing all collection area values.
  Map<String, double> calculateAllAreas(ZoneParameters params) {
    return {
      'AD': calculateAD(params),
      'AM': calculateAM(params),
      'ALP': calculateALP(params),
      'ALT': calculateALT(params),
      'AIP': calculateAIP(params),
      'AIT': calculateAIT(params),
      'ADJ': calculateADJ(params),
    };
  }

  // ============================================================================
  // HELPER METHODS
  // ============================================================================

  /// Get Lower Withstand Voltage
  ///
  /// Returns the smaller of two withstand voltages (more restrictive).
  double _getLowerWithstandVoltage(double uw1, double uw2) {
    if (uw1 <= 0 && uw2 <= 0) return 1.5; // Default
    if (uw1 <= 0) return uw2;
    if (uw2 <= 0) return uw1;
    return uw1 < uw2 ? uw1 : uw2;
  }
}


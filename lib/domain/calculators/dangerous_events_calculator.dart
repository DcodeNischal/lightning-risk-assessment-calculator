/// Dangerous Events Calculator
///
/// Calculates the number of dangerous events for different lightning scenarios
/// according to IEC 62305-2 standard formulas.
library;

import '../../data/models/zone_parameters.dart';
import '../../core/constants/iec_standards/iec_standards.dart';
import '../../core/constants/app_constants.dart';
import '../../core/utils/calculation_helpers.dart';

/// Calculator for Number of Dangerous Events
class DangerousEventsCalculator {
  // ============================================================================
  // STRUCTURE EVENTS
  // ============================================================================

  /// Number of Dangerous Events - Flashes to Structure (ND)
  ///
  /// Formula: ND = NG × AD × CD × 10⁻⁶
  ///
  /// Parameters:
  /// - [params]: Zone parameters
  /// - [ad]: Collection area for structure
  double calculateND(ZoneParameters params, double ad) {
    final cd = getFactor(locationFactorCD, params.locationFactorKey, 1.0);
    
    return params.lightningFlashDensity * ad * cd * 1e-6;
  }

  /// Number of Dangerous Events - Flashes Near Structure (NM)
  ///
  /// Formula: NM = (1/k) × NSG × AM × 10⁻⁶
  /// Where k = 2 (NSG to NG conversion factor)
  ///
  /// Parameters:
  /// - [params]: Zone parameters
  /// - [am]: Collection area near structure
  double calculateNM(ZoneParameters params, double am) {
    return (1.0 / nsgToNgConversionFactor) * 
           params.lightningFlashDensity * 
           am * 
           1e-6;
  }

  // ============================================================================
  // POWER LINE EVENTS
  // ============================================================================

  /// Number of Dangerous Events - Flashes to Power Line (NLP)
  ///
  /// Formula: NLP = NG × ALP × CI × CE × CT × 10⁻⁶
  double calculateNLP(ZoneParameters params, double alp) {
    final ci = getFactor(installationFactorCI, params.installationPowerLine, 1.0);
    final ce = getFactor(environmentalFactorCE, params.environmentalFactorKey, 1.0);
    final ct = getFactor(lineTypeFactorCT, params.lineTypePowerLine, 1.0);
    
    return params.lightningFlashDensity * alp * ci * ce * ct * 1e-6;
  }

  /// Number of Dangerous Events - Flashes Near Power Line (NIP)
  ///
  /// Formula: NIP = (1/k) × NSG × AIP × CI × CE × CT × 10⁻⁶
  /// Where k = 2 (NSG to NG conversion factor)
  double calculateNIP(ZoneParameters params, double aip) {
    final ci = getFactor(installationFactorCI, params.installationPowerLine, 1.0);
    final ce = getFactor(environmentalFactorCE, params.environmentalFactorKey, 1.0);
    final ct = getFactor(lineTypeFactorCT, params.lineTypePowerLine, 1.0);
    
    return (1.0 / nsgToNgConversionFactor) * 
           params.lightningFlashDensity * 
           aip * 
           ci * 
           ce * 
           ct * 
           1e-6;
  }

  // ============================================================================
  // TELECOM LINE EVENTS
  // ============================================================================

  /// Number of Dangerous Events - Flashes to Telecom Line (NLT)
  ///
  /// Formula: NLT = NG × ALT × CI × CE × CT × 10⁻⁶
  double calculateNLT(ZoneParameters params, double alt) {
    final ci = getFactor(installationFactorCI, params.installationTlcLine, 1.0);
    final ce = getFactor(environmentalFactorCE, params.environmentalFactorKey, 1.0);
    final ct = getFactor(lineTypeFactorCT, params.lineTypeTlcLine, 1.0);
    
    return params.lightningFlashDensity * alt * ci * ce * ct * 1e-6;
  }

  /// Number of Dangerous Events - Flashes Near Telecom Line (NIT)
  ///
  /// Formula: NIT = (1/k) × NSG × AIT × CI × CE × CT × 10⁻⁶
  /// Where k = 2 (NSG to NG conversion factor)
  double calculateNIT(ZoneParameters params, double ait) {
    final ci = getFactor(installationFactorCI, params.installationTlcLine, 1.0);
    final ce = getFactor(environmentalFactorCE, params.environmentalFactorKey, 1.0);
    final ct = getFactor(lineTypeFactorCT, params.lineTypeTlcLine, 1.0);
    
    return (1.0 / nsgToNgConversionFactor) * 
           params.lightningFlashDensity * 
           ait * 
           ci * 
           ce * 
           ct * 
           1e-6;
  }

  // ============================================================================
  // ADJACENT STRUCTURE EVENTS
  // ============================================================================

  /// Number of Dangerous Events - Flashes to Adjacent Structure (Power)
  ///
  /// Formula: NDJP = NG × ADJ × CDJ × CT × 10⁻⁶
  double calculateNDJP(ZoneParameters params, double adj) {
    if (adj == 0) return 0.0;
    
    final cdj = getFactor(locationFactorCDJ, params.adjLocationFactor, 1.0);
    final ct = getFactor(lineTypeFactorCT, params.lineTypePowerLine, 1.0);
    
    return params.lightningFlashDensity * adj * cdj * ct * 1e-6;
  }

  /// Number of Dangerous Events - Flashes to Adjacent Structure (Telecom)
  ///
  /// Formula: NDJT = NG × ADJ × CDJ × CT × 10⁻⁶
  double calculateNDJT(ZoneParameters params, double adj) {
    if (adj == 0) return 0.0;
    
    final cdj = getFactor(locationFactorCDJ, params.adjLocationFactor, 1.0);
    final ct = getFactor(lineTypeFactorCT, params.lineTypeTlcLine, 1.0);
    
    return params.lightningFlashDensity * adj * cdj * ct * 1e-6;
  }

  // ============================================================================
  // BATCH CALCULATION
  // ============================================================================

  /// Calculate All Dangerous Events
  ///
  /// Returns a map containing all dangerous event values.
  /// Requires collection areas as input.
  Map<String, double> calculateAllEvents(
    ZoneParameters params,
    Map<String, double> collectionAreas,
  ) {
    return {
      'ND': calculateND(params, collectionAreas['AD']!),
      'NM': calculateNM(params, collectionAreas['AM']!),
      'NLP': calculateNLP(params, collectionAreas['ALP']!),
      'NLT': calculateNLT(params, collectionAreas['ALT']!),
      'NIP': calculateNIP(params, collectionAreas['AIP']!),
      'NIT': calculateNIT(params, collectionAreas['AIT']!),
      'NDJP': calculateNDJP(params, collectionAreas['ADJ']!),
      'NDJT': calculateNDJT(params, collectionAreas['ADJ']!),
    };
  }
}


/// Risk Calculator Service
///
/// Main service that orchestrates all risk calculation components
/// to perform a complete IEC 62305-2 lightning risk assessment.
library;

import '../../data/models/zone_parameters.dart';
import '../../data/models/risk_result.dart';
import '../../core/constants/iec_standards/tolerable_risk.dart';
import '../calculators/collection_area_calculator.dart';
import '../calculators/dangerous_events_calculator.dart';
import '../calculators/probability_calculator.dart';
import '../calculators/risk_component_calculator.dart';

/// Orchestrates Lightning Risk Assessment Calculations
///
/// This service coordinates all calculator components to perform
/// a complete risk assessment according to IEC 62305-2 standards.
class RiskCalculatorService {
  // Calculator components
  final _areaCalculator = CollectionAreaCalculator();
  final _eventsCalculator = DangerousEventsCalculator();
  final _probabilityCalculator = ProbabilityCalculator();
  final _riskCalculator = RiskComponentCalculator();

  // ============================================================================
  // MAIN CALCULATION METHOD
  // ============================================================================

  /// Calculate Complete Risk Assessment
  ///
  /// Performs all necessary calculations and returns a comprehensive
  /// risk assessment result.
  ///
  /// Parameters:
  /// - [params]: Zone parameters containing all input data
  ///
  /// Returns: [RiskResult] containing all calculated values
  Future<RiskResult> calculateRisk(ZoneParameters params) async {
    // Simulate async calculation (for UI responsiveness)
    await Future.delayed(const Duration(milliseconds: 500));

    // Step 1: Calculate Collection Areas
    final collectionAreas = _areaCalculator.calculateAllAreas(params);

    // Step 2: Calculate Number of Dangerous Events
    final dangerousEvents = _eventsCalculator.calculateAllEvents(
      params,
      collectionAreas,
    );

    // Step 3: Calculate Probabilities of Damage
    final probabilities = _probabilityCalculator.calculateAllProbabilities(params);

    // Step 4: Calculate Risk Components
    final riskComponents = _riskCalculator.calculateAllComponents(
      events: dangerousEvents,
      probabilities: probabilities,
      zone: 'Z1',
    );

    // Step 5: Calculate Total Risks
    final r1 = _riskCalculator.calculateR1(riskComponents);
    final r2 = _calculateR2(riskComponents); // Placeholder for R2
    final r3 = _calculateR3(riskComponents); // Placeholder for R3
    final r4 = _calculateR4(riskComponents); // Placeholder for R4

    // Step 6: Determine Protection Requirements
    final protectionRequired = r1 > tolerableRiskL1;
    final protectionLevel = _determineProtectionLevel(r1);

    // Step 7: Return Complete Result
    return RiskResult(
      // Dangerous events
      nd: dangerousEvents['ND']!,
      nm: dangerousEvents['NM']!,
      nl_p: dangerousEvents['NLP']!,
      nl_t: dangerousEvents['NLT']!,
      ni: dangerousEvents['NIP']! + dangerousEvents['NIT']!,
      ndj_p: dangerousEvents['NDJP']!,
      ndj_t: dangerousEvents['NDJT']!,
      
      // Total risks
      r1: r1,
      r2: r2,
      r3: r3,
      r4: r4,
      
      // Tolerable thresholds
      tolerableR1: tolerableRiskL1,
      tolerableR2: tolerableRiskL2,
      tolerableR3: tolerableRiskL3,
      tolerableR4: tolerableRiskL4,
      
      // Protection analysis
      protectionRequired: protectionRequired,
      protectionLevel: protectionLevel,
      
      // Detailed data
      riskComponents: riskComponents,
      collectionAreas: collectionAreas,
    );
  }

  // ============================================================================
  // HELPER METHODS
  // ============================================================================

  /// Calculate R2 (Loss of Service to Public)
  ///
  /// Currently returns 0.0 as placeholder.
  /// Can be expanded to calculate based on service continuity requirements.
  double _calculateR2(Map<String, double> components) {
    // TODO: Implement R2 calculation when needed
    // R2 considers loss of service to the public
    return 0.0;
  }

  /// Calculate R3 (Loss of Cultural Heritage)
  ///
  /// Currently returns 0.0 as placeholder.
  /// Can be expanded to calculate based on cultural value.
  double _calculateR3(Map<String, double> components) {
    // TODO: Implement R3 calculation when needed
    // R3 considers loss of irreplaceable cultural heritage
    return 0.0;
  }

  /// Calculate R4 (Economic Loss)
  ///
  /// Currently returns 0.0 as placeholder.
  /// Can be expanded to calculate based on economic parameters.
  double _calculateR4(Map<String, double> components) {
    // TODO: Implement R4 calculation when needed
    // R4 considers economic loss from damage
    return 0.0;
  }

  /// Determine Protection Level Based on R1
  ///
  /// Returns recommended LPS class based on calculated risk.
  String _determineProtectionLevel(double r1) {
    if (r1 <= tolerableRiskL1) {
      return protectionLevelRecommendations['no_protection']!;
    } else if (r1 <= tolerableRiskL1 * 5) {
      return protectionLevelRecommendations['class_iv']!;
    } else if (r1 <= tolerableRiskL1 * 10) {
      return protectionLevelRecommendations['class_iii']!;
    } else if (r1 <= tolerableRiskL1 * 50) {
      return protectionLevelRecommendations['class_ii']!;
    } else {
      return protectionLevelRecommendations['class_i']!;
    }
  }

  // ============================================================================
  // DETAILED ANALYSIS METHODS (Optional)
  // ============================================================================

  /// Get Collection Areas for Specific Zone
  ///
  /// Returns all collection area values for inspection.
  Future<Map<String, double>> getCollectionAreas(ZoneParameters params) async {
    return _areaCalculator.calculateAllAreas(params);
  }

  /// Get Dangerous Events for Specific Zone
  ///
  /// Returns all dangerous event values for inspection.
  Future<Map<String, double>> getDangerousEvents(
    ZoneParameters params,
  ) async {
    final areas = await getCollectionAreas(params);
    return _eventsCalculator.calculateAllEvents(params, areas);
  }

  /// Get Probabilities for Specific Zone
  ///
  /// Returns all probability values for inspection.
  Future<Map<String, double>> getProbabilities(ZoneParameters params) async {
    return _probabilityCalculator.calculateAllProbabilities(params);
  }

  /// Get Risk Components for Specific Zone
  ///
  /// Returns all risk component values for inspection.
  Future<Map<String, double>> getRiskComponents(
    ZoneParameters params,
  ) async {
    final areas = await getCollectionAreas(params);
    final events = _eventsCalculator.calculateAllEvents(params, areas);
    final probabilities = _probabilityCalculator.calculateAllProbabilities(params);
    
    return _riskCalculator.calculateAllComponents(
      events: events,
      probabilities: probabilities,
      zone: 'Z1',
    );
  }

  // ============================================================================
  // VALIDATION METHODS
  // ============================================================================

  /// Validate Zone Parameters
  ///
  /// Checks if all required parameters are valid.
  /// Returns list of validation errors (empty if valid).
  List<String> validateParameters(ZoneParameters params) {
    final errors = <String>[];

    // Validate structure dimensions
    if (params.length <= 0) {
      errors.add('Structure length must be greater than 0');
    }
    if (params.width <= 0) {
      errors.add('Structure width must be greater than 0');
    }
    if (params.height <= 0) {
      errors.add('Structure height must be greater than 0');
    }

    // Validate lightning flash density
    if (params.lightningFlashDensity <= 0) {
      errors.add('Lightning flash density must be greater than 0');
    }

    // Validate withstand voltages if lines are present
    if (params.powerLinePresent && params.powerUW <= 0) {
      errors.add('Power line withstand voltage must be specified');
    }
    if (params.telecomPresent && params.tlcUW <= 0) {
      errors.add('Telecom line withstand voltage must be specified');
    }

    return errors;
  }

  /// Check if Parameters are Valid
  ///
  /// Returns true if all parameters pass validation.
  bool areParametersValid(ZoneParameters params) {
    return validateParameters(params).isEmpty;
  }
}


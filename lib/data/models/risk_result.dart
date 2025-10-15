/// Risk Result Data Model
///
/// Contains the results of a lightning risk assessment calculation.
/// This model follows IEC 62305-2 standard result definitions.
library;

import '../../core/constants/iec_standards/tolerable_risk.dart';
import '../../core/utils/formatters.dart';

/// Risk Assessment Result
///
/// Encapsulates all calculated risk values and associated metadata
/// from a lightning risk assessment according to IEC 62305-2.
class RiskResult {
  // ============================================================================
  // NUMBER OF DANGEROUS EVENTS
  // ============================================================================
  
  /// Number of dangerous events - flashes to structure
  final double nd;
  
  /// Number of dangerous events - flashes near structure
  final double nm;
  
  /// Number of dangerous events - flashes to power line
  final double nl_p;
  
  /// Number of dangerous events - flashes to telecom line
  final double nl_t;
  
  /// Number of dangerous events - flashes near lines (combined)
  final double ni;
  
  /// Number of dangerous events - flashes to adjacent structure (power)
  final double ndj_p;
  
  /// Number of dangerous events - flashes to adjacent structure (telecom)
  final double ndj_t;

  // ============================================================================
  // CALCULATED RISK VALUES
  // ============================================================================
  
  /// R1: Risk of loss of human life or permanent injury
  final double r1;
  
  /// R2: Risk of loss of service to the public
  final double r2;
  
  /// R3: Risk of loss of cultural heritage
  final double r3;
  
  /// R4: Risk of economic loss
  final double r4;

  // ============================================================================
  // TOLERABLE RISK THRESHOLDS
  // ============================================================================
  
  /// Tolerable risk threshold for R1
  final double tolerableR1;
  
  /// Tolerable risk threshold for R2
  final double tolerableR2;
  
  /// Tolerable risk threshold for R3
  final double tolerableR3;
  
  /// Tolerable risk threshold for R4
  final double tolerableR4;

  // ============================================================================
  // PROTECTION ANALYSIS
  // ============================================================================
  
  /// Whether protection is required
  final bool protectionRequired;
  
  /// Recommended protection level
  final String protectionLevel;

  // ============================================================================
  // DETAILED ANALYSIS DATA
  // ============================================================================
  
  /// Individual risk components (RA1, RB1, RC1, etc.)
  final Map<String, double> riskComponents;
  
  /// Collection areas (AD, AM, ALP, etc.)
  final Map<String, double> collectionAreas;

  // ============================================================================
  // CONSTRUCTOR
  // ============================================================================

  const RiskResult({
    required this.nd,
    required this.nm,
    required this.nl_p,
    required this.nl_t,
    required this.ni,
    required this.ndj_p,
    required this.ndj_t,
    required this.r1,
    this.r2 = 0.0,
    this.r3 = 0.0,
    this.r4 = 0.0,
    this.tolerableR1 = tolerableRiskL1,
    this.tolerableR2 = tolerableRiskL2,
    this.tolerableR3 = tolerableRiskL3,
    this.tolerableR4 = tolerableRiskL4,
    this.protectionRequired = false,
    this.protectionLevel = 'No protection required',
    this.riskComponents = const {},
    this.collectionAreas = const {},
  });

  // ============================================================================
  // COMPUTED PROPERTIES - Risk Status
  // ============================================================================

  /// Whether R1 exceeds tolerable risk
  bool get r1ExceedsTolerable => r1 > tolerableR1;
  
  /// Whether R2 exceeds tolerable risk
  bool get r2ExceedsTolerable => r2 > tolerableR2;
  
  /// Whether R3 exceeds tolerable risk
  bool get r3ExceedsTolerable => r3 > tolerableR3;
  
  /// Whether R4 exceeds tolerable risk
  bool get r4ExceedsTolerable => r4 > tolerableR4;

  /// Protection status for R1
  String get r1Status => formatProtectionStatus(r1ExceedsTolerable);
  
  /// Protection status for R2
  String get r2Status => formatProtectionStatus(r2ExceedsTolerable);
  
  /// Protection status for R3
  String get r3Status => formatProtectionStatus(r3ExceedsTolerable);
  
  /// Protection status for R4
  String get r4Status => formatProtectionStatus(r4ExceedsTolerable);

  // ============================================================================
  // COMPUTED PROPERTIES - Risk Levels
  // ============================================================================

  /// Risk level description for R1
  String get r1RiskLevel => formatRiskLevel(r1, tolerableR1);
  
  /// Risk level description for R2
  String get r2RiskLevel => formatRiskLevel(r2, tolerableR2);
  
  /// Risk level description for R3
  String get r3RiskLevel => formatRiskLevel(r3, tolerableR3);
  
  /// Risk level description for R4
  String get r4RiskLevel => formatRiskLevel(r4, tolerableR4);

  // ============================================================================
  // SERIALIZATION
  // ============================================================================

  /// Convert to Map
  Map<String, dynamic> toMap() {
    return {
      'nd': nd,
      'nm': nm,
      'nl_p': nl_p,
      'nl_t': nl_t,
      'ni': ni,
      'ndj_p': ndj_p,
      'ndj_t': ndj_t,
      'r1': r1,
      'r2': r2,
      'r3': r3,
      'r4': r4,
      'tolerableR1': tolerableR1,
      'tolerableR2': tolerableR2,
      'tolerableR3': tolerableR3,
      'tolerableR4': tolerableR4,
      'protectionRequired': protectionRequired,
      'protectionLevel': protectionLevel,
      'riskComponents': riskComponents,
      'collectionAreas': collectionAreas,
    };
  }

  /// Create from Map
  factory RiskResult.fromMap(Map<String, dynamic> map) {
    return RiskResult(
      nd: map['nd']?.toDouble() ?? 0.0,
      nm: map['nm']?.toDouble() ?? 0.0,
      nl_p: map['nl_p']?.toDouble() ?? 0.0,
      nl_t: map['nl_t']?.toDouble() ?? 0.0,
      ni: map['ni']?.toDouble() ?? 0.0,
      ndj_p: map['ndj_p']?.toDouble() ?? 0.0,
      ndj_t: map['ndj_t']?.toDouble() ?? 0.0,
      r1: map['r1']?.toDouble() ?? 0.0,
      r2: map['r2']?.toDouble() ?? 0.0,
      r3: map['r3']?.toDouble() ?? 0.0,
      r4: map['r4']?.toDouble() ?? 0.0,
      tolerableR1: map['tolerableR1']?.toDouble() ?? tolerableRiskL1,
      tolerableR2: map['tolerableR2']?.toDouble() ?? tolerableRiskL2,
      tolerableR3: map['tolerableR3']?.toDouble() ?? tolerableRiskL3,
      tolerableR4: map['tolerableR4']?.toDouble() ?? tolerableRiskL4,
      protectionRequired: map['protectionRequired'] ?? false,
      protectionLevel: map['protectionLevel'] ?? 'No protection required',
      riskComponents: Map<String, double>.from(map['riskComponents'] ?? {}),
      collectionAreas: Map<String, double>.from(map['collectionAreas'] ?? {}),
    );
  }

  // ============================================================================
  // HELPER METHODS
  // ============================================================================

  /// Get formatted R1 value
  String get formattedR1 => formatRisk(r1);
  
  /// Get formatted R2 value
  String get formattedR2 => formatRisk(r2);
  
  /// Get formatted R3 value
  String get formattedR3 => formatRisk(r3);
  
  /// Get formatted R4 value
  String get formattedR4 => formatRisk(r4);

  /// Whether any risk exceeds tolerable levels
  bool get anyRiskExceedsTolerable =>
      r1ExceedsTolerable ||
      r2ExceedsTolerable ||
      r3ExceedsTolerable ||
      r4ExceedsTolerable;

  /// Overall risk status
  String get overallRiskStatus {
    if (!anyRiskExceedsTolerable) return 'All risks acceptable';
    if (r1ExceedsTolerable) return 'R1 exceeds tolerable - ${r1RiskLevel} risk';
    if (r2ExceedsTolerable) return 'R2 exceeds tolerable - ${r2RiskLevel} risk';
    if (r3ExceedsTolerable) return 'R3 exceeds tolerable - ${r3RiskLevel} risk';
    return 'R4 exceeds tolerable - ${r4RiskLevel} risk';
  }
}


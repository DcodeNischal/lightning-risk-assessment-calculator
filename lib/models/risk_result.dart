class RiskResult {
  // Number of dangerous events
  final double nd;
  final double nm;
  final double nl_p;
  final double nl_t;
  final double ni;
  final double ndj_p;
  final double ndj_t;

  // Risk values (before protection)
  final double r1; // Risk of loss of human life
  final double r2; // Risk of loss of service to public
  final double r3; // Risk of loss of cultural heritage
  final double r4; // Risk of economic loss

  // Risk values after protection measures
  final double r1AfterProtection;
  final double r2AfterProtection;
  final double r3AfterProtection;
  final double r4AfterProtection;

  // Tolerable risk thresholds
  final double tolerableR1;
  final double tolerableR2;
  final double tolerableR3;
  final double tolerableR4;

  // Protection analysis
  final bool protectionRequired;
  final String protectionLevel;

  // Cost-Benefit Analysis
  final double costOfLossBeforeProtection; // CL
  final double costOfLossAfterProtection; // CRL
  final double annualCostOfProtection; // CPM
  final double annualSavings; // SM
  final double totalCostOfStructure; // ctotal in million
  final bool isProtectionEconomical;

  // Detailed risk components (for detailed analysis)
  final Map<String, double> riskComponents;
  final Map<String, double> collectionAreas;
  final Map<String, double> riskComponentsAfterProtection;

  RiskResult({
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
    this.r1AfterProtection = 0.0,
    this.r2AfterProtection = 0.0,
    this.r3AfterProtection = 0.0,
    this.r4AfterProtection = 0.0,
    this.tolerableR1 = 1.0e-5, // L1: loss of human life or permanent injury
    this.tolerableR2 = 1.0e-3, // L2: loss of service to the public
    this.tolerableR3 = 1.0e-4, // L3: loss of cultural heritage
    this.tolerableR4 = 1.0e-3, // L4: loss of economic value
    this.protectionRequired = false,
    this.protectionLevel = 'No protection required',
    this.costOfLossBeforeProtection = 0.0,
    this.costOfLossAfterProtection = 0.0,
    this.annualCostOfProtection = 0.0,
    this.annualSavings = 0.0,
    this.totalCostOfStructure = 200.0,
    this.isProtectionEconomical = false,
    this.riskComponents = const {},
    this.collectionAreas = const {},
    this.riskComponentsAfterProtection = const {},
  });

  // Risk assessment summary
  bool get r1ExceedsTolerable => r1 > tolerableR1;
  bool get r2ExceedsTolerable => r2 > tolerableR2;
  bool get r3ExceedsTolerable => r3 > tolerableR3;
  bool get r4ExceedsTolerable => r4 > tolerableR4;

  String get r1Status =>
      r1ExceedsTolerable ? 'Protection Required' : 'Protection Not Required';
  String get r2Status =>
      r2ExceedsTolerable ? 'Protection Required' : 'Protection Not Required';
  String get r3Status =>
      r3ExceedsTolerable ? 'Protection Required' : 'Protection Not Required';
  String get r4Status =>
      r4ExceedsTolerable ? 'Protection Required' : 'Protection Not Required';

  // Risk level descriptions
  String get r1RiskLevel {
    if (r1 <= tolerableR1) return 'Acceptable';
    if (r1 <= tolerableR1 * 10) return 'Low';
    if (r1 <= tolerableR1 * 100) return 'Moderate';
    if (r1 <= tolerableR1 * 1000) return 'High';
    return 'Very High';
  }

  String get r2RiskLevel {
    if (r2 <= tolerableR2) return 'Acceptable';
    if (r2 <= tolerableR2 * 10) return 'Low';
    if (r2 <= tolerableR2 * 100) return 'Moderate';
    if (r2 <= tolerableR2 * 1000) return 'High';
    return 'Very High';
  }

  String get r3RiskLevel {
    if (r3 <= tolerableR3) return 'Acceptable';
    if (r3 <= tolerableR3 * 10) return 'Low';
    if (r3 <= tolerableR3 * 100) return 'Moderate';
    if (r3 <= tolerableR3 * 1000) return 'High';
    return 'Very High';
  }

  String get r4RiskLevel {
    if (r4 <= tolerableR4) return 'Acceptable';
    if (r4 <= tolerableR4 * 10) return 'Low';
    if (r4 <= tolerableR4 * 100) return 'Moderate';
    if (r4 <= tolerableR4 * 1000) return 'High';
    return 'Very High';
  }

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
      'r1AfterProtection': r1AfterProtection,
      'r2AfterProtection': r2AfterProtection,
      'r3AfterProtection': r3AfterProtection,
      'r4AfterProtection': r4AfterProtection,
      'tolerableR1': tolerableR1,
      'tolerableR2': tolerableR2,
      'tolerableR3': tolerableR3,
      'tolerableR4': tolerableR4,
      'protectionRequired': protectionRequired,
      'protectionLevel': protectionLevel,
      'costOfLossBeforeProtection': costOfLossBeforeProtection,
      'costOfLossAfterProtection': costOfLossAfterProtection,
      'annualCostOfProtection': annualCostOfProtection,
      'annualSavings': annualSavings,
      'totalCostOfStructure': totalCostOfStructure,
      'isProtectionEconomical': isProtectionEconomical,
      'riskComponents': riskComponents,
      'collectionAreas': collectionAreas,
      'riskComponentsAfterProtection': riskComponentsAfterProtection,
    };
  }

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
      r1AfterProtection: map['r1AfterProtection']?.toDouble() ?? 0.0,
      r2AfterProtection: map['r2AfterProtection']?.toDouble() ?? 0.0,
      r3AfterProtection: map['r3AfterProtection']?.toDouble() ?? 0.0,
      r4AfterProtection: map['r4AfterProtection']?.toDouble() ?? 0.0,
      tolerableR1: map['tolerableR1']?.toDouble() ?? 1e-5,
      tolerableR2: map['tolerableR2']?.toDouble() ?? 1e-3,
      tolerableR3: map['tolerableR3']?.toDouble() ?? 1e-4,
      tolerableR4: map['tolerableR4']?.toDouble() ?? 1e-3,
      protectionRequired: map['protectionRequired'] ?? false,
      protectionLevel: map['protectionLevel'] ?? 'No protection required',
      costOfLossBeforeProtection:
          map['costOfLossBeforeProtection']?.toDouble() ?? 0.0,
      costOfLossAfterProtection:
          map['costOfLossAfterProtection']?.toDouble() ?? 0.0,
      annualCostOfProtection: map['annualCostOfProtection']?.toDouble() ?? 0.0,
      annualSavings: map['annualSavings']?.toDouble() ?? 0.0,
      totalCostOfStructure: map['totalCostOfStructure']?.toDouble() ?? 200.0,
      isProtectionEconomical: map['isProtectionEconomical'] ?? false,
      riskComponents: Map<String, double>.from(map['riskComponents'] ?? {}),
      collectionAreas: Map<String, double>.from(map['collectionAreas'] ?? {}),
      riskComponentsAfterProtection:
          Map<String, double>.from(map['riskComponentsAfterProtection'] ?? {}),
    );
  }
}

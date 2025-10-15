/// Zone Parameters Data Model
///
/// Contains all input parameters for a zone in the lightning risk assessment.
/// This model follows IEC 62305-2 standard parameter definitions.
library;

/// Zone Parameters for Risk Assessment
///
/// Encapsulates all structural, environmental, and electrical parameters
/// needed for calculating lightning risk according to IEC 62305-2.
class ZoneParameters {
  // ============================================================================
  // STRUCTURE PARAMETERS
  // ============================================================================
  
  /// Length of the structure (m)
  final double length;
  
  /// Width of the structure (m)
  final double width;
  
  /// Height of the structure (m) - measured from ground to highest point
  final double height;
  
  /// Location factor key (CD) - describes structure's position
  final String locationFactorKey;
  
  /// Construction material of the structure (PS)
  final String constructionMaterial;

  // ============================================================================
  // ENVIRONMENTAL PARAMETERS
  // ============================================================================
  
  /// Lightning flash density NG (flashes per year per km²)
  final double lightningFlashDensity;
  
  /// Environmental factor key (CE) - urban, suburban, or rural
  final String environmentalFactorKey;

  // ============================================================================
  // PROTECTION SYSTEM PARAMETERS
  // ============================================================================
  
  /// Lightning Protection System status (PLPS/PB)
  final String lpsStatus;
  
  /// External shielding mesh width (KS1)
  final double meshWidth1;
  
  /// Internal shielding mesh width (KS2)
  final double meshWidth2;
  
  /// Equipotential bonding status (PEB)
  final String equipotentialBonding;
  
  /// Coordinated SPD protection level (PSPD)
  final String spdProtectionLevel;

  // ============================================================================
  // POWER LINE PARAMETERS
  // ============================================================================
  
  /// Length of power line (m)
  final double lengthPowerLine;
  
  /// Installation type of power line (CI)
  final String installationPowerLine;
  
  /// Type of power line (CT)
  final String lineTypePowerLine;
  
  /// Power line shielding configuration (CLD)
  final String powerShielding;
  
  /// Power line shielding factor KS1
  final double powerShieldingFactorKs1;
  
  /// Power line withstand voltage UW (kV)
  final double powerUW;
  
  /// Spacing between power line conductors (m)
  final double spacingPowerLine;
  
  /// Power line type CT
  final String powerTypeCT;

  // ============================================================================
  // TELECOM LINE PARAMETERS
  // ============================================================================
  
  /// Length of telecommunication line (m)
  final double lengthTlcLine;
  
  /// Installation type of telecom line (CI)
  final String installationTlcLine;
  
  /// Type of telecom line (CT)
  final String lineTypeTlcLine;
  
  /// Telecom line shielding configuration (CLD)
  final String tlcShielding;
  
  /// Telecom line shielding factor KS1
  final double tlcShieldingFactorKs1;
  
  /// Telecom line withstand voltage UW (kV)
  final double tlcUW;
  
  /// Spacing between telecom line conductors (m)
  final double spacingTlcLine;
  
  /// Telecom line type CT
  final String teleTypeCT;

  // ============================================================================
  // ADJACENT STRUCTURE PARAMETERS
  // ============================================================================
  
  /// Length of adjacent structure (m)
  final double adjLength;
  
  /// Width of adjacent structure (m)
  final double adjWidth;
  
  /// Height of adjacent structure (m)
  final double adjHeight;
  
  /// Location factor for adjacent structure (CDJ)
  final String adjLocationFactor;

  // ============================================================================
  // SAFETY AND LOSS PARAMETERS
  // ============================================================================
  
  /// Reduction factor for touch voltage (rt) - floor surface material
  final double reductionFactorRT;
  
  /// Loss type for human life (LT)
  final String lossTypeLT;
  
  /// Exposure time in zone (hours per year)
  final double exposureTimeTZ;
  
  /// Number of persons exposed in zone
  final double exposedPersonsNZ;
  
  /// Total number of persons in structure
  final double totalPersonsNT;
  
  /// Shock protection against touch voltage in structure (PTA)
  final String shockProtectionPTA;
  
  /// Shock protection against touch voltage on lines (PTU)
  final String shockProtectionPTU;
  
  /// Fire protection measures (rp)
  final String fireProtection;
  
  /// Fire risk level (rf)
  final String fireRisk;

  // ============================================================================
  // ECONOMIC AND CULTURAL VALUE PARAMETERS
  // ============================================================================
  
  /// Total cost category of structure
  final String totalCostOfStructure;
  
  /// Economic value (custom entry)
  final String economicValue;
  
  /// Whether structure has economic value
  final String isAnyEconomicValue;
  
  /// Whether structure houses animals
  final String isAnyValueofAnimals;
  
  /// Cultural heritage value indicator
  final String coValue;
  
  /// Cultural heritage percentage for Zone 0
  final int culturalHeritageZ0;
  
  /// Total value of building (percentage)
  final int totalValueBuilding;
  
  /// Whether structure has life support devices
  final String lifeSupportDevice;

  // ============================================================================
  // LINE PRESENCE FLAGS
  // ============================================================================
  
  /// Whether power line is present
  final bool powerLinePresent;
  
  /// Whether telecom line is present
  final bool telecomPresent;

  // ============================================================================
  // CONSTRUCTOR
  // ============================================================================

  const ZoneParameters({
    required this.length,
    required this.width,
    required this.height,
    required this.locationFactorKey,
    required this.lightningFlashDensity,
    required this.environmentalFactorKey,
    required this.lpsStatus,
    required this.constructionMaterial,
    required this.meshWidth1,
    required this.meshWidth2,
    required this.equipotentialBonding,
    required this.spdProtectionLevel,
    required this.lengthPowerLine,
    required this.installationPowerLine,
    required this.lineTypePowerLine,
    required this.powerShielding,
    required this.powerShieldingFactorKs1,
    required this.powerUW,
    required this.spacingPowerLine,
    required this.powerTypeCT,
    required this.lengthTlcLine,
    required this.installationTlcLine,
    required this.lineTypeTlcLine,
    required this.tlcShielding,
    required this.tlcShieldingFactorKs1,
    required this.tlcUW,
    required this.spacingTlcLine,
    required this.teleTypeCT,
    required this.adjLength,
    required this.adjWidth,
    required this.adjHeight,
    required this.adjLocationFactor,
    required this.reductionFactorRT,
    required this.lossTypeLT,
    required this.exposureTimeTZ,
    required this.exposedPersonsNZ,
    required this.totalPersonsNT,
    required this.shockProtectionPTA,
    required this.shockProtectionPTU,
    required this.fireProtection,
    required this.fireRisk,
    this.totalCostOfStructure = 'Medium Scale Industry',
    this.economicValue = '',
    this.isAnyEconomicValue = 'No',
    this.isAnyValueofAnimals = 'No',
    this.coValue = 'No',
    this.culturalHeritageZ0 = 10,
    this.totalValueBuilding = 100,
    this.lifeSupportDevice = 'No',
    this.powerLinePresent = true,
    this.telecomPresent = true,
  });

  // ============================================================================
  // FACTORY CONSTRUCTORS
  // ============================================================================

  /// Create ZoneParameters from Map
  factory ZoneParameters.fromMap(Map<String, dynamic> map) {
    return ZoneParameters(
      length: map['length']?.toDouble() ?? 0.0,
      width: map['width']?.toDouble() ?? 0.0,
      height: map['height']?.toDouble() ?? 0.0,
      locationFactorKey: map['locationFactorKey'] ?? '',
      lightningFlashDensity: map['lightningFlashDensity']?.toDouble() ?? 0.0,
      environmentalFactorKey: map['environmentalFactorKey'] ?? '',
      lpsStatus: map['lpsStatus'] ?? '',
      constructionMaterial: map['constructionMaterial'] ?? 'Masonry',
      meshWidth1: map['meshWidth1']?.toDouble() ?? 0.0,
      meshWidth2: map['meshWidth2']?.toDouble() ?? 0.0,
      equipotentialBonding: map['equipotentialBonding'] ?? '',
      spdProtectionLevel: map['spdProtectionLevel'] ?? '',
      lengthPowerLine: map['lengthPowerLine']?.toDouble() ?? 0.0,
      installationPowerLine: map['installationPowerLine'] ?? '',
      lineTypePowerLine: map['lineTypePowerLine'] ?? '',
      powerShielding: map['powerShielding'] ?? '',
      powerShieldingFactorKs1: map['powerShieldingFactorKs1']?.toDouble() ?? 0.0,
      powerUW: map['powerUW']?.toDouble() ?? 0.0,
      spacingPowerLine: map['spacingPowerLine']?.toDouble() ?? 0.0,
      powerTypeCT: map['powerTypeCT'] ?? '',
      lengthTlcLine: map['lengthTlcLine']?.toDouble() ?? 0.0,
      installationTlcLine: map['installationTlcLine'] ?? '',
      lineTypeTlcLine: map['lineTypeTlcLine'] ?? '',
      tlcShielding: map['tlcShielding'] ?? '',
      tlcShieldingFactorKs1: map['tlcShieldingFactorKs1']?.toDouble() ?? 0.0,
      tlcUW: map['tlcUW']?.toDouble() ?? 0.0,
      spacingTlcLine: map['spacingTlcLine']?.toDouble() ?? 0.0,
      teleTypeCT: map['teleTypeCT'] ?? '',
      adjLength: map['adjLength']?.toDouble() ?? 0.0,
      adjWidth: map['adjWidth']?.toDouble() ?? 0.0,
      adjHeight: map['adjHeight']?.toDouble() ?? 0.0,
      adjLocationFactor: map['adjLocationFactor'] ?? '',
      reductionFactorRT: map['reductionFactorRT']?.toDouble() ?? 0.0,
      lossTypeLT: map['lossTypeLT'] ?? '',
      exposureTimeTZ: map['exposureTimeTZ']?.toDouble() ?? 0.0,
      exposedPersonsNZ: map['exposedPersonsNZ']?.toDouble() ?? 0.0,
      totalPersonsNT: map['totalPersonsNT']?.toDouble() ?? 0.0,
      shockProtectionPTA: map['shockProtectionPTA'] ?? '',
      shockProtectionPTU: map['shockProtectionPTU'] ?? '',
      fireProtection: map['fireProtection'] ?? 'No measures',
      fireRisk: map['fireRisk'] ?? 'Fire (Ordinary)',
      totalCostOfStructure: map['totalCostOfStructure'] ?? 'Medium Scale Industry',
      economicValue: map['economicValue'] ?? '',
      isAnyEconomicValue: map['isAnyEconomicValue'] ?? 'No',
      isAnyValueofAnimals: map['isAnyValueofAnimals'] ?? 'No',
      coValue: map['coValue'] ?? 'No',
      culturalHeritageZ0: map['culturalHeritageZ0']?.toInt() ?? 10,
      totalValueBuilding: map['totalValueBuilding']?.toInt() ?? 100,
      lifeSupportDevice: map['lifeSupportDevice'] ?? 'No',
      powerLinePresent: map['powerLinePresent'] ?? true,
      telecomPresent: map['telecomPresent'] ?? true,
    );
  }

  // ============================================================================
  // SERIALIZATION
  // ============================================================================

  /// Convert to Map
  Map<String, dynamic> toMap() {
    return {
      'length': length,
      'width': width,
      'height': height,
      'locationFactorKey': locationFactorKey,
      'lightningFlashDensity': lightningFlashDensity,
      'environmentalFactorKey': environmentalFactorKey,
      'lpsStatus': lpsStatus,
      'constructionMaterial': constructionMaterial,
      'meshWidth1': meshWidth1,
      'meshWidth2': meshWidth2,
      'equipotentialBonding': equipotentialBonding,
      'spdProtectionLevel': spdProtectionLevel,
      'lengthPowerLine': lengthPowerLine,
      'installationPowerLine': installationPowerLine,
      'lineTypePowerLine': lineTypePowerLine,
      'powerShielding': powerShielding,
      'powerShieldingFactorKs1': powerShieldingFactorKs1,
      'powerUW': powerUW,
      'spacingPowerLine': spacingPowerLine,
      'powerTypeCT': powerTypeCT,
      'lengthTlcLine': lengthTlcLine,
      'installationTlcLine': installationTlcLine,
      'lineTypeTlcLine': lineTypeTlcLine,
      'tlcShielding': tlcShielding,
      'tlcShieldingFactorKs1': tlcShieldingFactorKs1,
      'tlcUW': tlcUW,
      'spacingTlcLine': spacingTlcLine,
      'teleTypeCT': teleTypeCT,
      'adjLength': adjLength,
      'adjWidth': adjWidth,
      'adjHeight': adjHeight,
      'adjLocationFactor': adjLocationFactor,
      'reductionFactorRT': reductionFactorRT,
      'lossTypeLT': lossTypeLT,
      'exposureTimeTZ': exposureTimeTZ,
      'exposedPersonsNZ': exposedPersonsNZ,
      'totalPersonsNT': totalPersonsNT,
      'shockProtectionPTA': shockProtectionPTA,
      'shockProtectionPTU': shockProtectionPTU,
      'fireProtection': fireProtection,
      'fireRisk': fireRisk,
      'totalCostOfStructure': totalCostOfStructure,
      'economicValue': economicValue,
      'isAnyEconomicValue': isAnyEconomicValue,
      'isAnyValueofAnimals': isAnyValueofAnimals,
      'coValue': coValue,
      'culturalHeritageZ0': culturalHeritageZ0,
      'totalValueBuilding': totalValueBuilding,
      'lifeSupportDevice': lifeSupportDevice,
      'powerLinePresent': powerLinePresent,
      'telecomPresent': telecomPresent,
    };
  }

  // ============================================================================
  // COPY WITH
  // ============================================================================

  /// Create a copy with modified parameters
  ZoneParameters copyWith({
    double? length,
    double? width,
    double? height,
    String? locationFactorKey,
    double? lightningFlashDensity,
    String? environmentalFactorKey,
    String? lpsStatus,
    String? constructionMaterial,
    double? meshWidth1,
    double? meshWidth2,
    String? equipotentialBonding,
    String? spdProtectionLevel,
    double? lengthPowerLine,
    String? installationPowerLine,
    String? lineTypePowerLine,
    String? powerShielding,
    double? powerShieldingFactorKs1,
    double? powerUW,
    double? spacingPowerLine,
    String? powerTypeCT,
    double? lengthTlcLine,
    String? installationTlcLine,
    String? lineTypeTlcLine,
    String? tlcShielding,
    double? tlcShieldingFactorKs1,
    double? tlcUW,
    double? spacingTlcLine,
    String? teleTypeCT,
    double? adjLength,
    double? adjWidth,
    double? adjHeight,
    String? adjLocationFactor,
    double? reductionFactorRT,
    String? lossTypeLT,
    double? exposureTimeTZ,
    double? exposedPersonsNZ,
    double? totalPersonsNT,
    String? shockProtectionPTA,
    String? shockProtectionPTU,
    String? fireProtection,
    String? fireRisk,
    String? totalCostOfStructure,
    String? economicValue,
    String? isAnyEconomicValue,
    String? isAnyValueofAnimals,
    String? coValue,
    int? culturalHeritageZ0,
    int? totalValueBuilding,
    String? lifeSupportDevice,
    bool? powerLinePresent,
    bool? telecomPresent,
  }) {
    return ZoneParameters(
      length: length ?? this.length,
      width: width ?? this.width,
      height: height ?? this.height,
      locationFactorKey: locationFactorKey ?? this.locationFactorKey,
      lightningFlashDensity: lightningFlashDensity ?? this.lightningFlashDensity,
      environmentalFactorKey: environmentalFactorKey ?? this.environmentalFactorKey,
      lpsStatus: lpsStatus ?? this.lpsStatus,
      constructionMaterial: constructionMaterial ?? this.constructionMaterial,
      meshWidth1: meshWidth1 ?? this.meshWidth1,
      meshWidth2: meshWidth2 ?? this.meshWidth2,
      equipotentialBonding: equipotentialBonding ?? this.equipotentialBonding,
      spdProtectionLevel: spdProtectionLevel ?? this.spdProtectionLevel,
      lengthPowerLine: lengthPowerLine ?? this.lengthPowerLine,
      installationPowerLine: installationPowerLine ?? this.installationPowerLine,
      lineTypePowerLine: lineTypePowerLine ?? this.lineTypePowerLine,
      powerShielding: powerShielding ?? this.powerShielding,
      powerShieldingFactorKs1: powerShieldingFactorKs1 ?? this.powerShieldingFactorKs1,
      powerUW: powerUW ?? this.powerUW,
      spacingPowerLine: spacingPowerLine ?? this.spacingPowerLine,
      powerTypeCT: powerTypeCT ?? this.powerTypeCT,
      lengthTlcLine: lengthTlcLine ?? this.lengthTlcLine,
      installationTlcLine: installationTlcLine ?? this.installationTlcLine,
      lineTypeTlcLine: lineTypeTlcLine ?? this.lineTypeTlcLine,
      tlcShielding: tlcShielding ?? this.tlcShielding,
      tlcShieldingFactorKs1: tlcShieldingFactorKs1 ?? this.tlcShieldingFactorKs1,
      tlcUW: tlcUW ?? this.tlcUW,
      spacingTlcLine: spacingTlcLine ?? this.spacingTlcLine,
      teleTypeCT: teleTypeCT ?? this.teleTypeCT,
      adjLength: adjLength ?? this.adjLength,
      adjWidth: adjWidth ?? this.adjWidth,
      adjHeight: adjHeight ?? this.adjHeight,
      adjLocationFactor: adjLocationFactor ?? this.adjLocationFactor,
      reductionFactorRT: reductionFactorRT ?? this.reductionFactorRT,
      lossTypeLT: lossTypeLT ?? this.lossTypeLT,
      exposureTimeTZ: exposureTimeTZ ?? this.exposureTimeTZ,
      exposedPersonsNZ: exposedPersonsNZ ?? this.exposedPersonsNZ,
      totalPersonsNT: totalPersonsNT ?? this.totalPersonsNT,
      shockProtectionPTA: shockProtectionPTA ?? this.shockProtectionPTA,
      shockProtectionPTU: shockProtectionPTU ?? this.shockProtectionPTU,
      fireProtection: fireProtection ?? this.fireProtection,
      fireRisk: fireRisk ?? this.fireRisk,
      totalCostOfStructure: totalCostOfStructure ?? this.totalCostOfStructure,
      economicValue: economicValue ?? this.economicValue,
      isAnyEconomicValue: isAnyEconomicValue ?? this.isAnyEconomicValue,
      isAnyValueofAnimals: isAnyValueofAnimals ?? this.isAnyValueofAnimals,
      coValue: coValue ?? this.coValue,
      culturalHeritageZ0: culturalHeritageZ0 ?? this.culturalHeritageZ0,
      totalValueBuilding: totalValueBuilding ?? this.totalValueBuilding,
      lifeSupportDevice: lifeSupportDevice ?? this.lifeSupportDevice,
      powerLinePresent: powerLinePresent ?? this.powerLinePresent,
      telecomPresent: telecomPresent ?? this.telecomPresent,
    );
  }
}


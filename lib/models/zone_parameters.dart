class ZoneParameters {
  final double length;
  final double width;
  final double height;
  final String locationFactorKey;
  final double lightningFlashDensity;
  final String environmentalFactorKey;
  final String lpsStatus;
  final String constructionMaterial;
  final double meshWidth1;
  final double meshWidth2;
  final String equipotentialBonding;
  final String spdProtectionLevel;
  final double lengthPowerLine;
  final String installationPowerLine;
  final String lineTypePowerLine;
  final String powerShielding;
  final double powerShieldingFactorKs1;
  final double powerUW;
  final double spacingPowerLine;
  final String powerTypeCT;
  final double lengthTlcLine;
  final String installationTlcLine;
  final String lineTypeTlcLine;
  final String tlcShielding;
  final double tlcShieldingFactorKs1;
  final double tlcUW;
  final double spacingTlcLine;
  final String teleTypeCT;
  final double adjLength;
  final double adjWidth;
  final double adjHeight;
  final String adjLocationFactor;
  final double reductionFactorRT;
  final String lossTypeLT;
  final double exposureTimeTZ;
  final double exposedPersonsNZ;
  final double totalPersonsNT;
  final String shockProtectionPTA;
  final String shockProtectionPTU;
  final String fireProtection;
  final String fireRisk;

  // Additional fields to support full PDF blocks
  final String totalCostOfStructure; // e.g., Medium Scale Industry
  final String economicValue; // optional free text/value
  final String isAnyEconomicValue; // Yes/No
  final String isAnyValueofAnimals; // Yes/No
  final String coValue; // Yes/No or text
  final int culturalHeritageZ0; // percent
  final int totalValueBuilding; // percent
  final String lifeSupportDevice; // Yes/No
  final bool powerLinePresent; // derived or explicit flag
  final bool telecomPresent; // derived or explicit flag

  ZoneParameters({
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
      powerShieldingFactorKs1:
          map['powerShieldingFactorKs1']?.toDouble() ?? 0.0,
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
      totalCostOfStructure:
          map['totalCostOfStructure'] ?? 'Medium Scale Industry',
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

  Map<String, dynamic> toMap() {
    return {
      'length': length,
      'width': width,
      'height': height,
      'locationFactorKey': locationFactorKey,
      'lightningFlashDensity': lightningFlashDensity,
      'environmentalFactorKey': environmentalFactorKey,
      'lpsStatus': lpsStatus,
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
}

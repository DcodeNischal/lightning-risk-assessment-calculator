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
  final String powerUW;
  final double spacingPowerLine;
  final String powerTypeCT;
  final double lengthTlcLine;
  final String installationTlcLine;
  final String lineTypeTlcLine;
  final String tlcShielding;
  final double tlcShieldingFactorKs1;
  final String tlcUW;
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

  // Structure-specific fields
  final bool isComplexStructure;
  final double collectionAreaAD;
  final double collectionAreaADJ;

  // Environmental and Structure Attributes fields
  final double shieldingFactorKs1;
  final double shieldingFactorKs2;
  final bool buildingProvidesServices;
  final bool buildingHasCulturalValue;

  // Power Line Parameters fields
  final String powerCLI;
  final String powerPLD;
  final String powerPLI;
  final double powerKS4;
  final String powerKS3;

  // Telecom Line Parameters fields
  final String tlcCLI;
  final String tlcPLD;
  final String tlcPLI;
  final double tlcKS4;
  final String tlcKS3;

  // Economic Valuation fields
  final String ca;
  final String cb;
  final String cc;
  final String cs;

  // Cultural Heritage Value fields
  final String cZ0;
  final double cZ1;
  final double ct;
  final double X;

  // Zone Definitions fields
  final double totalZones;
  final double personsZone0;
  final double personsZone1;
  final double totalPersons;

  // Zone Parameters - stored as maps for each zone
  late Map<String, Map<String, dynamic>> zoneParameters;

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
    required this.spacingPowerLine,
    required this.powerTypeCT,
    required this.lengthTlcLine,
    required this.installationTlcLine,
    required this.lineTypeTlcLine,
    required this.tlcShielding,
    required this.tlcShieldingFactorKs1,
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
    this.isComplexStructure = false,
    this.collectionAreaAD = 0.0,
    this.collectionAreaADJ = 0.0,
    this.shieldingFactorKs1 = 1.0,
    this.shieldingFactorKs2 = 1.0,
    this.buildingProvidesServices = false,
    this.buildingHasCulturalValue = false,
    this.powerCLI = 'Unshielded overhead line',
    this.powerPLD = 'Overhead',
    this.powerPLI = '1.5',
    this.powerKS4 = 0.667,
    this.powerKS3 =
        'Unshielded Cable - no routing precaution to avoid loops (loop surface 50 m2)',
    this.powerUW = '2.5',
    this.tlcCLI = 'Unshielded overhead line',
    this.tlcPLD = 'Overhead',
    this.tlcPLI = '1.5',
    this.tlcKS4 = 0.667,
    this.tlcKS3 =
        'Unshielded Cable - no routing precaution to avoid loops (loop surface 50 m2)',
    this.tlcUW = '1.5',
    this.ca = 'No',
    this.cb = 'No',
    this.cc = 'No',
    this.cs = 'No',
    this.cZ0 = '10',
    this.cZ1 = 90.0,
    this.ct = 100.0,
    this.X = 0.0,
    this.totalZones = 2.0,
    this.personsZone0 = 0.0,
    this.personsZone1 = 30.0,
    this.totalPersons = 30.0,
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
  }) {
    // Initialize zone parameters
    zoneParameters = {
      'zone0': {
        'rt': 'Asphalt, linoleum, wood',
        'PTA': 'No protection measures',
        'PTU': 'No protection measure',
        'rf': 'Fire(Ordinary)',
        'rp': 'No measures',
        'KS2': 1.0,
        'KS3_power':
            'Unshielded Cable - no routing precaution to avoid loops (loop surface 50 m2)',
        'PSPD_power': 'No coordinated SPD system',
        'KS3_telecom':
            'Unshielded Cable - no routing precaution to avoid loops (loop surface 50 m2)',
        'PSPD_telecom': 'No coordinated SPD system',
        'hz': 'No special risk',
        'LT': 'All types',
        'LF1': 'Industrial structure, economically used plant',
        'LO1': 'LO(Others)',
        'np': 0.0, // Will be auto-calculated
        'LF2': 'LF(None)',
        'LO2': 'TV, telecommunication(LO)',
        'LF3': 'None',
        'LT4': 'LT(None)',
        'LF4': 'LF(None)',
        'LO4':
            'hospital, industrial structure, office building, hotel, economically used plant',
      },
      'zone1': {
        'rt': 'Asphalt, linoleum, wood',
        'PTA': 'No protection measures',
        'PTU': 'No protection measure',
        'rf': 'Fire(Ordinary)',
        'rp': 'No measures',
        'KS2': 1.0,
        'KS3_power':
            'Unshielded Cable - no routing precaution to avoid loops (loop surface 50 m2)',
        'PSPD_power': 'No coordinated SPD system',
        'KS3_telecom':
            'Unshielded Cable - no routing precaution to avoid loops (loop surface 50 m2)',
        'PSPD_telecom': 'No coordinated SPD system',
        'hz': 'No special risk',
        'LT': 'All types',
        'LF1': 'Industrial structure, economically used plant',
        'LO1': 'LO(Others)',
        'np': 1.0, // Will be auto-calculated
        'LF2': 'LF(None)',
        'LO2': 'TV, telecommunication(LO)',
        'LF3': 'None',
        'LT4': 'LT(None)',
        'LF4': 'LF(None)',
        'LO4':
            'hospital, industrial structure, office building, hotel, economically used plant',
      },
    };
  }

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
      powerUW: map['powerUW'] ?? '2.5',
      spacingPowerLine: map['spacingPowerLine']?.toDouble() ?? 0.0,
      powerTypeCT: map['powerTypeCT'] ?? '',
      lengthTlcLine: map['lengthTlcLine']?.toDouble() ?? 0.0,
      installationTlcLine: map['installationTlcLine'] ?? '',
      lineTypeTlcLine: map['lineTypeTlcLine'] ?? '',
      tlcShielding: map['tlcShielding'] ?? '',
      tlcShieldingFactorKs1: map['tlcShieldingFactorKs1']?.toDouble() ?? 0.0,
      tlcUW: map['tlcUW'] ?? '1.5',
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
      isComplexStructure: map['isComplexStructure'] == 'Yes' ||
          map['isComplexStructure'] == true,
      collectionAreaAD: map['collectionAreaAD']?.toDouble() ?? 0.0,
      collectionAreaADJ: map['collectionAreaADJ']?.toDouble() ?? 0.0,
      shieldingFactorKs1: map['shieldingFactorKs1']?.toDouble() ?? 1.0,
      shieldingFactorKs2: map['shieldingFactorKs2']?.toDouble() ?? 1.0,
      buildingProvidesServices: map['buildingProvidesServices'] == 'Yes' ||
          map['buildingProvidesServices'] == true,
      buildingHasCulturalValue: map['buildingHasCulturalValue'] == 'Yes' ||
          map['buildingHasCulturalValue'] == true,
      powerCLI: map['powerCLI'] ?? 'Unshielded overhead line',
      powerPLD: map['powerPLD'] ?? 'Overhead',
      powerPLI: map['powerPLI'] ?? '1.5',
      powerKS4: map['powerKS4']?.toDouble() ?? 0.667,
      powerKS3: map['powerKS3'] ??
          'Unshielded Cable - no routing precaution to avoid loops (loop surface 50 m2)',
      tlcCLI: map['tlcCLI'] ?? 'Unshielded overhead line',
      tlcPLD: map['tlcPLD'] ?? 'Overhead',
      tlcPLI: map['tlcPLI'] ?? '1.5',
      tlcKS4: map['tlcKS4']?.toDouble() ?? 0.667,
      tlcKS3: map['tlcKS3'] ??
          'Unshielded Cable - no routing precaution to avoid loops (loop surface 50 m2)',
      ca: map['ca'] ?? 'No',
      cb: map['cb'] ?? 'No',
      cc: map['cc'] ?? 'No',
      cs: map['cs'] ?? 'No',
      cZ0: map['cZ0'] ?? '10',
      cZ1: map['cZ1']?.toDouble() ?? 90.0,
      ct: map['ct']?.toDouble() ?? 100.0,
      X: map['X']?.toDouble() ?? 0.0,
      totalZones: map['totalZones']?.toDouble() ?? 2.0,
      personsZone0: map['personsZone0']?.toDouble() ?? 0.0,
      personsZone1: map['personsZone1']?.toDouble() ?? 30.0,
      totalPersons: map['totalPersons']?.toDouble() ?? 30.0,
      totalCostOfStructure:
          map['totalCostOfStructure'] ?? 'Medium Scale Industry',
      economicValue: map['economicValue'] ?? '',
      isAnyEconomicValue: map['isAnyEconomicValue'] ?? 'No',
      isAnyValueofAnimals: map['isAnyValueofAnimals'] ?? 'No',
      coValue: map['coValue'] ?? 'No',
      culturalHeritageZ0: map['culturalHeritageZ0']?.toInt() ?? 10,
      totalValueBuilding: map['totalValueBuilding']?.toInt() ?? 100,
      lifeSupportDevice: map['lifeSupportDevice'] ?? 'No',
      powerLinePresent:
          map['powerLinePresent'] == 'Yes' || map['powerLinePresent'] == true,
      telecomPresent:
          map['telecomPresent'] == 'Yes' || map['telecomPresent'] == true,
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
      'isComplexStructure': isComplexStructure ? 'Yes' : 'No',
      'collectionAreaAD': collectionAreaAD,
      'collectionAreaADJ': collectionAreaADJ,
      'shieldingFactorKs1': shieldingFactorKs1,
      'shieldingFactorKs2': shieldingFactorKs2,
      'buildingProvidesServices': buildingProvidesServices ? 'Yes' : 'No',
      'buildingHasCulturalValue': buildingHasCulturalValue ? 'Yes' : 'No',
      'powerCLI': powerCLI,
      'powerPLD': powerPLD,
      'powerPLI': powerPLI,
      'powerKS4': powerKS4,
      'powerKS3': powerKS3,
      'tlcCLI': tlcCLI,
      'tlcPLD': tlcPLD,
      'tlcPLI': tlcPLI,
      'tlcKS4': tlcKS4,
      'tlcKS3': tlcKS3,
      'ca': ca,
      'cb': cb,
      'cc': cc,
      'cs': cs,
      'cZ0': cZ0,
      'cZ1': cZ1,
      'ct': ct,
      'X': X,
      'totalZones': totalZones,
      'personsZone0': personsZone0,
      'personsZone1': personsZone1,
      'totalPersons': totalPersons,
      'zoneParameters': zoneParameters,
      'totalCostOfStructure': totalCostOfStructure,
      'economicValue': economicValue,
      'isAnyEconomicValue': isAnyEconomicValue,
      'isAnyValueofAnimals': isAnyValueofAnimals,
      'coValue': coValue,
      'culturalHeritageZ0': culturalHeritageZ0,
      'totalValueBuilding': totalValueBuilding,
      'lifeSupportDevice': lifeSupportDevice,
      'powerLinePresent': powerLinePresent ? 'Yes' : 'No',
      'telecomPresent': telecomPresent ? 'Yes' : 'No',
    };
  }
}

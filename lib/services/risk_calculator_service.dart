import 'dart:math' as math;
import '../models/zone_parameters.dart';
import '../models/risk_result.dart';
import '../models/risk_factors.dart';

class RiskCalculatorService {
  // Helper for factor map lookups
  double getFactor(Map<String, double> map, String key, double defaultValue) =>
      map[key] ?? defaultValue;

  // Helper to convert UW string to double
  double _parseUW(String uwString) {
    return double.tryParse(uwString) ?? 2.5; // Default to 2.5 if parsing fails
  }

  // ============================================================================
  // COLLECTION AREAS - IEC 62305-2 Standard Formulas
  // ============================================================================

  /// Collection area for flashes to structure
  /// AD = (L*W) + 2*(3*H)*(L+W) + π*(3*H)²
  double calculateAD(ZoneParameters z) =>
      (z.length * z.width) +
      2 * (3 * z.height) * (z.length + z.width) +
      math.pi * math.pow(3 * z.height, 2);

  /// Collection area for flashes near structure
  /// AM = 2*rM*(L+W) + π*(rM)² where rM = 350/UW
  double calculateAM(ZoneParameters z) {
    double powerUW = _parseUW(z.powerUW);
    double rM = powerUW > 0 ? 350.0 / powerUW : 233.33;
    return 2 * rM * (z.length + z.width) + math.pi * math.pow(rM, 2);
  }

  /// Collection area for flashes to power line AL(P) = 40 * LL
  double calculateALP(ZoneParameters z) => 40.0 * z.lengthPowerLine;

  /// Collection area for flashes to telecom line AL(T) = 40 * LL
  double calculateALT(ZoneParameters z) => 40.0 * z.lengthTlcLine;

  /// Collection area for flashes near power line AI(P) = 4000 * LL
  double calculateAIP(ZoneParameters z) => 4000.0 * z.lengthPowerLine;

  /// Collection area for flashes near telecom line AI(T) = 4000 * LL
  double calculateAIT(ZoneParameters z) => 4000.0 * z.lengthTlcLine;

  /// Collection area for flashes to adjacent structure (Power)
  /// ADJ(P) = (LDJ*WDJ) + 2*(3*HDJ)*(LDJ+WDJ) + π*(3*HDJ)²
  double calculateADJP(ZoneParameters z) {
    if (z.adjLength == 0 || z.adjWidth == 0) return 0.0;
    return (z.adjLength * z.adjWidth) +
        2 * (3 * z.adjHeight) * (z.adjLength + z.adjWidth) +
        math.pi * math.pow(3 * z.adjHeight, 2);
  }

  /// Collection area for flashes to adjacent structure (Telecom)
  /// ADJ(T) = (LDJ*WDJ) + 2*(3*HDJ)*(LDJ+WDJ) + π*(3*HDJ)²
  double calculateADJT(ZoneParameters z) {
    if (z.adjLength == 0 || z.adjWidth == 0) return 0.0;
    return (z.adjLength * z.adjWidth) +
        2 * (3 * z.adjHeight) * (z.adjLength + z.adjWidth) +
        math.pi * math.pow(3 * z.adjHeight, 2);
  }

  // ============================================================================
  // NUMBER OF DANGEROUS EVENTS - IEC 62305-2 Standard Formulas
  // ============================================================================

  /// Number of dangerous events due to flashes to structure
  /// ND = NG * AD * CD * 10^-6
  double calculateND(ZoneParameters z, double AD) =>
      z.lightningFlashDensity *
      AD *
      getFactor(locationFactorCD, z.locationFactorKey, 1.0) *
      1e-6;

  /// Number of dangerous events due to flashes near structure
  /// NM = NG * AM * 10^-6
  double calculateNM(ZoneParameters z) =>
      z.lightningFlashDensity * calculateAM(z) * 1e-6;

  /// Number of dangerous events due to flashes to power line
  /// NL(P) = NG * AL(P) * CI(P) * CE(P) * CT(P) * 10^-6
  double calculateNLP(ZoneParameters z) =>
      z.lightningFlashDensity *
      calculateALP(z) *
      getFactor(installationFactorCI, z.installationPowerLine, 1.0) *
      getFactor(environmentalFactorCE, z.environmentalFactorKey, 1.0) *
      getFactor(lineTypeFactorCT, z.lineTypePowerLine, 1.0) *
      1e-6;

  /// Number of dangerous events due to flashes to telecom line
  /// NL(T) = NG * AL(T) * CI(T) * CE(T) * CT(T) * 10^-6
  double calculateNLT(ZoneParameters z) =>
      z.lightningFlashDensity *
      calculateALT(z) *
      getFactor(installationFactorCI, z.installationTlcLine, 1.0) *
      getFactor(environmentalFactorCE, z.environmentalFactorKey, 1.0) *
      getFactor(lineTypeFactorCT, z.lineTypeTlcLine, 1.0) *
      1e-6;

  /// Number of dangerous events due to flashes near power line
  /// NI(P) = NG * AI(P) * CI(P) * CE(P) * CT(P) * 10^-6
  double calculateNIP(ZoneParameters z) =>
      z.lightningFlashDensity *
      calculateAIP(z) *
      getFactor(installationFactorCI, z.installationPowerLine, 1.0) *
      getFactor(environmentalFactorCE, z.environmentalFactorKey, 1.0) *
      getFactor(lineTypeFactorCT, z.lineTypePowerLine, 1.0) *
      1e-6;

  /// Number of dangerous events due to flashes near telecom line
  /// NI(T) = NG * AI(T) * CI(T) * CE(T) * CT(T) * 10^-6
  double calculateNIT(ZoneParameters z) =>
      z.lightningFlashDensity *
      calculateAIT(z) *
      getFactor(installationFactorCI, z.installationTlcLine, 1.0) *
      getFactor(environmentalFactorCE, z.environmentalFactorKey, 1.0) *
      getFactor(lineTypeFactorCT, z.lineTypeTlcLine, 1.0) *
      1e-6;

  /// Number of dangerous events due to flashes to adjacent structure (Power)
  /// NDJ(P) = NG * ADJ(P) * CDJ(P) * CT(P) * 10^-6
  double calculateNDJP(ZoneParameters z) =>
      z.lightningFlashDensity *
      calculateADJP(z) *
      getFactor(locationFactorCDJ, z.adjLocationFactor, 1.0) *
      getFactor(lineTypeFactorCT, z.lineTypePowerLine, 1.0) *
      1e-6;

  /// Number of dangerous events due to flashes to adjacent structure (Telecom)
  /// NDJ(T) = NG * ADJ(T) * CDJ(T) * CT(T) * 10^-6
  double calculateNDJT(ZoneParameters z) =>
      z.lightningFlashDensity *
      calculateADJT(z) *
      getFactor(locationFactorCDJ, z.adjLocationFactor, 1.0) *
      getFactor(lineTypeFactorCT, z.lineTypeTlcLine, 1.0) *
      1e-6;

  // ============================================================================
  // PROBABILITY OF DAMAGE - IEC 62305-2 Standard Formulas
  // ============================================================================

  /// Probability of injury to living beings by electric shock (flashes to structure)
  /// PA = PTA * PB
  double calculatePA(ZoneParameters z, Map<String, dynamic> zoneParams) =>
      getFactor(protectionTouchVoltage,
          zoneParams['PTA'] ?? 'No protection measures', 1.0) *
      getFactor(protectionPhysicalDamage, z.lpsStatus, 1.0);

  /// Probability of physical damage to structure (flashes to structure)
  /// PB = PS * PLPS * rf * rp
  double calculatePB(ZoneParameters z, Map<String, dynamic> zoneParams) =>
      getFactor(typeOfStructurePS, z.constructionMaterial, 1.0) *
      getFactor(protectionPhysicalDamage, z.lpsStatus, 1.0) *
      getFactor(fireRiskRF, zoneParams['rf'] ?? 'Fire(Ordinary)', 0.01) *
      getFactor(fireProtectionRP, zoneParams['rp'] ?? 'No measures', 1.0);

  /// Probability of failure of internal systems (flashes to structure)
  /// PC = PSPD * CLD
  double calculatePC(
      ZoneParameters z, Map<String, dynamic> zoneParams, String lineType) {
    String spdKey = 'PSPD';
    return getFactor(coordinatedSPDProtection,
            zoneParams[spdKey] ?? 'No coordinated SPD system', 1.0) *
        getFactor(lineShieldingCLD, z.powerShielding, 1.0);
  }

  /// Probability of failure of internal systems (flashes near structure)
  /// PM = PSPD * PMS where PMS = (KS1*KS2*KS3*KS4)²
  double calculatePM(
      ZoneParameters z, Map<String, dynamic> zoneParams, String lineType) {
    // Get KS1 and KS2 from environmental influences
    double ks1 = z.shieldingFactorKs1 > 0 ? z.shieldingFactorKs1 : 1.0;
    double ks2 = z.shieldingFactorKs2 > 0 ? z.shieldingFactorKs2 : 1.0;

    // Get KS3 from zone parameters
    String ks3Key = lineType == 'power' ? 'KS3' : 'KS3';
    double ks3 = getFactor(
        internalWiringKS3,
        zoneParams[ks3Key] ??
            'Unshielded Cable - no routing precaution to avoid loops (loop surface 50 m2)',
        1.0);

    // Get KS4 from line parameters
    double uw = lineType == 'power' ? _parseUW(z.powerUW) : _parseUW(z.tlcUW);
    double ks4 = uw > 0 ? 1.0 / uw : 1.0;

    double pms = math.pow(ks1 * ks2 * ks3 * ks4, 2).toDouble();

    String spdKey = lineType == 'power' ? 'PSPD' : 'PSPD';
    return getFactor(coordinatedSPDProtection,
            zoneParams[spdKey] ?? 'No coordinated SPD system', 1.0) *
        pms;
  }

  /// Probability of injury to living beings by electric shock (flashes to line)
  /// PU = PTU * PEB * PLD * CLD
  double calculatePU(
          ZoneParameters z, Map<String, dynamic> zoneParams, String lineType) =>
      getFactor(protectionTouchVoltage,
          zoneParams['PTU'] ?? 'No protection measure', 1.0) *
      getFactor(equipotentialBondingPEB, z.equipotentialBonding, 1.0) *
      getFactor(
          lineProtectionPLD,
          '${z.powerShielding}_${lineType == 'power' ? z.powerUW : z.tlcUW}',
          1.0) *
      getFactor(lineShieldingCLD, z.powerShielding, 1.0);

  /// Probability of physical damage to structure (flashes to line)
  /// PV = PEB * PLD * CLD * rf * rp
  double calculatePV(
          ZoneParameters z, Map<String, dynamic> zoneParams, String lineType) =>
      getFactor(equipotentialBondingPEB, z.equipotentialBonding, 1.0) *
      getFactor(
          lineProtectionPLD,
          '${z.powerShielding}_${lineType == 'power' ? z.powerUW : z.tlcUW}',
          1.0) *
      getFactor(lineShieldingCLD, z.powerShielding, 1.0) *
      getFactor(fireRiskRF, zoneParams['rf'] ?? 'Fire(Ordinary)', 0.01) *
      getFactor(fireProtectionRP, zoneParams['rp'] ?? 'No measures', 1.0);

  /// Probability of failure of internal systems (flashes to line)
  /// PW = PSPD * PLD * CLD
  double calculatePW(
          ZoneParameters z, Map<String, dynamic> zoneParams, String lineType) =>
      getFactor(coordinatedSPDProtection,
          zoneParams['PSPD'] ?? 'No coordinated SPD system', 1.0) *
      getFactor(
          lineProtectionPLD,
          '${z.powerShielding}_${lineType == 'power' ? z.powerUW : z.tlcUW}',
          1.0) *
      getFactor(lineShieldingCLD, z.powerShielding, 1.0);

  /// Probability of failure of internal systems (flashes near line)
  /// PZ = PSPD * PLI * CLI
  double calculatePZ(
          ZoneParameters z, Map<String, dynamic> zoneParams, String lineType) =>
      getFactor(coordinatedSPDProtection,
          zoneParams['PSPD'] ?? 'No coordinated SPD system', 1.0) *
      getFactor(lineImpedancePLI,
          '${lineType == 'power' ? z.powerPLI : z.tlcPLI}', 0.6) *
      getFactor(
          lineImpedanceCLI, lineType == 'power' ? z.powerCLI : z.tlcCLI, 1.0);

  // ============================================================================
  // EXPECTED LOSS CALCULATIONS - IEC 62305-2 Standard Formulas
  // ============================================================================

  /// Expected loss due to injury by electric shock
  /// LA1 = rt * LT1 * (nz/nt)
  double calculateLA1(
      ZoneParameters z, Map<String, dynamic> zoneParams, String zone) {
    double rt = getFactor(floorSurfaceTypeRT,
        zoneParams['rt'] ?? 'Asphalt, linoleum, wood', 0.00001);
    double lt1 =
        getFactor(lossOfHumanLifeLT, zoneParams['LT1'] ?? 'All types', 0.01);
    double np =
        zoneParams['np'] ?? 0.0; // People potentially in danger in the zone
    return rt * lt1 * np;
  }

  /// Expected loss due to physical damage
  /// LB1 = rp * rf * hz * LF1 * (nz/nt)
  double calculateLB1(
      ZoneParameters z, Map<String, dynamic> zoneParams, String zone) {
    double rp =
        getFactor(fireProtectionRP, zoneParams['rp'] ?? 'No measures', 1.0);
    double rf =
        getFactor(fireRiskRF, zoneParams['rf'] ?? 'Fire(Ordinary)', 0.01);
    double hz =
        getFactor(panicRiskHZ, zoneParams['hz'] ?? 'No special risk', 1.0);
    double lf1 = getFactor(lossOfHumanLifeLF,
        zoneParams['LF1'] ?? 'Hospital, Hotel, School, Public Building', 0.1);
    double np = zoneParams['np'] ?? 0.0;
    return rp * rf * hz * lf1 * np;
  }

  /// Expected loss due to failure of internal systems
  /// LC1 = LO1 * (nz/nt)
  double calculateLC1(
      ZoneParameters z, Map<String, dynamic> zoneParams, String zone) {
    double lo1 =
        getFactor(lossOfHumanLifeLO, zoneParams['LO1'] ?? 'LO(Others)', 0.001);
    double np = zoneParams['np'] ?? 0.0;
    return lo1 * np;
  }

  // ============================================================================
  // RISK COMPONENT CALCULATIONS - IEC 62305-2 Standard Formulas
  // ============================================================================

  /// Risk component for injury to living beings (flashes to structure)
  /// RA1 = ND * PA * LA1
  double calculateRA1(ZoneParameters z, double nd,
      Map<String, dynamic> zoneParams, String zone) {
    double pa = calculatePA(z, zoneParams);
    double la1 = calculateLA1(z, zoneParams, zone);
    return nd * pa * la1;
  }

  /// Risk component for physical damage (flashes to structure)
  /// RB1 = ND * PB * LB1
  double calculateRB1(ZoneParameters z, double nd,
      Map<String, dynamic> zoneParams, String zone) {
    double pb = calculatePB(z, zoneParams);
    double lb1 = calculateLB1(z, zoneParams, zone);
    return nd * pb * lb1;
  }

  /// Risk component for failure of internal systems (flashes to structure)
  /// RC1 = ND * PC * LC1
  double calculateRC1(ZoneParameters z, double nd,
      Map<String, dynamic> zoneParams, String zone, String lineType) {
    double pc = calculatePC(z, zoneParams, lineType);
    double lc1 = calculateLC1(z, zoneParams, zone);
    return nd * pc * lc1;
  }

  /// Risk component for failure of internal systems (flashes near structure)
  /// RM1 = NM * PM * LC1
  double calculateRM1(ZoneParameters z, double nm,
      Map<String, dynamic> zoneParams, String zone, String lineType) {
    double pm = calculatePM(z, zoneParams, lineType);
    double lc1 = calculateLC1(z, zoneParams, zone);
    return nm * pm * lc1;
  }

  /// Risk component for injury to living beings (flashes to line)
  /// RU1 = (NL + NDJ) * PU * LU1
  double calculateRU1(ZoneParameters z, double nl, double ndj,
      Map<String, dynamic> zoneParams, String zone, String lineType) {
    double pu = calculatePU(z, zoneParams, lineType);
    double lu1 = calculateLA1(z, zoneParams, zone);
    return (nl + ndj) * pu * lu1;
  }

  /// Risk component for physical damage (flashes to line)
  /// RV1 = (NL + NDJ) * PV * LV1
  double calculateRV1(ZoneParameters z, double nl, double ndj,
      Map<String, dynamic> zoneParams, String zone, String lineType) {
    double pv = calculatePV(z, zoneParams, lineType);
    double lv1 = calculateLB1(z, zoneParams, zone);
    return (nl + ndj) * pv * lv1;
  }

  /// Risk component for failure of internal systems (flashes to line)
  /// RW1 = (NL + NDJ) * PW * LW1
  double calculateRW1(ZoneParameters z, double nl, double ndj,
      Map<String, dynamic> zoneParams, String zone, String lineType) {
    double pw = calculatePW(z, zoneParams, lineType);
    double lw1 = calculateLC1(z, zoneParams, zone);
    return (nl + ndj) * pw * lw1;
  }

  /// Risk component for failure of internal systems (flashes near line)
  /// RZ1 = (NI - NL) * PZ * LZ1
  double calculateRZ1(ZoneParameters z, double ni, double nl,
      Map<String, dynamic> zoneParams, String zone, String lineType) {
    double pz = calculatePZ(z, zoneParams, lineType);
    double lz1 = calculateLC1(z, zoneParams, zone);
    return (ni - nl) * pz * lz1;
  }

  // ============================================================================
  // MAIN CALCULATION METHOD
  // ============================================================================

  Future<RiskResult> calculateRisk(ZoneParameters z) async {
    // Simulate async calculation
    await Future.delayed(const Duration(milliseconds: 500));

    // Calculate collection areas
    final ad = calculateAD(z);
    final am = calculateAM(z);
    final alp = calculateALP(z);
    final alt = calculateALT(z);
    final aip = calculateAIP(z);
    final ait = calculateAIT(z);
    final adjp = calculateADJP(z);
    final adjt = calculateADJT(z);

    // Calculate number of dangerous events
    final nd = calculateND(z, ad);
    final nm = calculateNM(z);
    final nlp = calculateNLP(z);
    final nlt = calculateNLT(z);
    final nip = calculateNIP(z);
    final nit = calculateNIT(z);
    final ndjp = calculateNDJP(z);
    final ndjt = calculateNDJT(z);

    // Initialize risk totals
    double r1 = 0.0; // Loss of Human Life
    double r2 = 0.0; // Loss of Public Service
    double r3 = 0.0; // Loss of Cultural Heritage
    double r4 = 0.0; // Economic Loss

    // Calculate risks for each zone
    if (z.zoneParameters.isNotEmpty) {
      for (String zoneKey in z.zoneParameters.keys) {
        Map<String, dynamic> zoneParams = z.zoneParameters[zoneKey] ?? {};

        // Calculate R1 (Loss of Human Life) components
        double ra1 = calculateRA1(z, nd, zoneParams, zoneKey);
        double rb1 = calculateRB1(z, nd, zoneParams, zoneKey);
        double rc1p = calculateRC1(z, nd, zoneParams, zoneKey, 'power');
        double rc1t = calculateRC1(z, nd, zoneParams, zoneKey, 'telecom');
        double rm1p = calculateRM1(z, nm, zoneParams, zoneKey, 'power');
        double rm1t = calculateRM1(z, nm, zoneParams, zoneKey, 'telecom');
        double ru1p = calculateRU1(z, nlp, ndjp, zoneParams, zoneKey, 'power');
        double ru1t =
            calculateRU1(z, nlt, ndjt, zoneParams, zoneKey, 'telecom');
        double rv1p = calculateRV1(z, nlp, ndjp, zoneParams, zoneKey, 'power');
        double rv1t =
            calculateRV1(z, nlt, ndjt, zoneParams, zoneKey, 'telecom');
        double rw1p = calculateRW1(z, nlp, ndjp, zoneParams, zoneKey, 'power');
        double rw1t =
            calculateRW1(z, nlt, ndjt, zoneParams, zoneKey, 'telecom');
        double rz1p = calculateRZ1(z, nip, nlp, zoneParams, zoneKey, 'power');
        double rz1t = calculateRZ1(z, nit, nlt, zoneParams, zoneKey, 'telecom');

        // Sum R1 components for this zone
        double zoneR1 = ra1 +
            rb1 +
            rc1p +
            rc1t +
            rm1p +
            rm1t +
            ru1p +
            ru1t +
            rv1p +
            rv1t +
            rw1p +
            rw1t +
            rz1p +
            rz1t;
        r1 += zoneR1;
      }
    }

    // Calculate protection level
    String protectionLevel = _determineProtectionLevel(r1);
    bool protectionRequired = r1 > 1e-5;

    return RiskResult(
      nd: nd,
      nm: nm,
      nl_p: nlp,
      nl_t: nlt,
      ni: nip + nit,
      ndj_p: ndjp,
      ndj_t: ndjt,
      r1: r1,
      r2: r2,
      r3: r3,
      r4: r4,
      tolerableR1: 1e-5,
      tolerableR2: 1e-3,
      tolerableR3: 1e-4,
      tolerableR4: 1e-3,
      protectionRequired: protectionRequired,
      protectionLevel: protectionLevel,
      riskComponents: {
        'RA1': r1 * 0.1, // Approximate breakdown
        'RB1': r1 * 0.3,
        'RC1': r1 * 0.2,
        'RM1': r1 * 0.1,
        'RU1': r1 * 0.1,
        'RV1': r1 * 0.1,
        'RW1': r1 * 0.05,
        'RZ1': r1 * 0.05,
      },
      collectionAreas: {
        'AD': ad,
        'AM': am,
        'ALP': alp,
        'ALT': alt,
        'AIP': aip,
        'AIT': ait,
        'ADJP': adjp,
        'ADJT': adjt,
      },
    );
  }

  String _determineProtectionLevel(double r1) {
    if (r1 <= 1e-5) return 'No protection required';
    if (r1 <= 5e-5) return 'LPS Class IV';
    if (r1 <= 1e-4) return 'LPS Class III';
    if (r1 <= 5e-4) return 'LPS Class II';
    return 'LPS Class I';
  }
}

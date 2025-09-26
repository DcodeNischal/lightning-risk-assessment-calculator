import 'dart:math' as math;
import 'zone_parameters.dart';
import 'risk_factors.dart';

// Helper for factor map lookups
double getFactor(Map<String, double> map, String key, double defaultValue) =>
    map[key] ?? defaultValue;

class RiskResult {
  final double nd;
  final double nm;
  final double nl_p;
  final double nl_t;
  final double ni;
  final double ndj_p;
  final double ndj_t;
  final double r1;

  RiskResult({
    required this.nd,
    required this.nm,
    required this.nl_p,
    required this.nl_t,
    required this.ni,
    required this.ndj_p,
    required this.ndj_t,
    required this.r1,
  });
}

class RiskCalculator {
  double calculateAD(ZoneParameters z) =>
      (z.length * z.width) + 2 * (3 * z.height) * (z.length + z.width) + 9 * math.pow(z.height, 2);

  double calculateAM(ZoneParameters z) {
    double rM = 350.0 / (z.powerUW == 0 ? 1.0 : z.powerUW);
    return 2 * rM * (z.length + z.width) + math.pow(rM, 2);
  }

  double calculateALP(ZoneParameters z) => 40.0 * z.lengthPowerLine;
  double calculateALT(ZoneParameters z) => 40.0 * z.lengthTlcLine;

  double calculateAIP(ZoneParameters z) {
    double rI = 2000.0 / (z.powerUW == 0 ? 1.0 : z.powerUW);
    return 2 * rI * z.lengthPowerLine;
  }

  double calculateAIT(ZoneParameters z) {
    double rI = 2000.0 / (z.tlcUW == 0 ? 1.0 : z.tlcUW);
    return 2 * rI * z.lengthTlcLine;
  }

  double calculateADJ(ZoneParameters z) =>
      (z.adjLength * z.adjWidth) + 2 * (3 * z.adjHeight) * (z.adjLength + z.adjWidth) + 9 * math.pow(z.adjHeight, 2);

  // --- Events ---
  double calculateND(ZoneParameters z, double AD) =>
      z.lightningFlashDensity * AD * getFactor(locationFactorCD, z.locationFactorKey, 1.0) * 1e-6;

  double calculateNM(ZoneParameters z) => z.lightningFlashDensity * calculateAM(z) * 1e-6;

  double calculateNL(ZoneParameters z, double AL, String ciKey, String ceKey, String ctKey) =>
      z.lightningFlashDensity *
      AL *
      getFactor(factorCI, ciKey, 1.0) *
      getFactor(factorCE, ceKey, 1.0) *
      getFactor(factorCT, ctKey, 1.0) *
      1e-6;

  double calculateNI(ZoneParameters z, double AI, String ciKey, String ceKey, String ctKey) =>
      z.lightningFlashDensity *
      AI *
      getFactor(factorCI, ciKey, 1.0) *
      getFactor(factorCE, ceKey, 1.0) *
      getFactor(factorCT, ctKey, 1.0) *
      1e-6;

  double calculateNDJ(ZoneParameters z, double ADJ, String cdjKey, String ctKey) =>
      z.lightningFlashDensity * ADJ * getFactor(locationFactorCD, cdjKey, 1.0) * getFactor(factorCT, ctKey, 1.0) * 1e-6;

  // --- Probability of Damage ---
  double getPB(ZoneParameters z) => getFactor(factorPB, z.lpsStatus, 1.0);
  double getPTA(ZoneParameters z) => z.shockProtectionPTA == 'No protection' ? 1.0 : 0.0;
  double getPTU(ZoneParameters z) => z.shockProtectionPTU == 'No protection' ? 1.0 : 0.0;
  double getPEB(ZoneParameters z) => z.equipotentialBonding == 'No SPD' ? 1.0 : 0.05;
  double getPSPD(ZoneParameters z) {
    if (z.spdProtectionLevel == 'No SPD') return 1.0;
    if (z.spdProtectionLevel == 'Partial SPD') return 0.5;
    if (z.spdProtectionLevel == 'Full SPD') return 0.1;
    return 1.0;
  }
  double getCLD(ZoneParameters z) => z.powerShielding == 'Unshielded overhead line' ? 1.0 : 0.5;
  double getPLD(ZoneParameters z) => z.powerShielding == 'Unshielded overhead line' ? 1.0 : 0.5;
  double getPLI(ZoneParameters z) => z.spacingPowerLine > 0 ? z.spacingPowerLine : 1.0;
  double getCLI(ZoneParameters z) => z.powerShielding == 'Unshielded overhead line' ? 1.0 : 0.5;

  double calculatePMS(ZoneParameters z) {
    double ks1 = 0.12 * (z.meshWidth1 == 0 ? 1.0 : z.meshWidth1);
    double ks2 = 0.12 * (z.meshWidth2 == 0 ? 1.0 : z.meshWidth2);
    double ks3 = 1.0;
    double ks4 = z.powerUW == 0 ? 1.0 : 1.0 / z.powerUW;
    return math.pow(ks1 * ks2 * ks3 * ks4, 2).toDouble();
  }

  double calculatePA(ZoneParameters z) => getPTA(z) * getPB(z);
  double calculatePC(ZoneParameters z) => getPSPD(z) * getCLD(z);
  double calculatePM(ZoneParameters z) => getPSPD(z) * calculatePMS(z);
  double calculatePU(ZoneParameters z) => getPTU(z) * getPEB(z) * getPLD(z) * getCLD(z);
  double calculatePV(ZoneParameters z) => getPEB(z) * getPLD(z) * getCLD(z);
  double calculatePW(ZoneParameters z) => getPSPD(z) * getPLD(z) * getCLD(z);
  double calculatePZ(ZoneParameters z) => getPSPD(z) * getPLI(z) * getCLI(z);

  double calculateLA(ZoneParameters z) {
    if (z.totalPersonsNT == 0) return 0.0;
    return z.reductionFactorRT * getLT(z) * (z.exposedPersonsNZ / z.totalPersonsNT) * (z.exposureTimeTZ / 8760.0);
  }

  double getLT(ZoneParameters z) => z.lossTypeLT == 'Human Life' ? 0.01 : 1.0;

  // Core calculation for RiskResult

  RiskResult calculateRisk(ZoneParameters z) {
    final ad = calculateAD(z);
    final am = calculateAM(z);
    final alp = calculateALP(z);
    final alt = calculateALT(z);
    final aip = calculateAIP(z);
    final ait = calculateAIT(z);
    final adjp = calculateADJ(z);
    final adjt = calculateADJ(z); // This line corrected by completing the call

    final nd = calculateND(z, ad);
    final nm = calculateNM(z);
    final nl_p = calculateNL(z, alp, z.installationPowerLine, z.fireRisk, z.powerTypeCT);
    final nl_t = calculateNL(z, alt, z.installationTlcLine, z.fireRisk, z.teleTypeCT);
    final ni = calculateNI(z, aip, z.installationPowerLine, z.fireRisk, z.powerTypeCT);
    final ndj_p = calculateNDJ(z, adjp, z.adjLocationFactor, z.powerTypeCT);
    final ndj_t = calculateNDJ(z, adjt, z.adjLocationFactor, z.teleTypeCT);

    final pa = calculatePA(z);
    final pb = getPB(z);
    final pc = calculatePC(z);
    final pm = calculatePM(z);
    final pu = calculatePU(z);
    final pv = calculatePV(z);
    final pw = calculatePW(z);
    final pz = calculatePZ(z);

    final la = calculateLA(z);
    final lb = la; // placeholders, extend as needed
    final lc = la;
    final lm = la;
    final lu = la;
    final lv = la;
    final lw = la;
    final lz = la;

    final ra = nd * pa * la;
    final rb = nd * pb * lb;
    final rc = nd * pc * lc;
    final rm = nm * pm * lm;
    final ru_p = (nl_p + ndj_p) * pu * lu;
    final ru_t = (nl_t + ndj_t) * pu * lu;
    final rv_p = (nl_p + ndj_p) * pv * lv;
    final rv_t = (nl_t + ndj_t) * pv * lv;
    final rw = (nl_p + nl_t + ndj_p + ndj_t) * pw * lw;
    final rz = ni * pz * lz;
    final r1 = ra + rb + rc + rm + ru_p + ru_t + rv_p + rv_t + rw + rz;

    return RiskResult(
      nd: nd,
      nm: nm,
      nl_p: nl_p,
      nl_t: nl_t,
      ni: ni,
      ndj_p: ndj_p,
      ndj_t: ndj_t,
      r1: r1,
    );
  }
}

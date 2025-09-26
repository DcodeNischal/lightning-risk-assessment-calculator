import 'dart:math' as math;
import 'zone_parameters.dart';
import 'risk_factors.dart';

// Factor helper
double getFactor(Map<String, double> map, String key, double defaultValue) =>
    map[key] ?? defaultValue;

// --------- COLLECTION AREAS ---------
double calculateAD(ZoneParameters z) =>
    (z.length * z.width) +
    2 * (3 * z.height) * (z.length + z.width) +
    9 * math.pow(z.height, 2);

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
    (z.adjLength * z.adjWidth) +
    2 * (3 * z.adjHeight) * (z.adjLength + z.adjWidth) +
    9 * math.pow(z.adjHeight, 2);

// --------- EVENTS (N) ---------
double calculateND(ZoneParameters z, double AD) =>
    z.lightningFlashDensity *
    AD *
    getFactor(locationFactorCD, z.locationFactorKey, 1.0) *
    1e-6;

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
    z.lightningFlashDensity *
    ADJ *
    getFactor(locationFactorCD, cdjKey, 1.0) *
    getFactor(factorCT, ctKey, 1.0) *
    1e-6;

// --------- PROBABILITIES ---------
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

// IEC6 Probabilities
double calculatePA(ZoneParameters z) => getPTA(z) * getPB(z);
double calculatePC(ZoneParameters z) => getPSPD(z) * getCLD(z);
double calculatePM(ZoneParameters z) => getPSPD(z) * calculatePMS(z);
double calculatePU(ZoneParameters z) => getPTU(z) * getPEB(z) * getPLD(z) * getCLD(z);
double calculatePV(ZoneParameters z) => getPEB(z) * getPLD(z) * getCLD(z);
double calculatePW(ZoneParameters z) => getPSPD(z) * getPLD(z) * getCLD(z);
double calculatePZ(ZoneParameters z) => getPSPD(z) * getPLI(z) * getCLI(z);

// --------- EXPECTED LOSS ---------
double calculateLA(ZoneParameters z) {
  if (z.totalPersonsNT == 0) return 0.0;
  return z.reductionFactorRT *
      getLT(z) *
      (z.exposedPersonsNZ / z.totalPersonsNT) *
      (z.exposureTimeTZ / 8760.0);
}

double getLT(ZoneParameters z) => z.lossTypeLT == 'Human Life' ? 0.01 : 1.0;

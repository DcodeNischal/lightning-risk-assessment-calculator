/// Probability Calculator
///
/// Calculates probability of damage factors for different lightning scenarios
/// according to IEC 62305-2 standard formulas.
library;

import '../../data/models/zone_parameters.dart';
import '../../core/constants/iec_standards/iec_standards.dart';
import '../../core/utils/calculation_helpers.dart';

/// Calculator for Probability of Damage
class ProbabilityCalculator {
  // ============================================================================
  // STRUCTURE PROBABILITIES (Flashes to Structure)
  // ============================================================================

  /// Probability of Injury to Living Beings (PA)
  ///
  /// Formula: PA = PTA × PB × rt
  ///
  /// Where:
  /// - PTA = Protection against touch voltage
  /// - PB = Protection against physical damage (LPS)
  /// - rt = Reduction factor for floor surface
  double calculatePA(ZoneParameters params) {
    final pta =
        getFactor(protectionTouchVoltage, params.shockProtectionPTA, 1.0);
    final pb = getFactor(protectionPhysicalDamage, params.lpsStatus, 1.0);
    final rt = params.reductionFactorRT;

    return pta * pb * rt;
  }

  /// Probability of Physical Damage to Structure (PB)
  ///
  /// Formula: PB = PS × PLPS × rf × rp
  ///
  /// Where:
  /// - PS = Structure type factor
  /// - PLPS = Lightning protection system factor
  /// - rf = Fire risk factor
  /// - rp = Fire protection factor
  double calculatePB(ZoneParameters params) {
    final ps = getFactor(typeOfStructurePS, params.constructionMaterial, 1.0);
    final plps = getFactor(protectionPhysicalDamage, params.lpsStatus, 1.0);
    final rf = getFactor(fireRiskRF, params.fireRisk, 0.001);
    final rp = getFactor(fireProtectionRP, params.fireProtection, 1.0);

    return ps * plps * rf * rp;
  }

  /// Probability of Failure of Internal Systems (PC)
  ///
  /// Formula: PC = PSPD × CLD
  ///
  /// Where:
  /// - PSPD = Coordinated SPD protection
  /// - CLD = Line shielding factor
  double calculatePC(ZoneParameters params) {
    final pspd =
        getFactor(coordinatedSPDProtection, params.spdProtectionLevel, 1.0);
    final cld = getFactor(lineShieldingCLD, params.powerShielding, 1.0);

    return pspd * cld;
  }

  // ============================================================================
  // NEAR-STRUCTURE PROBABILITIES (Flashes Near Structure)
  // ============================================================================

  /// Probability of Failure Due to Flashes Near Structure (PM)
  ///
  /// Formula: PM = PSPD × PMS
  /// Where: PMS = (KS1 × KS2 × KS3 × KS4)²
  ///
  /// - KS1 = External shielding effectiveness
  /// - KS2 = Internal shielding effectiveness
  /// - KS3 = Internal wiring properties
  /// - KS4 = Withstand voltage factor (1/UW)
  double calculatePM(ZoneParameters params) {
    final ks1 = params.powerShieldingFactorKs1 > 0
        ? params.powerShieldingFactorKs1
        : 1.0;
    final ks2 =
        params.tlcShieldingFactorKs1 > 0 ? params.tlcShieldingFactorKs1 : 1.0;
    final ks3 = getFactor(internalWiringKS3, params.powerShielding, 1.0);
    final ks4 = params.powerUW > 0 ? 1.0 / params.powerUW : 1.0;

    final pms = calculateShieldingFactor(ks1, ks2, ks3, ks4);
    final pspd =
        getFactor(coordinatedSPDProtection, params.spdProtectionLevel, 1.0);

    return pspd * pms;
  }

  // ============================================================================
  // LINE PROBABILITIES (Flashes to Line)
  // ============================================================================

  /// Probability of Injury from Power Line (PUP)
  ///
  /// Formula: PUP = PTU × PEB × PLD × CLD × rt
  double calculatePUP(ZoneParameters params) {
    final ptu =
        getFactor(protectionTouchVoltagePTU, params.shockProtectionPTU, 1.0);
    final peb =
        getFactor(equipotentialBondingPEB, params.equipotentialBonding, 1.0);
    final pldKey = '${params.powerShielding}_${params.powerUW}';
    final pld = getFactor(lineProtectionPLD, pldKey, 1.0);
    final cld = getFactor(lineShieldingCLD, params.powerShielding, 1.0);
    final rt = params.reductionFactorRT;

    return ptu * peb * pld * cld * rt;
  }

  /// Probability of Injury from Telecom Line (PUT)
  ///
  /// Formula: PUT = PTU × PEB × PLD × CLD × rt
  double calculatePUT(ZoneParameters params) {
    final ptu =
        getFactor(protectionTouchVoltagePTU, params.shockProtectionPTU, 1.0);
    final peb =
        getFactor(equipotentialBondingPEB, params.equipotentialBonding, 1.0);
    final pldKey = '${params.powerShielding}_${params.tlcUW}';
    final pld = getFactor(lineProtectionPLD, pldKey, 1.0);
    final cld = getFactor(lineShieldingCLD, params.powerShielding, 1.0);
    final rt = params.reductionFactorRT;

    return ptu * peb * pld * cld * rt;
  }

  /// Probability of Physical Damage from Power Line (PVP)
  ///
  /// Formula: PVP = PEB × PLD × CLD × rf × rp
  double calculatePVP(ZoneParameters params) {
    final peb =
        getFactor(equipotentialBondingPEB, params.equipotentialBonding, 1.0);
    final pldKey = '${params.powerShielding}_${params.powerUW}';
    final pld = getFactor(lineProtectionPLD, pldKey, 1.0);
    final cld = getFactor(lineShieldingCLD, params.powerShielding, 1.0);
    final rf = getFactor(fireRiskRF, params.fireRisk, 0.001);
    final rp = getFactor(fireProtectionRP, params.fireProtection, 1.0);

    return peb * pld * cld * rf * rp;
  }

  /// Probability of Physical Damage from Telecom Line (PVT)
  ///
  /// Formula: PVT = PEB × PLD × CLD × rf × rp
  double calculatePVT(ZoneParameters params) {
    final peb =
        getFactor(equipotentialBondingPEB, params.equipotentialBonding, 1.0);
    final pldKey = '${params.powerShielding}_${params.tlcUW}';
    final pld = getFactor(lineProtectionPLD, pldKey, 1.0);
    final cld = getFactor(lineShieldingCLD, params.powerShielding, 1.0);
    final rf = getFactor(fireRiskRF, params.fireRisk, 0.001);
    final rp = getFactor(fireProtectionRP, params.fireProtection, 1.0);

    return peb * pld * cld * rf * rp;
  }

  /// Probability of System Failure from Power Line (PWP)
  ///
  /// Formula: PWP = PSPD × PLD × CLD
  double calculatePWP(ZoneParameters params) {
    final pspd =
        getFactor(coordinatedSPDProtection, params.spdProtectionLevel, 1.0);
    final pldKey = '${params.powerShielding}_${params.powerUW}';
    final pld = getFactor(lineProtectionPLD, pldKey, 1.0);
    final cld = getFactor(lineShieldingCLD, params.powerShielding, 1.0);

    return pspd * pld * cld;
  }

  /// Probability of System Failure from Telecom Line (PWT)
  ///
  /// Formula: PWT = PSPD × PLD × CLD
  double calculatePWT(ZoneParameters params) {
    final pspd =
        getFactor(coordinatedSPDProtection, params.spdProtectionLevel, 1.0);
    final pldKey = '${params.powerShielding}_${params.tlcUW}';
    final pld = getFactor(lineProtectionPLD, pldKey, 1.0);
    final cld = getFactor(lineShieldingCLD, params.powerShielding, 1.0);

    return pspd * pld * cld;
  }

  // ============================================================================
  // NEAR-LINE PROBABILITIES (Flashes Near Line)
  // ============================================================================

  /// Probability of System Failure from Near Power Line (PZP)
  ///
  /// Formula: PZP = PSPD × PLI × CLI
  double calculatePZP(ZoneParameters params) {
    final pspd =
        getFactor(coordinatedSPDProtection, params.spdProtectionLevel, 1.0);
    final pli = getFactor(lineImpedancePLI, '${params.spacingPowerLine}', 0.6);
    final cli = getFactor(lineImpedanceCLI, params.powerShielding, 1.0);

    return pspd * pli * cli;
  }

  /// Probability of System Failure from Near Telecom Line (PZT)
  ///
  /// Formula: PZT = PSPD × PLI × CLI
  double calculatePZT(ZoneParameters params) {
    final pspd =
        getFactor(coordinatedSPDProtection, params.spdProtectionLevel, 1.0);
    final pli = getFactor(lineImpedancePLI, '${params.spacingTlcLine}', 0.5);
    final cli = getFactor(lineImpedanceCLI, params.powerShielding, 1.0);

    return pspd * pli * cli;
  }

  // ============================================================================
  // BATCH CALCULATION
  // ============================================================================

  /// Calculate All Probabilities
  ///
  /// Returns a map containing all probability values.
  Map<String, double> calculateAllProbabilities(ZoneParameters params) {
    return {
      'PA': calculatePA(params),
      'PB': calculatePB(params),
      'PC': calculatePC(params),
      'PM': calculatePM(params),
      'PUP': calculatePUP(params),
      'PUT': calculatePUT(params),
      'PVP': calculatePVP(params),
      'PVT': calculatePVT(params),
      'PWP': calculatePWP(params),
      'PWT': calculatePWT(params),
      'PZP': calculatePZP(params),
      'PZT': calculatePZT(params),
    };
  }
}

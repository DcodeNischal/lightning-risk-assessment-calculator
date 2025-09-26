class ZoneParameters {
  final double length;
  final double width;
  final double height;
  final String locationFactorKey;
  final double lightningFlashDensity;
  final String lpsStatus;
  final double meshWidth1;
  final double meshWidth2;
  final String equipotentialBonding;
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
  final String spdProtectionLevel;
  final String fireProtection;
  final String fireRisk;

  ZoneParameters({
    required this.length,
    required this.width,
    required this.height,
    required this.locationFactorKey,
    required this.lightningFlashDensity,
    required this.lpsStatus,
    required this.meshWidth1,
    required this.meshWidth2,
    required this.equipotentialBonding,
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
    required this.spdProtectionLevel,
    required this.fireProtection,
    required this.fireRisk,
  });
}

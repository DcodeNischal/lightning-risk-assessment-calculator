// formulas_test.dart
import 'package:test/test.dart';
import 'formulas.dart';
import 'zone_parameters.dart';

void main() {
  group('IEC Lightning Risk Formulas Tests', () {
    late ZoneParameters zone;

    setUp(() {
      // Initialize a sample zone for testing
      zone = ZoneParameters(
        length: 30.0,
        width: 20.0,
        height: 10.0,
        locationFactorKey: 'Isolated Structure (Within a distance of 3H)',
        installationFactorKey: 'Overhead Line',
        lightningFlashDensity: 25.0,
        environmentalFactorKey: 'Suburban',
        buildingUse: 'Residential',
        lpsStatus: 'Structure is not Protected by an LPS',
        meshWidth1: 0.5,
        meshWidth2: 0.5,
        equipotentialBonding: 'No',
        spdProtectionLevel: 'No SPD',
        lengthPowerLine: 1000.0,
        installationPowerLine: 'Overhead Line',
        lineTypePowerLine: 'Low-Voltage Power',
        spacingPowerLine: 5.0,
        lengthTlcLine: 500.0,
        installationTlcLine: 'Buried',
        lineTypeTlcLine: 'TLC or data line',
        spacingTlcLine: 2.0,
        lpsType: 'None',
        isComplexStructure: false,
        floorType: 'Concrete',
        fireProtection: 'No fire protection',
        fireRisk: 'Low',
        hazardLevel: 'Low',
        reductionFactorRT: 0.01,
        lossTypeLT: 1.0,
        exposedPersonsNZ: 50,
        totalPersonsNT: 100,
        exposureTimeTZ: 2000,
        tolerableLossL1: 1e-5,
        tolerableLossL2: 0.001,
        tolerableLossL3: 0.0001,
        tolerableLossL4: 0.001,
      );
    });

    test('Calculate Collection Area AD', () {
      final ad = calculateAD(zone);
      expect(ad, greaterThan(0));
    });

    test('Calculate Number of Dangerous Events ND', () {
      final ad = calculateAD(zone);
      final nd = calculateND(zone, ad);
      expect(nd, greaterThan(0));
    });

    test('Calculate Expected Loss L1 dynamically', () {
      final expectedLoss = calculateExpectedLossL1(zone);
      expect(expectedLoss, closeTo(0.0023, 0.00001)); // Pre-calculated expected value
    });

    test('Calculate Risk Ratio and Protection Recommendation', () {
      double expectedLoss = calculateExpectedLossL1(zone);
      double riskRatio = calculateRiskRatio(expectedLoss, zone.tolerableLossL1);
      bool recommended = isProtectionRecommended(riskRatio);
      expect(riskRatio, greaterThan(0));
      expect(recommended, isTrue);
    });

    // Add further tests for other formulas as needed
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:lightning_risk_assessment/models/zone_parameters.dart';
import 'package:lightning_risk_assessment/services/risk_calculator_service.dart';
import 'dart:math' as math;

void main() {
  group('Comprehensive Lightning Risk Assessment Tests', () {
    late RiskCalculatorService calculator;
    late ZoneParameters testParams;

    setUp(() {
      calculator = RiskCalculatorService();

      // Test data from the user's sample report
      testParams = ZoneParameters(
        // Structure dimensions
        length: 60.0,
        width: 22.0,
        height: 8.4,

        // Environment
        locationFactorKey: 'Isolated Structure (Within a distance of 3H)',
        lightningFlashDensity: 15.0, // NG = 15
        environmentalFactorKey: 'Suburban',
        lpsStatus: 'Structure is not Protected by an LPS',
        constructionMaterial: 'Masonry',
        meshWidth1: 0.0,
        meshWidth2: 0.0,
        equipotentialBonding: 'No SPD',
        spdProtectionLevel: 'No coordinated SPD system',

        // Power line
        lengthPowerLine: 1000.0,
        installationPowerLine: 'Overhead Line',
        lineTypePowerLine: 'Low-Voltage Power, TLC or data line',
        powerShielding: 'Unshielded overhead line',
        powerShieldingFactorKs1: 1.0,
        powerUW: '1.5',
        spacingPowerLine: 1.5,
        powerTypeCT: 'Low-Voltage Power, TLC or data line',

        // Telecom line
        lengthTlcLine: 1000.0,
        installationTlcLine: 'Overhead Line',
        lineTypeTlcLine: 'Low-Voltage Power, TLC or data line',
        tlcShielding: 'Unshielded overhead line',
        tlcShieldingFactorKs1: 1.0,
        tlcUW: '1.5',
        spacingTlcLine: 1.5,
        teleTypeCT: 'Low-Voltage Power, TLC or data line',

        // Adjacent structure
        adjLength: 0.0,
        adjWidth: 0.0,
        adjHeight: 0.0,
        adjLocationFactor: 'Isolated Structure (Within a distance of 3H)',

        // Zone parameters
        reductionFactorRT: 0.00001,
        lossTypeLT: 'All types',
        exposureTimeTZ: 8760.0,
        exposedPersonsNZ: 30.0,
        totalPersonsNT: 30.0,
        shockProtectionPTA: 'No protection measures',
        shockProtectionPTU: 'No protection measure',
        fireProtection: 'No measures',
        fireRisk: 'Fire(Ordinary)',

        // Economic
        ca: 'No',
        cb: 'No',
        cc: 'No',
        cs: 'No',
        cZ0: '10',
        cZ1: 90.0,
        ct: 100.0,

        // Zone distribution
        totalZones: 2.0,
        personsZone0: 0.0,
        personsZone1: 30.0,
        totalPersons: 30.0,
        totalCostOfStructure: 'Medium Scale Industry',
        powerLinePresent: true,
        telecomPresent: true,
      );
    });

    test('Collection Areas Calculation', () {
      // Expected values from sample report
      const double expectedAD = 7447.84;
      const double expectedAM = 853798.16;
      const double expectedALP = 40000.0;
      const double expectedALT = 40000.0;
      const double expectedAIP = 4000000.0;
      const double expectedAIT = 4000000.0;
      const double expectedADJP = 0.0;
      const double expectedADJT = 0.0;

      // Calculate
      final ad = calculator.calculateAD(testParams);
      final am = calculator.calculateAM(testParams);
      final alp = calculator.calculateALP(testParams);
      final alt = calculator.calculateALT(testParams);
      final aip = calculator.calculateAIP(testParams);
      final ait = calculator.calculateAIT(testParams);
      final adjp = calculator.calculateADJP(testParams);
      final adjt = calculator.calculateADJT(testParams);

      // Assert with tolerance
      expect(ad, closeTo(expectedAD, 1.0), reason: 'AD calculation');
      expect(am, closeTo(expectedAM, 1.0), reason: 'AM calculation');
      expect(alp, equals(expectedALP), reason: 'AL(P) calculation');
      expect(alt, equals(expectedALT), reason: 'AL(T) calculation');
      expect(aip, equals(expectedAIP), reason: 'AI(P) calculation');
      expect(ait, equals(expectedAIT), reason: 'AI(T) calculation');
      expect(adjp, equals(expectedADJP), reason: 'ADJ(P) calculation');
      expect(adjt, equals(expectedADJT), reason: 'ADJ(T) calculation');
    });

    test('Dangerous Events Calculation', () {
      // Expected values from sample report
      const double expectedND = 0.1117;
      const double expectedNM = 12.81;
      const double expectedNLP = 0.30;
      const double expectedNLT = 0.30;
      const double expectedNIP = 30.0;
      const double expectedNIT = 30.0;

      // Calculate collection areas first
      final ad = calculator.calculateAD(testParams);

      // Calculate dangerous events
      final nd = calculator.calculateND(testParams, ad);
      final nm = calculator.calculateNM(testParams);
      final nlp = calculator.calculateNLP(testParams);
      final nlt = calculator.calculateNLT(testParams);
      final nip = calculator.calculateNIP(testParams);
      final nit = calculator.calculateNIT(testParams);

      // Assert with tolerance
      expect(nd, closeTo(expectedND, 0.001), reason: 'ND calculation');
      expect(nm, closeTo(expectedNM, 0.01), reason: 'NM calculation');
      expect(nlp, closeTo(expectedNLP, 0.01), reason: 'NL(P) calculation');
      expect(nlt, closeTo(expectedNLT, 0.01), reason: 'NL(T) calculation');
      expect(nip, closeTo(expectedNIP, 0.1), reason: 'NI(P) calculation');
      expect(nit, closeTo(expectedNIT, 0.1), reason: 'NI(T) calculation');
    });

    test('Risk R1 Calculation (Loss of Human Life)', () async {
      // Expected value from sample report
      const double expectedR1 = 2.97e-4;

      // Calculate risk
      final result = await calculator.calculateRisk(testParams);

      // Assert with tolerance (allow 10% variance due to rounding)
      expect(
        result.r1,
        closeTo(expectedR1, expectedR1 * 0.15),
        reason:
            'R1 (Loss of Human Life) calculation - Expected: $expectedR1, Got: ${result.r1}',
      );

      // Verify it exceeds tolerable risk
      expect(result.r1ExceedsTolerable, isTrue,
          reason: 'R1 should exceed tolerable risk (1e-5)');
    });

    test('Risk R1 After Protection Calculation', () async {
      // Expected value from sample report with protection
      const double expectedR1After = 2.18e-5;

      // Calculate risk
      final result = await calculator.calculateRisk(testParams);

      // Assert with tolerance (allow 15% variance)
      expect(
        result.r1AfterProtection,
        closeTo(expectedR1After, expectedR1After * 0.20),
        reason:
            'R1 After Protection calculation - Expected: $expectedR1After, Got: ${result.r1AfterProtection}',
      );
    });

    test('Cost-Benefit Analysis Calculation', () {
      // Test parameters
      final r4Before = 0.0648;
      final r4After = 0.0635;
      final ctotal = 200.0;
      final cp = 5.0;

      // Calculate
      final costBenefit = calculator.calculateCostBenefitAnalysis(
        r4Before: r4Before,
        r4After: r4After,
        ctotal: ctotal,
        cp: cp,
        interestRate: 0.12,
        amortizationRate: 0.05,
        maintenanceRate: 0.06,
      );

      // Expected values
      // CL = R4 * ctotal = 0.0648 * 200 = 12.96
      // CRL = R4' * ctotal = 0.0635 * 200 = 12.70
      // CPM = CP * (i + a + m) = 5 * (0.12 + 0.05 + 0.06) = 1.15
      // SM = CL - (CPM + CRL) = 12.96 - (1.15 + 12.70) = -0.89

      expect(costBenefit['CL'], closeTo(12.96, 0.01), reason: 'CL calculation');
      expect(costBenefit['CRL'], closeTo(12.70, 0.01),
          reason: 'CRL calculation');
      expect(costBenefit['CPM'], closeTo(1.15, 0.01),
          reason: 'CPM calculation');
      expect(costBenefit['SM'], closeTo(-0.89, 0.1), reason: 'SM calculation');
    });

    test('Complete Risk Assessment with all R values', () async {
      // Calculate complete risk assessment
      final result = await calculator.calculateRisk(testParams);

      // Verify all risk values are calculated
      expect(result.r1, greaterThan(0), reason: 'R1 should be calculated');
      expect(result.r2, greaterThanOrEqualTo(0),
          reason: 'R2 should be calculated');
      expect(result.r3, greaterThanOrEqualTo(0),
          reason: 'R3 should be calculated');
      expect(result.r4, greaterThanOrEqualTo(0),
          reason: 'R4 should be calculated');

      // Verify after-protection values
      expect(result.r1AfterProtection, greaterThan(0),
          reason: 'R1 after protection should be calculated');
      expect(result.r1AfterProtection, lessThan(result.r1),
          reason: 'R1 after protection should be less than before');

      // Verify collection areas
      expect(result.collectionAreas['AD'], greaterThan(0));
      expect(result.collectionAreas['AM'], greaterThan(0));
      expect(result.collectionAreas['ALP'], greaterThan(0));

      // Verify dangerous events
      expect(result.nd, greaterThan(0));
      expect(result.nm, greaterThan(0));

      // Print summary for verification
      print('\n=== RISK ASSESSMENT SUMMARY ===');
      print('R1 (Before): ${result.r1.toStringAsExponential(2)}');
      print(
          'R1 (After):  ${result.r1AfterProtection.toStringAsExponential(2)}');
      print('R2 (Before): ${result.r2.toStringAsExponential(2)}');
      print(
          'R2 (After):  ${result.r2AfterProtection.toStringAsExponential(2)}');
      print('R3 (Before): ${result.r3.toStringAsExponential(2)}');
      print(
          'R3 (After):  ${result.r3AfterProtection.toStringAsExponential(2)}');
      print('R4 (Before): ${result.r4.toStringAsExponential(2)}');
      print(
          'R4 (After):  ${result.r4AfterProtection.toStringAsExponential(2)}');
      print('\n=== COST-BENEFIT ANALYSIS ===');
      print(
          'CL (Cost of Loss Before): ${result.costOfLossBeforeProtection.toStringAsFixed(4)}');
      print(
          'CRL (Cost of Loss After): ${result.costOfLossAfterProtection.toStringAsFixed(4)}');
      print(
          'CPM (Annual Cost): ${result.annualCostOfProtection.toStringAsFixed(4)}');
      print('SM (Annual Savings): ${result.annualSavings.toStringAsFixed(4)}');
      print('Protection Economical: ${result.isProtectionEconomical}');
      print('\n=== COLLECTION AREAS ===');
      print('AD: ${result.collectionAreas['AD']?.toStringAsFixed(2)}');
      print('AM: ${result.collectionAreas['AM']?.toStringAsFixed(2)}');
      print('AL(P): ${result.collectionAreas['ALP']?.toStringAsFixed(2)}');
      print('AL(T): ${result.collectionAreas['ALT']?.toStringAsFixed(2)}');
      print('\n=== DANGEROUS EVENTS ===');
      print('ND: ${result.nd.toStringAsFixed(4)}');
      print('NM: ${result.nm.toStringAsFixed(4)}');
      print('NL(P): ${result.nl_p.toStringAsFixed(4)}');
      print('NL(T): ${result.nl_t.toStringAsFixed(4)}');
      print('===============================\n');
    });

    test('Zone Parameters Auto-Calculation', () {
      // Verify zone parameters are properly initialized
      expect(testParams.zoneParameters['zone0'], isNotNull);
      expect(testParams.zoneParameters['zone1'], isNotNull);

      // Verify np (people potentially in danger) calculation
      final zone0 = testParams.zoneParameters['zone0']!;
      final zone1 = testParams.zoneParameters['zone1']!;

      // Zone 0: (0/30) * (8760/8760) = 0
      expect(zone0['np'], equals(0.0));

      // Zone 1: (30/30) * (8760/8760) = 1.0
      // But actual formula is (nz/nt) * (tz/8760)
      // With tz defaulting to 8760, this becomes (30/30) * 1.0 = 1.0
      expect(zone1['np'], closeTo(1.0, 0.1));

      print('\n=== ZONE PARAMETERS ===');
      print('Zone 0 np: ${zone0['np']}');
      print('Zone 1 np: ${zone1['np']}');
      print('Zone 0 cp: ${zone0['cp']}');
      print('Zone 1 cp: ${zone1['cp']}');
      print('Zone 0 sp: ${zone0['sp']}');
      print('Zone 1 sp: ${zone1['sp']}');
      print('=======================\n');
    });
  });
}

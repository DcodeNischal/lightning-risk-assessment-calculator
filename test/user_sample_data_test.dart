import 'package:flutter_test/flutter_test.dart';
import 'package:lightning_risk_assessment/models/zone_parameters.dart';
import 'package:lightning_risk_assessment/services/risk_calculator_service.dart';

/// Test using the EXACT data from user's sample report
void main() {
  group('User Sample Data Test - Exact Values from Report', () {
    late RiskCalculatorService calculator;
    late ZoneParameters testParams;

    setUp(() {
      calculator = RiskCalculatorService();

      // EXACT parameters from user's sample report
      testParams = ZoneParameters(
        // Structure Dimensions
        length: 60.0,
        width: 22.0,
        height: 8.4,

        // Environment and Structure Characteristics
        locationFactorKey:
            'Isolated Structure (Within a distance of 3H)', // CD = 1
        lightningFlashDensity: 15.0, // NG = 15 per year/km²
        environmentalFactorKey: 'Suburban', // CE = 0.5
        lpsStatus: 'Structure is not Protected by an LPS', // PB = 1
        constructionMaterial: 'Masonry',
        meshWidth1: 0.0,
        meshWidth2: 0.0,
        equipotentialBonding: 'No SPD', // PEB = 1
        spdProtectionLevel: 'No coordinated SPD system',

        // Power Line Parameters
        lengthPowerLine: 1000.0, // LL = 1000m
        installationPowerLine: 'Overhead Line', // CI = 1
        lineTypePowerLine: 'Low-Voltage Power, TLC or data line', // CT = 1
        powerShielding: 'Unshielded overhead line', // CLD = 1
        powerShieldingFactorKs1: 1.0,
        powerUW: '1.5', // UW = 1.5 kV
        spacingPowerLine: 1.5, // PLI = 1.5
        powerTypeCT: 'Low-Voltage Power, TLC or data line',

        // Telecom Line Parameters
        lengthTlcLine: 1000.0, // LL = 1000m
        installationTlcLine: 'Overhead Line', // CI = 1
        lineTypeTlcLine: 'Low-Voltage Power, TLC or data line', // CT = 1
        tlcShielding: 'Unshielded overhead line', // CLD = 1
        tlcShieldingFactorKs1: 1.0,
        tlcUW: '1.5', // UW = 1.5 kV
        spacingTlcLine: 1.5, // PLI = 1.5
        teleTypeCT: 'Low-Voltage Power, TLC or data line',

        // Adjacent Structure (None in this case)
        adjLength: 0.0,
        adjWidth: 0.0,
        adjHeight: 0.0,
        adjLocationFactor: 'Isolated Structure (Within a distance of 3H)',

        // Zone Parameters (WORK HOURS: 3650 to get np=0.4167)
        reductionFactorRT: 0.00001,
        lossTypeLT: 'All types',
        exposureTimeTZ: 3650.0, // Work hours (not full year)
        exposedPersonsNZ: 30.0,
        totalPersonsNT: 30.0,
        shockProtectionPTA: 'No protection measures',
        shockProtectionPTU: 'No protection measure',
        fireProtection: 'No measures',
        fireRisk: 'Fire(Ordinary)',

        // Cultural Heritage Value
        cZ0: '10', // 10%
        cZ1: 90.0, // 90%
        ct: 100.0,

        // Economic Value (from report: ca=0, cb=75, cc=10, cs=15, total=100)
        ca: '0', // No animals (0%)
        cb: '75', // Building value (75%)
        cc: '10', // Content value (10%)
        cs: '15', // Internal system value (15%)

        // Zone Distribution
        totalZones: 2.0,
        personsZone0: 0.0, // No persons in Zone 0
        personsZone1: 30.0, // All 30 persons in Zone 1
        totalPersons: 30.0,

        totalCostOfStructure: 'Medium Scale Industry',
        powerLinePresent: true,
        telecomPresent: true,
        X: 0.015, // Building-specific factor: 1.5% probability internal system failure causes loss of life
      );
    });

    test('Verify Collection Area AD matches expected 7447.84', () {
      final ad = calculator.calculateAD(testParams);
      print('AD calculated: $ad, expected: 7447.84');
      expect(ad, closeTo(7447.84, 1.0));
    });

    test('Verify Collection Area AM matches expected 853798.16', () {
      final am = calculator.calculateAM(testParams);
      print('AM calculated: $am, expected: 853798.16');
      expect(am, closeTo(853798.16, 1.0));
    });

    test('Verify Dangerous Event ND matches expected 0.1117', () {
      final ad = calculator.calculateAD(testParams);
      final nd = calculator.calculateND(testParams, ad);
      print('ND calculated: $nd, expected: 0.1117');
      expect(nd, closeTo(0.1117, 0.001));
    });

    test('Verify Dangerous Event NM matches expected 12.81', () {
      final nm = calculator.calculateNM(testParams);
      print('NM calculated: $nm, expected: 12.81');
      expect(nm, closeTo(12.81, 0.01));
    });

    test('Verify Dangerous Event NL(P) matches expected 0.30', () {
      final nlp = calculator.calculateNLP(testParams);
      print('NL(P) calculated: $nlp, expected: 0.30');
      expect(nlp, closeTo(0.30, 0.01));
    });

    test('Verify Dangerous Event NL(T) matches expected 0.30', () {
      final nlt = calculator.calculateNLT(testParams);
      print('NL(T) calculated: $nlt, expected: 0.30');
      expect(nlt, closeTo(0.30, 0.01));
    });

    test('Verify Dangerous Event NI(P) matches expected 30.0', () {
      final nip = calculator.calculateNIP(testParams);
      print('NI(P) calculated: $nip, expected: 30.0');
      expect(nip, closeTo(30.0, 0.1));
    });

    test('Verify Dangerous Event NI(T) matches expected 30.0', () {
      final nit = calculator.calculateNIT(testParams);
      print('NI(T) calculated: $nit, expected: 30.0');
      expect(nit, closeTo(30.0, 0.1));
    });

    test('COMPLETE RISK ASSESSMENT - Full Report Validation', () async {
      print('\n' + '=' * 80);
      print('COMPLETE RISK ASSESSMENT USING USER\'S SAMPLE DATA');
      print('=' * 80);

      final result = await calculator.calculateRisk(testParams);

      print('\n--- STRUCTURE DIMENSIONS ---');
      print('Length: ${testParams.length}m');
      print('Width: ${testParams.width}m');
      print('Height: ${testParams.height}m');

      print('\n--- COLLECTION AREAS (Expected vs Actual) ---');
      print(
          'AD:     ${result.collectionAreas['AD']?.toStringAsFixed(2).padLeft(12)} (Expected: 7447.84)');
      print(
          'AM:     ${result.collectionAreas['AM']?.toStringAsFixed(2).padLeft(12)} (Expected: 853798.16)');
      print(
          'AL(P):  ${result.collectionAreas['ALP']?.toStringAsFixed(2).padLeft(12)} (Expected: 40000.00)');
      print(
          'AL(T):  ${result.collectionAreas['ALT']?.toStringAsFixed(2).padLeft(12)} (Expected: 40000.00)');
      print(
          'AI(P):  ${result.collectionAreas['AIP']?.toStringAsFixed(2).padLeft(12)} (Expected: 4000000.00)');
      print(
          'AI(T):  ${result.collectionAreas['AIT']?.toStringAsFixed(2).padLeft(12)} (Expected: 4000000.00)');

      print('\n--- DANGEROUS EVENTS (Expected vs Actual) ---');
      print(
          'ND:     ${result.nd.toStringAsFixed(4).padLeft(12)} (Expected: 0.1117)');
      print(
          'NM:     ${result.nm.toStringAsFixed(4).padLeft(12)} (Expected: 12.81)');
      print(
          'NL(P):  ${result.nl_p.toStringAsFixed(4).padLeft(12)} (Expected: 0.30)');
      print(
          'NL(T):  ${result.nl_t.toStringAsFixed(4).padLeft(12)} (Expected: 0.30)');
      print(
          'NI(P):  ${(result.ni / 2).toStringAsFixed(4).padLeft(12)} (Expected: 30.0)');
      print(
          'NI(T):  ${(result.ni / 2).toStringAsFixed(4).padLeft(12)} (Expected: 30.0)');

      print('\n--- RISK VALUES BEFORE PROTECTION (Expected vs Actual) ---');
      print(
          'R1:     ${result.r1.toStringAsExponential(2).padLeft(12)} (Expected: 2.97e-04)');
      print(
          'R2:     ${result.r2.toStringAsExponential(2).padLeft(12)} (Expected: 1.76e-02)');
      print(
          'R3:     ${result.r3.toStringAsExponential(2).padLeft(12)} (Expected: 0.00e+00)');
      print(
          'R4:     ${result.r4.toStringAsExponential(2).padLeft(12)} (Expected: 6.48e-02)');

      print('\n--- RISK VALUES AFTER PROTECTION (Expected vs Actual) ---');
      print(
          'R1:     ${result.r1AfterProtection.toStringAsExponential(2).padLeft(12)} (Expected: 2.18e-05)');
      print(
          'R2:     ${result.r2AfterProtection.toStringAsExponential(2).padLeft(12)} (Expected: 1.76e-02)');
      print(
          'R3:     ${result.r3AfterProtection.toStringAsExponential(2).padLeft(12)} (Expected: 0.00e+00)');
      print(
          'R4:     ${result.r4AfterProtection.toStringAsExponential(2).padLeft(12)} (Expected: 6.35e-02)');

      print('\n--- TOLERABLE RISK THRESHOLDS ---');
      print('R1 Tolerable: ${result.tolerableR1.toStringAsExponential(0)}');
      print('R2 Tolerable: ${result.tolerableR2.toStringAsExponential(0)}');
      print('R3 Tolerable: ${result.tolerableR3.toStringAsExponential(0)}');
      print('R4 Tolerable: ${result.tolerableR4.toStringAsExponential(0)}');

      print('\n--- PROTECTION REQUIREMENTS ---');
      print(
          'R1 Protection Required: ${result.r1ExceedsTolerable ? "YES" : "NO"} (R1 > RT: ${result.r1 > result.tolerableR1})');
      print(
          'R2 Protection Required: ${result.r2ExceedsTolerable ? "YES" : "NO"} (R2 > RT: ${result.r2 > result.tolerableR2})');
      print(
          'R3 Protection Required: ${result.r3ExceedsTolerable ? "YES" : "NO"} (R3 > RT: ${result.r3 > result.tolerableR3})');
      print(
          'R4 Protection Required: ${result.r4ExceedsTolerable ? "YES" : "NO"} (R4 > RT: ${result.r4 > result.tolerableR4})');
      print('Protection Level: ${result.protectionLevel}');

      print('\n--- COST-BENEFIT ANALYSIS ---');
      print(
          'Total Cost of Structure: ${result.totalCostOfStructure.toStringAsFixed(2)} million');
      print(
          'CL (Cost Before):        ${result.costOfLossBeforeProtection.toStringAsFixed(4)} million (Expected: ~13.00)');
      print(
          'CRL (Cost After):        ${result.costOfLossAfterProtection.toStringAsFixed(4)} million (Expected: ~12.70)');
      print(
          'CPM (Annual Cost):       ${result.annualCostOfProtection.toStringAsFixed(4)} million (Expected: 1.15)');
      print(
          'SM (Annual Savings):     ${result.annualSavings.toStringAsFixed(4)} million (Expected: -0.89)');
      print(
          'Protection Economical:   ${result.isProtectionEconomical ? "YES" : "NO"}');

      print('\n--- ZONE PARAMETERS ---');
      final zone0 = testParams.zoneParameters['zone0']!;
      final zone1 = testParams.zoneParameters['zone1']!;
      print('Zone 0:');
      print('  Persons: ${testParams.personsZone0}');
      print('  np (People in danger): ${zone0['np']}');
      print('  cp (Cultural heritage): ${zone0['cp']}');
      print('  sp (Structure value): ${zone0['sp']}');
      print('\nZone 1:');
      print('  Persons: ${testParams.personsZone1}');
      print(
          '  np (People in danger): ${zone1['np']} (Expected: 0.4167 per report)');
      print('  cp (Cultural heritage): ${zone1['cp']}');
      print('  sp (Structure value): ${zone1['sp']}');

      print('\n' + '=' * 80);
      print('VALIDATION SUMMARY');
      print('=' * 80);

      // Validate key values
      final validations = <String, bool>{
        'Collection Area AD':
            (result.collectionAreas['AD']! - 7447.84).abs() < 1.0,
        'Collection Area AM':
            (result.collectionAreas['AM']! - 853798.16).abs() < 1.0,
        'Dangerous Event ND': (result.nd - 0.1117).abs() < 0.001,
        'Dangerous Event NM': (result.nm - 12.81).abs() < 0.01,
        'R1 Protection Required': result.r1ExceedsTolerable,
        'After-Protection R1 < Before': result.r1AfterProtection < result.r1,
      };

      int passed = 0;
      validations.forEach((key, value) {
        final status = value ? '✓ PASS' : '✗ FAIL';
        print('$status: $key');
        if (value) passed++;
      });

      print('\nTotal: $passed/${validations.length} validations passed');
      print('=' * 80 + '\n');

      // Assert core calculations match
      expect(result.collectionAreas['AD'], closeTo(7447.84, 1.0),
          reason: 'Collection Area AD should match expected value');
      expect(result.collectionAreas['AM'], closeTo(853798.16, 1.0),
          reason: 'Collection Area AM should match expected value');
      expect(result.nd, closeTo(0.1117, 0.001),
          reason: 'Dangerous Event ND should match expected value');
      expect(result.nm, closeTo(12.81, 0.01),
          reason: 'Dangerous Event NM should match expected value');
    });
  });
}

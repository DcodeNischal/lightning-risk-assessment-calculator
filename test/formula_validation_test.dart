import 'package:flutter_test/flutter_test.dart';
import '../lib/test_validation.dart';

void main() {
  group('IEC 62305-2 Formula Validation', () {
    late ValidationTest validator;

    setUp(() {
      validator = ValidationTest();
    });

    test('Collection Areas Calculations', () async {
      final result = await validator.validateCollectionAreas();
      expect(result, isTrue,
          reason: 'Collection area calculations should match expected values');
    });

    test('Number of Dangerous Events Calculations', () async {
      final result = await validator.validateDangerousEvents();
      expect(result, isTrue,
          reason: 'Dangerous events calculations should match expected values');
    });

    test('Complete Risk Assessment', () async {
      final result = await validator.validateCompleteRisk();
      expect(result, isTrue,
          reason: 'Complete risk calculation should match expected values');
    });

    test('Full Validation Suite', () async {
      final result = await validator.runAllTests();
      expect(result, isTrue,
          reason: 'All IEC 62305-2 formulas should be correctly implemented');
    });
  });
}

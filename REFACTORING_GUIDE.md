# Lightning Risk Assessment Calculator - Refactoring Guide

## 📋 Overview

This document explains the optimized code structure implemented to improve code maintainability, readability, and reduce redundancy in the Lightning Risk Assessment Calculator.

## 🏗️ New Project Structure

```
lib/
├── main.dart                              # Application entry point
│
├── config/                                # Application configuration
│   ├── app_config.dart                    # App-level settings
│   └── theme_config.dart                  # Theme configuration (future)
│
├── core/                                  # Core functionality and utilities
│   ├── constants/                         # All constant values
│   │   ├── app_constants.dart             # General app constants
│   │   ├── calculation_constants.dart     # Calibration factors
│   │   └── iec_standards/                 # IEC 62305-2 standard constants
│   │       ├── iec_standards.dart         # Main export file
│   │       ├── location_factors.dart      # CD, CDJ, CE, NG
│   │       ├── line_factors.dart          # CI, CT, CLD, CLI, PLD, PLI
│   │       ├── protection_factors.dart    # PB, PSPD, PEB, PTA, PTU, KS
│   │       ├── loss_factors.dart          # rf, rp, rt, hz, LT, LF, LO
│   │       └── tolerable_risk.dart        # RT thresholds
│   │
│   └── utils/                             # Utility functions
│       ├── calculation_helpers.dart       # Reusable calculation functions
│       ├── validators.dart                # Input validation functions
│       └── formatters.dart                # Data formatting utilities
│
├── data/                                  # Data models
│   └── models/
│       ├── zone_parameters.dart           # Input parameters model
│       └── risk_result.dart               # Calculation results model
│
├── domain/                                # Business logic layer
│   ├── calculators/                       # Modular calculation components
│   │   ├── collection_area_calculator.dart     # AD, AM, ALP, ALT, etc.
│   │   ├── dangerous_events_calculator.dart    # ND, NM, NL, NI, NDJ
│   │   ├── probability_calculator.dart         # PA, PB, PC, PM, etc.
│   │   └── risk_component_calculator.dart      # RA, RB, RC, RU, RV, RW, RZ
│   │
│   └── services/
│       ├── risk_calculator_service.dart   # Main calculation orchestrator
│       └── pdf_generator_service.dart     # PDF export service
│
└── presentation/                          # UI layer
    ├── screens/
    │   └── home_screen.dart               # Main application screen
    │
    ├── widgets/
    │   ├── forms/
    │   │   └── risk_assessment_form.dart  # Input form
    │   ├── results/
    │   │   └── results_display.dart       # Results display
    │   └── common/
    │       ├── section_card.dart          # Reusable section card
    │       └── info_row.dart              # Reusable info row
    │
    └── theme/
        └── app_theme.dart                 # Application theme
```

## 🎯 Key Improvements

### 1. Separation of Concerns

**Before:**
- Single `risk_factors.dart` file with 343 lines of constants
- Monolithic `risk_calculator_service.dart` with 503 lines
- Mixed business logic and UI code

**After:**
- Constants organized into 5 focused files by category
- Calculator logic split into 4 specialized components
- Clear separation between data, domain, and presentation layers

### 2. Code Organization

#### Constants (IEC Standards)

Each constant file focuses on a specific aspect:

- **location_factors.dart**: Environmental and location-based factors
- **line_factors.dart**: Power and telecom line characteristics
- **protection_factors.dart**: LPS, SPD, and shielding factors
- **loss_factors.dart**: Expected loss values and risk reduction factors
- **tolerable_risk.dart**: Risk threshold values

#### Calculators (Domain Logic)

Each calculator has a single responsibility:

- **CollectionAreaCalculator**: Calculates AD, AM, ALP, ALT, AIP, AIT, ADJ
- **DangerousEventsCalculator**: Calculates ND, NM, NLP, NLT, NIP, NIT, NDJ
- **ProbabilityCalculator**: Calculates PA, PB, PC, PM, PU, PV, PW, PZ
- **RiskComponentCalculator**: Calculates RA, RB, RC, RU, RV, RW, RZ, and total risks

#### Services

- **RiskCalculatorService**: Orchestrates all calculators
- **PDFGeneratorService**: Handles PDF export functionality

### 3. Reusable Utilities

#### Calculation Helpers

```dart
// Before: Repeated code in multiple methods
final h3 = 3 * height;
return (length * width) + (2 * h3 * (length + width)) + (math.pi * math.pow(h3, 2));

// After: Reusable helper function
return calculateStructureCollectionArea(length, width, height);
```

#### Validators

```dart
// Before: Inline validation
if (value == null || value.isEmpty) return 'Field is required';
final num = double.tryParse(value);
if (num == null) return 'Must be a number';
if (num < 0 || num > 1000) return 'Must be between 0 and 1000';

// After: Reusable validator
return validateNumberInRange(value, min: 0, max: 1000, fieldName: 'Length');
```

#### Formatters

```dart
// Before: Inconsistent formatting
if (value.abs() < 0.0001) {
  return value.toStringAsExponential(6);
}
return value.toStringAsFixed(6);

// After: Consistent formatter
return formatRisk(value); // Automatically handles scientific notation
```

### 4. Documentation

Every file, class, and public method now includes:
- Purpose description
- Parameter documentation
- Return value documentation
- Usage examples where helpful
- IEC 62305-2 formula references

## 📚 Usage Guide

### Importing Constants

```dart
// Import all IEC standards
import 'package:lightning_risk_assessment/core/constants/iec_standards/iec_standards.dart';

// Or import specific categories
import 'package:lightning_risk_assessment/core/constants/iec_standards/location_factors.dart';

// Use constants
final cd = locationFactorCD['Isolated Structure (Within a distance of 3H)'];
```

### Using Calculators

```dart
// Create calculator instances
final areaCalculator = CollectionAreaCalculator();
final eventsCalculator = DangerousEventsCalculator();

// Calculate collection areas
final areas = areaCalculator.calculateAllAreas(zoneParams);

// Calculate dangerous events
final events = eventsCalculator.calculateAllEvents(zoneParams, areas);
```

### Main Service

```dart
// Use the main service for complete calculations
final service = RiskCalculatorService();
final result = await service.calculateRisk(zoneParameters);

// Access results
print('R1 = ${result.formattedR1}');
print('Protection required: ${result.protectionRequired}');
print('Protection level: ${result.protectionLevel}');
```

### Utilities

```dart
// Validation
final errors = validateStructureDimension('15.5', dimension: 'Length');

// Formatting
final formatted = formatRisk(0.0000179); // Returns "1.79e-5"
final area = formatArea(1234.56); // Returns "1234.56 m²"

// Calculation helpers
final ad = calculateStructureCollectionArea(15, 20, 6);
final rM = calculateRm(2.5); // withstand voltage
```

## 🔄 Migration Path

### For Developers Working on Existing Code

1. **Update Imports**
   ```dart
   // Old
   import '../models/risk_factors.dart';
   
   // New
   import '../../core/constants/iec_standards/iec_standards.dart';
   ```

2. **Use New Services**
   ```dart
   // Old
   final service = RiskCalculatorService();
   final nd = service.calculateND(params, ad);
   
   // New
   final areaCalc = CollectionAreaCalculator();
   final eventsCalc = DangerousEventsCalculator();
   final areas = areaCalc.calculateAllAreas(params);
   final events = eventsCalc.calculateAllEvents(params, areas);
   ```

3. **Use Helper Functions**
   ```dart
   // Old
   final factor = map[key] ?? defaultValue;
   
   // New
   import '../../core/utils/calculation_helpers.dart';
   final factor = getFactor(map, key, defaultValue);
   ```

## 🧪 Testing Strategy

### Unit Tests

Each calculator component can be tested independently:

```dart
test('CollectionAreaCalculator calculates AD correctly', () {
  final calculator = CollectionAreaCalculator();
  final params = ZoneParameters(...);
  final ad = calculator.calculateAD(params);
  expect(ad, closeTo(expectedValue, tolerance));
});
```

### Integration Tests

Test the complete calculation flow:

```dart
test('RiskCalculatorService produces correct results', () async {
  final service = RiskCalculatorService();
  final result = await service.calculateRisk(testParams);
  expect(result.r1, closeTo(expectedR1, tolerance));
});
```

## 📊 Performance Considerations

### Memory Usage
- Constants are now organized and lazy-loaded
- Calculators are lightweight and can be created on-demand
- Results are cached in RiskResult objects

### Computation
- Modular design allows parallel calculation of independent components
- Helper functions eliminate redundant calculations
- Async/await pattern maintains UI responsiveness

## 🔒 Type Safety

All calculations use:
- Strong typing with explicit types
- Named parameters for clarity
- Const constructors where applicable
- Null safety compliance

## 🎨 Code Style

### Naming Conventions

- Files: `snake_case.dart`
- Classes: `PascalCase`
- Functions/Variables: `camelCase`
- Constants: `camelCase` (for maps) or `SCREAMING_SNAKE_CASE` (for values)
- Private members: `_leadingUnderscore`

### Documentation

- Every public API has documentation
- Complex formulas include IEC 62305-2 references
- Usage examples for non-trivial functions

## 🚀 Future Enhancements

### Planned Improvements

1. **R2, R3, R4 Calculations**
   - Complete implementation of all risk types
   - Multi-zone support

2. **Configuration System**
   - User-customizable calculation parameters
   - Profile management

3. **Enhanced PDF Export**
   - Customizable report templates
   - Multiple language support

4. **Caching Layer**
   - Cache frequently used calculations
   - Optimization for repeated assessments

## 📝 Contributing Guidelines

When adding new features:

1. **Place code in appropriate layer**
   - Constants → `core/constants/`
   - Business logic → `domain/`
   - UI → `presentation/`
   - Models → `data/models/`

2. **Follow single responsibility principle**
   - One calculator per calculation category
   - One widget per UI component
   - One service per business function

3. **Add documentation**
   - Document public APIs
   - Include usage examples
   - Reference IEC standards where applicable

4. **Write tests**
   - Unit tests for calculators
   - Widget tests for UI components
   - Integration tests for services

## 🤝 Team Benefits

### For New Developers
- Clear structure makes onboarding easier
- Documentation explains purpose and usage
- Examples show best practices

### For Maintainers
- Modular design simplifies updates
- Single responsibility makes debugging easier
- Comprehensive docs reduce support burden

### For Reviewers
- Organized code is easier to review
- Clear separation of concerns
- Consistent patterns throughout

## 📞 Support

For questions or clarification:
- Review this guide
- Check inline documentation
- Refer to IEC 62305-2 standard
- Contact the development team

---

**Last Updated:** October 2025  
**Version:** 2.0  
**Author:** Development Team


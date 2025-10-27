# UI vs PDF Data Comparison Checklist

## Data Sources
Both UI and PDF use the **same** data sources:
- `RiskResult riskResult` - All calculated values
- `ZoneParameters zoneParameters` - All input parameters

## Collection Areas Tab vs PDF Structure Column

### UI Display (`_buildCollectionAreasTab`)
```dart
collectionAreas['AD']  // Direct strikes to structure
collectionAreas['AM']  // Nearby strikes to structure
collectionAreas['ALP'] // Power line direct strikes
collectionAreas['ALT'] // Telecom line direct strikes
collectionAreas['AIP'] // Power line indirect strikes
collectionAreas['AIT'] // Telecom line indirect strikes
collectionAreas['ADJP'] // Adjacent structure (Power)
collectionAreas['ADJT'] // Adjacent structure (Telecom)
```

### PDF Display (`_buildStructureColumn`)
```dart
collectionAreas['AD']   // ✅ SAME
collectionAreas['AM']   // ✅ SAME
collectionAreas['ALP']  // ✅ SAME
collectionAreas['ALT']  // ✅ SAME
collectionAreas['AIP']  // ✅ SAME
collectionAreas['AIT']  // ✅ SAME
collectionAreas['ADJP'] // ✅ SAME
collectionAreas['ADJT'] // ✅ SAME
```

## Dangerous Events Tab vs PDF Calculated Risk Column

### UI Display (`_buildDangerousEventsTab`)
```dart
riskResult.nd     // Direct strikes to structure
riskResult.nm     // Nearby strikes to structure
riskResult.nl_p   // Direct strikes to power line
riskResult.nl_t   // Direct strikes to telecom line
riskResult.ni     // Indirect strikes to both lines
riskResult.ndj_p  // Direct strikes to adjacent (Power)
riskResult.ndj_t  // Direct strikes to adjacent (Telecom)
```

### PDF Display (`_buildCalculatedRiskColumn`)
```dart
riskResult.nd     // ✅ SAME
riskResult.nm     // ✅ SAME
riskResult.nl_p   // ✅ SAME
riskResult.nl_t   // ✅ SAME
riskResult.ni     // ✅ SAME
riskResult.ndj_p  // ✅ SAME
riskResult.ndj_t  // ✅ SAME
```

## Risk Analysis Tab vs PDF Risk Columns

### UI Display (`_buildRiskAnalysisTab`)
```dart
riskResult.r1  // Loss of Human Life
riskResult.r2  // Loss of Public Service
riskResult.r3  // Loss of Cultural Heritage
riskResult.r4  // Economic Loss
riskResult.tolerableR1
riskResult.tolerableR2
riskResult.tolerableR3
riskResult.tolerableR4
```

### PDF Display (Before/After Protection Columns)
```dart
riskResult.r1  // ✅ SAME
riskResult.r2  // ✅ SAME
riskResult.r3  // ✅ SAME
riskResult.r4  // ✅ SAME
riskResult.r1AfterProtection  // ✅ SAME
riskResult.r2AfterProtection  // ✅ SAME
riskResult.r3AfterProtection  // ✅ SAME
riskResult.r4AfterProtection  // ✅ SAME
riskResult.tolerableR1  // ✅ SAME
riskResult.tolerableR2  // ✅ SAME
riskResult.tolerableR3  // ✅ SAME
riskResult.tolerableR4  // ✅ SAME
```

## Input Data Tab vs PDF Multiple Columns

### Structure Dimensions
UI: `zoneParameters.length/width/height`
PDF: `zoneParameters.length/width/height` ✅ SAME

### Environmental Factors
UI: `zoneParameters.lightningFlashDensity/locationFactorKey/lpsStatus/equipotentialBonding`
PDF: `zoneParameters.lightningFlashDensity/locationFactorKey/lpsStatus/equipotentialBonding` ✅ SAME

### Power Line Parameters
UI: `zoneParameters.lengthPowerLine/installationPowerLine/lineTypePowerLine/powerUW/powerShielding`
PDF: `zoneParameters.lengthPowerLine/installationPowerLine/lineTypePowerLine/powerUW/powerShielding` ✅ SAME

### Zone Parameters
UI: `zoneParameters.zoneParameters['zone0'/'zone1']`
PDF: `zoneParams.zoneParameters['zone0'/'zone1']` ✅ SAME

## Cost-Benefit Analysis

### UI Display (`_buildCostBenefitTab`)
```dart
riskResult.costOfLossBeforeProtection
riskResult.costOfLossAfterProtection
riskResult.annualCostOfProtection
riskResult.annualSavings
riskResult.isProtectionEconomical
```

### PDF Display (`_buildRiskAfterProtectionColumn`)
```dart
riskResult.costOfLossBeforeProtection  // ✅ SAME
riskResult.costOfLossAfterProtection   // ✅ SAME
riskResult.annualCostOfProtection      // ✅ SAME
riskResult.annualSavings               // ✅ SAME
riskResult.isProtectionEconomical      // ✅ SAME
```

## VERDICT

✅ **UI and PDF use IDENTICAL data sources**
✅ **All values are pulled from the same `RiskResult` and `ZoneParameters` objects**
✅ **Both receive data from the same parent component**

## Potential Issues

1. **Formatting differences** - UI might format numbers differently than PDF
2. **Missing fields** - UI might not show all fields that PDF shows (or vice versa)
3. **Null handling** - UI uses `N/A`, PDF might use different default values
4. **Value keys** - If map keys don't match exactly (e.g., 'ALP' vs 'AL(P)')

## Action Required

User reports: "the result & report tab shows one thing and pdf export shows another thing"

**NEXT STEP:** User needs to specify which specific values are different between UI and PDF.



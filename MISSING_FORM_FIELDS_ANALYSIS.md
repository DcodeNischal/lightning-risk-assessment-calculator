# 🔍 Missing Form Fields Analysis

## Parameters Required for Calculation vs. Form Fields

### ✅ Fields Already in Form
Most fields are already present, including:
- Structure dimensions (L, W, H)
- Lightning flash density (NG)
- LPS status (PB)
- Mesh widths (wm1, wm2)
- Exposure time (TZ) ✅ Just added
- Power line parameters (UW, KS3, KS4, PLI, PLD, etc.)
- Telecom line parameters
- Zone parameters (rt, PTA, PTU, rf, rp, hz, LT, LF, LO)
- Economic values (ca, cb, cc, cs)
- Cultural heritage values (cZ0, cZ1, ct)

### ❌ MISSING CRITICAL FIELDS

#### 1. **constructionMaterial** (Type of Structure - PS)
- **Status**: ❌ **MISSING from form**
- **Used in**: `calculatePB()` - Probability of Physical Damage
- **Purpose**: Determines structure vulnerability based on material
- **Impact**: **CRITICAL** - Affects all risk calculations
- **Default**: Currently hardcoded to "Masonry"

**IEC 62305-2 Values:**
| Material | PS Factor |
|----------|-----------|
| Masonry, brick, concrete | 1.0 |
| Metal | 0.5 |
| Wood, reinforced concrete | 0.2 |
| Others | Varies |

#### 2. **reductionFactorRT** (Touch Voltage Reduction Factor)
- **Status**: ❌ **MISSING from form**
- **Used in**: Zone parameters, loss calculations
- **Purpose**: Reduction factor for touch voltage probability
- **Impact**: **MODERATE** - Affects L1 calculations
- **Default**: Currently hardcoded to 0.00001

**IEC 62305-2 Values:**
| Floor Type | rt Factor |
|------------|-----------|
| Agricultural, concrete | 0.01 |
| Asphalt, linoleum, wood | 0.00001 |
| Marble, ceramic | 0.001 |
| Gravel, moquette, carpets | 0.0001 |

---

## 🚨 Impact Assessment

### Construction Material (PS):
**CRITICAL MISSING FIELD** ⚠️

Currently hardcoded to "Masonry" (PS=1.0), which is the **most conservative** value. This means:
- ✅ **Safe side**: Always assumes worst-case scenario
- ❌ **Over-conservative**: Metal buildings (PS=0.5) would show 2x higher risk than actual
- ❌ **Not flexible**: Can't assess different building types accurately

### Reduction Factor RT (Touch Voltage):
**ALREADY IN ZONE PARAMETERS** ✅

Actually, this is already handled through the zone parameter **'rt' (Floor surface type)**!
- Zone 0: rt = 'Agricultural, concrete' → 0.01
- Zone 1: rt = 'Asphalt, linoleum, wood' → 0.00001

**Status**: ✅ Already in form as dropdown in zone parameters

---

## 📋 Conclusion

### Missing from Form:
1. ✅ **exposureTimeTZ** - **JUST ADDED** ✓
2. ❌ **constructionMaterial** - **NEEDS TO BE ADDED** ⚠️

### Already in Form (confirmed):
- ✅ reductionFactorRT (via zone parameter 'rt')
- ✅ All power line parameters
- ✅ All telecom line parameters
- ✅ All zone parameters
- ✅ All economic values

---

## 🎯 Recommendation

**ADD ONE CRITICAL FIELD:**

### Construction Material Dropdown
**Location**: Structure Dimensions section (after height)

**Field**: "Construction Material (Type of Structure)"

**Options**:
1. Masonry, brick, concrete (PS = 1.0)
2. Metal (PS = 0.5)
3. Wood, reinforced concrete (PS = 0.2)

**Default**: "Masonry, brick, concrete" (most conservative, current default)

**Impact**: 
- Allows accurate assessment for metal buildings
- Critical for industrial structures
- Affects PB (probability of damage) calculation
- Influences all risk values (R1, R2, R3, R4)

---

## ✅ Summary

| Field | Status | Priority | Action |
|-------|--------|----------|--------|
| exposureTimeTZ | ✅ Added | High | Complete |
| constructionMaterial | ❌ Missing | **CRITICAL** | **NEEDS TO BE ADDED** |
| reductionFactorRT | ✅ In form | N/A | Already as 'rt' in zones |

**Final Answer**: **YES, there is ONE critical field missing: Construction Material (Type of Structure)**


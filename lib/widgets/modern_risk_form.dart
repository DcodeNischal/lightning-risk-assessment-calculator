import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/risk_calculator_service.dart';
import '../models/zone_parameters.dart';
import '../models/risk_result.dart';
import '../models/risk_factors.dart';

class ModernRiskForm extends StatefulWidget {
  final Function(RiskResult, ZoneParameters) onRiskCalculated;
  final VoidCallback onCalculationStarted;
  final bool isCalculating;

  const ModernRiskForm({
    super.key,
    required this.onRiskCalculated,
    required this.onCalculationStarted,
    required this.isCalculating,
  });

  @override
  State<ModernRiskForm> createState() => _ModernRiskFormState();
}

class _ModernRiskFormState extends State<ModernRiskForm> {
  final _formKey = GlobalKey<FormState>();
  final _calculatorService = RiskCalculatorService();
  late Map<String, dynamic> _formData;

  @override
  void initState() {
    super.initState();
    _initializeFormData();
  }

  void _initializeFormData() {
    _formData = {
      // Structure - From your validated sample data
      'length': 15.0, // L = 15m
      'width': 20.0, // W = 20m
      'height': 6.0, // H = 6m
      'locationFactorKey':
          'Isolated Structure (Within a distance of 3H)', // CD = 1

      // Lightning - From your validated sample data
      'lightningFlashDensity': 8.0, // NSG = 8 (k=2, so NG=16)
      'environmentalFactorKey': 'Rural', // CE = 1

      // LPS - From your validated sample data
      'lpsStatus': 'Structure is not Protected by an LPS', // PLPS = 1 (None)
      'constructionMaterial': 'Masonry', // PS = 1 (Masonry from sample)
      'meshWidth1': 1.0, // KS1 = 1 (none)
      'meshWidth2': 1.0, // KS2 = 1 (none)
      'equipotentialBonding': 'No SPD', // PEB = 1 (None)
      'spdProtectionLevel': 'No coordinated SPD system', // PSPD = 1

      // Power Line - From your validated sample data
      'lengthPowerLine': 1000.0, // LL = 1000m
      'installationPowerLine': 'Overhead Line', // CIP = 1 (Aerial)
      'lineTypePowerLine':
          'Low-Voltage Power, TLC or data line', // CTP = 1 (LV line)
      'powerShielding': 'Unshielded overhead line', // CLDP = 1 (None)
      'powerShieldingFactorKs1': 1.0, // From calculation
      'powerUW': 2.5, // UWP = 2.5kV
      'spacingPowerLine': 0.0, // No spacing specified
      'powerTypeCT': 'Low-Voltage Power, TLC or data line', // CTP = 1

      // Telecom Line - From your validated sample data
      'lengthTlcLine': 800.0, // LL = 800m
      'installationTlcLine': 'Overhead Line', // CIT = 1 (Aerial)
      'lineTypeTlcLine':
          'Low-Voltage Power, TLC or data line', // CTT = 1 (Telecom Line)
      'tlcShielding': 'Unshielded overhead line', // CLDT = 1 (None)
      'tlcShieldingFactorKs1': 1.0, // From calculation
      'tlcUW': 1.5, // UWT = 1.5kV
      'spacingTlcLine': 0.0, // No spacing specified
      'teleTypeCT': 'Low-Voltage Power, TLC or data line', // CTT = 1

      // Adjacent Structure - From your validated sample data (all zero)
      'adjLength': 0.0, // LJ = 0
      'adjWidth': 0.0, // WJ = 0
      'adjHeight': 0.0, // HJ = 0
      'adjLocationFactor':
          'Isolated Structure (Within a distance of 3H)', // CDJ = 0

      // Safety - From your validated sample data Zone Z1
      'reductionFactorRT': 1e-5, // rt = 1.00E-05 (Linoleum)
      'lossTypeLT': 'All types', // LT = 1.00E-02
      'exposureTimeTZ': 4380.0, // tz = 4380 (PP = 0.5 = 4380/8760)
      'exposedPersonsNZ': 1.0, // Normalized to 1 person
      'totalPersonsNT': 1.0, // Normalized to 1 person total

      // Protection - From your validated sample data
      'shockProtectionPTA': 'No protection measures', // Pam = 1 (None)
      'shockProtectionPTU': 'No protection measure', // PO = 0 (Not applicable)
      'fireProtection': 'No measures', // rp = 1 (None)
      'fireRisk': 'Fire(Low)', // rf = 1.00E-03 (Low)
    };
  }

  void _calculateRisk() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    _formKey.currentState!.save();
    widget.onCalculationStarted();

    try {
      final zone = ZoneParameters.fromMap(_formData);
      final result = await _calculatorService.calculateRisk(zone);
      widget.onRiskCalculated(result, zone);

      // Haptic feedback
      HapticFeedback.lightImpact();

      // Show success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 8),
                Text('Risk calculation completed successfully'),
              ],
            ),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error, color: Colors.white),
                const SizedBox(width: 8),
                Expanded(
                  child: Text('Calculation failed: ${e.toString()}'),
                ),
              ],
            ),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Modern sections with cards
              _buildModernSection(
                'Structure Dimensions',
                Icons.business,
                Colors.blue,
                [
                  LayoutBuilder(
                    builder: (context, constraints) {
                      if (constraints.maxWidth < 600) {
                        // Mobile: Stack vertically
                        return Column(
                          children: [
                            _buildNumberField(
                                'Length (m)', 'length', Icons.straighten),
                            const SizedBox(height: 16),
                            _buildNumberField(
                                'Width (m)', 'width', Icons.straighten),
                          ],
                        );
                      } else {
                        // Desktop: Side by side
                        return Row(
                          children: [
                            Expanded(
                                child: _buildNumberField(
                                    'Length (m)', 'length', Icons.straighten)),
                            const SizedBox(width: 16),
                            Expanded(
                                child: _buildNumberField(
                                    'Width (m)', 'width', Icons.straighten)),
                          ],
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildNumberField('Height (m)', 'height', Icons.height),
                  const SizedBox(height: 16),
                  _buildDropdownField('Location Factor', 'locationFactorKey',
                      Icons.location_on, locationFactorCD.keys.toList()),
                ],
              ),

              const SizedBox(height: 16),

              _buildModernSection(
                'Environmental Influences',
                Icons.cloud,
                Colors.green,
                [
                  _buildNumberField('Lightning Flash Density',
                      'lightningFlashDensity', Icons.flash_on),
                  const SizedBox(height: 16),
                  _buildDropdownField(
                      'Environmental Factor',
                      'environmentalFactorKey',
                      Icons.nature,
                      environmentalFactorCE.keys.toList()),
                ],
              ),

              const SizedBox(height: 16),

              _buildModernSection(
                'Protection Systems',
                Icons.security,
                Colors.orange,
                [
                  _buildDropdownField('LPS Status', 'lpsStatus', Icons.shield,
                      protectionPhysicalDamage.keys.toList()),
                  const SizedBox(height: 16),
                  _buildDropdownField(
                      'Construction Material',
                      'constructionMaterial',
                      Icons.business,
                      typeOfStructurePS.keys.toList()),
                  const SizedBox(height: 16),
                  _buildDropdownField(
                      'SPD Protection Level',
                      'spdProtectionLevel',
                      Icons.electrical_services,
                      coordinatedSPDProtection.keys.toList()),
                  const SizedBox(height: 16),
                  _buildDropdownField(
                      'Equipotential Bonding',
                      'equipotentialBonding',
                      Icons.link,
                      equipotentialBondingPEB.keys.toList()),
                ],
              ),

              const SizedBox(height: 16),

              _buildModernSection(
                'Power Line Parameters',
                Icons.electrical_services,
                Colors.purple,
                [
                  LayoutBuilder(
                    builder: (context, constraints) {
                      if (constraints.maxWidth < 600) {
                        // Mobile: Stack vertically
                        return Column(
                          children: [
                            _buildNumberField('Length (m)', 'lengthPowerLine',
                                Icons.timeline),
                            const SizedBox(height: 16),
                            _buildNumberField('Withstand Voltage (kV)',
                                'powerUW', Icons.bolt),
                          ],
                        );
                      } else {
                        // Desktop: Side by side
                        return Row(
                          children: [
                            Expanded(
                                child: _buildNumberField('Length (m)',
                                    'lengthPowerLine', Icons.timeline)),
                            const SizedBox(width: 16),
                            Expanded(
                                child: _buildNumberField(
                                    'Withstand Voltage (kV)',
                                    'powerUW',
                                    Icons.bolt)),
                          ],
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildDropdownField(
                      'Installation Type',
                      'installationPowerLine',
                      Icons.power,
                      installationFactorCI.keys.toList()),
                  const SizedBox(height: 16),
                  _buildDropdownField('Line Type', 'lineTypePowerLine',
                      Icons.cable, lineTypeFactorCT.keys.toList()),
                  const SizedBox(height: 16),
                  _buildDropdownField('Shielding', 'powerShielding',
                      Icons.shield_outlined, lineShieldingCLD.keys.toList()),
                ],
              ),

              const SizedBox(height: 16),

              _buildModernSection(
                'Telecommunication Line Parameters',
                Icons.wifi,
                Colors.teal,
                [
                  LayoutBuilder(
                    builder: (context, constraints) {
                      if (constraints.maxWidth < 600) {
                        // Mobile: Stack vertically
                        return Column(
                          children: [
                            _buildNumberField(
                                'Length (m)', 'lengthTlcLine', Icons.timeline),
                            const SizedBox(height: 16),
                            _buildNumberField(
                                'Withstand Voltage (kV)', 'tlcUW', Icons.bolt),
                          ],
                        );
                      } else {
                        // Desktop: Side by side
                        return Row(
                          children: [
                            Expanded(
                                child: _buildNumberField('Length (m)',
                                    'lengthTlcLine', Icons.timeline)),
                            const SizedBox(width: 16),
                            Expanded(
                                child: _buildNumberField(
                                    'Withstand Voltage (kV)',
                                    'tlcUW',
                                    Icons.bolt)),
                          ],
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildDropdownField(
                      'Installation Type',
                      'installationTlcLine',
                      Icons.power,
                      installationFactorCI.keys.toList()),
                  const SizedBox(height: 16),
                  _buildDropdownField('Line Type', 'lineTypeTlcLine',
                      Icons.cable, lineTypeFactorCT.keys.toList()),
                  const SizedBox(height: 16),
                  _buildDropdownField('Shielding', 'tlcShielding',
                      Icons.shield_outlined, lineShieldingCLD.keys.toList()),
                ],
              ),

              const SizedBox(height: 16),

              _buildModernSection(
                'Safety & Risk Parameters',
                Icons.safety_check,
                Colors.red,
                [
                  LayoutBuilder(
                    builder: (context, constraints) {
                      if (constraints.maxWidth < 600) {
                        // Mobile: Stack vertically
                        return Column(
                          children: [
                            _buildNumberField('Exposure Time (h/year)',
                                'exposureTimeTZ', Icons.schedule),
                            const SizedBox(height: 16),
                            _buildNumberField('Exposed Persons',
                                'exposedPersonsNZ', Icons.people),
                          ],
                        );
                      } else {
                        // Desktop: Side by side
                        return Row(
                          children: [
                            Expanded(
                                child: _buildNumberField(
                                    'Exposure Time (h/year)',
                                    'exposureTimeTZ',
                                    Icons.schedule)),
                            const SizedBox(width: 16),
                            Expanded(
                                child: _buildNumberField('Exposed Persons',
                                    'exposedPersonsNZ', Icons.people)),
                          ],
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildDropdownField(
                      'Shock Protection PTA',
                      'shockProtectionPTA',
                      Icons.electrical_services,
                      protectionTouchVoltage.keys.toList()),
                  const SizedBox(height: 16),
                  _buildDropdownField(
                      'Fire Protection',
                      'fireProtection',
                      Icons.local_fire_department,
                      fireProtectionRP.keys.toList()),
                  const SizedBox(height: 16),
                  _buildDropdownField('Fire Risk', 'fireRisk', Icons.warning,
                      fireRiskRF.keys.toList()),
                ],
              ),

              const SizedBox(height: 32),

              // Calculate button
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context).colorScheme.primary,
                      Theme.of(context).colorScheme.secondary
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context)
                          .colorScheme
                          .primary
                          .withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: widget.isCalculating ? null : _calculateRisk,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: widget.isCalculating
                      ? const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            ),
                            SizedBox(width: 12),
                            Text(
                              'Calculating Risk...',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        )
                      : const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.calculate,
                              color: Colors.white,
                              size: 24,
                            ),
                            SizedBox(width: 12),
                            Text(
                              'Calculate Lightning Risk',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildModernSection(
      String title, IconData icon, Color color, List<Widget> children) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white,
              color.withOpacity(0.05),
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(icon, color: color, size: 24),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      title,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[800],
                          ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ...children,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNumberField(String label, String key, IconData icon,
      {double? min, double? max}) {
    return TextFormField(
      initialValue: _formData[key]?.toString() ?? '',
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: Colors.grey[50],
      ),
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
      ],
      validator: (value) {
        if (value?.isEmpty ?? true) return 'Required';
        final num = double.tryParse(value!);
        if (num == null) return 'Invalid number';
        if (min != null && num < min) return 'Minimum $min';
        if (max != null && num > max) return 'Maximum $max';
        return null;
      },
      onSaved: (value) {
        _formData[key] = double.tryParse(value ?? '0') ?? 0.0;
      },
    );
  }

  Widget _buildDropdownField(
      String label, String key, IconData icon, List<String> items) {
    return DropdownButtonFormField<String>(
      value: _formData[key],
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: Colors.grey[50],
        contentPadding:
            const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      ),
      items: items.map((String item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Text(
            item,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: const TextStyle(fontSize: 14),
          ),
        );
      }).toList(),
      isExpanded: true,
      menuMaxHeight: 300,
      validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
      onChanged: (value) {
        setState(() {
          _formData[key] = value;
        });
      },
      onSaved: (value) {
        _formData[key] = value ?? '';
      },
    );
  }
}

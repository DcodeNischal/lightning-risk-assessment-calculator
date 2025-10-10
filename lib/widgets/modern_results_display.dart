import 'package:flutter/material.dart';
import '../models/risk_result.dart';
import '../models/zone_parameters.dart';
import '../services/modern_pdf_service.dart' as report;

class ModernResultsDisplay extends StatefulWidget {
  final RiskResult riskResult;
  final ZoneParameters zoneParameters;

  const ModernResultsDisplay({
    super.key,
    required this.riskResult,
    required this.zoneParameters,
  });

  @override
  State<ModernResultsDisplay> createState() => _ModernResultsDisplayState();
}

class _ModernResultsDisplayState extends State<ModernResultsDisplay> {
  bool _isGeneratingPDF = false;

  Future<void> _generatePDF() async {
    setState(() {
      _isGeneratingPDF = true;
    });

    try {
      final pdfService = report.ModernPDFService();
      await pdfService.generateModernReport(
          widget.riskResult, widget.zoneParameters);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 8),
                Text('PDF report generated successfully'),
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
                  child: Text('PDF generation failed: ${e.toString()}'),
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
    } finally {
      if (mounted) {
        setState(() {
          _isGeneratingPDF = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Risk Summary Card
            _buildRiskSummaryCard(),

            const SizedBox(height: 16),

            // Report Sections - Responsive Layout
            LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth < 800) {
                  // Mobile: Stack vertically
                  return Column(
                    children: [
                      _buildStructureDimensionsCard(),
                      const SizedBox(height: 16),
                      _buildPowerLineCard(),
                      const SizedBox(height: 16),
                      _buildEconomicCard(),
                      const SizedBox(height: 16),
                      _buildEnvironmentalCard(),
                      const SizedBox(height: 16),
                      _buildTelecomCard(),
                      const SizedBox(height: 16),
                      _buildZoneDefinitionsCard(),
                      const SizedBox(height: 16),
                      _buildCalculatedRiskCard(),
                      const SizedBox(height: 16),
                      _buildProtectionLevelCard(),
                    ],
                  );
                } else {
                  // Desktop: Side by side
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Column(
                          children: [
                            _buildStructureDimensionsCard(),
                            const SizedBox(height: 16),
                            _buildPowerLineCard(),
                            const SizedBox(height: 16),
                            _buildEconomicCard(),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        flex: 2,
                        child: Column(
                          children: [
                            _buildEnvironmentalCard(),
                            const SizedBox(height: 16),
                            _buildTelecomCard(),
                            const SizedBox(height: 16),
                            _buildZoneDefinitionsCard(),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        flex: 2,
                        child: Column(
                          children: [
                            _buildCalculatedRiskCard(),
                            const SizedBox(height: 16),
                            _buildProtectionLevelCard(),
                          ],
                        ),
                      ),
                    ],
                  );
                }
              },
            ),

            const SizedBox(height: 32),

            // Export PDF Button
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.red[600]!, Colors.red[800]!],
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.red.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ElevatedButton.icon(
                onPressed: _isGeneratingPDF ? null : _generatePDF,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 32),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                icon: _isGeneratingPDF
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Icon(Icons.picture_as_pdf,
                        color: Colors.white, size: 24),
                label: Text(
                  _isGeneratingPDF
                      ? 'Generating PDF...'
                      : 'Export Professional PDF Report',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Disclaimer
            _buildDisclaimerCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildRiskSummaryCard() {
    final isProtectionRequired =
        widget.riskResult.r1 > widget.riskResult.tolerableR1;

    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isProtectionRequired
                ? [Colors.red[50]!, Colors.red[100]!]
                : [Colors.green[50]!, Colors.green[100]!],
          ),
        ),
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isProtectionRequired
                        ? Colors.red[200]
                        : Colors.green[200],
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    isProtectionRequired ? Icons.warning : Icons.check_circle,
                    color: isProtectionRequired
                        ? Colors.red[800]
                        : Colors.green[800],
                    size: 32,
                  ),
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Lightning Risk Assessment Results',
                        style:
                            Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[800],
                                ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        isProtectionRequired
                            ? 'Protection Required'
                            : 'Protection Not Required',
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: isProtectionRequired
                                      ? Colors.red[800]
                                      : Colors.green[800],
                                  fontWeight: FontWeight.w600,
                                ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: _buildRiskMetric('R1 (Human Life)',
                      widget.riskResult.r1, widget.riskResult.tolerableR1),
                ),
                Expanded(
                  child: _buildRiskMetric(
                      'Tolerable Risk', widget.riskResult.tolerableR1, null),
                ),
                Expanded(
                  child: _buildRiskMetric('Protection Level', null, null,
                      customValue: widget.riskResult.protectionLevel),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRiskMetric(String label, double? value, double? threshold,
      {String? customValue}) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            customValue ??
                (value != null ? value.toStringAsExponential(2) : 'N/A'),
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildStructureDimensionsCard() {
    return _buildSectionCard(
      'Structure Dimensions',
      Icons.business,
      Colors.blue,
      [
        _buildDataRow('Length of structure (m)', 'L',
            widget.zoneParameters.length.toString()),
        _buildDataRow('Width of the structure (m)', 'W',
            widget.zoneParameters.width.toString()),
        _buildDataRow('Height of the structure (m)*', 'H',
            widget.zoneParameters.height.toString()),
        _buildDataRow('*highest point measured from the ground level', '', ''),
        _buildDataRow('Is it a Complex Structure ?', '', 'No'),
        _buildDataRow('Collection Area (m²)', 'AD',
            widget.riskResult.collectionAreas['AD']?.toStringAsFixed(2) ?? '0'),
      ],
    );
  }

  Widget _buildEnvironmentalCard() {
    return _buildSectionCard(
      'Environmental Influences and Structure Attributes',
      Icons.cloud,
      Colors.green,
      [
        _buildDataRow(
            'Location Factor', 'CD', widget.zoneParameters.locationFactorKey),
        _buildDataRow('Lightning Flash Density', 'NG',
            widget.zoneParameters.lightningFlashDensity.toString()),
        _buildDataRow('LPS Status', 'PB', widget.zoneParameters.lpsStatus),
        _buildDataRow(
            'Mesh width', 'wm1', widget.zoneParameters.meshWidth1.toString()),
        _buildDataRow('Internal shield width', 'wm2',
            widget.zoneParameters.meshWidth2.toString()),
        _buildDataRow('Shielding Factor Ks1', 'Ks1',
            widget.zoneParameters.powerShieldingFactorKs1.toString()),
        _buildDataRow('Shielding Factor Ks2', 'Ks2',
            widget.zoneParameters.tlcShieldingFactorKs1.toString()),
        _buildDataRow('Equipotential Bonding', 'PEB',
            widget.zoneParameters.equipotentialBonding),
      ],
    );
  }

  Widget _buildPowerLineCard() {
    return _buildSectionCard(
      'Power Line Parameters',
      Icons.electrical_services,
      Colors.purple,
      [
        _buildDataRow('Length of Line', 'LL',
            widget.zoneParameters.lengthPowerLine.toString()),
        _buildDataRow('Type of Installation', 'CI',
            widget.zoneParameters.installationPowerLine),
        _buildDataRow(
            'Line Type', 'CT', widget.zoneParameters.lineTypePowerLine),
        _buildDataRow('Environmental Factor', 'CE',
            widget.zoneParameters.environmentalFactorKey),
        _buildDataRow('Shielding, Earthing & Insulation', 'CLD',
            widget.zoneParameters.powerShielding),
        _buildDataRow('Shielding, Earthing & Insulation', 'CLI',
            widget.zoneParameters.powerShielding),
        _buildDataRow('Withstand voltage of internal system', 'UW',
            widget.zoneParameters.powerUW.toString()),
        _buildDataRow(
            'Line Shielding', 'PLD', widget.zoneParameters.powerShielding),
      ],
    );
  }

  Widget _buildTelecomCard() {
    return _buildSectionCard(
      'Telecommunication Line Parameters',
      Icons.wifi,
      Colors.teal,
      [
        _buildDataRow('Length of Line', 'LL',
            widget.zoneParameters.lengthTlcLine.toString()),
        _buildDataRow('Type of Installation', 'CI',
            widget.zoneParameters.installationTlcLine),
        _buildDataRow('Line Type', 'CT', widget.zoneParameters.lineTypeTlcLine),
        _buildDataRow('Environmental Factor', 'CE',
            widget.zoneParameters.environmentalFactorKey),
        _buildDataRow('Shielding, Earthing & Insulation', 'CLD',
            widget.zoneParameters.tlcShielding),
        _buildDataRow('Shielding, Earthing & Insulation', 'CLI',
            widget.zoneParameters.tlcShielding),
        _buildDataRow('Withstand voltage of internal system', 'UW',
            widget.zoneParameters.tlcUW.toString()),
        _buildDataRow(
            'Line Shielding', 'PLD', widget.zoneParameters.tlcShielding),
      ],
    );
  }

  Widget _buildEconomicCard() {
    return _buildSectionCard(
      'Economic Valuation',
      Icons.attach_money,
      Colors.amber,
      [
        _buildDataRow('Total cost of Structure (Building Type)', '',
            'Medium Scale Industry'),
        _buildDataRow('Economic Value', '', ''),
        _buildDataRow('Is There any Economic Value', '', 'No'),
        _buildDataRow('Economic Value', '', ''),
        _buildDataRow('Is there any value of Animals', 'ca', 'No'),
        _buildDataRow('', 'cb', 'No'),
        _buildDataRow('', 'cc', 'No'),
        _buildDataRow('', 'cs', 'No'),
      ],
    );
  }

  Widget _buildZoneDefinitionsCard() {
    return _buildSectionCard(
      'Zone Definitions',
      Icons.layers,
      Colors.indigo,
      [
        _buildDataRow('Total No. of Zones', '', '2'),
        _buildDataRow('No. of Person in Zone 0', '', '0'),
        _buildDataRow('No. of Person in Zone 1', '',
            widget.zoneParameters.exposedPersonsNZ.toString()),
        _buildDataRow('Total No. of Persons (nt)', '',
            widget.zoneParameters.totalPersonsNT.toString()),
        _buildDataRow('Zone 0 Parameters', '', ''),
        _buildDataRow('Surface Type', 'rt', 'Agricultural, concrete'),
        _buildDataRow('Shock Protection', 'PTA',
            widget.zoneParameters.shockProtectionPTA),
        _buildDataRow('Protection Against Shock', 'PTU',
            widget.zoneParameters.shockProtectionPTU),
      ],
    );
  }

  Widget _buildCalculatedRiskCard() {
    return _buildSectionCard(
      'Calculated Risk Parameters',
      Icons.assessment,
      Colors.red,
      [
        _buildDataRow('Loss of Human Life', 'R1',
            widget.riskResult.r1.toStringAsExponential(2)),
        _buildDataRow(
            'Loss of Public Service', 'R2', 'No Loss of Public Service'),
        _buildDataRow(
            'Loss of Cultural Heritage', 'R3', 'No Loss of Cultural Heritage'),
        _buildDataRow('Economic Loss', 'R4', 'Economic Value Not Evaluated'),
        _buildDataRow('', '', ''),
        _buildDataRow('Required Level Of Protection', '', ''),
        _buildDataRow('Protection Measure (Physical Damage)', 'PB',
            widget.zoneParameters.lpsStatus),
        _buildDataRow('Protection Measure (Lightning Equipotential Bonding)',
            'PEB', widget.zoneParameters.equipotentialBonding),
      ],
    );
  }

  Widget _buildProtectionLevelCard() {
    return _buildSectionCard(
      'Calculated Risk after Protection Level Consideration',
      Icons.shield,
      Colors.green,
      [
        _buildDataRow('Loss of Human Life', 'R1',
            widget.riskResult.r1.toStringAsExponential(2)),
        _buildDataRow(
            'Loss of Public Service', 'R2', 'No Loss of Public Service'),
        _buildDataRow(
            'Loss of Cultural Heritage', 'R3', 'No Loss of Cultural Heritage'),
        _buildDataRow('Economic Loss', 'R4', 'Economic Value Not Evaluated'),
        _buildDataRow('', '', ''),
        _buildDataRow('Annual Savings [ SM= CL- ( CPM+CRL ) ]', '', ''),
        _buildDataRow('Investment on Protective measures is', '', 'N/A'),
      ],
    );
  }

  Widget _buildSectionCard(
      String title, IconData icon, Color color, List<Widget> children) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.white, color.withOpacity(0.03)],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              child: Row(
                children: [
                  Icon(icon, color: color, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      title,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: color,
                          ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(children: children),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDataRow(String parameter, String symbol, String value) {
    if (parameter.isEmpty && symbol.isEmpty && value.isEmpty) {
      return const SizedBox(height: 8);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              parameter,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontSize: 11,
                    color: Colors.grey[700],
                  ),
            ),
          ),
          if (symbol.isNotEmpty) ...[
            SizedBox(
              width: 40,
              child: Text(
                symbol,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[800],
                    ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontSize: 11,
                    color: Colors.grey[800],
                  ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDisclaimerCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.grey[50],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.info_outline, color: Colors.blue[700], size: 20),
                const SizedBox(width: 8),
                Text(
                  'Disclaimer',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[700],
                      ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'The IEC lightning risk assessment calculator is intended to assist in the analysis of various criteria to determine the risk of loss due to lightning. It is not possible to cover each special design element that may render a structure more or less susceptible to lightning damage. In special cases, personal and economic factors may be very important and should be considered in addition to the assessment obtained by use of this tool. It is intended that this tool be used in conjunction with the written standard IEC62305-2.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                    height: 1.4,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

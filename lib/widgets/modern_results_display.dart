import 'package:flutter/material.dart';
import '../models/risk_result.dart';
import '../models/zone_parameters.dart';
import '../services/modern_pdf_service.dart' as report;

class ModernResultsDisplay extends StatelessWidget {
  final RiskResult riskResult;
  final ZoneParameters zoneParameters;

  const ModernResultsDisplay({
    super.key,
    required this.riskResult,
    required this.zoneParameters,
  });

  @override
  Widget build(BuildContext context) {
    return _ModernResultsDisplayContent(
      key: ValueKey(
          '${riskResult.r1}_${riskResult.r2}_${riskResult.r3}_${riskResult.r4}_${riskResult.nd}'),
      riskResult: riskResult,
      zoneParameters: zoneParameters,
    );
  }
}

class _ModernResultsDisplayContent extends StatefulWidget {
  final RiskResult riskResult;
  final ZoneParameters zoneParameters;

  const _ModernResultsDisplayContent({
    super.key,
    required this.riskResult,
    required this.zoneParameters,
  });

  @override
  State<_ModernResultsDisplayContent> createState() =>
      _ModernResultsDisplayContentState();
}

class _ModernResultsDisplayContentState
    extends State<_ModernResultsDisplayContent>
    with SingleTickerProviderStateMixin {
  bool _isGeneratingPDF = false;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 7, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

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
    return SingleChildScrollView(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Risk Summary Card (Always visible)
          _buildRiskSummaryCard(),

          const SizedBox(height: 16),

          // Tab Bar
          Container(
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
            child: TabBar(
              controller: _tabController,
              isScrollable: true,
              labelColor: Colors.blue[800],
              unselectedLabelColor: Colors.grey[600],
              indicatorColor: Colors.blue[800],
              indicatorWeight: 3,
              tabs: const [
                Tab(icon: Icon(Icons.calculate), text: 'Collection Areas'),
                Tab(icon: Icon(Icons.flash_on), text: 'Dangerous Events'),
                Tab(icon: Icon(Icons.assessment), text: 'Risk Analysis'),
                Tab(icon: Icon(Icons.shield), text: 'After Protection'),
                Tab(icon: Icon(Icons.attach_money), text: 'Cost-Benefit'),
                Tab(icon: Icon(Icons.layers), text: 'Zone Parameters'),
                Tab(icon: Icon(Icons.business), text: 'Input Data'),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Tab Bar View with fixed height
          SizedBox(
            height: 600,
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildCollectionAreasTab(),
                _buildDangerousEventsTab(),
                _buildRiskAnalysisTab(),
                _buildAfterProtectionTab(),
                _buildCostBenefitTab(),
                _buildZoneParametersTab(),
                _buildInputDataTab(),
              ],
            ),
          ),

          const SizedBox(height: 16),

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
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
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

          const SizedBox(height: 16),

          // Disclaimer
          _buildDisclaimerCard(),
        ],
      ),
    );
  }

  Widget _buildRiskSummaryCard() {
    final r1 = widget.riskResult.r1;
    final r2 = widget.riskResult.r2;
    final r3 = widget.riskResult.r3;
    final r4 = widget.riskResult.r4;
    final rt1 = widget.riskResult.tolerableR1;

    final isProtectionRequired = r1 > rt1;

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
                      const SizedBox(height: 4),
                      Text(
                        'Recommended: ${widget.riskResult.protectionLevel}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.grey[700],
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _buildRiskMetric('R1 (Human Life)', r1, rt1),
                _buildRiskMetric('R2 (Public Service)', r2, 1e-3),
                _buildRiskMetric('R3 (Cultural Heritage)', r3, 1e-4),
                _buildRiskMetric('R4 (Economic Loss)', r4, 1e-3),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRiskMetric(String label, double value, double threshold) {
    final exceedsThreshold = value > threshold;

    return Container(
      constraints: const BoxConstraints(minWidth: 180),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: exceedsThreshold ? Colors.red[300]! : Colors.green[300]!,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                exceedsThreshold ? Icons.warning_amber : Icons.check_circle,
                color: exceedsThreshold ? Colors.red[700] : Colors.green[700],
                size: 20,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  label,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value.toStringAsExponential(2),
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: exceedsThreshold ? Colors.red[800] : Colors.green[800],
                ),
          ),
          const SizedBox(height: 4),
          Text(
            'Tolerable: ${threshold.toStringAsExponential(0)}',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey[500],
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildCollectionAreasTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildSectionCard(
            'Collection Areas',
            Icons.calculate,
            Colors.blue,
            [
              _buildDataRow(
                  'AD - Collection area for flashes to the structure',
                  'AD',
                  '${widget.riskResult.collectionAreas['AD']?.toStringAsFixed(2)} m²'),
              _buildDataRow(
                  'AM - Collection area for flashes near the structure',
                  'AM',
                  '${widget.riskResult.collectionAreas['AM']?.toStringAsFixed(2)} m²'),
              const Divider(),
              _buildDataRow('AL(P) - Collection area for power line', 'AL(P)',
                  '${widget.riskResult.collectionAreas['ALP']?.toStringAsFixed(2)} m²'),
              _buildDataRow('AL(T) - Collection area for telecom line', 'AL(T)',
                  '${widget.riskResult.collectionAreas['ALT']?.toStringAsFixed(2)} m²'),
              const Divider(),
              _buildDataRow(
                  'AI(P) - Collection area for power line ground flashes',
                  'AI(P)',
                  '${widget.riskResult.collectionAreas['AIP']?.toStringAsFixed(2)} m²'),
              _buildDataRow(
                  'AI(T) - Collection area for telecom line ground flashes',
                  'AI(T)',
                  '${widget.riskResult.collectionAreas['AIT']?.toStringAsFixed(2)} m²'),
              const Divider(),
              _buildDataRow(
                  'ADJ(P) - Adjacent structure collection area (Power)',
                  'ADJ(P)',
                  '${widget.riskResult.collectionAreas['ADJP']?.toStringAsFixed(2)} m²'),
              _buildDataRow(
                  'ADJ(T) - Adjacent structure collection area (Telecom)',
                  'ADJ(T)',
                  '${widget.riskResult.collectionAreas['ADJT']?.toStringAsFixed(2)} m²'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDangerousEventsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildSectionCard(
            'Annual Number of Dangerous Events',
            Icons.flash_on,
            Colors.orange,
            [
              _buildDataRow('ND - Flashes to the structure', 'ND',
                  widget.riskResult.nd.toStringAsFixed(4)),
              _buildDataRow('NM - Flashes near the structure', 'NM',
                  widget.riskResult.nm.toStringAsFixed(4)),
              const Divider(),
              _buildDataRow('NL(P) - Flashes to power line', 'NL(P)',
                  widget.riskResult.nl_p.toStringAsFixed(4)),
              _buildDataRow('NL(T) - Flashes to telecom line', 'NL(T)',
                  widget.riskResult.nl_t.toStringAsFixed(4)),
              const Divider(),
              _buildDataRow('NI(P/T) - Flashes near lines', 'NI',
                  widget.riskResult.ni.toStringAsFixed(4)),
              const Divider(),
              _buildDataRow('NDJ(P) - Flashes to adjacent structure (Power)',
                  'NDJ(P)', widget.riskResult.ndj_p.toStringAsFixed(4)),
              _buildDataRow('NDJ(T) - Flashes to adjacent structure (Telecom)',
                  'NDJ(T)', widget.riskResult.ndj_t.toStringAsFixed(4)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRiskAnalysisTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildSectionCard(
            'Risk Before Protection',
            Icons.assessment,
            Colors.red,
            [
              _buildDataRow('R1 - Risk of Loss of Human Life', 'R1',
                  '${widget.riskResult.r1.toStringAsExponential(2)} (Tolerable: ${widget.riskResult.tolerableR1.toStringAsExponential(0)})'),
              _buildDataRow('R2 - Risk of Loss of Public Service', 'R2',
                  '${widget.riskResult.r2.toStringAsExponential(2)} (Tolerable: 1.00E-3)'),
              _buildDataRow('R3 - Risk of Loss of Cultural Heritage', 'R3',
                  '${widget.riskResult.r3.toStringAsExponential(2)} (Tolerable: 1.00E-4)'),
              _buildDataRow('R4 - Risk of Economic Loss', 'R4',
                  '${widget.riskResult.r4.toStringAsExponential(2)} (Tolerable: 1.00E-3)'),
              const Divider(),
              _buildDataRow(
                  'Protection Required?',
                  '',
                  widget.riskResult.r1 > widget.riskResult.tolerableR1
                      ? 'YES'
                      : 'NO'),
              _buildDataRow('Recommended Protection Level', '',
                  widget.riskResult.protectionLevel),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAfterProtectionTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildSectionCard(
            'Risk After Protection Measures',
            Icons.shield,
            Colors.green,
            [
              _buildDataRow('R1 (After) - Risk of Loss of Human Life', 'R1',
                  '${widget.riskResult.r1AfterProtection.toStringAsExponential(2)}'),
              _buildDataRow('R2 (After) - Risk of Loss of Public Service', 'R2',
                  '${widget.riskResult.r2AfterProtection.toStringAsExponential(2)}'),
              _buildDataRow(
                  'R3 (After) - Risk of Loss of Cultural Heritage',
                  'R3',
                  '${widget.riskResult.r3AfterProtection.toStringAsExponential(2)}'),
              _buildDataRow('R4 (After) - Risk of Economic Loss', 'R4',
                  '${widget.riskResult.r4AfterProtection.toStringAsExponential(2)}'),
              const Divider(),
              _buildDataRow('R1 Reduction', '',
                  '${((1 - widget.riskResult.r1AfterProtection / widget.riskResult.r1) * 100).toStringAsFixed(1)}%'),
              _buildDataRow('R2 Reduction', '',
                  '${((1 - widget.riskResult.r2AfterProtection / widget.riskResult.r2) * 100).toStringAsFixed(1)}%'),
              _buildDataRow('R4 Reduction', '',
                  '${((1 - widget.riskResult.r4AfterProtection / widget.riskResult.r4) * 100).toStringAsFixed(1)}%'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCostBenefitTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildSectionCard(
            'Cost-Benefit Analysis',
            Icons.attach_money,
            Colors.amber,
            [
              _buildDataRow('Total Cost of Structure', 'Ctotal',
                  '\$${widget.riskResult.totalCostOfStructure.toStringAsFixed(2)} million USD'),
              const Divider(),
              _buildDataRow('CL - Cost of Loss Before Protection', 'CL',
                  '\$${widget.riskResult.costOfLossBeforeProtection.toStringAsFixed(4)} million USD'),
              _buildDataRow('CRL - Cost of Loss After Protection', 'CRL',
                  '\$${widget.riskResult.costOfLossAfterProtection.toStringAsFixed(4)} million USD'),
              _buildDataRow('CPM - Annual Cost of Protection Measures', 'CPM',
                  '\$${widget.riskResult.annualCostOfProtection.toStringAsFixed(4)} million USD'),
              const Divider(),
              _buildDataRow('SM - Annual Savings (CL - CPM - CRL)', 'SM',
                  '\$${widget.riskResult.annualSavings.toStringAsFixed(4)} million USD'),
              const Divider(),
              _buildDataRow('Is Protection Economical?', '',
                  widget.riskResult.isProtectionEconomical ? 'YES' : 'NO'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildZoneParametersTab() {
    final z0 = widget.zoneParameters.zoneParameters['zone0'] ?? {};
    final z1 = widget.zoneParameters.zoneParameters['zone1'] ?? {};

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildSectionCard(
            'Zone 0 Parameters',
            Icons.location_city,
            Colors.purple,
            [
              _buildDataRow(
                  'Floor Surface Type', 'rt', z0['rt']?.toString() ?? 'N/A'),
              _buildDataRow(
                  'Shock Protection', 'PTA', z0['PTA']?.toString() ?? 'N/A'),
              _buildDataRow('Protection Against Shock', 'PTU',
                  z0['PTU']?.toString() ?? 'N/A'),
              _buildDataRow(
                  'Risk of Fire', 'rf', z0['rf']?.toString() ?? 'N/A'),
              _buildDataRow(
                  'Fire Protection', 'rp', z0['rp']?.toString() ?? 'N/A'),
              _buildDataRow(
                  'Spatial Shield', 'KS2', z0['KS2']?.toString() ?? 'N/A'),
              _buildDataRow('Internal Power Systems', 'hz',
                  z0['hz']?.toString() ?? 'N/A'),
              const Divider(),
              _buildDataRow('People in Danger', 'np',
                  z0['np']?.toStringAsFixed(4) ?? 'N/A'),
              _buildDataRow('Cultural Heritage Potential', 'cp',
                  z0['cp']?.toStringAsFixed(4) ?? 'N/A'),
              _buildDataRow('Structure Value Potential', 'sp',
                  z0['sp']?.toStringAsFixed(4) ?? 'N/A'),
            ],
          ),
          const SizedBox(height: 16),
          _buildSectionCard(
            'Zone 1 Parameters',
            Icons.business,
            Colors.indigo,
            [
              _buildDataRow(
                  'Floor Surface Type', 'rt', z1['rt']?.toString() ?? 'N/A'),
              _buildDataRow(
                  'Shock Protection', 'PTA', z1['PTA']?.toString() ?? 'N/A'),
              _buildDataRow('Protection Against Shock', 'PTU',
                  z1['PTU']?.toString() ?? 'N/A'),
              _buildDataRow(
                  'Risk of Fire', 'rf', z1['rf']?.toString() ?? 'N/A'),
              _buildDataRow(
                  'Fire Protection', 'rp', z1['rp']?.toString() ?? 'N/A'),
              _buildDataRow(
                  'Spatial Shield', 'KS2', z1['KS2']?.toString() ?? 'N/A'),
              _buildDataRow('Power Internal Wiring', 'KS3',
                  z1['KS3_power']?.toString() ?? 'N/A'),
              _buildDataRow(
                  'Power SPD', 'PSPD', z1['PSPD_power']?.toString() ?? 'N/A'),
              _buildDataRow('Telecom Internal Wiring', 'KS3',
                  z1['KS3_telecom']?.toString() ?? 'N/A'),
              _buildDataRow('Telecom SPD', 'PSPD',
                  z1['PSPD_telecom']?.toString() ?? 'N/A'),
              _buildDataRow('Internal Power Systems', 'hz',
                  z1['hz']?.toString() ?? 'N/A'),
              const Divider(),
              _buildDataRow('People in Danger', 'np',
                  z1['np']?.toStringAsFixed(4) ?? 'N/A'),
              _buildDataRow('Cultural Heritage Potential', 'cp',
                  z1['cp']?.toStringAsFixed(4) ?? 'N/A'),
              _buildDataRow('Structure Value Potential', 'sp',
                  z1['sp']?.toStringAsFixed(4) ?? 'N/A'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInputDataTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildSectionCard(
            'Structure Dimensions',
            Icons.business,
            Colors.blue,
            [
              _buildDataRow('Length', 'L', '${widget.zoneParameters.length} m'),
              _buildDataRow('Width', 'W', '${widget.zoneParameters.width} m'),
              _buildDataRow('Height', 'H', '${widget.zoneParameters.height} m'),
              _buildDataRow('Construction Material', 'PS',
                  widget.zoneParameters.constructionMaterial),
              _buildDataRow('Collection Area', 'AD',
                  '${widget.riskResult.collectionAreas['AD']?.toStringAsFixed(2)} m²'),
            ],
          ),
          const SizedBox(height: 16),
          _buildSectionCard(
            'Environmental Factors',
            Icons.cloud,
            Colors.green,
            [
              _buildDataRow('Lightning Flash Density', 'NG',
                  '${widget.zoneParameters.lightningFlashDensity} flashes/km²/year'),
              _buildDataRow('Location Factor', 'CD',
                  widget.zoneParameters.locationFactorKey),
              _buildDataRow('Environmental Factor', 'CE',
                  widget.zoneParameters.environmentalFactorKey),
              _buildDataRow(
                  'LPS Status', 'PB', widget.zoneParameters.lpsStatus),
              _buildDataRow('Equipotential Bonding', 'PEB',
                  widget.zoneParameters.equipotentialBonding),
            ],
          ),
          const SizedBox(height: 16),
          _buildSectionCard(
            'Power Line Parameters',
            Icons.electrical_services,
            Colors.purple,
            [
              _buildDataRow(
                  'Length', 'LL', '${widget.zoneParameters.lengthPowerLine} m'),
              _buildDataRow('Installation Type', 'CI',
                  widget.zoneParameters.installationPowerLine),
              _buildDataRow(
                  'Line Type', 'CT', widget.zoneParameters.lineTypePowerLine),
              _buildDataRow('Withstand Voltage', 'UW',
                  '${widget.zoneParameters.powerUW} kV'),
              _buildDataRow(
                  'Shielding', 'CLD', widget.zoneParameters.powerShielding),
            ],
          ),
          const SizedBox(height: 16),
          _buildSectionCard(
            'Telecom Line Parameters',
            Icons.wifi,
            Colors.teal,
            [
              _buildDataRow(
                  'Length', 'LL', '${widget.zoneParameters.lengthTlcLine} m'),
              _buildDataRow('Installation Type', 'CI',
                  widget.zoneParameters.installationTlcLine),
              _buildDataRow(
                  'Line Type', 'CT', widget.zoneParameters.lineTypeTlcLine),
              _buildDataRow('Withstand Voltage', 'UW',
                  '${widget.zoneParameters.tlcUW} kV'),
              _buildDataRow(
                  'Shielding', 'CLD', widget.zoneParameters.tlcShielding),
            ],
          ),
          const SizedBox(height: 16),
          _buildSectionCard(
            'Economic & Cultural Values',
            Icons.account_balance,
            Colors.amber,
            [
              _buildDataRow('Total Cost of Structure', '',
                  widget.zoneParameters.totalCostOfStructure),
              _buildDataRow('Exposure Time', 'TZ',
                  '${widget.zoneParameters.exposureTimeTZ} hours/year'),
              _buildDataRow('Total Persons', 'nt',
                  '${widget.zoneParameters.totalPersonsNT}'),
              _buildDataRow('Persons in Zone 0', 'nz0',
                  '${widget.zoneParameters.personsZone0}'),
              _buildDataRow('Persons in Zone 1', 'nz1',
                  '${widget.zoneParameters.personsZone1}'),
              const Divider(),
              _buildDataRow('Animals Value', 'ca', widget.zoneParameters.ca),
              _buildDataRow('Building Value', 'cb', widget.zoneParameters.cb),
              _buildDataRow('Content Value', 'cc', widget.zoneParameters.cc),
              _buildDataRow('Systems Value', 'cs', widget.zoneParameters.cs),
              const Divider(),
              _buildDataRow('Cultural Heritage Z0', 'cZ0',
                  '${widget.zoneParameters.cZ0}%'),
              _buildDataRow('Cultural Heritage Z1', 'cZ1',
                  '${widget.zoneParameters.cZ1}%'),
            ],
          ),
        ],
      ),
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
                  Icon(icon, color: color, size: 24),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Text(
              parameter,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[700],
                  ),
            ),
          ),
          if (symbol.isNotEmpty) ...[
            Container(
              width: 60,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                symbol,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[800],
                    ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(width: 12),
          ],
          Expanded(
            flex: 4,
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[900],
                    fontWeight: FontWeight.w500,
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
          color: Colors.blue[50],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.info_outline, color: Colors.blue[700], size: 24),
                const SizedBox(width: 12),
                Text(
                  'Disclaimer',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[800],
                      ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'The IEC lightning risk assessment calculator is intended to assist in the analysis of various criteria to determine the risk of loss due to lightning. It is not possible to cover each special design element that may render a structure more or less susceptible to lightning damage. In special cases, personal and economic factors may be very important and should be considered in addition to the assessment obtained by use of this tool. It is intended that this tool be used in conjunction with the written standard IEC62305-2.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[700],
                    height: 1.5,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

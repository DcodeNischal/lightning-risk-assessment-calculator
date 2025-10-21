import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../models/risk_result.dart';
import '../models/zone_parameters.dart';

// --- PDF Generation Service ---

class ModernPDFService {
  Future<void> generateModernReport(
      RiskResult riskResult, ZoneParameters zoneParams) async {
    try {
      final pdf = pw.Document();

      // --- FONT LOADING LOGIC HAS BEEN REMOVED ---

      pdf.addPage(
        pw.MultiPage(
          // The 'theme' property has been removed to use default fonts
          pageFormat: PdfPageFormat.a4.landscape,
          margin: const pw.EdgeInsets.all(20),
          build: (pw.Context context) {
            return [
              _buildReportBody(riskResult, zoneParams),
              pw.SizedBox(height: 15),
              _buildDisclaimer(),
            ];
          },
        ),
      );

      final pdfBytes = await pdf.save();
      await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdfBytes,
        name: 'Lightning_Risk_Assessment_Report.pdf',
      );
    } catch (e) {
      print('PDF Generation Error: $e');
      rethrow;
    }
  }

  pw.Widget _buildReportBody(RiskResult riskResult, ZoneParameters zoneParams) {
    return pw.Column(
      children: [
        // --- TOP SECTION ---
        pw.Table(
          border: pw.TableBorder.all(color: PdfColors.grey, width: 0.5),
          columnWidths: const {
            0: pw.FlexColumnWidth(3),
            1: pw.FlexColumnWidth(4),
            2: pw.FlexColumnWidth(4),
            3: pw.FlexColumnWidth(4),
          },
          children: [
            pw.TableRow(
              decoration: const pw.BoxDecoration(color: PdfColors.grey200),
              children: [
                _buildHeaderCell('Structure Dimensions'),
                _buildHeaderCell(
                    'Environmental Influences and Structure Attributes'),
                _buildHeaderCell('Power Line Parameters'),
                _buildHeaderCell('Telecommunication Line Parameters'),
              ],
            ),
            pw.TableRow(
              verticalAlignment: pw.TableCellVerticalAlignment.top,
              children: [
                _buildStructureColumn(riskResult, zoneParams),
                _buildEnvironmentalColumn(zoneParams),
                _buildPowerLineColumn(zoneParams),
                _buildTelecomLineColumn(zoneParams),
              ],
            ),
          ],
        ),
        pw.SizedBox(height: 5),
        // --- MIDDLE SECTION ---
        pw.Table(
          border: pw.TableBorder.all(color: PdfColors.grey, width: 0.5),
          columnWidths: const {
            0: pw.FlexColumnWidth(2),
            1: pw.FlexColumnWidth(2),
            2: pw.FlexColumnWidth(4),
            3: pw.FlexColumnWidth(3),
          },
          children: [
            pw.TableRow(
              decoration: const pw.BoxDecoration(color: PdfColors.grey200),
              children: [
                _buildHeaderCell('Economic Value', flex: 2),
                _buildHeaderCell('Zone Definitions', flex: 2),
                _buildHeaderCell('Zone 1 Parameters', flex: 4),
                _buildHeaderCell('Calculated Risk Parameters',
                    flex: 3, color: PdfColors.red50),
              ],
            ),
            pw.TableRow(
              verticalAlignment: pw.TableCellVerticalAlignment.top,
              children: [
                _buildEconomicValueColumn(zoneParams),
                _buildZoneDefinitionsColumn(zoneParams),
                _buildZone1ParametersColumn(zoneParams),
                _buildCalculatedRiskColumn(riskResult),
              ],
            ),
          ],
        ),
        pw.SizedBox(height: 5),
        // --- BOTTOM SECTION ---
        pw.Table(
          border: pw.TableBorder.all(color: PdfColors.grey, width: 0.5),
          columnWidths: const {
            0: pw.FlexColumnWidth(4),
            1: pw.FlexColumnWidth(4),
            2: pw.FlexColumnWidth(3),
          },
          children: [
            pw.TableRow(
              decoration: const pw.BoxDecoration(color: PdfColors.grey200),
              children: [
                _buildHeaderCell('Zone 0 Parameters'),
                _buildHeaderCell('Required Level Of Protection'),
                _buildHeaderCell(
                    'Calculated Risk after Protection Level Consideration',
                    color: PdfColors.red50),
              ],
            ),
            pw.TableRow(
              verticalAlignment: pw.TableCellVerticalAlignment.top,
              children: [
                _buildZone0ParametersColumn(zoneParams),
                _buildRequiredProtectionColumn(riskResult, zoneParams),
                _buildRiskAfterProtectionColumn(riskResult),
              ],
            ),
          ],
        ),
      ],
    );
  }

  // --- COLUMN BUILDERS (No changes needed below this line) ---

  pw.Widget _buildStructureColumn(
      RiskResult riskResult, ZoneParameters zoneParams) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(2),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          _buildParamRow(
              'Length of structure (m)', 'L', zoneParams.length.toString()),
          _buildParamRow(
              'Width of the structure (m)', 'W', zoneParams.width.toString()),
          _buildParamRow('Height of the structure (m)*', 'H',
              zoneParams.height.toString()),
          _buildParamRow(
              '*highest point measured from the ground level', '', '',
              isNote: true),
          _buildParamRow('Is it a Complex Structure ?', '', 'No'),
          _buildParamRow('Collection Area (m²)', 'AD',
              (riskResult.collectionAreas['AD'] ?? 0).toStringAsFixed(2)),
          _buildSectionDivider('Adjacent Structure Dimensions (If Any)'),
          _buildParamRow('Adjacent Structure Length (m)', 'LDJ',
              zoneParams.adjLength.toString()),
          _buildParamRow('Adjacent Structure Breadth (m)', 'WDJ',
              zoneParams.adjWidth.toString()),
          _buildParamRow('Adjacent Structure Height (m)', 'HDJ',
              zoneParams.adjHeight.toString()),
          _buildParamRow('Collection Area of Adjacent Structure', 'ADJ', 'N/A'),
        ],
      ),
    );
  }

  pw.Widget _buildEnvironmentalColumn(ZoneParameters zoneParams) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(2),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          _buildParamRow('Location Factor', 'CD', zoneParams.locationFactorKey),
          _buildParamRow('Lightning Flash Density', 'NG',
              zoneParams.lightningFlashDensity.toString()),
          _buildParamRow('LPS Status', 'PB', zoneParams.lpsStatus),
          _buildParamRow('Mesh width', 'wm1', zoneParams.meshWidth1.toString()),
          _buildParamRow(
              'Internal shield width', 'wm2', zoneParams.meshWidth2.toString()),
          _buildParamRow('Shielding Factor Ks1', 'Ks1',
              zoneParams.powerShieldingFactorKs1.toString()),
          _buildParamRow('Shielding Factor Ks2', 'Ks2',
              zoneParams.tlcShieldingFactorKs1.toString()),
          _buildParamRow(
              'Equipotential Bonding', 'PEB', zoneParams.equipotentialBonding),
          _buildParamRow('Location Factor of Adjacent Structure', 'CDJ',
              zoneParams.adjLocationFactor),
          _buildParamRow(
              'Does this Building provide services to the public ?', '', 'No'),
          _buildParamRow('Does this building have cultural value ?', '', 'No'),
        ],
      ),
    );
  }

  pw.Widget _buildPowerLineColumn(ZoneParameters zoneParams) {
    Map<String, dynamic> zone1 = zoneParams.zoneParameters['zone1'] ?? {};

    return pw.Padding(
      padding: const pw.EdgeInsets.all(2),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          _buildParamRow(
              'Length of Line', 'LL', zoneParams.lengthPowerLine.toString()),
          _buildParamRow(
              'Type of Installation', 'CI', zoneParams.installationPowerLine),
          _buildParamRow('Line Type', 'CT', zoneParams.lineTypePowerLine),
          _buildParamRow(
              'Environmental Factor', 'CE', zoneParams.environmentalFactorKey),
          _buildParamRow('Shielding, Earthing & Insulation', 'CLD',
              zoneParams.powerShielding),
          _buildParamRow('Shielding, Earthing & Insulation', 'CLI',
              zoneParams.powerShielding),
          _buildParamRow('Withstand voltage of internal system', 'UW',
              zoneParams.powerUW.toString()),
          _buildParamRow('Line Shielding', 'PLD', zoneParams.powerShielding),
          _buildParamRow(
              'Shielding Near Line', 'PLI', zoneParams.powerUW.toString()),
          _buildParamRow(
              'Impulse withstand voltage (resistibility)', 'KS4', '0.667'),
          _buildParamRow(
              'Internal wiring:  Routing and Shielding',
              'KS3',
              zone1['KS3_power']?.toString() ??
                  'Unshielded Cable - no routing precaution to avoid loops (loop surface 50 m2)'),
        ],
      ),
    );
  }

  pw.Widget _buildTelecomLineColumn(ZoneParameters zoneParams) {
    Map<String, dynamic> zone1 = zoneParams.zoneParameters['zone1'] ?? {};

    return pw.Padding(
      padding: const pw.EdgeInsets.all(2),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          _buildParamRow(
              'Length of Line', 'LL', zoneParams.lengthTlcLine.toString()),
          _buildParamRow(
              'Type of Installation', 'CI', zoneParams.installationTlcLine),
          _buildParamRow('Line Type', 'CT', zoneParams.lineTypeTlcLine),
          _buildParamRow(
              'Environmental Factor', 'CE', zoneParams.environmentalFactorKey),
          _buildParamRow('Shielding, Earthing & Insulation', 'CLD',
              zoneParams.tlcShielding),
          _buildParamRow('Shielding, Earthing & Insulation', 'CLI',
              zoneParams.tlcShielding),
          _buildParamRow('Withstand voltage of internal system', 'UW',
              zoneParams.tlcUW.toString()),
          _buildParamRow('Line Shielding', 'PLD', zoneParams.tlcShielding),
          _buildParamRow(
              'Shielding Near Line', 'PLI', zoneParams.tlcUW.toString()),
          _buildParamRow(
              'Impulse withstand voltage (resistibility)', 'KS4', '0.667'),
          _buildParamRow(
              'Internal wiring:  Routing and Shielding',
              'KS3',
              zone1['KS3_telecom']?.toString() ??
                  'Unshielded Cable - no routing precaution to avoid loops (loop surface 50 m2)'),
        ],
      ),
    );
  }

  pw.Widget _buildEconomicValueColumn(ZoneParameters zoneParams) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(2),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          _buildParamRow('Total cost of Structure (Building Type)', '',
              zoneParams.totalCostOfStructure),
          pw.SizedBox(height: 3),
          _buildSectionDivider('Economic Value'),
          _buildParamRow(
              'Is There any Economic Value', '', zoneParams.isAnyEconomicValue),
          pw.SizedBox(height: 3),
          _buildSectionDivider('Economic Value'),
          _buildParamRow('Is there any value of Animals', 'ca', zoneParams.ca),
          _buildParamRow('', 'cb', zoneParams.cb),
          _buildParamRow('', 'cc', zoneParams.cc),
          _buildParamRow('', 'cs', zoneParams.cs),
          pw.SizedBox(height: 3),
          _buildSectionDivider('Cultural Heritage Value'),
          _buildParamRow('Value of Cultural Heritage Z0 (in Percent)', 'cZ0',
              zoneParams.cZ0),
          _buildParamRow('Value of Cultural Heritage Z1 (in Percent)', 'cZ1',
              zoneParams.cZ1.toString()),
          _buildParamRow(
              'Total Value of Building', 'ct', zoneParams.ct.toString()),
          pw.SizedBox(height: 3),
          _buildParamRow('Life support via device ? (Hospital)', '',
              zoneParams.lifeSupportDevice),
          _buildParamRow('Animal with economical value (Farm)', '',
              zoneParams.isAnyValueofAnimals),
          _buildParamRow('For Hospital', 'X', zoneParams.X.toString()),
          _buildParamRow('Is Power Line Parameters Present?', '',
              zoneParams.powerLinePresent ? 'Yes' : 'No'),
          _buildParamRow('Is Telecommunication Parameters Present?', '',
              zoneParams.telecomPresent ? 'Yes' : 'No'),
        ],
      ),
    );
  }

  pw.Widget _buildZoneDefinitionsColumn(ZoneParameters zoneParams) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(2),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          _buildParamRow('Total No. of Zones', '',
              zoneParams.totalZones.toStringAsFixed(0)),
          _buildParamRow('No. of Person in Zone 0', '',
              zoneParams.personsZone0.toStringAsFixed(0)),
          _buildParamRow('No. of Person in Zone 1', '',
              zoneParams.personsZone1.toStringAsFixed(0)),
          _buildParamRow('Total No. of Persons\n(nt)', '',
              zoneParams.totalPersons.toStringAsFixed(0)),
        ],
      ),
    );
  }

  pw.Widget _buildZone1ParametersColumn(ZoneParameters zoneParams) {
    // Get Zone 1 parameters
    Map<String, dynamic> zone1 = zoneParams.zoneParameters['zone1'] ?? {};

    return pw.Padding(
      padding: const pw.EdgeInsets.all(2),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          _buildParamRow('Floor surface type', 'rt',
              zone1['rt']?.toString() ?? 'Asphalt, linoleum, wood'),
          _buildParamRow('Protection against Shock', 'PTA',
              zone1['PTA']?.toString() ?? 'No protection measures'),
          _buildParamRow('Shock Protection', 'PTU',
              zone1['PTU']?.toString() ?? 'No protection measure'),
          _buildParamRow('Risk of fire', 'rf',
              zone1['rf']?.toString() ?? 'Fire(Ordinary)'),
          _buildParamRow('Fire Protection', 'rp',
              zone1['rp']?.toString() ?? 'No measures'),
          _buildParamRow(
              'Spatial Shield', 'KS2', zone1['KS2']?.toString() ?? '1'),
          _buildParamRow(
              'Power (Internal Wiring)',
              'KS3',
              zone1['KS3_power']?.toString() ??
                  'Unshielded Cable - no routing precaution to avoid loops (loop surface 50 m2)'),
          _buildParamRow('Power (Coordinated SPDs)', 'PSPD',
              zone1['PSPD_power']?.toString() ?? 'No coordinated SPD system'),
          _buildParamRow(
              'Telecom (Internal Wiring)',
              'KS3',
              zone1['KS3_telecom']?.toString() ??
                  'Unshielded Cable - no routing precaution to avoid loops (loop surface 50 m2)'),
          _buildParamRow('Telecom (Coordinated SPDs)', 'PSPD',
              zone1['PSPD_telecom']?.toString() ?? 'No coordinated SPD system'),
          _buildParamRow('Internal Power systems', 'hz',
              zone1['hz']?.toString() ?? 'No special risk'),
          _buildParamRow('L1 : Loss of Human Life', 'LT',
              zone1['LT']?.toString() ?? 'All types'),
          _buildParamRow(
              '',
              'LF1',
              zone1['LF1']?.toString() ??
                  'Hospital, Hotel, School, Public Building',
              isSubValue: true),
          _buildSectionDivider('Calculated Zone 1 Factors'),
          _buildParamRow('People in danger', 'np',
              zone1['np']?.toStringAsFixed(4) ?? '1.0'),
          _buildParamRow('Cultural heritage potential', 'cp',
              zone1['cp']?.toStringAsFixed(4) ?? '0.9'),
          _buildParamRow('Structure value potential', 'sp',
              zone1['sp']?.toStringAsFixed(4) ?? '1.0'),
          pw.SizedBox(height: 5),
          _buildParamRow('L2 : Loss of Public Service', 'LF2',
              zone1['LF2']?.toString() ?? 'TV, telecommunication(LF)'),
          _buildParamRow('', 'LO2',
              zone1['LO2']?.toString() ?? 'TV, telecommunication(LO)',
              isSubValue: true),
          _buildParamRow('L3 : Loss of Cultural Heritage', 'LF3',
              zone1['LF3']?.toString() ?? 'None'),
          _buildParamRow('L4: Economic Loss', 'LT4',
              zone1['LT4']?.toString() ?? 'LT(None)'),
          _buildParamRow(
              '',
              'LF4',
              zone1['LF4']?.toString() ??
                  'hotel, school, office building, church, entertainment facility, economically used plant',
              isSubValue: true),
          _buildParamRow(
              '',
              'LO4',
              zone1['LO4']?.toString() ??
                  'hospital, industrial structure, office building, hotel, economically used plant',
              isSubValue: true),
        ],
      ),
    );
  }

  pw.Widget _buildCalculatedRiskColumn(RiskResult riskResult) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(2),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          _buildParamRow('Loss of Human Life', 'R1',
              riskResult.r1.toStringAsExponential(2)),
          _buildParamRow(
              'Loss of Public Service',
              'R2',
              riskResult.r2 == 0
                  ? 'No Loss of Public Service'
                  : riskResult.r2.toStringAsExponential(2)),
          _buildParamRow(
              'Loss of Cultural Heritage',
              'R3',
              riskResult.r3 == 0
                  ? 'No Loss of Cultural Heritage Value'
                  : riskResult.r3.toStringAsExponential(2)),
          _buildParamRow(
              'Economic Loss',
              'R4',
              riskResult.r4 == 0
                  ? 'Economic Value Not Evaluated'
                  : riskResult.r4.toStringAsExponential(2)),
        ],
      ),
    );
  }

  pw.Widget _buildZone0ParametersColumn(ZoneParameters zoneParams) {
    // Get Zone 0 parameters
    Map<String, dynamic> zone0 = zoneParams.zoneParameters['zone0'] ?? {};

    return pw.Padding(
      padding: const pw.EdgeInsets.all(2),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          _buildParamRow('Surface Type', 'rt',
              zone0['rt']?.toString() ?? 'Agricultural, concrete'),
          _buildParamRow('Shock Protection', 'PTA',
              zone0['PTA']?.toString() ?? 'No protection measures'),
          _buildParamRow('Protection Against Shock', 'PTU',
              zone0['PTU']?.toString() ?? 'No protection measure'),
          _buildParamRow('Risk of fire', 'rf',
              zone0['rf']?.toString() ?? 'Fire(Ordinary)'),
          _buildParamRow('Fire protection', 'rp',
              zone0['rp']?.toString() ?? 'No measures'),
          _buildParamRow('Internal Spatial Shield', 'KS2',
              zone0['KS2']?.toString() ?? '1'),
          _buildParamRow('Internal Power systems', 'hz',
              zone0['hz']?.toString() ?? 'No special risk'),
          _buildParamRow('L1 : Loss of human life', 'LT',
              zone0['LT']?.toString() ?? 'All types'),
          _buildParamRow(
              '',
              'LF1',
              zone0['LF1']?.toString() ??
                  'Hospital, Hotel, School, Public Building',
              isSubValue: true),
          _buildParamRow('', 'LO1', zone0['LO1']?.toString() ?? 'LO(Others)',
              isSubValue: true),
          _buildParamRow('L2: Loss of Public Service', 'LF2',
              zone0['LF2']?.toString() ?? 'LF(None)'),
          _buildParamRow('', 'LO2', zone0['LO2']?.toString() ?? 'LO(None)',
              isSubValue: true),
          _buildParamRow('L3: Loss of Cultural Heritage', 'LF3',
              zone0['LF3']?.toString() ?? 'None'),
          _buildParamRow('L4: Economic Loss', 'LT4',
              zone0['LT4']?.toString() ?? 'LT(None)'),
          _buildParamRow('', 'LF4', zone0['LF4']?.toString() ?? 'LF(Others)',
              isSubValue: true),
          _buildParamRow(
              '',
              'LO4',
              zone0['LO4']?.toString() ??
                  'hospital, industrial structure, office building, hotel, economically used plant',
              isSubValue: true),
          pw.SizedBox(height: 10),
          _buildSectionDivider('Calculated Zone 0 Factors'),
          _buildParamRow(
              'People in danger', 'np', zone0['np']?.toStringAsFixed(4) ?? '0'),
          _buildParamRow('Cultural heritage potential', 'cp',
              zone0['cp']?.toStringAsFixed(4) ?? '0.1'),
          _buildParamRow('Structure value potential', 'sp',
              zone0['sp']?.toStringAsFixed(4) ?? '1.0'),
          pw.SizedBox(height: 5),
          _buildSectionDivider('Cultural Heritage Value'),
          _buildParamRow('Value of Cultural Heritage Z0 (in Percent)', 'cZ0',
              zoneParams.cZ0),
          _buildParamRow('Value of Cultural Heritage Z1 (in Percent)', 'cZ1',
              zoneParams.cZ1.toString()),
          _buildParamRow(
              'Total Value of Building', 'ct', zoneParams.ct.toString()),
          pw.SizedBox(height: 5),
          _buildSectionDivider(''),
          _buildParamRow('Life support via device ? (Hospital)', '',
              zoneParams.lifeSupportDevice),
          _buildParamRow('Animal with economical value (Farm)', '',
              zoneParams.isAnyValueofAnimals),
          _buildParamRow('Is Power Line Parameters Present?', '',
              zoneParams.powerLinePresent ? 'Yes' : 'No'),
          _buildParamRow('Is Telecommunication Parameters Present?', '',
              zoneParams.telecomPresent ? 'Yes' : 'No'),
        ],
      ),
    );
  }

  pw.Widget _buildRequiredProtectionColumn(
      RiskResult riskResult, ZoneParameters zoneParams) {
    // Get Zone 1 parameters for coordinated SPD
    Map<String, dynamic> zone1 = zoneParams.zoneParameters['zone1'] ?? {};

    return pw.Padding(
      padding: const pw.EdgeInsets.all(2),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          _buildParamRow('Protection Measure (Physical Damage)', 'PB',
              zoneParams.lpsStatus),
          _buildParamRow('Protection Measure (Lightning Equipotential Bonding)',
              'PEB', zoneParams.equipotentialBonding),
          _buildParamRow('Coordinated Surge Protection (Power)', 'PSPD(P)',
              zone1['PSPD_power']?.toString() ?? 'No coordinated SPD system'),
          _buildParamRow('Coordinated Surge Protection (Telecom)', 'PSPD(T)',
              zone1['PSPD_telecom']?.toString() ?? 'No coordinated SPD system'),
        ],
      ),
    );
  }

  pw.Widget _buildRiskAfterProtectionColumn(RiskResult riskResult) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(2),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          _buildParamRow('Loss of Human Life', 'R1',
              riskResult.r1AfterProtection.toStringAsExponential(2)),
          _buildParamRow(
              'Loss of Public Service',
              'R2',
              riskResult.r2AfterProtection == 0
                  ? 'No Loss of Public Service'
                  : riskResult.r2AfterProtection.toStringAsExponential(2)),
          _buildParamRow(
              'Loss of Cultural Heritage',
              'R3',
              riskResult.r3AfterProtection == 0
                  ? 'No Loss of Cultural Heritage Value'
                  : riskResult.r3AfterProtection.toStringAsExponential(2)),
          _buildParamRow(
              'Economic Loss',
              'R4',
              riskResult.r4AfterProtection == 0
                  ? 'Economic Value Not Evaluated'
                  : riskResult.r4AfterProtection.toStringAsExponential(2)),
          pw.SizedBox(height: 5),
          _buildSectionDivider('Annual Savings [ SM= CL- ( CPM+CRL ) ]'),
          _buildParamRow('Investment on Protective measures is', '', 'N/A'),
        ],
      ),
    );
  }

  pw.Widget _buildHeaderCell(String text,
      {int flex = 1, PdfColor color = PdfColors.grey200}) {
    return pw.Expanded(
      flex: flex,
      child: pw.Container(
        decoration: pw.BoxDecoration(color: color),
        padding: const pw.EdgeInsets.all(4),
        child: pw.Text(
          text,
          style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 9),
          textAlign: pw.TextAlign.center,
        ),
      ),
    );
  }

  pw.Widget _buildParamRow(
    String label,
    String symbol,
    String value, {
    bool isNote = false,
    bool isSubValue = false,
    PdfColor valueColor = PdfColors.black,
    PdfColor? backgroundColor,
  }) {
    return pw.Container(
      color: backgroundColor,
      padding: const pw.EdgeInsets.symmetric(vertical: 1.5, horizontal: 2),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Expanded(
            flex: 4,
            child: pw.Text(
              label,
              style: pw.TextStyle(
                  fontSize: 7,
                  fontStyle:
                      isNote ? pw.FontStyle.italic : pw.FontStyle.normal),
            ),
          ),
          pw.Expanded(
            flex: 5,
            child: pw.Row(
              children: [
                pw.Container(
                  width: 30,
                  child: pw.Text(
                    symbol,
                    style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold, fontSize: 7),
                    textAlign: pw.TextAlign.center,
                  ),
                ),
                pw.SizedBox(width: 4),
                pw.Expanded(
                  child: pw.Padding(
                    padding: pw.EdgeInsets.only(left: isSubValue ? 15 : 0),
                    child: pw.Text(
                      value,
                      style: pw.TextStyle(fontSize: 7, color: valueColor),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  pw.Widget _buildSectionDivider(String title) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 3),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Divider(height: 1, color: PdfColors.grey, thickness: 0.5),
          if (title.isNotEmpty)
            pw.Padding(
              padding: const pw.EdgeInsets.only(top: 2),
              child: pw.Text(
                title,
                style:
                    pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 8),
              ),
            ),
        ],
      ),
    );
  }

  pw.Widget _buildDisclaimer() {
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.end,
      children: [
        pw.Expanded(
          child: pw.Text(
            'The IEC lightning risk assessment calculator is intended to assist in the analysis of risk criteria to determine the risk of loss due to lightning. It is not possible to cover each special design element that may render a structure more or less susceptible to lightning damage. In special cases, personal and economic factors may be very important and should be considered in addition to the assessment obtained by use of this tool. It is intended that this tool be used in conjunction with the written standard from which it.',
            style: pw.TextStyle(fontSize: 8, fontStyle: pw.FontStyle.italic),
            textAlign: pw.TextAlign.justify,
          ),
        ),
      ],
    );
  }
}

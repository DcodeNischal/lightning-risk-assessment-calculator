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
                _buildRequiredProtectionColumn(),
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
              'Length of the structure (m)', 'L', zoneParams.length.toString()),
          _buildParamRow(
              'Width of the structure (m)', 'W', zoneParams.width.toString()),
          _buildParamRow('Height of the structure (m)*', 'H',
              zoneParams.height.toString()),
          _buildParamRow('*Highest part measured from the ground level', '', '',
              isNote: true),
          _buildParamRow('Is it a Complex Structure ?', '', 'No'),
          _buildParamRow('Collection Area (m²)', 'Ad',
              (riskResult.collectionAreas['AD'] ?? 0).toStringAsFixed(2)),
          _buildSectionDivider('Adjacent Structure Dimensions (If Any)'),
          _buildParamRow('Adjacent Structure Length (m)', '',
              zoneParams.adjLength.toString()),
          _buildParamRow('Adjacent Structure Breadth (m)', '',
              zoneParams.adjWidth.toString()),
          _buildParamRow('Adjacent Structure Height (m)', '',
              zoneParams.adjHeight.toString()),
          _buildParamRow('Collection Area of Adjacent\nStructure', '', 'N/A'),
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
          _buildParamRow('Location Factor', 'Cd', zoneParams.locationFactorKey),
          _buildParamRow('Ng(per year/km²)', '',
              '2'), // Assuming a value, replace with zoneParams.ng
          _buildParamRow('LPS Status', 'Pb', zoneParams.lpsStatus),
          _buildParamRow(
              'Mesh width Wm(m)', '', '0'), // Added Wm(m) for clarity
          _buildParamRow(
              'Internal Shield width Wiz', '', '0'), // Added Wiz for clarity
          _buildParamRow('Shielding Factor Ks1', 'Ks1',
              zoneParams.powerShieldingFactorKs1.toString()),
          _buildParamRow('Shielding Factor Ks2', 'Ks2',
              zoneParams.tlcShieldingFactorKs1.toString()),
          _buildParamRow('Equipotential\nBonding', 'PDR',
              zoneParams.equipotentialBonding), // Changed Peb to PDR
          _buildParamRow('Location Factor of\nAdjacent Structure', 'Cda',
              zoneParams.adjLocationFactor),
          _buildParamRow(
              'Does the building\nprovide services to\nthe public ?', '', 'No'),
          _buildParamRow('Does this building\nhave cultural value ?', '', 'No'),
        ],
      ),
    );
  }

  pw.Widget _buildPowerLineColumn(ZoneParameters zoneParams) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(2),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          _buildParamRow(
              'Length of line', 'Li', zoneParams.lengthPowerLine.toString()),
          _buildParamRow(
              'Type of Installation', 'Ct', zoneParams.installationPowerLine),
          _buildParamRow(
              'Environmental Factor', 'Ce', zoneParams.environmentalFactorKey),
          _buildParamRow('Shielding, Earthing &\nCabling', 'Cg',
              zoneParams.powerShielding), // Changed Insulation to Cabling
          _buildParamRow('Withstand voltage of\ninternal system', 'Uw',
              zoneParams.powerUW.toString()),
          _buildParamRow(
              'Line Shielding', 'Pw', zoneParams.powerShielding), // Psh to Pw
          _buildParamRow('Shielding Near Line', 'Pu',
              zoneParams.spacingPowerLine.toString()), // Pli to Pu
          _buildParamRow('Impulse withstand\nvoltage (resistibility)', 'Kst',
              '0.667'), // Ka to Kst, placeholder value
          _buildParamRow('Internal wiring: Routing\nand Shielding', 'Kp',
              zoneParams.powerShielding), // Added Kp
        ],
      ),
    );
  }

  pw.Widget _buildTelecomLineColumn(ZoneParameters zoneParams) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(2),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          _buildParamRow(
              'Length of line', 'Li', zoneParams.lengthTlcLine.toString()),
          _buildParamRow(
              'Type of Installation', 'Ct', zoneParams.installationTlcLine),
          _buildParamRow(
              'Environmental Factor', 'Ce', zoneParams.environmentalFactorKey),
          _buildParamRow('Shielding, Earthing &\nCabling', 'Cg',
              zoneParams.tlcShielding), // Changed Insulation to Cabling
          _buildParamRow('Withstand voltage of\ninternal system', 'Uw',
              zoneParams.tlcUW.toString()),
          _buildParamRow(
              'Line Shielding', 'Pw', zoneParams.tlcShielding), // Psh to Pw
          _buildParamRow('Shielding Near Line', 'Pu',
              zoneParams.spacingTlcLine.toString()), // Pli to Pu
          _buildParamRow('Impulse withstand\nvoltage (resistibility)', 'Kst',
              '0.667'), // Ka to Kst, placeholder value
          _buildParamRow('Internal wiring: Routing\nand Shielding', 'Kp',
              zoneParams.tlcShielding), // Added Kp
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
          _buildParamRow('Total cost of Structure\n(Building Type)', '',
              zoneParams.totalCostOfStructure),
          _buildParamRow(
              'Is there any Economic Value', '', zoneParams.isAnyEconomicValue),
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
          _buildParamRow('Total No. of Zones', '', '2'),
          _buildParamRow('No. of persons in\nZone HZ', '', '30'),
          _buildParamRow('Total No. of persons', '', '30'),
        ],
      ),
    );
  }

  pw.Widget _buildZone1ParametersColumn(ZoneParameters zoneParams) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(2),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          _buildParamRow('Floor surface type', 'rp', 'Asphalt, linoleum, wood'),
          _buildParamRow(
              'Protection against Shock', 'Pa', 'No protection measures'),
          _buildParamRow(
              'Shock Protection\nRisk of Fire', 'Ptu', 'No protection measure'),
          _buildParamRow('Fire protection measure', 'rp', 'Fire(Ordinary)'),
          _buildParamRow('Spatial Shield', 'Kms', 'No measures'),
          _buildParamRow('Power (Internal Wiring)', 'KpDB',
              'Unshielded Cable - no routing\nprecaution to avoid loops (loop...)'),
          _buildParamRow(
              'Power (Coordinated\nSPDs)', 'PSPD', 'No coordinated SPD system'),
          _buildParamRow('Telecom (Internal\nWiring)', 'Ktelecom',
              'Unshielded Cable - no routing\nprecaution to avoid loops (loop...)'),
          _buildParamRow('Telecom (Coordinated\nSPDs)', 'PSPD',
              'No coordinated SPD system'),
          _buildParamRow('Internal Power Systems', 'Kp', 'no special risk'),
          _buildParamRow(
              'L1: Loss of Human Life', 'Lt', 'All types, Hospital...'),
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
                  : riskResult.r2.toString()),
          _buildParamRow(
              'Loss of Cultural Heritage',
              'R3',
              riskResult.r3 == 0
                  ? 'No Loss of Cultural Heritage Value'
                  : riskResult.r3.toString()),
          _buildParamRow(
              'Economic Loss',
              'R4',
              riskResult.r4 == 0
                  ? 'Economic Value Not Evaluated'
                  : riskResult.r4.toString()),
        ],
      ),
    );
  }

  pw.Widget _buildZone0ParametersColumn(ZoneParameters zoneParams) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(2),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          _buildParamRow('Surface Type', 'rp', 'Agricultural, concrete'),
          _buildParamRow(
              'Protection Against\nShock', 'Pa', 'No protection measure'),
          _buildParamRow(
              'Shock Protection\nRisk of fire', 'Ptu', 'No protection measure'),
          _buildParamRow('Risk of fire', 'rf', 'Fire(Ordinary)'),
          _buildParamRow('Fire protection\nmeasure', 'rp', 'No measures'),
          _buildParamRow('Internal power\nSystems', 'Kp', 'No special risk'),
          _buildParamRow('L1: Loss of Human\nlife', 'Lt', 'All types'),
          _buildParamRow('', '', 'Hospital, Hotel, School,\nPublic Building',
              isSubValue: true),
          _buildParamRow('L2: Loss of Public\nService', 'LD2', 'LD(None)'),
          _buildParamRow('L3: Loss of Cultural\nHeritage', 'LF3', 'None'),
          _buildParamRow('L4 Economic Loss', 'LT4', 'LT(None)'),
          pw.SizedBox(height: 10),
          _buildSectionDivider('Cultural Heritage Value'),
          _buildParamRow(
              'Value of Cultural Heritage\nZD (in Percent)', '', '10'),
          _buildParamRow(
              'Value of Cultural Heritage\nZ (in Percent)', '', '90'),
          _buildParamRow('Total Value of Building', 'c1', '100'),
          pw.SizedBox(height: 5),
          _buildSectionDivider(''),
          _buildParamRow('Is Power Line Parameters Present?', '',
              zoneParams.powerLinePresent ? 'Yes' : 'No'),
          _buildParamRow('Is Telecommunication\nParameters Present?', '',
              zoneParams.telecomPresent ? 'Yes' : 'No'),
        ],
      ),
    );
  }

  pw.Widget _buildRequiredProtectionColumn() {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(2),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          _buildParamRow('Protection Measure\n(Physical Damage)', 'Pb',
              'Structure is Protected by an LPS\nClass (IV)'),
          _buildParamRow(
              'Protection Measure\n(Lightning Potential)', 'Pdr', 'III-IV'),
          _buildParamRow('Coordinated Surge\nProtection (Power)', 'PPROT',
              'No coordinated SPD system'),
          _buildParamRow('Coordinated Surge\nProtection (Telecom)', 'PPROT',
              'No coordinated SPD system'),
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
              riskResult.r1.toStringAsExponential(2),
              backgroundColor: PdfColors.red100),
          _buildParamRow(
              'Loss of Public Service',
              'R2',
              riskResult.r2 == 0
                  ? 'No Loss of Public Service'
                  : riskResult.r2.toString()),
          _buildParamRow(
              'Loss of Cultural Heritage',
              'R3',
              riskResult.r3 == 0
                  ? 'No Loss of Cultural Heritage Value'
                  : riskResult.r3.toString()),
          _buildParamRow(
              'Economic Loss',
              'R4',
              riskResult.r4 == 0
                  ? 'Economic Value Not Evaluated'
                  : riskResult.r4.toString()),
          _buildSectionDivider('Annual Savings [ Sa = CPL ( Cpa + Cps ) ]'),
          _buildParamRow('', '', 'N/A'),
          _buildSectionDivider('Investment on Protective measure'),
          _buildParamRow('', '', 'N/A'),
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
            style:
                const pw.TextStyle(fontSize: 8, fontStyle: pw.FontStyle.italic),
            textAlign: pw.TextAlign.justify,
          ),
        ),
      ],
    );
  }
}

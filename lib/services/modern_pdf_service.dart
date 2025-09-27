import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../models/risk_result.dart';
import '../models/zone_parameters.dart';

class ModernPDFService {
  Future<void> generateModernReport(
      RiskResult riskResult, ZoneParameters zoneParams) async {
    try {
      final pdf = pw.Document();

      // Add the main report page
      pdf.addPage(
        pw.MultiPage(
          pageFormat:
              PdfPageFormat.a4.landscape, // Landscape for better table layout
          margin: const pw.EdgeInsets.all(20),
          build: (pw.Context context) {
            return [
              _buildHeader(),
              pw.SizedBox(height: 20),
              _buildMainTable(riskResult, zoneParams),
              pw.SizedBox(height: 20),
              _buildDisclaimer(),
            ];
          },
        ),
      );

      // Generate PDF bytes and open
      final pdfBytes = await pdf.save();
      await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdfBytes,
        name: 'Lightning_Risk_Assessment_Professional_Report.pdf',
      );
    } catch (e) {
      print('PDF Generation Error: $e');
      rethrow;
    }
  }

  pw.Widget _buildHeader() {
    return pw.Container(
      padding: const pw.EdgeInsets.all(20),
      decoration: pw.BoxDecoration(
        color: PdfColors.blue900,
        borderRadius: pw.BorderRadius.circular(10),
      ),
      child: pw.Row(
        children: [
          pw.Container(
            width: 60,
            height: 60,
            decoration: pw.BoxDecoration(
              color: PdfColors.white,
              borderRadius: pw.BorderRadius.circular(30),
            ),
            child: pw.Center(
              child: pw.Text(
                '⚡',
                style: pw.TextStyle(fontSize: 30),
              ),
            ),
          ),
          pw.SizedBox(width: 20),
          pw.Expanded(
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  'LIGHTNING RISK ASSESSMENT REPORT',
                  style: pw.TextStyle(
                    fontSize: 24,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.white,
                  ),
                ),
                pw.SizedBox(height: 5),
                pw.Text(
                  'IEC 62305-2 Standard Compliance Assessment',
                  style: pw.TextStyle(
                    fontSize: 14,
                    color: PdfColors.white,
                  ),
                ),
                pw.SizedBox(height: 5),
                pw.Text(
                  'Generated on: ${DateTime.now().toString().split('.')[0]}',
                  style: pw.TextStyle(
                    fontSize: 12,
                    color: PdfColors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  pw.Widget _buildMainTable(RiskResult riskResult, ZoneParameters zoneParams) {
    return pw.Table(
      border: pw.TableBorder.all(color: PdfColors.grey400, width: 0.5),
      columnWidths: {
        0: const pw.FlexColumnWidth(1),
        1: const pw.FlexColumnWidth(1),
        2: const pw.FlexColumnWidth(1),
      },
      children: [
        // Header row
        pw.TableRow(
          decoration: const pw.BoxDecoration(color: PdfColors.grey200),
          children: [
            _buildHeaderCell('Structure Dimensions'),
            _buildHeaderCell(
                'Environmental Influences and Structure Attributes'),
            _buildHeaderCell('Power Line Parameters'),
          ],
        ),

        // Data rows
        _buildDataRow([
          _buildParameterCell(
              'Length of structure (m)', 'L', zoneParams.length.toString()),
          _buildParameterCell(
              'Location Factor', 'CD', zoneParams.locationFactorKey),
          _buildParameterCell(
              'Length of Line', 'LL', zoneParams.lengthPowerLine.toString()),
        ]),

        _buildDataRow([
          _buildParameterCell(
              'Width of the structure (m)', 'W', zoneParams.width.toString()),
          _buildParameterCell('Lightning Flash Density', 'NG',
              zoneParams.lightningFlashDensity.toString()),
          _buildParameterCell(
              'Type of Installation', 'CI', zoneParams.installationPowerLine),
        ]),

        _buildDataRow([
          _buildParameterCell('Height of the structure (m)*', 'H',
              zoneParams.height.toString()),
          _buildParameterCell('LPS Status', 'PB', zoneParams.lpsStatus),
          _buildParameterCell('Line Type', 'CT', zoneParams.lineTypePowerLine),
        ]),

        _buildDataRow([
          _buildParameterCell(
              '*highest point measured from the ground level', '', ''),
          _buildParameterCell(
              'Mesh width', 'wm1', zoneParams.meshWidth1.toString()),
          _buildParameterCell(
              'Environmental Factor', 'CE', zoneParams.environmentalFactorKey),
        ]),

        _buildDataRow([
          _buildParameterCell('Is it a Complex Structure ?', '', 'No'),
          _buildParameterCell(
              'Internal shield width', 'wm2', zoneParams.meshWidth2.toString()),
          _buildParameterCell('Shielding, Earthing & Insulation', 'CLD',
              zoneParams.powerShielding),
        ]),

        _buildDataRow([
          _buildParameterCell('Collection Area (m²)', 'AD',
              riskResult.collectionAreas['AD']?.toStringAsFixed(2) ?? '0'),
          _buildParameterCell('Shielding Factor Ks1', 'Ks1',
              zoneParams.powerShieldingFactorKs1.toString()),
          _buildParameterCell('Shielding, Earthing & Insulation', 'CLI',
              zoneParams.powerShielding),
        ]),

        // Second section header
        pw.TableRow(
          decoration: const pw.BoxDecoration(color: PdfColors.grey200),
          children: [
            _buildHeaderCell('Adjacent Structure Dimensions (If Any)'),
            _buildHeaderCell('Shielding Factor Ks2'),
            _buildHeaderCell('Telecommunication Line Parameters'),
          ],
        ),

        _buildDataRow([
          _buildParameterCell('Adjacent Structure Length (m)', 'LDJ',
              zoneParams.adjLength.toString()),
          _buildParameterCell('Shielding Factor Ks2', 'Ks2',
              zoneParams.tlcShieldingFactorKs1.toString()),
          _buildParameterCell(
              'Length of Line', 'LL', zoneParams.lengthTlcLine.toString()),
        ]),

        _buildDataRow([
          _buildParameterCell('Adjacent Structure Breadth (m)', 'WDJ',
              zoneParams.adjWidth.toString()),
          _buildParameterCell(
              'Equipotential Bonding', 'PEB', zoneParams.equipotentialBonding),
          _buildParameterCell(
              'Type of Installation', 'CI', zoneParams.installationTlcLine),
        ]),

        _buildDataRow([
          _buildParameterCell('Adjacent Structure Height (m)', 'HDJ',
              zoneParams.adjHeight.toString()),
          _buildParameterCell('Location Factor of Adjacent Structure', 'CDJ',
              zoneParams.adjLocationFactor),
          _buildParameterCell('Line Type', 'CT', zoneParams.lineTypeTlcLine),
        ]),

        _buildDataRow([
          _buildParameterCell(
              'Collection Area of Adjacent Structure', 'ADJ', 'N/A'),
          _buildParameterCell(
              'Does this Building provide services to the public ?', '', 'No'),
          _buildParameterCell(
              'Environmental Factor', 'CE', zoneParams.environmentalFactorKey),
        ]),

        // Risk Results Section
        pw.TableRow(
          decoration: const pw.BoxDecoration(color: PdfColors.blue100),
          children: [
            _buildHeaderCell('Economic Valuation'),
            _buildHeaderCell('Zone Definitions'),
            _buildHeaderCell('Calculated Risk Parameters'),
          ],
        ),

        _buildDataRow([
          _buildParameterCell('Total cost of Structure (Building Type)', '',
              'Medium Scale Industry'),
          _buildParameterCell('Total No. of Zones', '', '2'),
          _buildParameterCell('Loss of Human Life', 'R1',
              riskResult.r1.toStringAsExponential(2)),
        ]),

        _buildDataRow([
          _buildParameterCell('Economic Value', '', ''),
          _buildParameterCell('No. of Person in Zone 0', '', '0'),
          _buildParameterCell(
              'Loss of Public Service', 'R2', 'No Loss of Public Service'),
        ]),

        _buildDataRow([
          _buildParameterCell('Is There any Economic Value', '', 'No'),
          _buildParameterCell('No. of Person in Zone 1', '',
              zoneParams.exposedPersonsNZ.toString()),
          _buildParameterCell('Loss of Cultural Heritage', 'R3',
              'No Loss of Cultural Heritage'),
        ]),

        _buildDataRow([
          _buildParameterCell('Economic Value', '', ''),
          _buildParameterCell('Total No. of Persons (nt)', '',
              zoneParams.totalPersonsNT.toString()),
          _buildParameterCell(
              'Economic Loss', 'R4', 'Economic Value Not Evaluated'),
        ]),

        // Zone Parameters Section
        pw.TableRow(
          decoration: const pw.BoxDecoration(color: PdfColors.green100),
          children: [
            _buildHeaderCell('Zone 0 Parameters'),
            _buildHeaderCell('Zone 1 Parameters'),
            _buildHeaderCell('Required Level Of Protection'),
          ],
        ),

        _buildDataRow([
          _buildParameterCell('Surface Type', 'rt', 'Agricultural, concrete'),
          _buildParameterCell(
              'Floor surface type', 'rt', 'Asphalt, linoleum, wood'),
          _buildParameterCell('Protection Measure (Physical Damage)', 'PB',
              'Structure is Protected by an LPS Class (IV)'),
        ]),

        _buildDataRow([
          _buildParameterCell(
              'Shock Protection', 'PTA', zoneParams.shockProtectionPTA),
          _buildParameterCell(
              'Protection against Shock', 'PTA', zoneParams.shockProtectionPTA),
          _buildParameterCell(
              'Protection Measure (Lightning Equipotential Bonding)',
              'PEB',
              'III-IV'),
        ]),

        _buildDataRow([
          _buildParameterCell(
              'Protection Against Shock', 'PTU', zoneParams.shockProtectionPTU),
          _buildParameterCell(
              'Shock Protection', 'PTU', zoneParams.shockProtectionPTU),
          _buildParameterCell('Coordinated Surge Protection (Power)', 'PSPD(P)',
              'No coordinated SPD system'),
        ]),

        _buildDataRow([
          _buildParameterCell('Risk of fire', 'rf', zoneParams.fireRisk),
          _buildParameterCell('Risk of fire', 'rf', zoneParams.fireRisk),
          _buildParameterCell('Coordinated Surge Protection (Telecom)',
              'PSPD(T)', 'No coordinated SPD system'),
        ]),

        // Final Results Section
        pw.TableRow(
          decoration: const pw.BoxDecoration(color: PdfColors.red100),
          children: [
            _buildHeaderCell('Cultural Heritage Value'),
            _buildHeaderCell('Life support via device ? (Hospital)'),
            _buildHeaderCell(
                'Calculated Risk after Protection Level Consideration'),
          ],
        ),

        _buildDataRow([
          _buildParameterCell(
              'Value of Cultural Heritage Z0 (in Percent)', 'cZ0', '10'),
          _buildParameterCell('Life support via device ? (Hospital)', '', 'No'),
          _buildParameterCell('Loss of Human Life', 'R1',
              riskResult.r1.toStringAsExponential(2)),
        ]),

        _buildDataRow([
          _buildParameterCell(
              'Value of Cultural Heritage Z1 (in Percent)', 'cZ1', '90'),
          _buildParameterCell('Animal with economical value (Farm)', '', 'No'),
          _buildParameterCell(
              'Loss of Public Service', 'R2', 'No Loss of Public Service'),
        ]),

        _buildDataRow([
          _buildParameterCell('Total Value of Building', 'ct', '100'),
          _buildParameterCell('For Hospital', 'X', '0'),
          _buildParameterCell('Loss of Cultural Heritage', 'R3',
              'No Loss of Cultural Heritage'),
        ]),

        _buildDataRow([
          _buildParameterCell('', '', ''),
          _buildParameterCell('Is Power Line Parameters Present?', '', 'Yes'),
          _buildParameterCell(
              'Economic Loss', 'R4', 'Economic Value Not Evaluated'),
        ]),

        _buildDataRow([
          _buildParameterCell('', '', ''),
          _buildParameterCell(
              'Is Telecommunication Parameters Present?', '', 'Yes'),
          _buildParameterCell('Annual Savings [ SM= CL- ( CPM+CRL ) ]', '', ''),
        ]),

        _buildDataRow([
          _buildParameterCell('', '', ''),
          _buildParameterCell('', '', ''),
          _buildParameterCell(
              'Investment on Protective measures is', '', 'N/A'),
        ]),
      ],
    );
  }

  pw.Widget _buildHeaderCell(String text) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(8),
      child: pw.Text(
        text,
        style: pw.TextStyle(
          fontSize: 10,
          fontWeight: pw.FontWeight.bold,
          color: PdfColors.black,
        ),
        textAlign: pw.TextAlign.center,
      ),
    );
  }

  pw.TableRow _buildDataRow(List<pw.Widget> cells) {
    return pw.TableRow(
      children: cells,
    );
  }

  pw.Widget _buildParameterCell(String parameter, String symbol, String value) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(4),
      child: pw.Row(
        children: [
          pw.Expanded(
            flex: 3,
            child: pw.Text(
              parameter,
              style: const pw.TextStyle(fontSize: 8),
            ),
          ),
          if (symbol.isNotEmpty) ...[
            pw.SizedBox(
              width: 30,
              child: pw.Text(
                symbol,
                style: pw.TextStyle(
                  fontSize: 8,
                  fontWeight: pw.FontWeight.bold,
                ),
                textAlign: pw.TextAlign.center,
              ),
            ),
          ],
          pw.Expanded(
            flex: 3,
            child: pw.Text(
              value,
              style: const pw.TextStyle(fontSize: 8),
            ),
          ),
        ],
      ),
    );
  }

  pw.Widget _buildDisclaimer() {
    return pw.Container(
      padding: const pw.EdgeInsets.all(15),
      decoration: pw.BoxDecoration(
        color: PdfColors.grey100,
        borderRadius: pw.BorderRadius.circular(8),
        border: pw.Border.all(color: PdfColors.grey400),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'DISCLAIMER',
            style: pw.TextStyle(
              fontSize: 12,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.blue800,
            ),
          ),
          pw.SizedBox(height: 10),
          pw.Text(
            'The IEC lightning risk assessment calculator is intended to assist in the analysis of various criteria to determine the risk of loss due to lightning. It is not possible to cover each special design element that may render a structure more or less susceptible to lightning damage. In special cases, personal and economic factors may be very important and should be considered in addition to the assessment obtained by use of this tool. It is intended that this tool be used in conjunction with the written standard IEC62305-2.',
            style: const pw.TextStyle(fontSize: 10),
            textAlign: pw.TextAlign.justify,
          ),
        ],
      ),
    );
  }
}

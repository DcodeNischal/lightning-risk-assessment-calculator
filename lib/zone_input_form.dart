import 'package:flutter/material.dart';
import 'risk/zone_parameters.dart';
import 'risk/risk_calculator.dart';
import 'risk/risk_factors.dart';

class ZoneInputForm extends StatefulWidget {
  @override
  _ZoneInputFormState createState() => _ZoneInputFormState();
}

class _ZoneInputFormState extends State<ZoneInputForm> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> inputs = {};
  RiskResult? riskResult;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(12),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            numberField('Length (m)', 'length'),
            numberField('Width (m)', 'width'),
            numberField('Height (m)', 'height'),
            dropdownField('Location Factor', locationFactorCD.keys.toList(), 'locationFactorKey'),
            numberField('Lightning Flash Density', 'lightningFlashDensity'),
            dropdownField('LPS Status', factorPB.keys.toList(), 'lpsStatus'),
            numberField('Mesh Width 1 (m)', 'meshWidth1'),
            numberField('Mesh Width 2 (m)', 'meshWidth2'),
            dropdownField('Equipotential Bonding', ['No SPD', 'Yes'], 'equipotentialBonding'),
            dropdownField('Environmental Factor', factorCE.keys.toList(), 'environmentalFactorKey'),

            numberField('Power Line Length (m)', 'lengthPowerLine'),
            dropdownField('Power Line Installation', factorCI.keys.toList(), 'installationPowerLine'),
            dropdownField('Power Line Type', factorCT.keys.toList(), 'lineTypePowerLine'),
            dropdownField('Power Shielding', ['Unshielded overhead line', 'Shielded'], 'powerShielding'),
            numberField('Power Shielding Factor KS1', 'powerShieldingFactorKs1'),
            numberField('Power Withstand Voltage UW (kV)', 'powerUW'),
            numberField('Power Line Spacing (m)', 'spacingPowerLine'),
            dropdownField('Power Type CT', factorCT.keys.toList(), 'powerTypeCT'),

            numberField('Telecom Line Length (m)', 'lengthTlcLine'),
            dropdownField('Telecom Line Installation', factorCI.keys.toList(), 'installationTlcLine'),
            dropdownField('Telecom Line Type', factorCT.keys.toList(), 'lineTypeTlcLine'),
            dropdownField('Telecom Shielding', ['Unshielded overhead line', 'Shielded'], 'tlcShielding'),
            numberField('Telecom Shielding Factor KS1', 'tlcShieldingFactorKs1'),
            numberField('Telecom Withstand Voltage UW (kV)', 'tlcUW'),
            numberField('Telecom Line Spacing (m)', 'spacingTlcLine'),
            dropdownField('Telecom Type CT', factorCT.keys.toList(), 'teleTypeCT'),

            numberField('Adjacent Structure Length (m)', 'adjLength'),
            numberField('Adjacent Structure Width (m)', 'adjWidth'),
            numberField('Adjacent Structure Height (m)', 'adjHeight'),
            dropdownField('Adjacent Location Factor', locationFactorCD.keys.toList(), 'adjLocationFactor'),

            numberField('Reduction Factor RT', 'reductionFactorRT'),
            dropdownField('Loss Type', ['Human Life'], 'lossTypeLT'), // expand if needed
            numberField('Exposure Time (hours/year)', 'exposureTimeTZ'),
            numberField('Exposed Persons NZ', 'exposedPersonsNZ'),
            numberField('Total Persons NT', 'totalPersonsNT'),

            dropdownField('Shock Protection PTA', ['No protection', 'Partial', 'Full'], 'shockProtectionPTA'),
            dropdownField('Shock Protection PTU', ['No protection', 'Partial', 'Full'], 'shockProtectionPTU'),
            dropdownField('SPD Protection Level', ['No SPD', 'Partial SPD', 'Full SPD'], 'spdProtectionLevel'),

            SizedBox(height: 20),
            ElevatedButton(
              child: Text('Calculate Risk'),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();

                  ZoneParameters zone = ZoneParameters(
                    length: inputs['length'],
                    width: inputs['width'],
                    height: inputs['height'],
                    locationFactorKey: inputs['locationFactorKey'],
                    lightningFlashDensity: inputs['lightningFlashDensity'],
                    lpsStatus: inputs['lpsStatus'],
                    meshWidth1: inputs['meshWidth1'],
                    meshWidth2: inputs['meshWidth2'],
                    equipotentialBonding: inputs['equipotentialBonding'],
                    lengthPowerLine: inputs['lengthPowerLine'],
                    installationPowerLine: inputs['installationPowerLine'],
                    lineTypePowerLine: inputs['lineTypePowerLine'],
                    powerShielding: inputs['powerShielding'],
                    powerShieldingFactorKs1: inputs['powerShieldingFactorKs1'],
                    powerUW: inputs['powerUW'],
                    spacingPowerLine: inputs['spacingPowerLine'],
                    powerTypeCT: inputs['powerTypeCT'],
                    lengthTlcLine: inputs['lengthTlcLine'],
                    installationTlcLine: inputs['installationTlcLine'],
                    lineTypeTlcLine: inputs['lineTypeTlcLine'],
                    tlcShielding: inputs['tlcShielding'],
                    tlcShieldingFactorKs1: inputs['tlcShieldingFactorKs1'],
                    tlcUW: inputs['tlcUW'],
                    spacingTlcLine: inputs['spacingTlcLine'],
                    teleTypeCT: inputs['teleTypeCT'],
                    adjLength: inputs['adjLength'],
                    adjWidth: inputs['adjWidth'],
                    adjHeight: inputs['adjHeight'],
                    adjLocationFactor: inputs['adjLocationFactor'],
                    reductionFactorRT: inputs['reductionFactorRT'],
                    lossTypeLT: inputs['lossTypeLT'],
                    exposureTimeTZ: inputs['exposureTimeTZ'],
                    exposedPersonsNZ: inputs['exposedPersonsNZ'],
                    totalPersonsNT: inputs['totalPersonsNT'],
                    shockProtectionPTA: inputs['shockProtectionPTA'],
                    shockProtectionPTU: inputs['shockProtectionPTU'],
                    spdProtectionLevel: inputs['spdProtectionLevel'],
                    fireProtection: 'No measures',
                    fireRisk: 'Fire (Ordinary)',
                  );

                  RiskCalculator calc = RiskCalculator();
                  RiskResult result = calc.calculateRisk(zone);

                  setState(() {
                    riskResult = result;
                  });
                }
              },
            ),
            SizedBox(height: 30),
            if (riskResult != null) ...[
              Text('Number of Dangerous Events (ND): ${riskResult!.nd.toStringAsFixed(6)}'),
              Text('Number of Monitoring Events (NM): ${riskResult!.nm.toStringAsFixed(6)}'),
              Text('Risk of Loss of Human Life (R1): ${riskResult!.r1.toStringAsPrecision(5)}'),
            ],
          ],
        ),
      ),
    );
  }

  Widget numberField(String label, String key) => TextFormField(
        decoration: InputDecoration(labelText: label),
        keyboardType: TextInputType.numberWithOptions(decimal: true),
        validator: (val) => val == null || val.isEmpty || double.tryParse(val) == null ? 'Enter number' : null,
        onSaved: (val) => inputs[key] = double.parse(val!),
      );

  Widget dropdownField(String label, List<String> items, String key) => DropdownButtonFormField<String>(
        decoration: InputDecoration(labelText: label),
        items: items.map((item) => DropdownMenuItem<String>(value: item, child: Text(item))).toList(),
        validator: (val) => val == null ? 'Select value' : null,
        onChanged: (val) => inputs[key] = val,
      );
}

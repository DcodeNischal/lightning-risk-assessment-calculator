import 'package:flutter/material.dart';
import 'zone_input_form.dart';

void main() => runApp(LightningRiskApp());

class LightningRiskApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lightning Risk Assessment',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: Scaffold(
        appBar: AppBar(title: const Text('Lightning Risk Assessment')),
        body: ZoneInputForm(),
      ),
    );
  }
}

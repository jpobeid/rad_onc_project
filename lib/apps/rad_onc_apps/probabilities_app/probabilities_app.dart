import 'package:flutter/material.dart';
import 'package:rad_onc_project/widgets/rad_app_bar.dart';
import 'package:rad_onc_project/data/global_data.dart' as datas;

class ProbabilitiesApp extends StatefulWidget {
  static const String routeName = '/probabilities-app';

  @override
  _ProbabilitiesAppState createState() => _ProbabilitiesAppState();
}

class _ProbabilitiesAppState extends State<ProbabilitiesApp> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: RadAppBar(
          strAppTitle: datas.mapAppNames[0]![2],
        ),
        body: Container(
          color: Colors.blue,
        ),
      ),
    );
  }
}

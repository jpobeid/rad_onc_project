import 'package:flutter/material.dart';
import 'dart:math';

import 'package:rad_onc_project/functions/text_field_validation.dart';
import 'package:rad_onc_project/widgets/rad_app_bar.dart';
import 'package:rad_onc_project/data/global_data.dart' as datas;
import 'package:rad_onc_project/widgets/text_fields.dart' as fields;

class BedQedCalc extends StatefulWidget {
  static const routeName = '/bed-qed-app';
  static const double fractionStart = 0.03;

  @override
  _BedQedCalcState createState() => _BedQedCalcState();
}

class _BedQedCalcState extends State<BedQedCalc> {
  TextEditingController _controllerDose = TextEditingController(text: '');
  TextEditingController _controllerFractions = TextEditingController(text: '');
  TextEditingController _controllerRate = TextEditingController(text: '');
  double _nAbRatio = 3.0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: RadAppBar(
          strAppTitle: datas.mapAppNames[1]![0],
        ),
        body: Column(
          children: [
            Container(
              height:
                  MediaQuery.of(context).size.height * BedQedCalc.fractionStart,
            ),
            Table(
              defaultVerticalAlignment: TableCellVerticalAlignment.top,
              columnWidths: {0: FlexColumnWidth(5), 1: FlexColumnWidth(3)},
              children: [
                TableRow(children: [
                  Text(
                    'Total dose (Gy):',
                    style: Theme.of(context).textTheme.headline2,
                  ),
                  fields.textFieldDose(context, _controllerDose,
                      funcOnChanged: (text) => setState),
                ]),
                TableRow(children: [
                  Text(
                    'Total fractions:',
                    style: Theme.of(context).textTheme.headline2,
                  ),
                  fields.textFieldFraction(context, _controllerFractions,
                      funcOnChanged: (text) => setState),
                ]),
                TableRow(children: [
                  Text(
                    'X (Gy/Fx):',
                    style: Theme.of(context).textTheme.headline2,
                  ),
                  fields.textFieldDose(context, _controllerRate,
                      funcOnChanged: (text) => setState),
                ]),
                TableRow(children: [
                  TableCell(
                    verticalAlignment: TableCellVerticalAlignment.middle,
                    child: Slider(
                      min: 1,
                      max: 10,
                      divisions: 18,
                      value: _nAbRatio,
                      onChanged: (n) {
                        setState(() {
                          _nAbRatio = n;
                        });
                      },
                    ),
                  ),
                  Text(
                    '\u03b1/\u03b2\n$_nAbRatio',
                    style: Theme.of(context).textTheme.headline2,
                    textAlign: TextAlign.center,
                  ),
                ]),
              ],
            ),
            Divider(
              height: MediaQuery.of(context).size.height *
                  BedQedCalc.fractionStart *
                  2,
              color: Theme.of(context).primaryColor,
              thickness: 1,
            ),
            Table(
              columnWidths: {0: FlexColumnWidth(5), 1: FlexColumnWidth(3)},
              children: [
                TableRow(children: [
                  Text(
                    'BED (Gy):',
                    style: Theme.of(context).textTheme.headline2,
                  ),
                  Text(
                    getBED(_controllerDose.text, _controllerFractions.text,
                        _controllerRate.text, _nAbRatio),
                    style: Theme.of(context).textTheme.headline2,
                    textAlign: TextAlign.center,
                  ),
                ]),
                TableRow(children: [
                  Text(
                    checkStrings(_controllerDose.text, _controllerFractions.text,
                            _controllerRate.text)[1]
                        ? 'EQD-${_controllerRate.text} (Gy):'
                        : 'EQD-X (Gy):',
                    style: Theme.of(context).textTheme.headline2,
                  ),
                  Text(
                    getEQDx(_controllerDose.text, _controllerFractions.text,
                        _controllerRate.text, _nAbRatio),
                    style: Theme.of(context).textTheme.headline2,
                    textAlign: TextAlign.center,
                  ),
                ])
              ],
            ),
          ],
        ),
      ),
    );
  }
}

List<bool> checkStrings(String strD, String strN, String strX) {
  bool validDose =
      textFieldDoubleValidation(strD, false, false, true, true, 100, 0, 2, 2);
  bool validFractions =
      textFieldDoubleValidation(strN, false, false, false, false, 99, 0, 2, 0);
  bool validX =
      textFieldDoubleValidation(strX, false, false, true, true, 100, 0, 2, 3);
  return [validDose && validFractions, validDose && validFractions && validX];
}

String getBED(String strD, String strN, String strX, double ab) {
  if (checkStrings(strD, strN, strX)[0]) {
    double D = double.parse(strD);
    double N = double.parse(strN);
    double ansBED = D + (pow(D, 2) / (N * ab));
    return ansBED.toStringAsFixed(2);
  } else {
    return 'N/A';
  }
}

String getEQDx(String strD, String strN, String strX, double ab) {
  if (checkStrings(strD, strN, strX)[1]) {
    double D = double.parse(strD);
    double N = double.parse(strN);
    double X = double.parse(strX);
    double ansEQDx = D * ((1 + D / (N * ab)) / (1 + X / ab));
    return ansEQDx.toStringAsFixed(2);
  } else {
    return 'N/A';
  }
}

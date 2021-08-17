import 'package:flutter/material.dart';
import 'dart:math';

import 'package:rad_onc_project/functions/text_field_validation.dart';
import 'package:rad_onc_project/widgets/rad_app_bar.dart';
import 'package:rad_onc_project/data/global_data.dart' as datas;
import 'package:rad_onc_project/widgets/text_fields.dart' as fields;

class BedQedCalc extends StatefulWidget {
  static const routeName = '/bed-qed-app';
  static const List<int> flexVertical = [1, 8, 1, 1, 4, 3];
  static const double fractionWidth = 0.4;
  static const double sizeRadius = 10;

  @override
  _BedQedCalcState createState() => _BedQedCalcState();
}

class _BedQedCalcState extends State<BedQedCalc> {
  TextEditingController _controllerDose = TextEditingController(text: '');
  TextEditingController _controllerFractions = TextEditingController(text: '');
  TextEditingController _controllerRate = TextEditingController(text: '');
  double _nAbRatio = 3.0;

  void resetDefaults() {
    _controllerDose.text = '';
    _controllerFractions.text = '';
    _controllerRate.text = '';
    _nAbRatio = 3.0;
  }

  @override
  void dispose() {
    _controllerDose.dispose();
    _controllerFractions.dispose();
    _controllerRate.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: RadAppBar(
          strAppTitle: datas.mapAppNames[1]![0],
        ),
        body: Column(
          children: [
            Spacer(
              flex: BedQedCalc.flexVertical[0],
            ),
            Expanded(
              flex: BedQedCalc.flexVertical[1],
              child: Table(
                defaultVerticalAlignment: TableCellVerticalAlignment.top,
                columnWidths: {0: FlexColumnWidth(5), 1: FlexColumnWidth(3)},
                children: [
                  TableRow(children: [
                    Text(
                      'Total dose [Gy]:',
                      style: Theme.of(context).textTheme.headline1,
                    ),
                    fields.textFieldDose(context, _controllerDose,
                        funcOnChanged: (text) {
                      setState(() {});
                    }),
                  ]),
                  TableRow(children: [
                    Text(
                      'Total fractions:',
                      style: Theme.of(context).textTheme.headline1,
                    ),
                    fields.textFieldFraction(context, _controllerFractions,
                        funcOnChanged: (text) {
                      setState(() {});
                    }),
                  ]),
                  TableRow(children: [
                    Text(
                      'X [Gy/Fx]:',
                      style: Theme.of(context).textTheme.headline1,
                    ),
                    fields.textFieldDose(context, _controllerRate,
                        funcOnChanged: (text) {
                      setState(() {});
                    }),
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
            ),
            Spacer(
              flex: BedQedCalc.flexVertical[2],
            ),
            Divider(
              color: Theme.of(context).primaryColor,
              thickness: 1,
            ),
            Spacer(
              flex: BedQedCalc.flexVertical[3],
            ),
            Expanded(
              flex: BedQedCalc.flexVertical[4],
              child: Table(
                columnWidths: {0: FlexColumnWidth(5), 1: FlexColumnWidth(3)},
                children: [
                  TableRow(children: [
                    Text(
                      'BED [Gy]:',
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
                      checkStrings(
                              _controllerDose.text,
                              _controllerFractions.text,
                              _controllerRate.text)[1]
                          ? 'EQD-${_controllerRate.text} [Gy]:'
                          : 'EQD-X [Gy]:',
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
            ),
            Expanded(
              flex: BedQedCalc.flexVertical[5],
              child: TextButton(
                child: Container(
                  width: MediaQuery.of(context).size.width * BedQedCalc.fractionWidth,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(BedQedCalc.sizeRadius),
                  ),
                  child: Text(
                    'Reset',
                    style: Theme.of(context).textTheme.headline2,
                    textAlign: TextAlign.center,
                  ),
                ),
                onPressed: () {
                  setState(() {
                    resetDefaults();
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

List<bool> checkStrings(String strD, String strN, String strX) {
  bool validDose = textFieldDoubleValidation(
      strN: strD,
      allowBlank: false,
      allowNegative: false,
      allowZero: true,
      allowDecimal: true,
      maxValue: 100,
      minValue: 0,
      maxDigitsPreDecimal: 2,
      maxDigitsPostDecimal: 2);
  bool validFractions = textFieldDoubleValidation(
      strN: strN,
      allowBlank: false,
      allowNegative: false,
      allowZero: false,
      allowDecimal: false,
      maxValue: 99,
      minValue: 0,
      maxDigitsPreDecimal: 2,
      maxDigitsPostDecimal: 0);
  bool validX = textFieldDoubleValidation(
      strN: strX,
      allowBlank: false,
      allowNegative: false,
      allowZero: true,
      allowDecimal: true,
      maxValue: 100,
      minValue: 0,
      maxDigitsPreDecimal: 2,
      maxDigitsPostDecimal: 3);
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

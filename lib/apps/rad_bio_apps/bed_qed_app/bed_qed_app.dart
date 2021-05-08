import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:math';

import 'package:rad_onc_project/functions/text_field_validation.dart';
import 'package:rad_onc_project/widgets/rad_app_bar.dart';
import 'package:rad_onc_project/data/main_data.dart' as datas;

class Controller extends GetxController {
  var nSlider = (3.0).obs;
  var strDose = ''.obs;
  var strFractions = ''.obs;
  var strX = ''.obs;

  void resetValues() {
    nSlider.value = (3.0);
    strDose.value = '';
    strFractions.value = '';
    strX.value = '';
  }
}

class BedQedCalc extends StatefulWidget {
  static const routeName = '/bed-qed-app';
  static const double fractionStart = 0.03;

  @override
  _BedQedCalcState createState() => _BedQedCalcState();
}

class _BedQedCalcState extends State<BedQedCalc> {
  final ctrl = Get.put(Controller());

  @override
  void initState() {
    ctrl.resetValues();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: RadAppBar(
          strAppTitle: datas.mapAppNames[1][0],
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
                  TextField(
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(0.0), isDense: true),
                    keyboardType: TextInputType.number,
                    maxLength: 5,
                    style: Theme.of(context).textTheme.headline2,
                    textAlign: TextAlign.center,
                    onChanged: (text) {
                      ctrl.strDose.value = text;
                    },
                  ),
                ]),
                TableRow(children: [
                  Text(
                    'Total fractions:',
                    style: Theme.of(context).textTheme.headline2,
                  ),
                  TextField(
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(0),
                      isDense: true,
                    ),
                    keyboardType: TextInputType.number,
                    maxLength: 2,
                    style: Theme.of(context).textTheme.headline2,
                    textAlign: TextAlign.center,
                    onChanged: (text) {
                      ctrl.strFractions.value = text;
                    },
                  ),
                ]),
                TableRow(children: [
                  Text(
                    'X (Gy/Fx):',
                    style: Theme.of(context).textTheme.headline2,
                  ),
                  TextField(
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(0),
                      isDense: true,
                    ),
                    keyboardType: TextInputType.number,
                    maxLength: 5,
                    style: Theme.of(context).textTheme.headline2,
                    textAlign: TextAlign.center,
                    onChanged: (text) {
                      ctrl.strX.value = text;
                    },
                  ),
                ]),
                TableRow(children: [
                  TableCell(
                    verticalAlignment: TableCellVerticalAlignment.middle,
                    child: Slider(
                      min: 1,
                      max: 10,
                      divisions: 18,
                      value: ctrl.nSlider.value,
                      onChanged: (n) {
                        ctrl.nSlider.value = n;
                      },
                    ),
                  ),
                  Text(
                    '\u03b1/\u03b2\n${ctrl.nSlider.value}',
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
                    getBED(ctrl.strDose.value, ctrl.strFractions.value,
                        ctrl.strX.value, ctrl.nSlider.value),
                    style: Theme.of(context).textTheme.headline2,
                    textAlign: TextAlign.center,
                  ),
                ]),
                TableRow(children: [
                  Text(
                    checkStrings(ctrl.strDose.value, ctrl.strFractions.value,
                            ctrl.strX.value)[1]
                        ? 'EQD-${ctrl.strX.value} (Gy):'
                        : 'EQD-X (Gy):',
                    style: Theme.of(context).textTheme.headline2,
                  ),
                  Text(
                    getEQDx(ctrl.strDose.value, ctrl.strFractions.value,
                        ctrl.strX.value, ctrl.nSlider.value),
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

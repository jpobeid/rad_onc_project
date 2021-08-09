import 'package:flutter/material.dart';
import 'package:rad_onc_project/functions/text_field_validation.dart';
import 'package:rad_onc_project/widgets/rad_app_bar.dart';
import 'dart:math' as math;
import 'package:rad_onc_project/widgets/rad_toggle_button.dart';
import 'package:rad_onc_project/data/global_data.dart' as datas;
import 'package:rad_onc_project/widgets/text_fields.dart' as fields;

class TumorVolume extends StatefulWidget {
  static const String routeName = '/tumor-volume-app';

  static const double fractionToggleWidth = 0.8;
  static const double sizeBorderRadius = 10;
  static const double sizeBorderWidth = 2;
  static const List<double> listHeightFractions = [0.03, 0.07, 0.3, 0.07, 0.15];
  static const List<double> listHorizontalFlex = [3, 2];
  static const bool allowBlank = false;
  static const bool allowNegative = false;
  static const bool allowZero = true;
  static const bool allowDecimal = true;
  static const double maxInputN = 100;
  static const double minInputN = 0;
  static const int maxDigitsPreDecimal = 3;
  static const int maxDigitsPostDecimal = 3;

  @override
  _TumorVolumeState createState() => _TumorVolumeState();
}

class _TumorVolumeState extends State<TumorVolume> {
  List<bool> _isSelected = [true, false];
  String _strVolAns = '';
  String _strSAAns = '';

  TextEditingController ctrlSpherical = TextEditingController(text: '');
  TextEditingController ctrlEllipsoidal1 = TextEditingController(text: '');
  TextEditingController ctrlEllipsoidal2 = TextEditingController(text: '');
  TextEditingController ctrlEllipsoidal3 = TextEditingController(text: '');

  void resetAns() {
    _strVolAns = '';
    _strSAAns = '';
  }

  void functionTogglePressed() {
    setState(() {
      _isSelected = _isSelected.map((e) => !e).toList();
      clearControllers();
      resetAns();
    });
  }

  void clearControllers() {
    ctrlSpherical.clear();
    ctrlEllipsoidal1.clear();
    ctrlEllipsoidal2.clear();
    ctrlEllipsoidal3.clear();
  }

  @override
  void dispose() {
    ctrlSpherical.dispose();
    ctrlEllipsoidal1.dispose();
    ctrlEllipsoidal2.dispose();
    ctrlEllipsoidal3.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double heightApp = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: RadAppBar(
          strAppTitle: datas.mapAppNames[0]![0],
        ),
        body: Column(
          children: [
            SizedBox(
              height: heightApp * TumorVolume.listHeightFractions[0],
            ),
            Container(
              height: MediaQuery.of(context).size.height *
                  TumorVolume.listHeightFractions[1],
              child: RadToggleButton(
                strOption1: 'Spherical',
                strOption2: 'Ellipsoidal',
                fractionToggleWidth: TumorVolume.fractionToggleWidth,
                sizeBorderRadius: TumorVolume.sizeBorderRadius,
                listIsSelected: _isSelected,
                functionOnPressed: functionTogglePressed,
              ),
            ),
            SizedBox(
              height: heightApp * TumorVolume.listHeightFractions[0],
            ),
            Container(
              height: MediaQuery.of(context).size.height *
                  TumorVolume.listHeightFractions[2],
              child: LayoutBuilder(
                builder: (context, constraints) {
                  if (_isSelected[0]) {
                    return Table(
                      columnWidths: {
                        0: FlexColumnWidth(TumorVolume.listHorizontalFlex[0]),
                        1: FlexColumnWidth(TumorVolume.listHorizontalFlex[1])
                      },
                      children: [
                        makeTableRow(context, 'Diameter:', ctrlSpherical),
                      ],
                    );
                  } else {
                    return Table(
                      columnWidths: {
                        0: FlexColumnWidth(TumorVolume.listHorizontalFlex[0]),
                        1: FlexColumnWidth(TumorVolume.listHorizontalFlex[1])
                      },
                      children: [
                        makeTableRow(context, 'Diameter 1:', ctrlEllipsoidal1),
                        makeTableRow(context, 'Diameter 2:', ctrlEllipsoidal2),
                        makeTableRow(context, 'Diameter 3:', ctrlEllipsoidal3),
                      ],
                    );
                  }
                },
              ),
            ),
            SizedBox(
              height: heightApp * TumorVolume.listHeightFractions[0],
            ),
            TextButton(
              child: Container(
                height: MediaQuery.of(context).size.height *
                    TumorVolume.listHeightFractions[3],
                width: MediaQuery.of(context).size.width *
                    TumorVolume.fractionToggleWidth,
                decoration: BoxDecoration(
                  color: Theme.of(context).textTheme.headline1!.color,
                  borderRadius:
                      BorderRadius.circular(TumorVolume.sizeBorderRadius),
                ),
                alignment: Alignment.center,
                child: Text(
                  'Compute',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: Theme.of(context).textTheme.headline2!.fontSize,
                    fontWeight:
                        Theme.of(context).textTheme.headline2!.fontWeight,
                    color: Theme.of(context).scaffoldBackgroundColor,
                  ),
                ),
              ),
              onPressed: () {
                setState(() {
                  if (_isSelected[0]) {
                    bool isStrDValid = validateField(ctrlSpherical);
                    _strVolAns = isStrDValid
                        ? getVolumeSpherical(ctrlSpherical.text)
                            .toStringAsFixed(2)
                        : 'N/A';
                    _strSAAns = isStrDValid
                        ? getSASpherical(ctrlSpherical.text).toStringAsFixed(2)
                        : 'N/A';
                  } else {
                    bool isStrD1Valid = validateField(ctrlEllipsoidal1);
                    bool isStrD2Valid = validateField(ctrlEllipsoidal2);
                    bool isStrD3Valid = validateField(ctrlEllipsoidal3);
                    _strVolAns = (isStrD1Valid && isStrD2Valid && isStrD3Valid)
                        ? getVolumeEllipsoidal(ctrlEllipsoidal1.text,
                                ctrlEllipsoidal2.text, ctrlEllipsoidal3.text)
                            .toStringAsFixed(2)
                        : 'N/A';
                    _strSAAns = (isStrD1Valid && isStrD2Valid && isStrD3Valid)
                        ? getSAEllipsoidal(ctrlEllipsoidal1.text,
                                ctrlEllipsoidal2.text, ctrlEllipsoidal3.text)
                            .toStringAsFixed(2)
                        : 'N/A';
                  }
                });
              },
            ),
            SizedBox(
              height: heightApp * TumorVolume.listHeightFractions[0],
            ),
            Container(
              height: TumorVolume.listHeightFractions[4],
              child: Table(
                border: TableBorder.all(
                    color: Theme.of(context).primaryColor,
                    width: TumorVolume.sizeBorderWidth),
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                children: [
                  TableRow(
                    children: [
                      Text(
                        'Volume\n',
                        style: Theme.of(context).textTheme.headline2,
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        _strVolAns,
                        style: Theme.of(context).textTheme.headline2,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                  TableRow(
                    children: [
                      Text(
                        'Surface\nArea',
                        style: Theme.of(context).textTheme.headline2,
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        _strSAAns,
                        style: Theme.of(context).textTheme.headline2,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

bool validateField(TextEditingController controller) {
  return textFieldDoubleValidation(
      strN: controller.text,
      allowBlank: TumorVolume.allowBlank,
      allowNegative: TumorVolume.allowNegative,
      allowZero: TumorVolume.allowZero,
      allowDecimal: TumorVolume.allowDecimal,
      maxValue: TumorVolume.maxInputN,
      minValue: TumorVolume.minInputN,
      maxDigitsPreDecimal: TumorVolume.maxDigitsPreDecimal,
      maxDigitsPostDecimal: TumorVolume.maxDigitsPostDecimal);
}

TableRow makeTableRow(
    BuildContext context, String strText, TextEditingController ctrl) {
  return TableRow(
    children: [
      Text(
        strText,
        style: Theme.of(context).textTheme.headline2,
        textAlign: TextAlign.center,
      ),
      fields.textFieldStandard(context, ctrl, true),
    ],
  );
}

double getVolumeSpherical(String strD) {
  double d = double.parse(strD);
  double vol = 4 / 3 * math.pi * math.pow(d / 2, 3);
  return vol;
}

double getSASpherical(String strD) {
  double d = double.parse(strD);
  double sa = 4 * math.pi * math.pow(d / 2, 2);
  return sa;
}

double getVolumeEllipsoidal(String strD1, String strD2, String strD3) {
  double d1 = double.parse(strD1);
  double d2 = double.parse(strD2);
  double d3 = double.parse(strD3);
  double vol = 4 / 3 * math.pi * (d1 / 2) * (d2 / 2) * (d3 / 2);
  return vol;
}

double getSAEllipsoidal(String strD1, String strD2, String strD3) {
  double r1 = double.parse(strD1) / 2;
  double r2 = double.parse(strD2) / 2;
  double r3 = double.parse(strD3) / 2;
  double base = (math.pow(r1 * r2, 1.6) +
          math.pow(r1 * r3, 1.6) +
          math.pow(r2 * r3, 1.6)) /
      3;
  double sa = 4 * math.pi * math.pow((base), (1 / 1.6));
  return sa;
}

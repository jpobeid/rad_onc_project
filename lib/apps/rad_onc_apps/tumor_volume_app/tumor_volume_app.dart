import 'package:flutter/material.dart';
import 'package:rad_onc_project/functions/text_field_validation.dart';
import 'package:rad_onc_project/widgets/rad_app_bar.dart';
import 'dart:math' as math;
import 'package:rad_onc_project/widgets/rad_toggle_button.dart';
import 'package:rad_onc_project/data/main_data.dart' as datas;

class TumorVolume extends StatefulWidget {
  static const String routeName = '/tumor-volume-app';

  @override
  _TumorVolumeState createState() => _TumorVolumeState();
}

class _TumorVolumeState extends State<TumorVolume> {
  static const double fractionToggleWidth = 0.8;
  static const double sizeBorderRadius = 10;
  static const double sizeBorderWidth = 2;
  static const List<double> listHeightFractions = [0.03, 0.07, 0.3, 0.07, 0.15];
  static const List<double> listHorizontalFlex = [3, 2];

  List<bool> _isSelected = [true, false];
  String _strVolAns = '';
  String _strSAAns = '';

  TextEditingController ctrlSpherical = TextEditingController(text: '');
  TextEditingController ctrlEllipsoidal1 = TextEditingController(text: '');
  TextEditingController ctrlEllipsoidal2 = TextEditingController(text: '');
  TextEditingController ctrlEllipsoidal3 = TextEditingController(text: '');

  TextField makeTextField(int maxLength, TextEditingController ctrl) {
    return TextField(
      keyboardType: TextInputType.number,
      maxLength: maxLength,
      controller: ctrl,
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.headline2,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.all(0),
        isDense: true,
      ),
      onChanged: (text) {
        setState(() {
          resetAns();
        });
      },
    );
  }

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
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: RadAppBar(
        strAppTitle: datas.mapAppNames[0][0],
      ),
      body: Column(
        children: [
          SizedBox(
            height: heightApp * listHeightFractions[0],
          ),
          Container(
            height: MediaQuery.of(context).size.height * listHeightFractions[1],
            child: RadToggleButton(
              strOption1: 'Spherical',
              strOption2: 'Ellipsoidal',
              fractionToggleWidth: fractionToggleWidth,
              sizeBorderRadius: sizeBorderRadius,
              listIsSelected: _isSelected,
              functionOnPressed: functionTogglePressed,
            ),
          ),
          SizedBox(
            height: heightApp * listHeightFractions[0],
          ),
          Container(
            height: MediaQuery.of(context).size.height * listHeightFractions[2],
            child: LayoutBuilder(
              builder: (context, constraints) {
                if (_isSelected[0]) {
                  return Table(
                    columnWidths: {
                      0: FlexColumnWidth(listHorizontalFlex[0]),
                      1: FlexColumnWidth(listHorizontalFlex[1])
                    },
                    children: [
                      makeTableRow(
                          context, 'Diameter:', makeTextField, ctrlSpherical),
                    ],
                  );
                } else {
                  return Table(
                    columnWidths: {
                      0: FlexColumnWidth(listHorizontalFlex[0]),
                      1: FlexColumnWidth(listHorizontalFlex[1])
                    },
                    children: [
                      makeTableRow(context, 'Diameter 1:', makeTextField,
                          ctrlEllipsoidal1),
                      makeTableRow(context, 'Diameter 2:', makeTextField,
                          ctrlEllipsoidal2),
                      makeTableRow(context, 'Diameter 3:', makeTextField,
                          ctrlEllipsoidal3),
                    ],
                  );
                }
              },
            ),
          ),
          SizedBox(
            height: heightApp * listHeightFractions[0],
          ),
          FlatButton(
            child: Container(
              height:
                  MediaQuery.of(context).size.height * listHeightFractions[3],
              width: MediaQuery.of(context).size.width * fractionToggleWidth,
              decoration: BoxDecoration(
                color: Theme.of(context).textTheme.headline1.color,
                borderRadius: BorderRadius.circular(sizeBorderRadius),
              ),
              alignment: Alignment.center,
              child: Text(
                'Compute',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: Theme.of(context).textTheme.headline2.fontSize,
                  fontWeight: Theme.of(context).textTheme.headline2.fontWeight,
                  color: Theme.of(context).scaffoldBackgroundColor,
                ),
              ),
            ),
            onPressed: () {
              setState(() {
                if (_isSelected[0]) {
                  bool isStrDValid = textFieldDoubleValidation(
                      ctrlSpherical.text,
                      false,
                      false,
                      true,
                      true,
                      1000,
                      0,
                      3,
                      3);
                  _strVolAns = isStrDValid
                      ? getVolumeSpherical(ctrlSpherical.text)
                          .toStringAsFixed(2)
                      : 'N/A';
                  _strSAAns = isStrDValid
                      ? getSASpherical(ctrlSpherical.text).toStringAsFixed(2)
                      : 'N/A';
                } else {
                  bool isStrD1Valid = textFieldDoubleValidation(
                      ctrlEllipsoidal1.text,
                      false,
                      false,
                      true,
                      true,
                      1000,
                      0,
                      3,
                      3);
                  bool isStrD2Valid = textFieldDoubleValidation(
                      ctrlEllipsoidal2.text,
                      false,
                      false,
                      true,
                      true,
                      1000,
                      0,
                      3,
                      3);
                  bool isStrD3Valid = textFieldDoubleValidation(
                      ctrlEllipsoidal3.text,
                      false,
                      false,
                      true,
                      true,
                      1000,
                      0,
                      3,
                      3);
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
            height: heightApp * listHeightFractions[0],
          ),
          Container(
            height: listHeightFractions[4],
            child: Table(
              border: TableBorder.all(
                  color: Theme.of(context).primaryColor,
                  width: sizeBorderWidth),
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              children: [
                TableRow(
                  children: [
                    Text(
                      'Volume:',
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
                      'Surface Area:',
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
    );
  }
}

TableRow makeTableRow(BuildContext context, String strText,
    Function makeTextField, TextEditingController ctrl) {
  return TableRow(
    children: [
      Text(
        strText,
        style: Theme.of(context).textTheme.headline2,
        textAlign: TextAlign.center,
      ),
      makeTextField(5, ctrl),
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

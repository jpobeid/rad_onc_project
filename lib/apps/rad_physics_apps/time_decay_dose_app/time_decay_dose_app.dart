import 'package:flutter/material.dart';
import 'package:rad_onc_project/functions/text_field_validation.dart';
import 'package:rad_onc_project/widgets/rad_toggle_button.dart';
import 'dart:math' as math;
import 'package:rad_onc_project/widgets/rad_app_bar.dart';
import 'package:rad_onc_project/data/global_data.dart' as datas;

class TimeDecayDoseApp extends StatefulWidget {
  static const routeName = '/time-decay-dose-app';

  final bool fromIsotopes;
  final bool isBioPresent;
  final String strUnits;
  final String strImportedPHL;
  final String strImportedBHL;
  final String strSymbol;

  const TimeDecayDoseApp(
      {Key? key,
      this.fromIsotopes = false,
      this.isBioPresent = false,
      this.strUnits = '[User defined]',
      this.strImportedPHL = '',
      this.strImportedBHL = '',
      this.strSymbol = ''})
      : super(key: key);

  @override
  _TimeDecayDoseAppState createState() => _TimeDecayDoseAppState();
}

class _TimeDecayDoseAppState extends State<TimeDecayDoseApp> {
  static const double fractionWidthButtons = 0.8;
  static const List<int> listVerticalFlex = [1, 2, 10, 2, 7];
  static const List<int> listHorizontalFlex = [2, 1];
  static const double sizeBorderRadius = 10;
  static const Color colorUnits = Colors.greenAccent;
  static const Color colorRate = Colors.pink;
  static const Color colorTotal = Colors.indigoAccent;
  static const List<int> checkRowFlex = [1, 3];

  List<bool> _isSelected = [true, false];
  bool? _isBioHalfLife;
  bool _isCompute = false;
  String? _strUnits;
  String? _strSymbol;

  void resetIsCompute() {
    _isCompute = false;
  }

  TextEditingController _ctrlA0 = TextEditingController(text: '');
  TextEditingController _ctrlPHL = TextEditingController(text: '');
  TextEditingController _ctrlBHL = TextEditingController(text: '');
  TextEditingController _ctrlDT = TextEditingController(text: '');

  TextField makeTextField(BuildContext context, int maxLength,
      TextEditingController ctrl, bool isEnabled) {
    return TextField(
      decoration: InputDecoration(
        contentPadding: EdgeInsets.all(0),
        isDense: true,
      ),
      maxLength: maxLength,
      keyboardType: TextInputType.number,
      style: Theme.of(context).textTheme.headline1,
      textAlign: TextAlign.center,
      controller: ctrl,
      enabled: isEnabled,
      onChanged: (text) {
        setState(() {
          resetIsCompute();
        });
      },
    );
  }

  void functionTogglePressed() {
    setState(() {
      _isSelected = _isSelected.map((e) => !e).toList();
      resetIsCompute();
    });
  }

  @override
  void initState() {
    _isBioHalfLife = widget.isBioPresent;
    _strUnits = widget.strUnits;
    _ctrlPHL.text = widget.strImportedPHL;
    _ctrlBHL.text = widget.strImportedBHL;
    _strSymbol = widget.strSymbol;
    super.initState();
  }

  @override
  void dispose() {
    _ctrlA0.dispose();
    _ctrlPHL.dispose();
    _ctrlBHL.dispose();
    _ctrlDT.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String strAns = '';
    if (_isCompute) {
      strAns = checkStrings(_isBioHalfLife, _ctrlA0.text, _ctrlPHL.text,
              _ctrlBHL.text, _ctrlDT.text)
          ? computeAns(
                  _isSelected[0],
                  _isBioHalfLife!,
                  _ctrlA0.text,
                  _ctrlPHL.text,
                  _isBioHalfLife! ? _ctrlBHL.text : '',
                  _ctrlDT.text)
              .toStringAsFixed(2)
          : 'N/A';
    }
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: RadAppBar(
          strAppTitle: datas.mapAppNames[2]![2],
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Spacer(
              flex: listVerticalFlex[0],
            ),
            Expanded(
              flex: listVerticalFlex[1],
              child: RadToggleButton(
                strOption1: 'Differential',
                strOption2: 'Cumulative',
                fractionToggleWidth: fractionWidthButtons,
                sizeBorderRadius: sizeBorderRadius,
                listIsSelected: _isSelected,
                functionOnPressed: functionTogglePressed,
              ),
            ),
            Spacer(
              flex: listVerticalFlex[0],
            ),
            Expanded(
              flex: listVerticalFlex[2],
              child: Table(
                defaultVerticalAlignment: TableCellVerticalAlignment.top,
                border: TableBorder.all(
                    color: Theme.of(context).primaryColor, width: 2),
                columnWidths: {
                  0: FlexColumnWidth(listHorizontalFlex[0].toDouble()),
                  1: FlexColumnWidth(listHorizontalFlex[1].toDouble())
                },
                children: [
                  TableRow(children: [
                    Text(
                      'Initial Activity (A\u2080) /\nDose Rate (D\u2080)',
                      style: Theme.of(context).textTheme.headline1,
                      textAlign: TextAlign.center,
                    ),
                    makeTextField(context, 5, _ctrlA0, true),
                  ]),
                  TableRow(children: [
                    Text(
                      'Phys. Half-life:',
                      style: Theme.of(context).textTheme.headline1,
                      textAlign: TextAlign.center,
                    ),
                    makeTextField(context, 5, _ctrlPHL, !widget.fromIsotopes),
                  ]),
                  TableRow(children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: checkRowFlex[0],
                          child: IgnorePointer(
                            ignoring: widget.fromIsotopes,
                            child: Container(
                              color: Colors.grey[400],
                              child: Checkbox(
                                checkColor: Colors.black,
                                value: _isBioHalfLife,
                                onChanged: (value) {
                                  setState(() {
                                    _ctrlBHL.clear();
                                    _isBioHalfLife = value;
                                    resetIsCompute();
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: checkRowFlex[1],
                          child: Text(
                            'Bio. Half-life: ',
                            style: Theme.of(context).textTheme.headline1,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                    _isBioHalfLife! ?
                    makeTextField(context, 5, _ctrlBHL, !widget.fromIsotopes) : Container(),
                  ]),
                  TableRow(children: [
                    Text(
                      'Elapsed time:\n(\u0394T)',
                      style: Theme.of(context).textTheme.headline1,
                      textAlign: TextAlign.center,
                    ),
                    makeTextField(context, 5, _ctrlDT, true),
                  ]),
                  TableRow(children: [
                    Text(
                      widget.fromIsotopes
                          ? 'Isotope:\nTime units:'
                          : 'Time units:',
                      style: Theme.of(context).textTheme.headline1,
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      widget.fromIsotopes
                          ? '$_strSymbol\n$_strUnits'
                          : '$_strUnits',
                      style: TextStyle(
                          fontSize:
                              Theme.of(context).textTheme.headline1!.fontSize,
                          color: colorUnits),
                      textAlign: TextAlign.center,
                    ),
                  ]),
                ],
              ),
            ),
            Spacer(
              flex: listVerticalFlex[0],
            ),
            Expanded(
              flex: listVerticalFlex[3],
              child: Container(
                width: MediaQuery.of(context).size.width * fractionWidthButtons,
                decoration: BoxDecoration(
                  color: Theme.of(context).textTheme.headline1!.color,
                  borderRadius: BorderRadius.circular(sizeBorderRadius),
                ),
                child: TextButton(
                  child: Text(
                    _isCompute ? 'Reset' : 'Compute',
                    style: TextStyle(
                        fontSize:
                            Theme.of(context).textTheme.headline1!.fontSize,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).scaffoldBackgroundColor),
                  ),
                  onPressed: () {
                    setState(() {
                      _isCompute = !_isCompute;
                    });
                  },
                ),
              ),
            ),
            Spacer(
              flex: listVerticalFlex[0],
            ),
            Expanded(
              flex: listVerticalFlex[4],
              child: LayoutBuilder(
                builder: (context, index) {
                  return Table(
                    defaultVerticalAlignment: TableCellVerticalAlignment.top,
                    border: TableBorder.all(
                        color: Theme.of(context).primaryColor, width: 2),
                    columnWidths: {
                      0: FlexColumnWidth(listHorizontalFlex[0].toDouble()),
                      1: FlexColumnWidth(listHorizontalFlex[1].toDouble())
                    },
                    children: [
                      TableRow(children: [
                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            style: Theme.of(context).textTheme.headline1,
                            children: [
                              TextSpan(text: 'Final '),
                              TextSpan(
                                text: _isSelected[0]
                                    ? 'Activity/Dose\n'
                                    : 'TOTAL',
                                style: TextStyle(
                                    fontSize: Theme.of(context)
                                        .textTheme
                                        .headline1!
                                        .fontSize,
                                    color: _isSelected[0]
                                        ? Theme.of(context)
                                            .textTheme
                                            .headline1!
                                            .color
                                        : colorTotal),
                              ),
                              TextSpan(
                                text: _isSelected[0]
                                    ? 'RATE'
                                    : '\nDisintegrations/Dose',
                                style: TextStyle(
                                    fontSize: Theme.of(context)
                                        .textTheme
                                        .headline1!
                                        .fontSize,
                                    color: _isSelected[0]
                                        ? colorRate
                                        : Theme.of(context)
                                            .textTheme
                                            .headline1!
                                            .color),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          strAns,
                          style: Theme.of(context).textTheme.headline1,
                          textAlign: TextAlign.center,
                        ),
                      ]),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

bool checkStrings(
    bool? isBio, String strA0, String strPHL, String strBHL, String strDT) {
  int maxDigits = 5;
  bool validStrA0 = textFieldDoubleValidation(
      strN: strA0,
      allowBlank: false,
      allowNegative: false,
      allowZero: true,
      allowDecimal: true,
      maxValue: math.pow(10, maxDigits).toDouble(),
      minValue: 0,
      maxDigitsPreDecimal: maxDigits,
      maxDigitsPostDecimal: maxDigits);
  bool validStrPHL = textFieldDoubleValidation(
      strN: strPHL,
      allowBlank: false,
      allowNegative: false,
      allowZero: false,
      allowDecimal: true,
      maxValue: math.pow(10, maxDigits).toDouble(),
      minValue: 0,
      maxDigitsPreDecimal: maxDigits,
      maxDigitsPostDecimal: maxDigits);
  bool validStrBHL = textFieldDoubleValidation(
          strN: strBHL,
          allowBlank: false,
          allowNegative: false,
          allowZero: false,
          allowDecimal: true,
          maxValue: math.pow(10, maxDigits).toDouble(),
          minValue: 0,
          maxDigitsPreDecimal: maxDigits,
          maxDigitsPostDecimal: maxDigits) ||
      strBHL == '\u221e';
  bool validStrDT = textFieldDoubleValidation(
      strN: strDT,
      allowBlank: false,
      allowNegative: false,
      allowZero: true,
      allowDecimal: true,
      maxValue: math.pow(10, maxDigits).toDouble(),
      minValue: 0,
      maxDigitsPreDecimal: maxDigits,
      maxDigitsPostDecimal: maxDigits);
  return (validStrA0 && validStrPHL && (!isBio! || validStrBHL) && validStrDT);
}

double computeAns(bool isDiff, bool isBio, String strA0, String strPHL,
    String strBHL, String strDT) {
  double a0 = double.parse(strA0);
  double pHL = double.parse(strPHL);
  double dt = double.parse(strDT);
  double eHL;
  if (isBio && strBHL != '\u221e') {
    double bHL = double.parse(strBHL);
    eHL = 1 / ((1 / pHL) + (1 / bHL));
  } else {
    eHL = pHL;
  }
  double k = math.ln2 / eHL;
  double ans;
  if (isDiff) {
    ans = a0 * math.exp(-k * dt);
  } else {
    ans = (a0 / k) * (1 - math.exp(-k * dt));
  }
  return ans;
}

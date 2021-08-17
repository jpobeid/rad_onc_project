import 'package:flutter/material.dart';
import 'package:rad_onc_project/widgets/rad_app_bar.dart';
import 'package:rad_onc_project/data/global_data.dart' as datas;
import 'package:rad_onc_project/widgets/text_fields.dart' as fields;
import 'dart:math' as maths;
import 'package:rad_onc_project/functions/text_field_validation.dart' as funcs;

class ProbabilitiesApp extends StatefulWidget {
  static const String routeName = '/probabilities-app';

  static const List<String> probTypes = ['Fixed rate', 'Exp. Survival'];
  static const List<int> flexVertical = [1, 3, 1, 1];
  static const double fractionWidthButton = 0.8;
  static const double fractionHeightButton = 0.07;
  static const double borderRadius = 10;
  static const int durationSnack = 600;

  @override
  _ProbabilitiesAppState createState() => _ProbabilitiesAppState();
}

class _ProbabilitiesAppState extends State<ProbabilitiesApp> {
  int _iType = 0;
  TextEditingController _controller1 = TextEditingController(text: '');
  TextEditingController _controller2 = TextEditingController(text: '');
  TextEditingController _controller3 = TextEditingController(text: '');
  TextEditingController _controller4 = TextEditingController(text: '');
  String _result = '';

  @override
  void dispose() {
    _controller1.dispose();
    _controller2.dispose();
    _controller3.dispose();
    _controller4.dispose();
    super.dispose();
  }

  void resetInputs() {
    _controller1.clear();
    _controller2.clear();
    _controller3.clear();
    _controller4.clear();
    _result = '';
  }

  Row makeLayoutRow(String labelInput, TextEditingController controller) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Text(
            labelInput,
            style: Theme.of(context).textTheme.headline1,
          ),
        ),
        Expanded(
            flex: 1,
            child: fields.textFieldStandard(context, controller, true)),
      ],
    );
  }

  Column makeFixedRateLayout() {
    return Column(
      children: [
        makeLayoutRow('Rate [%/time]: ', _controller1),
        makeLayoutRow('Time elapsed: ', _controller2),
      ],
    );
  }

  Column makeExpLayout() {
    return Column(
      children: [
        makeLayoutRow('Plateau [%]: ', _controller1),
        Row(
          children: [
            Expanded(
              flex: 2,
              child: Text(
                'Known point\n[time, %]:',
                style: Theme.of(context).textTheme.headline1,
              ),
            ),
            Expanded(
                flex: 1,
                child: fields.textFieldStandard(context, _controller2, true)),
            Expanded(
                flex: 1,
                child: fields.textFieldStandard(context, _controller3, true)),
          ],
        ),
        makeLayoutRow('Time elapsed: ', _controller4),
      ],
    );
  }

  void showSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        'Invalid inputs',
        style: Theme.of(context).textTheme.headline2,
      ),
      duration: Duration(milliseconds: ProbabilitiesApp.durationSnack),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: RadAppBar(
          strAppTitle: datas.mapAppNames[0]![2],
        ),
        body: Column(
          children: [
            Expanded(
              flex: ProbabilitiesApp.flexVertical[0],
              child: Center(
                child: DropdownButton(
                  dropdownColor: Colors.blueGrey,
                  value: _iType,
                  items: ProbabilitiesApp.probTypes
                      .map(
                        (e) => DropdownMenuItem(
                          child: Text(
                            e,
                            style: Theme.of(context).textTheme.headline2,
                          ),
                          value: ProbabilitiesApp.probTypes.indexOf(e),
                        ),
                      )
                      .toList(),
                  onChanged: (int? index) {
                    setState(() {
                      _iType = index!;
                      resetInputs();
                    });
                  },
                ),
              ),
            ),
            Divider(
              color: Theme.of(context).primaryColor,
              thickness: 2,
            ),
            Expanded(
              flex: ProbabilitiesApp.flexVertical[1],
              child: Builder(builder: (context) {
                switch (_iType) {
                  case 0:
                    return makeFixedRateLayout();
                  case 1:
                    return makeExpLayout();
                  default:
                    return Container();
                }
              }),
            ),
            Divider(
              color: Theme.of(context).primaryColor,
              thickness: 2,
            ),
            Expanded(
              flex: ProbabilitiesApp.flexVertical[2],
              child: Row(
                children: [
                  Text('Prob [%]: ',
                      style: Theme.of(context).textTheme.headline2),
                  Text(
                    _result,
                    style: Theme.of(context).textTheme.headline2,
                  )
                ],
              ),
            ),
            Expanded(
              flex: ProbabilitiesApp.flexVertical[3],
              child: TextButton(
                child: Container(
                  width: MediaQuery.of(context).size.width *
                      ProbabilitiesApp.fractionWidthButton,
                  height: MediaQuery.of(context).size.height *
                      ProbabilitiesApp.fractionHeightButton,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.circular(ProbabilitiesApp.borderRadius),
                  ),
                  child: Center(
                    child: Text(
                      'Compute',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize:
                            Theme.of(context).textTheme.headline2!.fontSize,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                onPressed: () {
                  switch (_iType) {
                    case 0:
                      if (checkFixedRateInputs(_controller1, _controller2)) {
                        setState(() {
                          _result = getProbabilityFromRate(
                                  double.parse(_controller1.text),
                                  double.parse(_controller2.text))
                              .toStringAsFixed(2);
                        });
                      } else {
                        setState(() {
                          _result = '';
                          showSnackBar();
                        });
                      }
                      break;
                    case 1:
                      if (checkExpInputs(_controller1, _controller2,
                          _controller3, _controller4)) {
                        setState(() {
                          _result = getExpProb(
                                  double.parse(_controller1.text),
                                  double.parse(_controller2.text),
                                  double.parse(_controller3.text),
                                  double.parse(_controller4.text))
                              .toStringAsFixed(2);
                        });
                      } else {
                        setState(() {
                          _result = '';
                          showSnackBar();
                        });
                      }
                      break;
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

double getProbabilityFromRate(double rate, double time) {
  double complementaryProb = (1 - rate / 100);
  return (1 - maths.pow(complementaryProb, time).toDouble()) * 100;
}

double getExpProb(double yPlateau, double T, double yT, double time) {
  double A = 1 - (yPlateau / 100);
  double beta = -maths.log(1 + ((yT / 100) - 1) / A) / T;
  return (1 + A * (maths.exp(-beta * time) - 1)) * 100;
}

bool checkFixedRateInputs(TextEditingController controllerRate,
    TextEditingController controllerTime) {
  bool areValidInputs = funcs.textFieldDoubleValidation(
      strN: controllerRate.text,
      allowBlank: false,
      allowNegative: false,
      allowZero: true,
      allowDecimal: true,
      maxValue: 99.99,
      minValue: 0,
      maxDigitsPreDecimal: 3,
      maxDigitsPostDecimal: 3);
  areValidInputs = areValidInputs &&
      funcs.textFieldDoubleValidation(
          strN: controllerTime.text,
          allowBlank: false,
          allowNegative: false,
          allowZero: true,
          allowDecimal: true,
          maxValue: 99999,
          minValue: 0,
          maxDigitsPreDecimal: 3,
          maxDigitsPostDecimal: 3);
  return areValidInputs;
}

bool checkExpInputs(
    TextEditingController controllerPlateau,
    TextEditingController controllerPointT,
    TextEditingController controllerPointY,
    TextEditingController controllerTime) {
  bool areValidInputs = funcs.textFieldDoubleValidation(
      strN: controllerPlateau.text,
      allowBlank: false,
      allowNegative: false,
      allowZero: true,
      allowDecimal: true,
      maxValue: 99.99,
      minValue: 0,
      maxDigitsPreDecimal: 3,
      maxDigitsPostDecimal: 3);
  areValidInputs = areValidInputs &&
      funcs.textFieldDoubleValidation(
          strN: controllerPointT.text,
          allowBlank: false,
          allowNegative: false,
          allowZero: false,
          allowDecimal: true,
          maxValue: 99999,
          minValue: 0,
          maxDigitsPreDecimal: 3,
          maxDigitsPostDecimal: 3);
  areValidInputs = areValidInputs &&
      funcs.textFieldDoubleValidation(
          strN: controllerPointY.text,
          allowBlank: false,
          allowNegative: false,
          allowZero: false,
          allowDecimal: true,
          maxValue: 99.99,
          minValue: double.parse(controllerPlateau.text) + 0.0001,
          maxDigitsPreDecimal: 3,
          maxDigitsPostDecimal: 3);
  areValidInputs = areValidInputs &&
      funcs.textFieldDoubleValidation(
          strN: controllerTime.text,
          allowBlank: false,
          allowNegative: false,
          allowZero: true,
          allowDecimal: true,
          maxValue: 99999,
          minValue: 0,
          maxDigitsPreDecimal: 3,
          maxDigitsPostDecimal: 3);
  return areValidInputs;
}

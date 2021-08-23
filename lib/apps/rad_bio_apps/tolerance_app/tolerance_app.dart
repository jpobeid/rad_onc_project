import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:rad_onc_project/functions/text_field_validation.dart' as check;
import 'package:rad_onc_project/widgets/rad_app_bar.dart';
import 'package:rad_onc_project/widgets/rad_toggle_button.dart';
import 'package:rad_onc_project/data/global_data.dart' as datas;
import 'package:rad_onc_project/widgets/text_fields.dart' as fields;

class ToleranceApp extends StatefulWidget {
  static const routeName = '/tolerance-app';

  @override
  _ToleranceAppState createState() => _ToleranceAppState();
}

class _ToleranceAppState extends State<ToleranceApp> {
  static const double fractionToggleWidth = 0.75;
  static const double sizeToggleBorderRadius = 10;
  static const double fractionHeightPadding = 0.01;
  static const List<String> listStrDoseType = ['BED', 'EQD-2'];
  static const List<int> listHorizontalFlex1 = [8, 10];
  static const double sizeDivider = 2;
  static const double fractionButtonHeight = 0.075;
  static const double fractionButtonWidth = 0.75;

  int _nCourses = 1;
  int _nCoursesMax = 3;
  List<bool> _listToggle = [true, false];
  TextEditingController _controllerMaxDose = TextEditingController(text: '0');
  double _valueAbRatio = 3;
  List<double> _listPercentForgiven = [0.0];
  List<TextEditingController> _listControllerDose = [
    TextEditingController(text: '0')
  ];
  List<TextEditingController> _listControllerFractions = [
    TextEditingController(text: '0')
  ];

  void functionTogglePressed() {
    setState(() {
      _listToggle = _listToggle.map((e) => !e).toList();
    });
  }

  void functionCancelPressed() {
    setState(() {
      _listPercentForgiven.removeLast();
      _listControllerDose.removeLast();
      _listControllerFractions.removeLast();
      _nCourses--;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _listControllerDose.forEach((element) {
      element.dispose();
    });
    _listControllerFractions.forEach((element) {
      element.dispose();
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: RadAppBar(
          strAppTitle: datas.mapAppNames[1]![2],
        ),
        body: Column(
          children: [
            TitleRow(
              strText: 'Dose Type',
              isCancelable: false,
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  vertical: MediaQuery.of(context).size.height *
                      fractionHeightPadding),
              child: RadToggleButton(
                strOption1: listStrDoseType[0],
                strOption2: listStrDoseType[1],
                fractionToggleWidth: fractionToggleWidth,
                sizeBorderRadius: sizeToggleBorderRadius,
                listIsSelected: _listToggle,
                functionOnPressed: functionTogglePressed,
              ),
            ),
            TitleRow(
              strText: 'RadBio Parameters',
              isCancelable: false,
            ),
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Text(
                    'Max ${listStrDoseType[_listToggle.indexOf(true)]} [Gy]:',
                    style: Theme.of(context).textTheme.headline2,
                    textAlign: TextAlign.start,
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    '\u03b1/\u03b2',
                    style: Theme.of(context).textTheme.headline2,
                    textAlign: TextAlign.end,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  flex: listHorizontalFlex1[0],
                  child: fields.textFieldDose(context, _controllerMaxDose),
                ),
                Expanded(
                  flex: listHorizontalFlex1[1],
                  child: Slider(
                    min: 1,
                    max: 10,
                    divisions: 18,
                    value: _valueAbRatio,
                    label: _valueAbRatio.toString(),
                    onChanged: (value) {
                      setState(() {
                        _valueAbRatio = value;
                      });
                    },
                  ),
                ),
              ],
            ),
            Divider(
              thickness: sizeDivider,
              color: Theme.of(context).textTheme.headline2!.color,
            ),
            Expanded(
              child: ListView.builder(
                  itemCount: _nCourses + 1,
                  itemBuilder: (context, index) {
                    if (index <= _nCourses - 1) {
                      return CourseInfo(
                        nCourse: index + 1,
                        listPercentForgiven: _listPercentForgiven,
                        listControllerDose: _listControllerDose,
                        listControllerFractions: _listControllerFractions,
                        isCancelable: (index > 0 && index == _nCourses - 1)
                            ? true
                            : false,
                        functionCancelPressed: functionCancelPressed,
                      );
                    } else {
                      return Column(
                        children: [
                          Divider(
                            thickness: sizeDivider,
                            color: Theme.of(context).textTheme.headline2!.color,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: Theme.of(context)
                                      .textTheme
                                      .headline2!
                                      .color,
                                  borderRadius: BorderRadius.circular(
                                      sizeToggleBorderRadius),
                                ),
                                width: MediaQuery.of(context).size.width *
                                    fractionButtonWidth,
                                height: MediaQuery.of(context).size.height *
                                    fractionButtonHeight,
                                child: TextButton(
                                  child: Text(
                                    'Compute',
                                    style: TextStyle(
                                        fontSize: Theme.of(context)
                                            .textTheme
                                            .headline2!
                                            .fontSize,
                                        fontWeight: Theme.of(context)
                                            .textTheme
                                            .headline2!
                                            .fontWeight,
                                        color: Theme.of(context)
                                            .scaffoldBackgroundColor),
                                  ),
                                  onPressed: () {
                                    String strMaxDose = _controllerMaxDose.text;
                                    List<String> listStrDose =
                                        _listControllerDose
                                            .map((e) => e.text)
                                            .toList();
                                    List<String> listStrFractions =
                                        _listControllerFractions
                                            .map((e) => e.text)
                                            .toList();
                                    if (checkIsValid(strMaxDose, listStrDose,
                                        listStrFractions)) {
                                      double netDose = 0;
                                      for (int i = 0; i < _nCourses; i++) {
                                        Function fDose =
                                            _listToggle[0] ? getBed : getEqd2;
                                        netDose += fDose(
                                                double.parse(
                                                    _listControllerDose[i]
                                                        .text),
                                                double.parse(
                                                    _listControllerFractions[i]
                                                        .text),
                                                _valueAbRatio) *
                                            (1 - _listPercentForgiven[i] / 100);
                                      }
                                      showDialog(
                                          context: (context),
                                          builder: (context) {
                                            return ComputeDialog(
                                              isBed: _listToggle[0],
                                              maxDose: double.parse(
                                                  _controllerMaxDose.text),
                                              netDose: netDose,
                                              ab: _valueAbRatio,
                                            );
                                          });
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          backgroundColor:
                                              Theme.of(context).primaryColor,
                                          content: Text(
                                            'Invalid numeric input!',
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline1,
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    }
                  }),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
            child: Icon(
              _nCourses == _nCoursesMax ? Icons.lock : Icons.add,
              size: Theme.of(context).textTheme.headline2!.fontSize,
            ),
            backgroundColor: Colors.blue,
            onPressed: () {
              if (_nCourses < _nCoursesMax) {
                setState(() {
                  _nCourses++;
                  _listPercentForgiven.add(0.0);
                  _listControllerDose.add(TextEditingController(text: '0'));
                  _listControllerFractions
                      .add(TextEditingController(text: '0'));
                });
              }
            }),
        floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      ),
    );
  }
}

//region accessory widgets
class CourseInfo extends StatefulWidget {
  final int? nCourse;
  final List<double>? listPercentForgiven;
  final List<TextEditingController>? listControllerDose;
  final List<TextEditingController>? listControllerFractions;
  final bool? isCancelable;
  final Function? functionCancelPressed;

  const CourseInfo(
      {Key? key,
      this.nCourse,
      this.listPercentForgiven,
      this.listControllerDose,
      this.listControllerFractions,
      this.isCancelable,
      this.functionCancelPressed})
      : super(key: key);

  @override
  _CourseInfoState createState() => _CourseInfoState();
}

class _CourseInfoState extends State<CourseInfo> {
  @override
  Widget build(BuildContext context) {
    int index = widget.nCourse! - 1;
    return Column(
      children: [
        TitleRow(
          strText: 'Prior Course ${widget.nCourse}',
          isCancelable: widget.isCancelable,
          functionCancelPressed: widget.functionCancelPressed,
        ),
        Row(
          children: [
            Expanded(
              child: Text(
                'Dose [Gy]:',
                style: Theme.of(context).textTheme.headline2,
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(
              child: Text(
                'Fractions:',
                style: Theme.of(context).textTheme.headline2,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: fields.textFieldDose(
                  context, widget.listControllerDose![index]),
            ),
            Expanded(
              child: fields.textFieldFraction(
                  context, widget.listControllerFractions![index]),
            ),
          ],
        ),
        Row(
          children: [
            Text(
              '% Forgiven: ',
              style: Theme.of(context).textTheme.headline1,
            ),
            Expanded(
              child: Slider(
                value: widget.listPercentForgiven![index],
                label: widget.listPercentForgiven![index].round().toString(),
                min: 0,
                max: 100,
                divisions: 20,
                onChanged: (value) {
                  setState(() {
                    widget.listPercentForgiven![index] = value;
                  });
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class TitleRow extends StatelessWidget {
  final String? strText;
  final bool? isCancelable;
  final Function? functionCancelPressed;

  const TitleRow(
      {Key? key, this.strText, this.isCancelable, this.functionCancelPressed})
      : super(key: key);

  static const double fractionHeight = 0.0525;
  static const List<int> listHorizontalFlex = [4, 1];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * fractionHeight,
      color: Theme.of(context).primaryColor,
      alignment: Alignment.center,
      child: Row(
        children: [
          Expanded(
            flex: listHorizontalFlex[0],
            child: Text(
              strText!,
              style: TextStyle(
                fontSize: Theme.of(context).textTheme.headline2!.fontSize,
                fontWeight: Theme.of(context).textTheme.headline2!.fontWeight,
                color: Theme.of(context).scaffoldBackgroundColor,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          isCancelable!
              ? Expanded(
                  flex: listHorizontalFlex[1],
                  child: IconButton(
                    padding: EdgeInsets.all(0),
                    icon: Icon(
                      Icons.cancel_outlined,
                      size: Theme.of(context).textTheme.headline2!.fontSize!,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      functionCancelPressed!();
                    },
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}

class ComputeDialog extends StatefulWidget {
  final bool? isBed;
  final double? maxDose;
  final double? netDose;
  final double? ab;

  const ComputeDialog(
      {Key? key, this.isBed, this.maxDose, this.netDose, this.ab})
      : super(key: key);

  static const double sizeBorderWidth = 4;
  static const double sizeBorderRadius = 10;
  static const double fractionHeight = 0.6;
  static const double fractionWidth = 0.9;
  static const List<double> listHorizontalFlex = [6, 4];
  static const double sizeDivider = 2;

  @override
  _ComputeDialogState createState() => _ComputeDialogState();
}

class _ComputeDialogState extends State<ComputeDialog> {
  int? _valueDropdown = 0;
  TextEditingController _controllerQuantity = TextEditingController(text: '0');

  Row makeDropdownRow() {
    const List<int> listHorizontalFlex = [6, 4];
    return Row(
      children: [
        Expanded(
          flex: listHorizontalFlex[0],
          child: Text(
            'Partition by:',
            style: Theme.of(context).textTheme.headline2,
            textAlign: TextAlign.center,
          ),
        ),
        Expanded(
          flex: listHorizontalFlex[1],
          child: Container(
            child: DropdownButton(
              value: _valueDropdown,
              items: [
                DropdownMenuItem(
                  value: 0,
                  child: Text(
                    'None',
                    style: Theme.of(context).textTheme.headline2,
                  ),
                ),
                DropdownMenuItem(
                  value: 1,
                  child: Text(
                    'Dose',
                    style: Theme.of(context).textTheme.headline2,
                  ),
                ),
                DropdownMenuItem(
                  value: 2,
                  child: Text(
                    'Fx',
                    style: Theme.of(context).textTheme.headline2,
                  ),
                ),
              ],
              dropdownColor: Colors.blueGrey,
              onChanged: (int? value) {
                setState(() {
                  _valueDropdown = value;
                  _controllerQuantity.text = '0';
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  //###Gotta fix something!!! Error in numbers!

  Expanded dialogScaffold(bool isReserve) {
    const double sizeDivider = 2;
    const List<int> listHorizontalFlex = [6, 4];
    return Expanded(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Builder(
          builder: (context) {
            if (isReserve && _valueDropdown == 0) {
              return makeDropdownRow();
            } else if (isReserve && _valueDropdown! > 0) {
              bool isValid = _valueDropdown == 1
                  ? check.textFieldDoubleValidation(
                      strN: _controllerQuantity.text,
                      allowBlank: false,
                      allowNegative: false,
                      allowZero: false,
                      allowDecimal: true,
                      maxValue: 100,
                      minValue: 0,
                      maxDigitsPreDecimal: 2,
                      maxDigitsPostDecimal: 3)
                  : check.textFieldDoubleValidation(
                      strN: _controllerQuantity.text,
                      allowBlank: false,
                      allowNegative: false,
                      allowZero: false,
                      allowDecimal: false,
                      maxValue: 100,
                      minValue: 0,
                      maxDigitsPreDecimal: 0,
                      maxDigitsPostDecimal: 0);
              String strAns;
              if (isValid) {
                double R = (widget.maxDose! - widget.netDose!);
                double nAns = getPartition(widget.isBed!, _valueDropdown == 1,
                    R, double.parse(_controllerQuantity.text), widget.ab);
                strAns = nAns >= 0 ? nAns.toStringAsFixed(2) : 'N/A (<0)';
              } else {
                strAns = 'N/A';
              }
              return Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  makeDropdownRow(),
                  Divider(
                    color: Theme.of(context).textTheme.headline2!.color,
                    thickness: sizeDivider,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: listHorizontalFlex[0],
                        child: Text(
                          _valueDropdown == 1 ? 'Dose [Gy]:' : '# Fx:',
                          style: Theme.of(context).textTheme.headline2,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Expanded(
                        flex: listHorizontalFlex[1],
                        child: _valueDropdown == 1
                            ? fields.textFieldDose(context, _controllerQuantity,
                                funcOnChanged: (text) => setState)
                            : fields.textFieldFraction(
                                context, _controllerQuantity,
                                funcOnChanged: (text) => setState),
                      ),
                    ],
                  ),
                  Divider(
                    color: Theme.of(context).textTheme.headline2!.color,
                    thickness: sizeDivider,
                  ),
                  Table(
                    columnWidths: {
                      0: FlexColumnWidth(listHorizontalFlex[0].toDouble()),
                      1: FlexColumnWidth(listHorizontalFlex[1].toDouble())
                    },
                    border: TableBorder.symmetric(
                      inside: BorderSide(
                        color: Theme.of(context).primaryColor,
                        width: sizeDivider,
                      ),
                    ),
                    children: [
                      TableRow(
                        children: [
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: _valueDropdown == 1 ? 'MIN' : 'MAX',
                                  style: TextStyle(
                                      fontSize: Theme.of(context)
                                          .textTheme
                                          .headline2!
                                          .fontSize,
                                      fontWeight: Theme.of(context)
                                          .textTheme
                                          .headline2!
                                          .fontWeight,
                                      color: Theme.of(context).primaryColor),
                                ),
                                TextSpan(
                                  text: _valueDropdown == 1
                                      ? ' # Fx:'
                                      : ' Dose [Gy]:',
                                  style: Theme.of(context).textTheme.headline2,
                                ),
                              ],
                            ),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            strAns,
                            style: Theme.of(context).textTheme.headline2,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              );
            } else {
              return Text(
                'Prior net ${widget.isBed! ? 'BED' : 'EQD-2'} leaves no reserve dose available',
                style: Theme.of(context).textTheme.headline2,
                textAlign: TextAlign.center,
              );
            }
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controllerQuantity.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double diffDose = (widget.maxDose! - widget.netDose!);
    bool isReserve = diffDose > 0;
    return Center(
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          border: Border.all(
              color: Theme.of(context).primaryColor,
              width: ComputeDialog.sizeBorderWidth),
          borderRadius: BorderRadius.circular(ComputeDialog.sizeBorderRadius),
        ),
        height:
            MediaQuery.of(context).size.height * ComputeDialog.fractionHeight,
        width: MediaQuery.of(context).size.width * ComputeDialog.fractionWidth,
        child: Column(
          children: [
            Table(
              columnWidths: {
                0: FlexColumnWidth(ComputeDialog.listHorizontalFlex[0]),
                1: FlexColumnWidth(ComputeDialog.listHorizontalFlex[1])
              },
              border: TableBorder.symmetric(
                  inside: BorderSide(
                      color: Theme.of(context).primaryColor,
                      width: ComputeDialog.sizeBorderWidth / 2)),
              children: [
                TableRow(
                  children: [
                    Text(
                      'Max ${widget.isBed! ? 'BED' : 'EQD-2'}:',
                      style: Theme.of(context).textTheme.headline2,
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      widget.maxDose!.toStringAsFixed(2),
                      style: Theme.of(context).textTheme.headline2,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    Text(
                      'Net ${widget.isBed! ? 'BED' : 'EQD-2'}:',
                      style: Theme.of(context).textTheme.headline2,
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      widget.netDose!.toStringAsFixed(2),
                      style: Theme.of(context).textTheme.headline2,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    Text(
                      'Reserve:',
                      style: Theme.of(context).textTheme.headline2,
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      isReserve
                          ? diffDose.toStringAsFixed(2)
                          : (0).toStringAsFixed(2),
                      style: Theme.of(context).textTheme.headline2,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ],
            ),
            Divider(
              color: Theme.of(context).textTheme.headline1!.color,
              thickness: ComputeDialog.sizeDivider,
            ),
            dialogScaffold(isReserve),
          ],
        ),
      ),
    );
  }
}

//endregion accessory widgets

//region general functions
double getBed(double D, double N, double ab) {
  return D + math.pow(D, 2) / (N * ab);
}

double getEqd2(double D, double N, double ab) {
  return D * (1 + D / (N * ab)) / (1 + 2 / ab);
}

double fromBedGetD(double R, double N, double ab) {
  return (N * ab / 2) * (math.sqrt(1 + (4 * R / (N * ab))) - 1);
}

double fromBedGetN(double R, double D, double ab) {
  return math.pow(D, 2) / (ab * (R - D));
}

double fromEqd2GetD(double R, double N, double ab) {
  return (N * ab / 2) * (math.sqrt(1 + (4 * R / (N * ab)) * (1 + 2 / ab)) - 1);
}

double fromEqd2GetN(double R, double D, double ab) {
  return math.pow(D, 2) / (ab * (R * (1 + 2 / ab) - D));
}

double getPartition(bool isBed, bool isDose, double R, double q, double? ab) {
  if (isBed && isDose) {
    return fromBedGetN(R, q, ab!);
  } else if (isBed && !isDose) {
    return fromBedGetD(R, q, ab!);
  } else if (!isBed && isDose) {
    return fromEqd2GetN(R, q, ab!);
  } else {
    return fromEqd2GetD(R, q, ab!);
  }
}

bool checkIsValid(String strMaxDose, List<String> listStrDose,
    List<String> listStrFractions) {
  bool isValid = true;
  isValid = isValid &&
      check.textFieldDoubleValidation(
          strN: strMaxDose,
          allowBlank: false,
          allowNegative: false,
          allowZero: true,
          allowDecimal: true,
          maxValue: 1000,
          minValue: 0,
          maxDigitsPreDecimal: 3,
          maxDigitsPostDecimal: 3);
  listStrDose.forEach((element) {
    isValid = isValid &&
        check.textFieldDoubleValidation(
            strN: element,
            allowBlank: false,
            allowNegative: false,
            allowZero: true,
            allowDecimal: true,
            maxValue: 100,
            minValue: 0,
            maxDigitsPreDecimal: 2,
            maxDigitsPostDecimal: 3);
  });
  listStrFractions.forEach((element) {
    isValid = isValid &&
        check.textFieldDoubleValidation(
            strN: element,
            allowBlank: false,
            allowNegative: false,
            allowZero: false,
            allowDecimal: false,
            maxValue: 100,
            minValue: 0,
            maxDigitsPreDecimal: 0,
            maxDigitsPostDecimal: 0);
  });
  return isValid;
}
//endregion general functions

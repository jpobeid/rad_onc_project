import 'dart:collection';
import 'dart:core';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rad_onc_project/data/global_data.dart' as datas;
import 'package:rad_onc_project/functions/text_field_validation.dart';
import 'package:rad_onc_project/widgets/rad_app_bar.dart';
import 'package:rad_onc_project/widgets/text_fields.dart' as fields;

class ScalingTime extends StatefulWidget {
  static const routeName = '/scaling-time-app';

  static const year0 = 1990;
  static const double maxValue = 10000;
  static const List<int> listVerticalFlex = [1, 2, 2, 15, 2];
  static const List<int> listHorizontalFlex = [3, 2, 1];
  static const double fractionHeightRow = 0.08;
  static const int indexMainThreshold = 5;
  static const int maxMainIndex = 20;
  static const double fractionWidthCompute = 0.5;
  static const double fractionHeightAlert = 0.2;
  static const double fractionWidthAlert = 0.8;
  static const double radiusBorderAlert = 10;
  static const double widthBorderAlert = 2;

  @override
  _ScalingTimeState createState() => _ScalingTimeState();
}

class _ScalingTimeState extends State<ScalingTime> {
  int _indexMain = 0;
  List<DateTime> listDateTime = [];
  List<TextEditingController> listCtrl = [];

  Container makeRow(BuildContext context, int index, bool isLast) {
    DateTime now = DateTime.now();
    if (index >= listCtrl.length) {
      TextEditingController iCtrl = TextEditingController(text: '');
      listCtrl.add(iCtrl);
      listDateTime.add(DateTime(now.year, now.month, now.day));
    }
    return Container(
      height: MediaQuery.of(context).size.height * ScalingTime.fractionHeightRow,
      child: Row(
        children: [
          Expanded(
            flex: ScalingTime.listHorizontalFlex[0],
            child: TextButton(
              child: Align(
                alignment: Alignment.topCenter,
                child: Text(
                  '${listDateTime[index].month}/${listDateTime[index].day}/${listDateTime[index].year}',
                  style: Theme.of(context).textTheme.headline1,
                  textAlign: TextAlign.center,
                ),
              ),
              onPressed: () async {
                DateTime? value = await showDatePicker(
                    context: context,
                    initialDate: listDateTime[index],
                    firstDate: DateTime(ScalingTime.year0),
                    lastDate: DateTime.now());
                setState(() {
                  if (value != null) {
                    listDateTime[index] = value;
                  }
                });
              },
            ),
          ),
          Expanded(
            flex: ScalingTime.listHorizontalFlex[1],
            child: fields.textFieldStandard(context, listCtrl[index], true),
          ),
          Expanded(
            child: TextButton(
              child: Align(
                alignment: Alignment.topCenter,
                child: Icon(
                  isLast ? FontAwesomeIcons.timesCircle : Icons.remove,
                  color: Theme.of(context).textTheme.headline2!.color,
                  size: Theme.of(context).textTheme.headline2!.fontSize,
                ),
              ),
              onPressed: () {
                if (isLast) {
                  setState(() {
                    listCtrl.removeLast();
                    listDateTime.removeLast();
                    _indexMain -= 1;
                  });
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    listCtrl.forEach((element) {
      element.dispose();
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.of(context).orientation == Orientation.portrait) {
      return SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: RadAppBar(
            strAppTitle: datas.mapAppNames[0]![1],
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: ScalingTime.listVerticalFlex[1],
                child: Center(
                    child: Text(
                  'Biomarker Data',
                  style: Theme.of(context).textTheme.headline2,
                )),
              ),
              Expanded(
                flex: ScalingTime.listVerticalFlex[2],
                child: Container(
                  color: Theme.of(context).primaryColor,
                  child: Row(
                    children: [
                      Expanded(
                        flex: ScalingTime.listHorizontalFlex[0],
                        child: Text(
                          'Date',
                          style: TextStyle(
                              color: Theme.of(context).scaffoldBackgroundColor,
                              fontSize: Theme.of(context)
                                  .textTheme
                                  .headline2!
                                  .fontSize,
                              fontWeight: Theme.of(context)
                                  .textTheme
                                  .headline2!
                                  .fontWeight),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Expanded(
                        flex: ScalingTime.listHorizontalFlex[1],
                        child: Text(
                          'Level',
                          style: TextStyle(
                              color: Theme.of(context).scaffoldBackgroundColor,
                              fontSize: Theme.of(context)
                                  .textTheme
                                  .headline2!
                                  .fontSize,
                              fontWeight: Theme.of(context)
                                  .textTheme
                                  .headline2!
                                  .fontWeight),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Expanded(
                        child: Align(
                            alignment: Alignment.center,
                            child: Icon(
                              FontAwesomeIcons.timesCircle,
                              color: Theme.of(context).scaffoldBackgroundColor,
                              size: Theme.of(context)
                                  .textTheme
                                  .headline2!
                                  .fontSize,
                            )),
                      ),
                    ],
                  ),
                ),
              ),
              Spacer(
                flex: ScalingTime.listVerticalFlex[0],
              ),
              Expanded(
                flex: ScalingTime.listVerticalFlex[3],
                child: ListView.builder(
                    itemCount: _indexMain + 1,
                    itemBuilder: (context, index) {
                      return makeRow(
                          context, index, (index == _indexMain && index > 0));
                    }),
              ),
              Divider(
                thickness: 1,
                color: Theme.of(context).primaryColor,
              ),
              Spacer(
                flex: ScalingTime.listVerticalFlex[0],
              ),
              Expanded(
                flex: ScalingTime.listVerticalFlex[4],
                child: Container(
                  width:
                      MediaQuery.of(context).size.width * ScalingTime.fractionWidthCompute,
                  decoration: BoxDecoration(
                    color: Theme.of(context).textTheme.headline2!.color,
                    borderRadius: BorderRadius.circular(ScalingTime.radiusBorderAlert),
                  ),
                  child: TextButton(
                    child: Text(
                      'Compute',
                      style: TextStyle(
                          fontSize:
                              Theme.of(context).textTheme.headline2!.fontSize,
                          fontWeight:
                              Theme.of(context).textTheme.headline2!.fontWeight,
                          color: Theme.of(context).scaffoldBackgroundColor),
                    ),
                    onPressed: () {
                      bool isTwoPlus = listCtrl.length > 1;
                      if (isValidEntries(listCtrl) &&
                          isTwoPlus &&
                          checkNoDuplicateDates(listDateTime)) {
                        Map<DateTime, String> mapSortedData =
                            sortByDateTime(listDateTime, listCtrl);
                        Navigator.pushNamed(context, '/scaling-time-plot-app',
                            arguments: [
                              mapSortedData.keys.toList(),
                              mapSortedData.values.toList(),
                            ]);
                      } else if (!isTwoPlus) {
                        showDialogMessage(
                            context,
                            ScalingTime.fractionWidthAlert,
                            ScalingTime.fractionHeightAlert,
                            ScalingTime.widthBorderAlert,
                            ScalingTime.radiusBorderAlert,
                            'Error: Two or more entries are required');
                      } else if (!checkNoDuplicateDates(listDateTime)) {
                        showDialogMessage(
                            context,
                            ScalingTime.fractionWidthAlert,
                            ScalingTime.fractionHeightAlert,
                            ScalingTime.widthBorderAlert,
                            ScalingTime.radiusBorderAlert,
                            'Error: Duplicated dates present');
                      } else {
                        showDialogMessage(
                            context,
                            ScalingTime.fractionWidthAlert,
                            ScalingTime.fractionHeightAlert,
                            ScalingTime.widthBorderAlert,
                            ScalingTime.radiusBorderAlert,
                            'Error: Invalid value field');
                      }
                    },
                  ),
                ),
              ),
              Spacer(
                flex: ScalingTime.listVerticalFlex[0],
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.blue,
            child: Icon(
              Icons.add,
              size: Theme.of(context).textTheme.headline2!.fontSize,
            ),
            onPressed: () {
              setState(() {
                if (isValidEntries(listCtrl) &&
                    checkNoDuplicateDates(listDateTime)) {
                  _indexMain < (ScalingTime.maxMainIndex - 1)
                      ? _indexMain += 1
                      : _indexMain += 0;
                } else if (!checkNoDuplicateDates(listDateTime)) {
                  showDialogMessage(
                      context,
                      ScalingTime.fractionWidthAlert,
                      ScalingTime.fractionHeightAlert,
                      ScalingTime.widthBorderAlert,
                      ScalingTime.radiusBorderAlert,
                      'Error: Duplicated dates present');
                } else {
                  showDialogMessage(
                      context,
                      ScalingTime.fractionWidthAlert,
                      ScalingTime.fractionHeightAlert,
                      ScalingTime.widthBorderAlert,
                      ScalingTime.radiusBorderAlert,
                      'Error: Invalid value field');
                }
              });
            },
          ),
          floatingActionButtonLocation: _indexMain < (ScalingTime.indexMainThreshold - 1)
              ? FloatingActionButtonLocation.endFloat
              : FloatingActionButtonLocation.endTop,
        ),
      );
    } else {
      return Scaffold();
    }
  }
}

bool isValidEntries(List<TextEditingController> listCtrl) {
  return (!listCtrl.any((element) => !textFieldDoubleValidation(
      strN: element.text,
      allowBlank: false,
      allowNegative: false,
      allowZero: true,
      allowDecimal: true,
      maxValue: ScalingTime.maxValue,
      minValue: 0,
      maxDigitsPreDecimal: 4,
      maxDigitsPostDecimal: 4)));
}

bool checkNoDuplicateDates(List<DateTime> listDatetime) {
  bool isValid = true;
  for (int i = 0; i < listDatetime.length; i++) {
    isValid = listDatetime.lastIndexOf(listDatetime[i]) == i
        ? (isValid && true)
        : false;
  }
  return isValid;
}

Map<DateTime, String> sortByDateTime(
    List<DateTime> listDatetime, List<TextEditingController> listController) {
  Map<DateTime, String> mapInput = {};
  int i = 0;
  listDatetime.forEach((element) {
    mapInput.addAll({element: listController[i].text});
    i++;
  });
  SplayTreeMap mapSplay = SplayTreeMap();
  mapSplay.addAll(mapInput);
  List<DateTime> listDateTimeOut = List<DateTime>.from(mapSplay.keys.toList());
  List<String> listStrOut = List<String>.from(mapSplay.values.toList());
  Map<DateTime, String> mapOut = {};
  i = 0;
  listDateTimeOut.forEach((element) {
    mapOut.addAll({element: listStrOut[i]});
    i++;
  });
  return mapOut;
}

void showDialogMessage(
    BuildContext context,
    double fractionWidthAlert,
    double fractionHeightAlert,
    double widthBorderAlert,
    double radiusBorderAlert,
    String message) {
  showDialog(
      builder: (context) {
        return Center(
          child: Container(
            width: MediaQuery.of(context).size.width * fractionWidthAlert,
            height: MediaQuery.of(context).size.height * fractionHeightAlert,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              border: Border.all(
                  color: Theme.of(context).primaryColor,
                  width: widthBorderAlert),
              borderRadius: BorderRadius.circular(radiusBorderAlert),
            ),
            child: Text(
              message,
              style: Theme.of(context).textTheme.headline2,
              textAlign: TextAlign.center,
            ),
          ),
        );
      },
      context: context);
}

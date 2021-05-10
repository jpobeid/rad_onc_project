import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rad_onc_project/widgets/rad_app_bar.dart';
import 'package:rad_onc_project/data/curve_data.dart' as curves;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rad_onc_project/data/main_data.dart' as datas;

class CurveSettings extends StatefulWidget {
  static const String routeName = '/settings-curve';

  const CurveSettings({Key key}) : super(key: key);

  static const List<int> listFlexColumn = [1, 1, 8, 1];
  static const List<int> listFlexRow = [1, 3, 3, 1];

  @override
  _CurveSettingsState createState() => _CurveSettingsState();
}

class _CurveSettingsState extends State<CurveSettings> {
  bool _isEditing = false;
  int _nDropdown = 0;
  Map<String, dynamic> _mapCurve;
  List<TextEditingController> _listControllerDepth = [];
  List<TextEditingController> _listControllerDose = [];
  List<List<double>> _listEditedHistory = [];

  void clearControllers() {
    _listEditedHistory.clear();
    _listControllerDepth.clear();
    _listControllerDose.clear();
  }

  List<bool> checkNewLists(List<double> listNewDepth, List<double> listNewDose) {
    List<bool> areCleared = [true, true];
    for (int i = 0; i < listNewDepth.length - 1; i++) {
      areCleared[0] = areCleared[0] && (listNewDepth[i + 1] > listNewDepth[i]);
    }
    areCleared[0] = areCleared[0] && !listNewDepth.any((element) => element < 0);
    areCleared[1] = areCleared[1] &&
        !listNewDose.any((element) => element > 100) &&
        !listNewDose.any((element) => element < 0);
    return areCleared;
  }

  void revertEditHistory(String strSelectedCurveName) {
    _listEditedHistory.reversed.forEach((element) {
      if (element.first.toInt() == 1) {
        _mapCurve[strSelectedCurveName][0].removeAt(element[1].toInt());
        _mapCurve[strSelectedCurveName][1].removeAt(element[1].toInt());
      } else {
        _mapCurve[strSelectedCurveName][0].insert(element[1].toInt(), element[2]);
        _mapCurve[strSelectedCurveName][1].insert(element[1].toInt(), element[3]);
      }
    });
  }

  @override
  void initState() {
    initPreferences();
    super.initState();
  }

  Future<void> initPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      if (prefs.get('mapCurve') == null) {
        _mapCurve = curves.mapDefaultCurve;
      } else {
        _mapCurve = json.decode(prefs.getString('mapCurve'));
      }
    });
  }

  @override
  void dispose() {
    _listControllerDepth.forEach((element) {
      element.dispose();
    });
    _listControllerDose.forEach((element) {
      element.dispose();
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_mapCurve != null) {
      String strSelectedCurveName = curves.listCurveName[_nDropdown];
      String strUnitDepth = strSelectedCurveName.endsWith('X') ? 'cm' : 'mm';
      if (_isEditing && _listControllerDepth.isEmpty && _listControllerDose.isEmpty) {
        _mapCurve[strSelectedCurveName][0].forEach((element) {
          _listControllerDepth.add(TextEditingController(text: element.toString()));
        });
        _mapCurve[strSelectedCurveName][1].forEach((element) {
          _listControllerDose.add(TextEditingController(text: element.toString()));
        });
      }

      return SafeArea(
        child: Scaffold(
          appBar: RadAppBar(
            strAppTitle: datas.mapAppNames[3][0],
          ),
          body: Column(
            children: [
              Expanded(
                flex: CurveSettings.listFlexColumn[0],
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      'Curve:',
                      style: Theme.of(context).textTheme.headline1,
                    ),
                    IgnorePointer(
                      ignoring: _isEditing,
                      child: DropdownButton(
                        value: _nDropdown,
                        dropdownColor: Colors.blueGrey,
                        items: curves.listCurveName
                            .map(
                              (e) => DropdownMenuItem(
                            value: curves.listCurveName.indexOf(e),
                            child: Text(
                              e,
                              style: Theme.of(context).textTheme.headline1,
                            ),
                          ),
                        )
                            .toList(),
                        onChanged: (index) {
                          setState(() {
                            _nDropdown = index;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: CurveSettings.listFlexColumn[1],
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      flex: CurveSettings.listFlexRow[0],
                      child: Text(
                        'N',
                        style: Theme.of(context).textTheme.headline1,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Expanded(
                      flex: CurveSettings.listFlexRow[1],
                      child: Text(
                        'Depth ($strUnitDepth)',
                        style: Theme.of(context).textTheme.headline1,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Expanded(
                      flex: CurveSettings.listFlexRow[2],
                      child: Text(
                        'Dose (%)',
                        style: Theme.of(context).textTheme.headline1,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Expanded(
                      flex: CurveSettings.listFlexRow[3],
                      child: _isEditing
                          ? IconButton(
                        icon: Icon(Icons.add),
                        color: Theme.of(context).textTheme.headline1.color,
                        onPressed: () {
                          setState(() {
                            double addDepthIncrement = 0.1;
                            double addDoseIncrement = 0;
                            double addedDepth = double.parse(
                                (_mapCurve[strSelectedCurveName][0].last + addDepthIncrement)
                                    .toStringAsFixed(1));
                            double addedDose = double.parse(
                                (_mapCurve[strSelectedCurveName][1].last + addDoseIncrement)
                                    .toStringAsFixed(1));
                            _mapCurve[strSelectedCurveName][0].add(addedDepth);
                            _mapCurve[strSelectedCurveName][1].add(addedDose);
                            _listControllerDepth
                                .add(TextEditingController(text: addedDepth.toString()));
                            _listControllerDose
                                .add(TextEditingController(text: addedDose.toString()));
                            _listEditedHistory.add([
                              1,
                              (_mapCurve[strSelectedCurveName][0].length - 1).toDouble(),
                              addedDepth,
                              addedDose
                            ]);
                          });
                        },
                      )
                          : IconButton(
                        icon: Icon(Icons.edit),
                        color: Theme.of(context).textTheme.headline1.color,
                        onPressed: () {
                          setState(() {
                            _isEditing = true;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Divider(
                color: Theme.of(context).primaryColor,
              ),
              Expanded(
                flex: CurveSettings.listFlexColumn[2],
                child: ListView.builder(
                    itemCount: _mapCurve[strSelectedCurveName][0].length,
                    itemBuilder: (context, index) {
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Expanded(
                            flex: CurveSettings.listFlexRow[0],
                            child: Text(
                              '${index + 1}',
                              style: Theme.of(context).textTheme.headline1,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Expanded(
                            flex: CurveSettings.listFlexRow[1],
                            child: _isEditing
                                ? TextField(
                              decoration: InputDecoration(
                                  isDense: true, contentPadding: EdgeInsets.zero),
                              keyboardType: TextInputType.number,
                              maxLength: 4,
                              style: Theme.of(context).textTheme.headline1,
                              textAlign: TextAlign.center,
                              controller: _listControllerDepth[index],
                            )
                                : Text(
                              '${_mapCurve[strSelectedCurveName][0][index]}',
                              style: Theme.of(context).textTheme.headline1,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Expanded(
                            flex: CurveSettings.listFlexRow[2],
                            child: _isEditing
                                ? TextField(
                              decoration: InputDecoration(
                                  isDense: true, contentPadding: EdgeInsets.zero),
                              keyboardType: TextInputType.number,
                              maxLength: 5,
                              style: Theme.of(context).textTheme.headline1,
                              textAlign: TextAlign.center,
                              controller: _listControllerDose[index],
                            )
                                : Text(
                              '${_mapCurve[strSelectedCurveName][1][index]}',
                              style: Theme.of(context).textTheme.headline1,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Expanded(
                            flex: CurveSettings.listFlexRow[3],
                            child: _isEditing
                                ? IconButton(
                              icon: Icon(
                                Icons.cancel_outlined,
                                color: Theme.of(context).textTheme.headline1.color,
                              ),
                              onPressed: () {
                                _listEditedHistory.add([
                                  -1,
                                  index.toDouble(),
                                  double.parse(_listControllerDepth[index].text),
                                  double.parse(_listControllerDose[index].text)
                                ]);
                                setState(() {
                                  _listControllerDepth.removeAt(index);
                                  _listControllerDose.removeAt(index);
                                  _mapCurve[strSelectedCurveName][0].removeAt(index);
                                  _mapCurve[strSelectedCurveName][1].removeAt(index);
                                });
                              },
                              padding: EdgeInsets.zero,
                              alignment: Alignment.topCenter,
                            )
                                : Container(),
                          ),
                        ],
                      );
                    }),
              ),
              Divider(
                color: Theme.of(context).primaryColor,
              ),
              Expanded(
                flex: CurveSettings.listFlexColumn[3],
                child: _isEditing
                    ? Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        child: Text(
                          'Save',
                          style: TextStyle(
                              fontSize: Theme.of(context).textTheme.headline1.fontSize),
                        ),
                        onPressed: () async {
                          List<double> listNewDepth;
                          List<double> listNewDose;
                          try {
                            listNewDepth = _listControllerDepth
                                .map((e) => double.parse(e.text))
                                .toList();
                            listNewDose =
                                _listControllerDose.map((e) => double.parse(e.text)).toList();
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text('Invalid series'),
                              backgroundColor: Colors.red,
                            ));
                          }
                          List<bool> areCleared = checkNewLists(listNewDepth, listNewDose);
                          if (areCleared[0] && areCleared[1]) {
                            _mapCurve[strSelectedCurveName][0] = listNewDepth;
                            _mapCurve[strSelectedCurveName][1] = listNewDose;
                            SharedPreferences prefs = await SharedPreferences.getInstance();
                            prefs.setString('mapCurve', json.encode(_mapCurve));
                            setState(() {
                              clearControllers();
                              _isEditing = false;
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text('Successful save!'),
                                backgroundColor: Colors.green,
                              ));
                            });
                          } else if (!areCleared[0]) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text('Invalid depth series'),
                              backgroundColor: Colors.red,
                            ));
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text('Invalid dose series'),
                              backgroundColor: Colors.red,
                            ));
                          }
                        },
                      ),
                    ),
                    Expanded(
                      child: TextButton(
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                              fontSize: Theme.of(context).textTheme.headline1.fontSize),
                        ),
                        onPressed: () {
                          setState(() {
                            //Revert the edited history...
                            revertEditHistory(strSelectedCurveName);
                            clearControllers();
                            _isEditing = false;
                          });
                        },
                      ),
                    ),
                  ],
                )
                    : Container(),
              ),
            ],
          ),
        ),
      );
    } else {
      return Container();
    }
  }
}
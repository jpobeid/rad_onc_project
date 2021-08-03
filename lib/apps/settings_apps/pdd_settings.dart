import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:rad_onc_project/widgets/rad_app_bar.dart';
import 'package:rad_onc_project/data/particle_data.dart' as particles;
import 'package:rad_onc_project/widgets/text_fields.dart' as fields;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rad_onc_project/functions/preferences_functions.dart'
    as funcPrefs;

class PddSettings extends StatefulWidget {
  static const routeName = '/settings-pdd-app';

  const PddSettings({Key? key}) : super(key: key);

  static const List<int> listColumnFlex = [1, 8];
  static const Map<int, FlexColumnWidth> mapColumnWidthFlex = {
    0: FlexColumnWidth(3),
    1: FlexColumnWidth(3),
    2: FlexColumnWidth(1)
  };
  static const double sizeIcon = 32;
  static const int maxTableRows = 40;
  static const int minTableRows = 10;
  static const int nSnackDuration = 600;

  @override
  _PddSettingsState createState() => _PddSettingsState();
}

class _PddSettingsState extends State<PddSettings> {
  Map<String, List<double>> _mapDepth = {};
  Map<String, Map<int, List<double>>> _mapPdd = {};
  int _iParticle = 0;
  int _iFieldSize = 0;
  bool _isEditing = false;
  List<TextEditingController> _listControllerDepth = [];
  List<TextEditingController> _listControllerPdd = [];
  List<TableRow> _listTableRows = [];
  bool _toRebuildTable = true;

  Future<void> readPreferences() async {
    List<Map> results = await funcPrefs.readPreferences();
    _mapDepth = Map<String, List<double>>.from(results[0]);
    _mapPdd = Map<String, Map<int, List<double>>>.from(results[1]);
    setState(() {});
  }

  Future<void> writePreferences(String strParticle, int nSize,
      List<String> listStrDepth, List<String> listStrPdd) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList('depth' + strParticle, listStrDepth);
    prefs.setStringList(
        'pdd' + strParticle + '-' + nSize.toString(), listStrPdd);
  }

  @override
  void initState() {
    readPreferences();
    super.initState();
  }

  IconButton deleteButton() {
    return IconButton(
      padding: EdgeInsets.all(0),
      alignment: Alignment.topCenter,
      icon: Icon(
        Icons.clear,
        color: Colors.white,
      ),
      onPressed: () {
        if (_listTableRows.length > PddSettings.minTableRows) {
          setState(() {
            _toRebuildTable = false;
            _listControllerDepth.remove(_listControllerDepth.last);
            _listControllerPdd.remove(_listControllerPdd.last);
            _listTableRows.remove(_listTableRows.last);
            _listTableRows.last = TableRow(
              children: [
                fields.textFieldSetting(context, _listControllerDepth.last),
                fields.textFieldSetting(context, _listControllerPdd.last),
                deleteButton(),
              ],
            );
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              duration: Duration(milliseconds: PddSettings.nSnackDuration),
              content: Text(
                'Too few rows!',
                style: Theme.of(context).textTheme.headline1,
              )));
        }
      },
    );
  }

  void buildTable(String strParticle, int nSize) {
    Map<double, double> mapParticle = Map.fromIterables(
        _mapDepth[strParticle]!, _mapPdd[strParticle]![nSize]!);
    _listTableRows = [
      TableRow(
        children: [
          Text(
            'Depth [${strParticle[strParticle.length - 1] == 'X' ? 'cm' : 'mm'}]',
            style: Theme.of(context).textTheme.headline1,
            textAlign: TextAlign.center,
          ),
          Text(
            'PDD [%]',
            style: Theme.of(context).textTheme.headline1,
            textAlign: TextAlign.center,
          ),
          Container(),
        ],
      )
    ];
    mapParticle.forEach((key, value) {
      if (!_isEditing) {
        _listTableRows.add(
          TableRow(
            children: [
              Text(
                key.toString(),
                style: Theme.of(context).textTheme.headline1,
                textAlign: TextAlign.center,
              ),
              Text(
                value.toString(),
                style: Theme.of(context).textTheme.headline1,
                textAlign: TextAlign.center,
              ),
              Container(),
            ],
          ),
        );
      } else {
        _listControllerDepth.add(TextEditingController(text: key.toString()));
        _listControllerPdd.add(TextEditingController(text: value.toString()));
        _listTableRows.add(TableRow(
          children: [
            fields.textFieldSetting(context, _listControllerDepth.last),
            fields.textFieldSetting(context, _listControllerPdd.last),
            key == mapParticle.keys.last ? deleteButton() : Container(),
          ],
        ));
      }
    });
  }

  void resetTable() {
    _listTableRows.clear();
    _listControllerDepth.clear();
    _listControllerPdd.clear();
  }

  @override
  Widget build(BuildContext context) {
    if (_mapPdd['6X'] != null) {}
    bool canBuild = _mapDepth.isNotEmpty && _mapPdd.isNotEmpty;
    if (canBuild) {
      String strParticle = particles.listStrParticle[_iParticle];
      List<int> listSizes = _mapPdd[strParticle]!.keys.toList();
      int nSize = listSizes[_iFieldSize];
      if (_toRebuildTable) {
        buildTable(strParticle, nSize);
      } else {
        _toRebuildTable = true;
      }

      return SafeArea(
        child: Scaffold(
          appBar: RadAppBar(
            strAppTitle: 'PDD Settings',
          ),
          body: Column(
            children: [
              Expanded(
                flex: PddSettings.listColumnFlex[0],
                child: Row(
                  children: [
                    Expanded(
                      child: IgnorePointer(
                        ignoring: _isEditing,
                        child: DropdownButton(
                          value: _iParticle,
                          dropdownColor: Colors.blueGrey,
                          items: particles.listStrParticle
                              .map(
                                (e) => DropdownMenuItem(
                                  value: particles.listStrParticle.indexOf(e),
                                  child: Text(
                                    e,
                                    style:
                                        Theme.of(context).textTheme.headline1,
                                  ),
                                ),
                              )
                              .toList(),
                          onChanged: (num? index) {
                            setState(() {
                              _iParticle = index!.toInt();
                              _iFieldSize = 0;
                            });
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      child: IgnorePointer(
                        ignoring: _isEditing,
                        child: DropdownButton(
                          value: _iFieldSize,
                          dropdownColor: Colors.blueGrey,
                          items: particles.mapDefaultPdd[strParticle]!.keys
                              .toList()
                              .map(
                                (e) => DropdownMenuItem(
                                  value: particles
                                      .mapDefaultPdd[strParticle]!.keys
                                      .toList()
                                      .indexOf(e),
                                  child: Text(
                                    e.toString(),
                                    style:
                                        Theme.of(context).textTheme.headline1,
                                  ),
                                ),
                              )
                              .toList(),
                          onChanged: (int? index) {
                            setState(() {
                              _iFieldSize = index!.toInt();
                            });
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      child: IconButton(
                        onPressed: () {
                          if (_isEditing) {
                            bool canSubmit = checkCanSubmit(
                                _listControllerDepth, _listControllerPdd);
                            if (canSubmit) {
                              writePreferences(
                                  strParticle,
                                  nSize,
                                  _listControllerDepth
                                      .map((e) => e.text)
                                      .toList(),
                                  _listControllerPdd
                                      .map((e) => e.text)
                                      .toList());
                              resetTable();
                              _isEditing = !_isEditing;
                              readPreferences();
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      duration: Duration(
                                          milliseconds:
                                              PddSettings.nSnackDuration),
                                      content: Text(
                                        'Successfully saved values',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline1,
                                      )));
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      duration: Duration(
                                          milliseconds:
                                              PddSettings.nSnackDuration),
                                      content: Text(
                                        'Invalid inputs...',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline1,
                                      )));
                            }
                          } else {
                            setState(() {
                              _isEditing = !_isEditing;
                            });
                          }
                        },
                        icon: Icon(
                          _isEditing ? Icons.check_circle_outline : Icons.edit,
                          color: Colors.white,
                          size: PddSettings.sizeIcon,
                        ),
                      ),
                    ),
                    Expanded(
                      child: _isEditing
                          ? IconButton(
                              onPressed: () {
                                setState(() {
                                  resetTable();
                                  _isEditing = !_isEditing;
                                });
                              },
                              icon: Icon(
                                Icons.cancel_outlined,
                                color: Colors.white,
                                size: PddSettings.sizeIcon,
                              ),
                            )
                          : IconButton(
                              onPressed: () async {
                                bool? result = await showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: Text(
                                            'Reset $strParticle defaults?'),
                                        actions: [
                                          TextButton(
                                              onPressed: () =>
                                                  Navigator.of(context)
                                                      .pop(true),
                                              child: Text('Yes')),
                                          TextButton(
                                              onPressed: () =>
                                                  Navigator.of(context)
                                                      .pop(false),
                                              child: Text('No')),
                                        ],
                                      );
                                    });
                                if (result != null && result) {
                                  writePreferences(
                                      strParticle,
                                      nSize,
                                      particles.mapDefaultDepth[strParticle]!
                                          .map((e) => e.toString())
                                          .toList(),
                                      particles
                                          .mapDefaultPdd[strParticle]![nSize]!
                                          .map((e) => e.toString())
                                          .toList());
                                  readPreferences();
                                }
                              },
                              icon: Icon(
                                Icons.restore_outlined,
                                color: Colors.white,
                                size: PddSettings.sizeIcon,
                              ),
                            ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: PddSettings.listColumnFlex[1],
                child: ListView(
                  children: [
                    Table(
                      defaultVerticalAlignment: TableCellVerticalAlignment.top,
                      columnWidths: PddSettings.mapColumnWidthFlex,
                      children: _listTableRows,
                    ),
                  ],
                ),
              ),
            ],
          ),
          floatingActionButton: _isEditing
              ? FloatingActionButton(
                  backgroundColor: Colors.blue,
                  child: Icon(
                    Icons.add,
                    size: PddSettings.sizeIcon,
                  ),
                  onPressed: () {
                    if (_listTableRows.length < PddSettings.maxTableRows) {
                      setState(() {
                        _toRebuildTable = false;
                        _listTableRows.last = TableRow(
                          children: [
                            fields.textFieldSetting(
                                context, _listControllerDepth.last),
                            fields.textFieldSetting(
                                context, _listControllerPdd.last),
                            Container(),
                          ],
                        );
                        _listControllerDepth
                            .add(TextEditingController(text: '0'));
                        _listControllerPdd
                            .add(TextEditingController(text: '0'));
                        _listTableRows.add(TableRow(
                          children: [
                            fields.textFieldSetting(
                                context, _listControllerDepth.last),
                            fields.textFieldSetting(
                                context, _listControllerPdd.last),
                            deleteButton(),
                          ],
                        ));
                      });
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          duration: Duration(
                              milliseconds: PddSettings.nSnackDuration),
                          content: Text(
                            'Too many rows!',
                            style: Theme.of(context).textTheme.headline1,
                          )));
                    }
                  },
                )
              : Container(),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
        ),
      );
    } else {
      return Container();
    }
  }
}

bool checkCanSubmit(List<TextEditingController> listControllerDepth,
    List<TextEditingController> listControllerPdd) {
  List<double> listDepths;
  List<double> listPdds;
  try {
    listDepths = listControllerDepth.map((e) => double.parse(e.text)).toList();
    listPdds = listControllerPdd.map((e) => double.parse(e.text)).toList();
  } catch (e) {
    return false;
  }
  bool isInvalidDepth = listDepths.any((element) => element > 100) ||
      listDepths.any((element) => element < 0);
  List<double> listDepths2 = List.from(listDepths);
  listDepths2.sort();
  bool isDepthIncreasing = listDepths.every(
      (element) => listDepths.indexOf(element) == listDepths2.indexOf(element));
  bool isInvalidPdd = listPdds.any((element) => element > 100) ||
      listPdds.any((element) => element < 0);
  return !isInvalidDepth && !isInvalidPdd && isDepthIncreasing;
}

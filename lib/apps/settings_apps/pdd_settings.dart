import 'package:flutter/material.dart';
import 'package:rad_onc_project/data/particle_data.dart' as particles;
import 'package:rad_onc_project/functions/preferences_functions.dart'
    as funcPrefs;
import 'package:rad_onc_project/widgets/rad_app_bar.dart';
import 'package:rad_onc_project/widgets/text_fields.dart' as fields;
import 'package:collection/collection.dart' as collects;
import 'package:shared_preferences/shared_preferences.dart';

class PddSettings extends StatefulWidget {
  static const routeName = '/settings-pdd-app';

  const PddSettings({Key? key}) : super(key: key);

  static const List<int> listColumnFlex = [1, 7, 1];
  static const Map<int, FlexColumnWidth> mapColumnWidthFlex = {
    0: FlexColumnWidth(3),
    1: FlexColumnWidth(3),
    2: FlexColumnWidth(1)
  };
  static const double sizeIcon = 32;
  static const double sizeThicknessDivider = 2;
  static const int maxTableRows = 40;
  static const int minTableRows = 10;
  static const int nSnackDuration = 600;

  @override
  _PddSettingsState createState() => _PddSettingsState();
}

class _PddSettingsState extends State<PddSettings> {
  Map<String, Map<String, List<double>>> _mapPdd = {};
  int _iParticle = 0;
  int _iFieldSize = 0;
  bool _isEditing = false;
  List<TextEditingController> _listControllerDepth = [];
  List<TextEditingController> _listControllerPdd = [];
  List<TableRow> _listTableRows = [];
  bool _toRebuildTable = true;

  Future<void> readPreferences() async {
    _mapPdd = await funcPrefs.readPreferences(context);
    setState(() {});
  }

  Future<void> writePreferences(String strParticle, String fieldUnitFull,
      List<String> listDepths, List<String> listValues) async {
    String fieldSizeN = fieldUnitFull.split('-')[0];
    String depthUnits = fieldUnitFull.split('-')[1];
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String preferenceKeyDepths = funcPrefs
        .makePreferenceKey(strParticle, fieldSizeN, [true, depthUnits]);
    String preferenceKeyValues = funcPrefs
        .makePreferenceKey(strParticle, fieldSizeN, [false, depthUnits]);
    prefs.setStringList(preferenceKeyDepths, listDepths);
    prefs.setStringList(preferenceKeyValues, listValues);
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
                fields.textFieldStandard(
                    context, _listControllerDepth.last, false),
                fields.textFieldStandard(
                    context, _listControllerPdd.last, false),
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

  void buildTable(String strParticle, String depthUnit,
      List<double> activeDepths, List<double> activeValues) {
    Map<double, double> mapParticle =
        Map.fromIterables(activeDepths, activeValues);
    _listTableRows = [
      TableRow(
        children: [
          Text(
            'Depth' + ' [$depthUnit]',
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
            fields.textFieldStandard(context, _listControllerDepth.last, false),
            fields.textFieldStandard(context, _listControllerPdd.last, false),
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
    bool canBuild = _mapPdd.isNotEmpty;
    if (canBuild) {
      String strParticle = particles.listStrParticle[_iParticle];
      List<dynamic> pddParameters =
          funcPrefs.getPddParameters(_mapPdd, strParticle, _iFieldSize);
      List<String> listFieldsUnits = pddParameters[0];
      String fieldUnitFull = pddParameters[1][0];
      String fieldSizeN = pddParameters[1][1];
      String depthUnit = pddParameters[1][2];
      List<double> activeDepths = pddParameters[2];
      List<double> activeValues = pddParameters[3];
      if (_toRebuildTable) {
        buildTable(strParticle, depthUnit, activeDepths, activeValues);
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
                                        Theme.of(context).textTheme.headline2,
                                  ),
                                ),
                              )
                              .toList(),
                          onChanged: (int? index) {
                            setState(() {
                              _iParticle = index!;
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
                          items: listFieldsUnits
                              .map(
                                (e) => DropdownMenuItem(
                                  value: listFieldsUnits.indexOf(e),
                                  child: Text(
                                    e.split('-')[0] + ' cm',
                                    style:
                                        Theme.of(context).textTheme.headline2,
                                  ),
                                ),
                              )
                              .toList(),
                          onChanged: (int? index) {
                            setState(() {
                              _iFieldSize = index!;
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Divider(
                color: Theme.of(context).primaryColor,
                thickness: PddSettings.sizeThicknessDivider,
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
              Divider(
                color: Theme.of(context).primaryColor,
                thickness: PddSettings.sizeThicknessDivider,
              ),
              Expanded(
                flex: PddSettings.listColumnFlex[2],
                child: Row(
                  children: [
                    Expanded(
                      child: IconButton(
                        onPressed: () {
                          if (_isEditing) {
                            bool canSubmit = checkCanSubmit(
                                _listControllerDepth, _listControllerPdd);
                            if (canSubmit) {
                              writePreferences(
                                  strParticle,
                                  fieldUnitFull,
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
                          color: Colors.green,
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
                                color: Colors.red,
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
                                            'Reset $strParticle ($fieldSizeN cm) defaults?'),
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
                                  //To reset/write defaults
                                  Map<String, Map<String, List<double?>>>
                                      mapPddDefault =
                                      await funcPrefs.loadDefaults(context);
                                  List<String> mapKeys =
                                      mapPddDefault[strParticle]!.keys.toList();
                                  String keyDepth =
                                      mapKeys[particles.indexKeyDepth];
                                  List<double?> listDepths =
                                      mapPddDefault[strParticle]![keyDepth]!
                                          .map((e) => e)
                                          .toList();
                                  List<double?> listValues =
                                      mapPddDefault[strParticle]![fieldSizeN]!
                                          .map((e) => e)
                                          .toList();
                                  List<List<double>> filteredLists =
                                      funcPrefs.filterLists(
                                          List<double?>.from(listDepths),
                                          List<double?>.from(listValues));
                                  writePreferences(
                                      strParticle,
                                      fieldUnitFull,
                                      filteredLists[0]
                                          .map((e) => e.toString())
                                          .toList(),
                                      filteredLists[1]
                                          .map((e) => e.toString())
                                          .toList());
                                  readPreferences();
                                }
                              },
                              icon: Icon(
                                Icons.restore_outlined,
                                color: Colors.orange,
                                size: PddSettings.sizeIcon,
                              ),
                            ),
                    ),
                  ],
                ),
              )
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
                            fields.textFieldStandard(
                                context, _listControllerDepth.last, false),
                            fields.textFieldStandard(
                                context, _listControllerPdd.last, false),
                            Container(),
                          ],
                        );
                        _listControllerDepth
                            .add(TextEditingController(text: '0'));
                        _listControllerPdd
                            .add(TextEditingController(text: '0'));
                        _listTableRows.add(TableRow(
                          children: [
                            fields.textFieldStandard(
                                context, _listControllerDepth.last, false),
                            fields.textFieldStandard(
                                context, _listControllerPdd.last, false),
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
  double minDepth = 0;
  double maxDepth = 100;
  double minPdd = 0;
  double maxPdd = 100;
  List<double> listDepths;
  List<double> listPdds;
  try {
    listDepths = listControllerDepth.map((e) => double.parse(e.text)).toList();
    listPdds = listControllerPdd.map((e) => double.parse(e.text)).toList();
  } catch (e) {
    return false;
  }
  bool isInvalidDepth = listDepths.any((element) => element > maxDepth) ||
      listDepths.any((element) => element < minDepth);
  List<double> listDepths2 = List.from(listDepths);
  listDepths2.sort();
  bool isDepthIncreasing =
      collects.ListEquality().equals(listDepths, listDepths2);
  bool isInvalidPdd = listPdds.any((element) => element > maxPdd) ||
      listPdds.any((element) => element < minPdd);
  return !isInvalidDepth && !isInvalidPdd && isDepthIncreasing;
}

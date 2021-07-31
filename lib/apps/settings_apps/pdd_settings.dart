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
  static const double sizeIcon = 32;

  @override
  _PddSettingsState createState() => _PddSettingsState();
}

class _PddSettingsState extends State<PddSettings> {
  late SharedPreferences _prefs;
  Map<String, List<double>> _mapDepth = {};
  Map<String, List<double>> _mapPdd = {};
  Object? _nParticle = 0;
  bool _isEditing = false;
  List<TextEditingController> _listControllerDepth = [];
  List<TextEditingController> _listControllerPdd = [];

  Future<void> readPreferences() async {
    List<Map<String, List<double>>> results = await funcPrefs.readPreferences();
    _mapDepth = results[0];
    _mapPdd = results[1];
    setState(() {});
  }

  Future<void> writePreferences(String strParticle, List<String> listStrDepth,
      List<String> listStrPdd) async {
    _prefs = await SharedPreferences.getInstance();
    _prefs.setStringList('depth' + strParticle, listStrDepth);
    _prefs.setStringList('pdd' + strParticle, listStrPdd);
  }

  @override
  void initState() {
    readPreferences();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool canBuild = _mapDepth.isNotEmpty && _mapPdd.isNotEmpty;
    if (canBuild) {
      Map<double, double> mapParticle = Map.fromIterables(
          _mapDepth[particles.listStrParticle[_nParticle.hashCode]]!,
          _mapPdd[particles.listStrParticle[_nParticle.hashCode]]!);
      List<TableRow> listTableRows = [];
      mapParticle.forEach((key, value) {
        if (!_isEditing) {
          listTableRows.add(TableRow(
            children: [
              Text(
                key.toString(),
                style: Theme.of(context).textTheme.headline1,
              ),
              Text(
                value.toString(),
                style: Theme.of(context).textTheme.headline1,
              ),
            ],
          ));
        } else {
          _listControllerDepth.add(TextEditingController(text: key.toString()));
          _listControllerPdd.add(TextEditingController(text: value.toString()));
          listTableRows.add(TableRow(
            children: [
              fields.textFieldSetting(context, _listControllerDepth.last),
              fields.textFieldSetting(context, _listControllerPdd.last),
            ],
          ));
        }
      });

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
                          value: _nParticle,
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
                          onChanged: (index) {
                            setState(() {
                              _nParticle = index;
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
                                  particles
                                      .listStrParticle[_nParticle.hashCode],
                                  _listControllerDepth
                                      .map((e) => e.text)
                                      .toList(),
                                  _listControllerPdd
                                      .map((e) => e.text)
                                      .toList());
                              _listControllerDepth.clear();
                              _listControllerPdd.clear();
                              _isEditing = !_isEditing;
                              readPreferences();
                            } else {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                      content: Text(
                                'Invalid inputs...',
                                style: Theme.of(context).textTheme.headline1,
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
                                _listControllerDepth.clear();
                                _listControllerPdd.clear();
                                setState(() {
                                  _isEditing = !_isEditing;
                                });
                              },
                              icon: Icon(
                                Icons.cancel_outlined,
                                color: Colors.white,
                                size: PddSettings.sizeIcon,
                              ),
                            )
                          : Container(),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: PddSettings.listColumnFlex[1],
                child: ListView(
                  children: [
                    Table(
                      children: listTableRows,
                    ),
                  ],
                ),
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
  bool isInvalidPdd = listPdds.any((element) => element > 100) ||
      listPdds.any((element) => element < 0);
  return !isInvalidDepth && !isInvalidPdd;
}

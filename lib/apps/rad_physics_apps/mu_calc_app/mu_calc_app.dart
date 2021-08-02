import 'package:flutter/material.dart';
import 'package:rad_onc_project/widgets/rad_app_bar.dart';
import 'package:rad_onc_project/data/global_data.dart' as datas;
import 'package:rad_onc_project/widgets/text_fields.dart' as fields;
import 'package:rad_onc_project/data/particle_data.dart' as particles;
import 'package:rad_onc_project/widgets/rad_toggle_button.dart';
import 'package:rad_onc_project/functions/spline_functions.dart' as splines;
import 'package:rad_onc_project/functions/preferences_functions.dart'
    as funcPrefs;
import 'package:vector_math/vector_math_64.dart' as la;

class MUCalcApp extends StatefulWidget {
  static const String routeName = '/mu-calc-app';

  const MUCalcApp({Key? key}) : super(key: key);

  static const String defaultDose = '200';
  static const String defaultFieldSize = '10';
  static const String defaultDepth = '1.5';
  static const String defaultBlock = '0';
  static const double fractionWidthButton = 0.8;
  static const double radiusButton = 10;

  @override
  _MUCalcAppState createState() => _MUCalcAppState();
}

class _MUCalcAppState extends State<MUCalcApp> {
  Map<String, List<double>> _mapDepth = {};
  Map<String, List<double>> _mapPdd = {};
  List<bool> _listToggle = [true, false];
  int _nParticle = 0;
  TextEditingController _controllerDose =
      TextEditingController(text: MUCalcApp.defaultDose);
  TextEditingController _controllerX =
      TextEditingController(text: MUCalcApp.defaultFieldSize);
  TextEditingController _controllerY =
      TextEditingController(text: MUCalcApp.defaultFieldSize);
  TextEditingController _controllerDepth =
      TextEditingController(text: MUCalcApp.defaultDepth);
  TextEditingController _controllerBlock = TextEditingController(text: '');
  bool _isBlock = false;

  Future<void> initPreferences() async {
    List<Map<String, List<double>>> results = await funcPrefs.readPreferences();
    _mapDepth = results[0];
    _mapPdd = results[1];
    setState(() {});
  }

  @override
  void initState() {
    initPreferences();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String strParticle = particles.listStrParticle[_nParticle];

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: RadAppBar(
          strAppTitle: datas.mapAppNames[2]![3],
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            RadToggleButton(
              strOption1: 'SSD',
              strOption2: 'SAD',
              listIsSelected: _listToggle,
              functionOnPressed: () {
                setState(() {
                  _listToggle = _listToggle.map((e) => !e).toList();
                });
              },
            ),
            Row(
              children: [
                Expanded(
                    flex: 2,
                    child: Text(
                      'Particle:',
                      style: Theme.of(context).textTheme.headline2,
                    )),
                Expanded(
                  flex: 1,
                  child: DropdownButton<int>(
                    value: _nParticle,
                    items: particles.listStrParticle
                        .where((element) => element.endsWith('X'))
                        .map((e) => DropdownMenuItem(
                            value: particles.listStrParticle.indexOf(e),
                            child: Text(
                              e,
                              style: Theme.of(context).textTheme.headline2,
                              textAlign: TextAlign.center,
                            )))
                        .toList(),
                    dropdownColor: Colors.blueGrey,
                    onChanged: (index) {
                      setState(() {
                        _nParticle = index!;
                      });
                    },
                  ),
                ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                    child: Text(
                  'Dose [cGy]:',
                  style: Theme.of(context).textTheme.headline2,
                )),
                Expanded(child: fields.textFieldDose(context, _controllerDose)),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                    flex: 2,
                    child: Text(
                      'FS [cm]:',
                      style: Theme.of(context).textTheme.headline2,
                    )),
                Expanded(
                    flex: 1,
                    child: fields.textFieldFraction(context, _controllerX)),
                Expanded(
                    flex: 1,
                    child: fields.textFieldFraction(context, _controllerY)),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  child: Container(
                    color: Colors.grey,
                    child: Checkbox(
                      value: _isBlock,
                      onChanged: (val) {
                        setState(() {
                          _isBlock = val!;
                          if (_isBlock) {
                            _controllerBlock.text = MUCalcApp.defaultBlock;
                          } else {
                            _controllerBlock.text = '';
                          }
                        });
                      },
                    ),
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: Text(
                    'Block [%]',
                    style: Theme.of(context).textTheme.headline2,
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: IgnorePointer(
                    ignoring: !_isBlock,
                    child: fields.textFieldFraction(context, _controllerBlock),
                  ),
                ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                    child: Text(
                  'Depth [${strParticle.endsWith('X') ? 'cm' : 'mm'}]:',
                  style: Theme.of(context).textTheme.headline2,
                )),
                Expanded(
                    child: fields.textFieldDose(context, _controllerDepth)),
              ],
            ),
            Container(
              width: MediaQuery.of(context).size.width *
                  MUCalcApp.fractionWidthButton,
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(MUCalcApp.radiusButton),
              ),
              child: TextButton(
                onPressed: () async {
                  double eqSqr = getEquivalentSquare(
                      double.parse(_controllerX.text),
                      double.parse(_controllerY.text));
                  double effEqSqr = getEffectiveEquivalentSquare(
                      _isBlock
                          ? 1 - double.parse(_controllerBlock.text) / 100
                          : 1,
                      eqSqr);
                  double? scatterCollimator = getScatter(
                      particles.scatterCollimator[strParticle]!, eqSqr);
                  double? scatterPatient = getScatter(
                      particles.scatterPatient[strParticle]!, effEqSqr);
                  double? nPdd = getPdd(_mapDepth, _mapPdd, strParticle,
                      double.parse(_controllerDepth.text));

                  if (scatterCollimator != null &&
                      scatterPatient != null &&
                      nPdd != null) {
                    await showDialog(
                      context: context,
                      builder: (context) {
                        return Dialog(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.black,
                              border: Border.all(color: Colors.green, width: 4),
                            ),
                            width: MediaQuery.of(context).size.width * 0.8,
                            height: MediaQuery.of(context).size.height * 0.6,
                            child: Column(
                              children: [
                                Text(
                                  'Eq-Sqr [cm]\n${eqSqr.toStringAsFixed(2)}',
                                  style: Theme.of(context).textTheme.headline1,
                                  textAlign: TextAlign.center,
                                ),
                                Text(
                                  'Eff-Eq-Sqr [cm]\n${effEqSqr.toStringAsFixed(2)}',
                                  style: Theme.of(context).textTheme.headline1,
                                  textAlign: TextAlign.center,
                                ),
                                Divider(
                                  color: Colors.green,
                                  thickness: 2,
                                ),
                                Text(
                                  'Sc: ${scatterCollimator.toStringAsFixed(3)}',
                                  style: Theme.of(context).textTheme.headline1,
                                  textAlign: TextAlign.center,
                                ),
                                Text(
                                  'Sp: ${scatterPatient.toStringAsFixed(3)}',
                                  style: Theme.of(context).textTheme.headline1,
                                  textAlign: TextAlign.center,
                                ),
                                Text(
                                  'PDD [%]: ${nPdd.toStringAsFixed(1)}',
                                  style: Theme.of(context).textTheme.headline1,
                                  textAlign: TextAlign.center,
                                ),
                                Divider(
                                  color: Colors.green,
                                  thickness: 2,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
                child: Text(
                  'Compute',
                  style: Theme.of(context).textTheme.headline2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

double getEquivalentSquare(double length1, double length2) {
  return 2 * length1 * length2 / (length1 + length2);
}

double getEffectiveEquivalentSquare(double fractionAreaOpen, double eqSqr) {
  return eqSqr * fractionAreaOpen;
}

double? getScatter(Map<double, double> mapScatter, double eqSqr) {
  List<double> listX = mapScatter.keys.toList();
  List<double> listY = mapScatter.values.toList();
  int i = listX.indexWhere((element) => element > eqSqr);
  if (i >= 2 && i <= listX.length - 2) {
    la.Vector4 vecConstants = splines.getConstants(
        [listX[i - 2], listX[i - 1], listX[i], listX[i + 1]],
        [listY[i - 2], listY[i - 1], listY[i], listY[i + 1]]);
    return splines.getInterpolatedY(vecConstants, eqSqr);
  } else {
    return null;
  }
}

double? getPdd(Map<String, List<double>> mapDepth,
    Map<String, List<double>> mapPdd, String strParticle, double depth) {
  List<double> listDepth = mapDepth[strParticle]!.toList();
  List<double> listPdd = mapPdd[strParticle]!.toList();
  int i = listDepth.indexWhere((element) => element > depth);
  if (i >= 2 && i <= listDepth.length - 2) {
    la.Vector4 vecConstants = splines.getConstants(
        [listDepth[i - 2], listDepth[i - 1], listDepth[i], listDepth[i + 1]],
        [listPdd[i - 2], listPdd[i - 1], listPdd[i], listPdd[i + 1]]);
    return splines.getInterpolatedY(vecConstants, depth);
  } else {
    return null;
  }
}

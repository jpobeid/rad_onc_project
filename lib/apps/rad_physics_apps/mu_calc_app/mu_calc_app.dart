import 'package:flutter/material.dart';
import 'package:rad_onc_project/data/global_data.dart' as datas;
import 'package:rad_onc_project/data/particle_data.dart' as particles;
import 'package:rad_onc_project/functions/preferences_functions.dart'
    as funcPrefs;
import 'package:rad_onc_project/functions/spline_functions.dart' as splines;
import 'package:rad_onc_project/widgets/rad_app_bar.dart';
import 'package:rad_onc_project/widgets/text_fields.dart' as fields;

class MUCalcApp extends StatefulWidget {
  static const String routeName = '/mu-calc-app';

  const MUCalcApp({Key? key}) : super(key: key);

  static const List<int> flexVertical = [7, 2, 1, 1];
  static const String defaultDose = '200';
  static const String defaultFieldSize = '10';
  static const String defaultDepth = '1.5';
  static const String defaultBlock = '0';
  static const List<double> limitsDose = [0, 1000];
  static const List<double> limitsFieldSize = [5, 35];
  static const List<double> limitsBlock = [0, 80];
  static const List<double> limitsDepth = [0, 35];
  static const double fractionWidthButton = 0.8;
  static const double radiusButton = 10;
  static const int durationSnack = 600;

  @override
  _MUCalcAppState createState() => _MUCalcAppState();
}

class _MUCalcAppState extends State<MUCalcApp> {
  Map<String, Map<String, List<double>>> _mapPdd = {};
  int _iParticle = 0;
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
    _mapPdd = await funcPrefs.readPreferences(context);
    setState(() {});
  }

  @override
  void initState() {
    initPreferences();
    super.initState();
  }

  @override
  void dispose() {
    _controllerDose.dispose();
    _controllerX.dispose();
    _controllerY.dispose();
    _controllerDepth.dispose();
    _controllerBlock.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool canBuild = _mapPdd.isNotEmpty;
    if (canBuild) {
      return SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: RadAppBar(
            strAppTitle: datas.mapAppNames[2]![3],
          ),
          body: Column(
            children: [
              Expanded(
                flex: MUCalcApp.flexVertical[0],
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
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
                            value: _iParticle,
                            items: particles.listStrParticle
                                .where((element) => element.endsWith('X'))
                                .map((e) => DropdownMenuItem(
                                    value: particles.listStrParticle.indexOf(e),
                                    child: Text(
                                      e,
                                      style:
                                          Theme.of(context).textTheme.headline2,
                                      textAlign: TextAlign.center,
                                    )))
                                .toList(),
                            dropdownColor: Colors.blueGrey,
                            onChanged: (index) {
                              setState(() {
                                _iParticle = index!;
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
                        Expanded(
                            child:
                                fields.textFieldDose(context, _controllerDose)),
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
                            child: fields.textFieldFraction(
                                context, _controllerX)),
                        Expanded(
                            flex: 1,
                            child: fields.textFieldFraction(
                                context, _controllerY)),
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
                                    _controllerBlock.text =
                                        MUCalcApp.defaultBlock;
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
                            child: fields.textFieldFraction(
                                context, _controllerBlock),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                            child: Text(
                          //HARD code###
                          'Depth [cm]:',
                          style: Theme.of(context).textTheme.headline2,
                        )),
                        Expanded(
                            child: fields.textFieldDose(
                                context, _controllerDepth)),
                      ],
                    ),
                  ],
                ),
              ),
              Spacer(
                flex: MUCalcApp.flexVertical[1],
              ),
              Expanded(
                flex: MUCalcApp.flexVertical[2],
                child: Container(
                  width: MediaQuery.of(context).size.width *
                      MUCalcApp.fractionWidthButton,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(MUCalcApp.radiusButton),
                  ),
                  child: TextButton(
                    onPressed: () async {
                      await computeOutputs(
                        context,
                        particles.listStrParticle[_iParticle],
                        _mapPdd,
                        _controllerDose,
                        _controllerX,
                        _controllerY,
                        _controllerBlock,
                        _controllerDepth,
                        _isBlock,
                      );
                    },
                    child: Text(
                      'Compute',
                      style: Theme.of(context).textTheme.headline2,
                    ),
                  ),
                ),
              ),
              Spacer(
                flex: MUCalcApp.flexVertical[3],
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

double getEquivalentSquare(double length1, double length2) {
  return 2 * length1 * length2 / (length1 + length2);
}

double getEffectiveEquivalentSquare(double fractionAreaOpen, double eqSqr) {
  return eqSqr * fractionAreaOpen;
}

double? getFieldSizeInterpolatedPddN(
    Map<String, Map<String, List<double>>> mapPdd,
    String particle,
    double effEqSqr,
    double depth) {
  List<String> listFieldsUnits = mapPdd[particle]!.keys.toList();
  List<double> fieldSizes = listFieldsUnits
      .where((element) => !element.contains('-'))
      .map((e) => double.parse(e))
      .toList();
  int iField1 = fieldSizes.indexWhere((element) => element > effEqSqr);
  int iField0 = iField1 - 1;
  if (iField1 != -1 && iField0 != -1) {
    double fieldSize0 = fieldSizes[iField0];
    double fieldSize1 = fieldSizes[iField1];
    double linearWeight0 =
        1 - ((effEqSqr - fieldSize0) / (fieldSize1 - fieldSize0));
    List<dynamic> pddParameters0 =
        funcPrefs.getPddParameters(mapPdd, particle, iField0);
    List<double> pddDepths0 = pddParameters0[2];
    List<double> pddValues0 = pddParameters0[3];
    List<dynamic> pddParameters1 =
        funcPrefs.getPddParameters(mapPdd, particle, iField1);
    List<double> pddDepths1 = pddParameters1[2];
    List<double> pddValues1 = pddParameters1[3];
    double? pddN0 =
        splines.getInterpolatedNFromLists(pddDepths0, pddValues0, depth);
    double? pddN1 =
        splines.getInterpolatedNFromLists(pddDepths1, pddValues1, depth);
    if (pddN0 != null && pddN1 != null) {
      return linearWeight0 * pddN0 + (1 - linearWeight0) * pddN1;
    } else {
      return null;
    }
  } else {
    return null;
  }
}

bool areInputsValid(List<TextEditingController> controllers) {
  try {
    controllers.forEach((element) {
      double.parse(element.text);
    });
  } catch (e) {
    return false;
  }
  return true;
}

List<bool> inputsWithinLimits(
    TextEditingController controllerDose,
    TextEditingController controllerX,
    TextEditingController controllerY,
    TextEditingController controllerBlock,
    bool isBlock,
    TextEditingController controllerDepth) {
  List<bool> withinLimits = [];
  double n = double.parse(controllerDose.text);
  withinLimits
      .add(n >= MUCalcApp.limitsDose[0] && n <= MUCalcApp.limitsDose[1]);
  n = double.parse(controllerX.text);
  withinLimits.add(
      n >= MUCalcApp.limitsFieldSize[0] && n <= MUCalcApp.limitsFieldSize[1]);
  n = double.parse(controllerY.text);
  withinLimits.add(
      n >= MUCalcApp.limitsFieldSize[0] && n <= MUCalcApp.limitsFieldSize[1]);
  if (isBlock) {
    n = double.parse(controllerBlock.text);
    withinLimits
        .add(n >= MUCalcApp.limitsBlock[0] && n <= MUCalcApp.limitsBlock[1]);
  } else {
    withinLimits.add(true);
  }
  n = double.parse(controllerDepth.text);
  withinLimits
      .add(n >= MUCalcApp.limitsDepth[0] && n <= MUCalcApp.limitsDepth[1]);
  return withinLimits;
}

Future<void> computeOutputs(
  BuildContext context,
  String particle,
  Map<String, Map<String, List<double>>> mapPdd,
  TextEditingController controllerDose,
  TextEditingController controllerX,
  TextEditingController controllerY,
  TextEditingController controllerBlock,
  TextEditingController controllerDepth,
  bool isBlock,
) async {
  bool isError = false;
  String strError = '';

  if (!areInputsValid(isBlock
      ? [
          controllerDose,
          controllerX,
          controllerY,
          controllerBlock,
          controllerDepth
        ]
      : [controllerDose, controllerX, controllerY, controllerDepth])) {
    isError = true;
    strError = 'Invalid inputs';
  } else {
    List<bool> withinLimits = inputsWithinLimits(controllerDose, controllerX,
        controllerY, controllerBlock, isBlock, controllerDepth);
    List<String> limitErrors = [
      'Dose out of limit',
      'Field size out of limit',
      'Field size out of limit',
      'Block out of limit',
      'Depth out of limit'
    ];
    if (!withinLimits.every((element) => element)) {
      isError = true;
      strError = limitErrors[withinLimits.indexOf(false)];
    }
  }

  if (!isError) {
    double eqSqr = getEquivalentSquare(
        double.parse(controllerX.text), double.parse(controllerY.text));
    double effEqSqr = getEffectiveEquivalentSquare(
        isBlock ? 1 - double.parse(controllerBlock.text) / 100 : 1, eqSqr);
    double? scatterCollimator = splines.getInterpolatedNFromLists(
        particles.scatterCollimator[particle]!.keys.toList(),
        particles.scatterCollimator[particle]!.values.toList(),
        eqSqr);
    double? scatterPatient = splines.getInterpolatedNFromLists(
        particles.scatterPatient[particle]!.keys.toList(),
        particles.scatterPatient[particle]!.values.toList(),
        effEqSqr);

    if (scatterCollimator != null && scatterPatient != null) {
      double? nPdd = getFieldSizeInterpolatedPddN(
          mapPdd, particle, effEqSqr, double.parse(controllerDepth.text));

      if (nPdd != null) {
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
      } else {
        isError = true;
        strError = 'Invalid PDD computed';
      }
    } else {
      isError = true;
      strError = 'Incorrect scatter computed';
    }
  }
  if (isError) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          strError,
          style: Theme.of(context).textTheme.headline1,
        ),
        duration: Duration(milliseconds: MUCalcApp.durationSnack),
      ),
    );
  }
}

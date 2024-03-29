import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rad_onc_project/functions/draw_plot.dart';

import './find_roots.dart' as roots;
import './least_squares_line.dart' as lsqr;
import './metrics.dart' as metrics;

class ScalingTimePlot extends StatefulWidget {
  static const routeName = '/scaling-time-plot-app';

  static const Map<int, String> mapSuperscript = {
    0: '\u2070',
    1: '\u00B9',
    2: '\u00B2',
    3: '\u00B3',
    4: '\u2074',
    5: '\u2075',
    6: '\u2076',
    7: '\u2077',
    8: '\u2078',
    9: '\u2079',
  };
  static const double fontSizeScale = 20;
  static const List<String> scaleLabels = [
    '5x',
    '3x',
    '2x',
    '1.5x',
    '(2/3)x',
    '(1/2)x',
    '(1/3)x',
    '(1/5)x'
  ];
  static const List<double> scaleValues = [
    5.0,
    3.0,
    2.0,
    1.5,
    (2 / 3),
    (1 / 2),
    (1 / 3),
    (1 / 5),
  ];
  static const List<String> timeUnits = [
    'Days',
    'Months',
    'Years',
  ];

  final List<DateTime>? listDateTime;
  final List<String>? listStrValues;

  const ScalingTimePlot({Key? key, this.listDateTime, this.listStrValues})
      : super(key: key);

  @override
  _ScalingTimePlotState createState() => _ScalingTimePlotState();
}

class _ScalingTimePlotState extends State<ScalingTimePlot> {
  static const List<int> listHorizontalFlex = [10, 4];
  static const List<int> listVerticalFlex = [5, 1, 1, 1];
  static const double fractionCanvasHeight = 0.95;
  static const double fractionCanvasWidth = 0.95;
  static const double sizeRadius = 10;
  static const Color colorDropList = Colors.blueGrey;
  static const double fractionWidthDialog = 0.8;
  static const double fractionHeightDialog = 0.6;
  static const double widthBorderDialog = 5;
  static const double radiusBorderDialog = 20;

  int? _valueInterpol = 0;
  Function _valueFunction = roots.fExp;
  int? _valueScale = 0;
  int? _valueUnits = 0;
  List<double> _listCrosshairsData = [0, 0, 0];
  List<String> _listCrosshairsString = ['', '', 'true'];

  List<double>? _listAbsDays;
  late int _elapsedDays;
  List<double>? _listRelDays;
  late List<String> _listPossibleUnits;
  List<double>? _listValues;
  double? _maxValue;
  late String _strTimeUnit;
  List<double>? _normListX;
  List<double>? _normListY;
  List<double> _listFunctionNormArgs = [];
  List<double> _listFunctionArgs = [];

  void clearFunctionArgs() {
    _listFunctionNormArgs.clear();
    _listFunctionArgs.clear();
  }

  void updateMainVars() {
    _listAbsDays = widget.listDateTime!
        .map((e) => e.millisecondsSinceEpoch / 1000 / 60 / 60 / 24)
        .toList();
    _elapsedDays = (_listAbsDays!
                .reduce((value, element) => math.max(value, element)) -
            _listAbsDays!.reduce((value, element) => math.min(value, element)))
        .round();
    _listRelDays = _listAbsDays!.map((e) => (e - _listAbsDays![0])).toList();
    List<bool> listCanBeUnit = [
      _elapsedDays < 365,
      _elapsedDays > 30,
      _elapsedDays >= 365
    ];
    _listPossibleUnits = [];
    int i = 0;
    listCanBeUnit.forEach((element) {
      if (element) {
        _listPossibleUnits.add(ScalingTimePlot.timeUnits[i]);
      }
      i++;
    });
    _listValues = widget.listStrValues!.map((e) => double.parse(e)).toList();
    _maxValue =
        _listValues!.reduce((value, element) => math.max(value, element));
    _strTimeUnit = _listPossibleUnits[_valueUnits!];
    //Normalize lists for computations and plotting
    _normListX = getNormList(_listAbsDays, true);
    _normListY = getNormList(_listValues, false);
    //Get interpolation function - MUST use normArgs for drawing and true args for computations
    clearFunctionArgs();
    switch (_valueInterpol) {
      case 0:
        _valueFunction = roots.fExp;
        _listFunctionArgs.add(_listValues![0]);
        _listFunctionNormArgs.add(_normListY![0]);
        double normBetaPrime = roots.getBetaPrime(_normListX!, _normListY);
        double normBeta =
            roots.tuneNormBeta(normBetaPrime, _normListX, _normListY);
        _listFunctionNormArgs.add(normBeta);
        //Get TRUE beta for use with computations, this is based on non-normalized values
        double beta = roots.getBeta(
            normBeta,
            metrics.Metrics.convertElapsedTime(
                _elapsedDays.toDouble(), _strTimeUnit));
        _listFunctionArgs.add(beta);
        break;
      case 1:
        _valueFunction = lsqr.fLine;
        double normB = lsqr.getB(_normListX!, _normListY!);
        _listFunctionNormArgs.add(lsqr.getM(_normListX!, _normListY!, normB));
        _listFunctionNormArgs.add(normB);
        double b = lsqr.getB(_listRelDays!, _listValues!);
        double m = lsqr.getM(_listRelDays!, _listValues!, b);
        _listFunctionArgs.add(m);
        _listFunctionArgs.add(b);
        break;
      default:
        _valueFunction = roots.fExp;
        _listFunctionArgs.add(_listValues![0]);
        _listFunctionNormArgs.add(_listValues![0]);
        double normBetaPrime = roots.getBetaPrime(_normListX!, _normListY);
        double normBeta =
            roots.tuneNormBeta(normBetaPrime, _normListX, _normListY);
        _listFunctionNormArgs.add(normBeta);
        //Get TRUE beta for use with computations, this is based on non-normalized values
        double beta = roots.getBeta(
            normBeta,
            metrics.Metrics.convertElapsedTime(
                _elapsedDays.toDouble(), _strTimeUnit));
        _listFunctionArgs.add(beta);
        break;
    }
  }

  Container buildCanvas(int? elapsedDays, String? strTimeUnit, double? maxValue,
      List<double>? normListX, List<double>? normListY, double normBeta) {
    return Container(
      color: Colors.grey[200],
      child: CustomPaint(
        painter: PlotPaint(
          context: context,
          elapsedDays: elapsedDays,
          strTimeUnit: strTimeUnit,
          maxY: maxValue,
          normListX: normListX,
          normListY: normListY,
          activeFunction: _valueFunction,
          functionNormArgs: _listFunctionNormArgs,
          listCrosshairsDouble: _listCrosshairsData,
          listCrosshairsString: _listCrosshairsString,
        ),
      ),
    );
  }

  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
    ]);
    updateMainVars();
    super.initState();
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.of(context).orientation == Orientation.landscape) {
      return SafeArea(
        child: Scaffold(
          body: Row(
            children: [
              Expanded(
                flex: listHorizontalFlex[0],
                child: FractionallySizedBox(
                  heightFactor: fractionCanvasHeight,
                  widthFactor: fractionCanvasWidth,
                  child: LayoutBuilder(builder: (context, constraints) {
                    return GestureDetector(
                      onHorizontalDragStart: (details) {
                        double absX = details.localPosition.dx;
                        double absYd = details.localPosition.dy;
                        double maxAbsX = constraints.maxWidth;
                        double maxAbsY = constraints.maxHeight;
                        if (absX > 0 &&
                            absYd > 0 &&
                            absX < maxAbsX &&
                            absYd < maxAbsY) {
                          setState(() {
                            List<double> listDiffX = _normListX!
                                .map((e) =>
                                    (e - (details.localPosition.dx / maxAbsX))
                                        .abs())
                                .toList();
                            int indexX = listDiffX.indexOf(listDiffX.reduce(
                                (value, element) => math.min(value, element)));
                            //Set the double data for the crosshairs
                            _listCrosshairsData[0] =
                                _normListX![indexX] * maxAbsX;
                            _listCrosshairsData[1] =
                                (1 - _normListY![indexX]) * maxAbsY;
                            _listCrosshairsData[2] = 1;
                            //Set the string data for the crosshairs
                            DateTime selectedDate =
                                widget.listDateTime![indexX];
                            _listCrosshairsString[0] =
                                '${selectedDate.month}/${selectedDate.day}/${selectedDate.year}';
                            _listCrosshairsString[1] =
                                _listValues![indexX].toStringAsFixed(2);
                          });
                        }
                      },
                      onHorizontalDragUpdate: (details) {
                        double absX = details.localPosition.dx;
                        double absYd = details.localPosition.dy;
                        double maxAbsX = constraints.maxWidth;
                        double maxAbsY = constraints.maxHeight;
                        if (absX > 0 &&
                            absYd > 0 &&
                            absX < maxAbsX &&
                            absYd < maxAbsY) {
                          _listCrosshairsData[0] = absX;
                          if (_valueInterpol == 0) {
                            _listCrosshairsData[1] = (1 -
                                    (_valueFunction([
                                          _listFunctionArgs[0],
                                          _listFunctionNormArgs[1],
                                        ], absX / maxAbsX) /
                                        _maxValue)) *
                                maxAbsY;
                          } else {
                            _listCrosshairsData[1] = maxAbsY -
                                _valueFunction([
                                  _listFunctionNormArgs[0] * maxAbsY,
                                  _listFunctionArgs[1] * (maxAbsY / _maxValue!),
                                ], (absX / maxAbsX));
                          }
                          _listCrosshairsData[1] = _listCrosshairsData[1] < 0
                              ? 0
                              : _listCrosshairsData[1];
                          _listCrosshairsData[1] =
                              _listCrosshairsData[1] > maxAbsY
                                  ? maxAbsY
                                  : _listCrosshairsData[1];
                          setState(() {
                            //Set the double data for the crosshairs
                            _listCrosshairsData[2] = 1;
                            //Set the string data for the crosshairs
                            double dtDays = _elapsedDays * (absX / maxAbsX);
                            DateTime selectedDate =
                                DateTime.fromMillisecondsSinceEpoch(
                                    ((_listAbsDays![0] + dtDays) *
                                            1000 *
                                            60 *
                                            60 *
                                            24)
                                        .ceil());
                            _listCrosshairsString[0] =
                                '${selectedDate.month}/${selectedDate.day}/${selectedDate.year}';
                            _listCrosshairsString[1] =
                                ((1 - _listCrosshairsData[1] / maxAbsY) *
                                        _maxValue!)
                                    .toStringAsFixed(2);
                          });
                        }
                      },
                      child: buildCanvas(
                        _elapsedDays,
                        _strTimeUnit,
                        _maxValue,
                        _normListX,
                        _normListY,
                        _listFunctionNormArgs[1],
                      ),
                    );
                  }),
                ),
              ),
              Expanded(
                flex: listHorizontalFlex[1],
                child: Container(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  child: Column(
                    children: [
                      Expanded(
                        flex: listVerticalFlex[0],
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              'Interpol.:',
                              style: Theme.of(context).textTheme.headline1,
                            ),
                            DropdownButton(
                              value: _valueInterpol,
                              dropdownColor: colorDropList,
                              items: [
                                DropdownMenuItem(
                                  value: 0,
                                  child: Text(
                                    'Exp.',
                                    style:
                                        Theme.of(context).textTheme.headline1,
                                  ),
                                ),
                                DropdownMenuItem(
                                  value: 1,
                                  child: Text(
                                    'Linear',
                                    style:
                                        Theme.of(context).textTheme.headline1,
                                  ),
                                ),
                              ],
                              onChanged: (dynamic index) {
                                setState(() {
                                  _valueInterpol = index;
                                  updateMainVars();
                                  _listCrosshairsData[2] = 0;
                                });
                              },
                            ),
                            Text(
                              'Scale:',
                              style: Theme.of(context).textTheme.headline1,
                            ),
                            DropdownButton(
                              value: _valueScale,
                              dropdownColor: colorDropList,
                              items: getScaleMenu(
                                  context,
                                  ScalingTimePlot.scaleLabels,
                                  _listFunctionArgs,
                                  _valueInterpol),
                              onChanged: (dynamic index) {
                                setState(() {
                                  _valueScale = index;
                                  updateMainVars();
                                });
                              },
                            ),
                            Text(
                              'Units:',
                              style: Theme.of(context).textTheme.headline1,
                            ),
                            DropdownButton(
                              value: _valueUnits,
                              dropdownColor: colorDropList,
                              items: getUnitsMenu(context, _listPossibleUnits),
                              onChanged: (dynamic index) {
                                setState(() {
                                  _valueUnits = index;
                                  updateMainVars();
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      Spacer(
                        flex: listVerticalFlex[1],
                      ),
                      Expanded(
                        flex: listVerticalFlex[2],
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(sizeRadius),
                          ),
                          child: TextButton(
                            child: Text(
                              'Metrics',
                              style: Theme.of(context).textTheme.headline1,
                            ),
                            onPressed: () {
                              updateMainVars();
                              showMetrics(
                                context,
                                fractionWidthDialog,
                                fractionHeightDialog,
                                widthBorderDialog,
                                radiusBorderDialog,
                                ScalingTimePlot.scaleLabels,
                                ScalingTimePlot.scaleValues,
                                _valueScale,
                                _listRelDays,
                                _listValues,
                                _valueInterpol,
                                _listFunctionArgs,
                                _elapsedDays,
                                _strTimeUnit,
                              );
                            },
                          ),
                        ),
                      ),
                      Spacer(
                        flex: listVerticalFlex[3],
                      ),
                    ],
                  ),
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

class PlotPaint extends CustomPainter {
  final BuildContext? context;
  final int? elapsedDays;
  final String? strTimeUnit;
  final double? maxY;
  final List<double>? normListX;
  final List<double>? normListY;
  final activeFunction;
  final functionNormArgs;
  final List<double>? listCrosshairsDouble;
  final List<String>? listCrosshairsString;

  static const double sizeTickLength = 0.02;
  static const Color colorAxis = Colors.indigoAccent;
  static const Color colorPoints = Colors.pink;
  static const double strokeWidthCurve = 3;
  static const double strokeWidthPoints = 16;
  static const double strokeWidthCrosshairs = 3;
  static const double scaleWidthCrosshairPoints = 2;
  static const double fractionOffsetText = 0.03;
  static const int nPoints = 100;

  PlotPaint(
      {this.context,
      this.elapsedDays,
      this.strTimeUnit,
      this.maxY,
      this.normListX,
      this.normListY,
      this.activeFunction,
      this.functionNormArgs,
      this.listCrosshairsDouble,
      this.listCrosshairsString});

  @override
  void paint(Canvas canvas, Size size) {
    List<double?> listNTicks =
        getListNTicks(elapsedDays!.toDouble(), strTimeUnit, maxY!);
    double nTicksX = listNTicks[0]!;
    double nTicksY = listNTicks[1]!;
    double nOrderY = listNTicks[2]!;
    double strokeWidthAxis = 3;
    if (nTicksX > 180) {
      strokeWidthAxis = 1;
    } else if (nTicksX > 90) {
      strokeWidthAxis = 2;
    }

    //Draw curve
    Paint paintCurve = getPaintCurve(Colors.black, strokeWidthCurve);
    drawPlotCurve(
        canvas, size, nPoints, paintCurve, activeFunction, functionNormArgs);

    //Draw axis over
    drawFrame(canvas, size, nTicksX, nTicksY, sizeTickLength, colorAxis,
        strokeWidthAxis);
    TextPainter paintText = TextPainter(
        text: TextSpan(
            text: nOrderY > 0
                ? 'x10${ScalingTimePlot.mapSuperscript[nOrderY.round()]}'
                : '',
            style: TextStyle(
                color: Colors.black, fontSize: ScalingTimePlot.fontSizeScale)),
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr);
    paintText.layout();
    paintText.paint(
        canvas,
        normListY![0] < normListY!.last
            ? Offset(size.width * fractionOffsetText,
                size.height * fractionOffsetText)
            : Offset(size.width * (1 - fractionOffsetText * 4),
                size.height * fractionOffsetText));

    //Draw base points (on top)
    drawPlotPoints(
        canvas, size, normListX!, normListY!, colorPoints, strokeWidthPoints);

    //Draw crosshairs
    drawCrosshairs(
      canvas,
      size,
      getPaintCrosshairs(colorAxis, strokeWidthCrosshairs),
      getPaintPoints(
          colorAxis, strokeWidthCrosshairs * scaleWidthCrosshairPoints),
      listCrosshairsDouble![0],
      listCrosshairsDouble![1],
      listCrosshairsDouble![2],
      listCrosshairsString,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

List<double?> getListNTicks(double maxX, String? unitsX, double maxY) {
  double? nTicksX;
  if (unitsX == 'Days') {
    nTicksX = maxX / 1;
  } else if (unitsX == 'Months') {
    nTicksX = maxX * 12 / 365;
  } else if (unitsX == 'Years') {
    nTicksX = maxX / 365;
  }
  double nTicksY;
  int orderMaxY = 0;
  int maxYi = maxY.floor();
  while (maxYi >= 10) {
    orderMaxY++;
    maxYi = (maxYi / 10).floor();
  }
  nTicksY = maxY / math.pow(10, orderMaxY);
  return [nTicksX, nTicksY, orderMaxY.toDouble()];
}

//region menu functions
List<DropdownMenuItem> getScaleMenu(BuildContext context,
    List<String> listStrScale, List<double> listArgs, int? valueInterpol) {
  List<DropdownMenuItem> listOut = [];
  int indexStart = (valueInterpol == 0 ? listArgs[1] >= 0 : listArgs[0] >= 0)
      ? 0
      : (listStrScale.length / 2).floor();
  for (int i = 0; i < (listStrScale.length / 2).floor(); i++) {
    listOut.add(DropdownMenuItem(
      value: i,
      child: Text(
        listStrScale[indexStart + i],
        style: Theme.of(context).textTheme.headline1,
      ),
    ));
  }
  return listOut;
}

List<DropdownMenuItem> getUnitsMenu(
    BuildContext context, List<String> listPossibleUnits) {
  List<DropdownMenuItem> listOut = [];
  int i = 0;
  for (String e in listPossibleUnits) {
    listOut.add(DropdownMenuItem(
      value: i,
      child: Text(
        e,
        style: Theme.of(context).textTheme.headline1,
      ),
    ));
    i++;
  }
  return listOut;
}
//endregion menu functions

void showMetrics(
  BuildContext context,
  double fractionWidthDialog,
  double fractionHeightDialog,
  double widthBorderDialog,
  double radiusBorderDialog,
  List<String> listStrScale,
  List<double> listNScale,
  int? valueScale,
  List<double>? listRelX,
  List<double>? listY,
  int? valueInterpol,
  List<double> listArgs,
  int elapsedDays,
  String strTimeUnit,
) {
  showDialog(
      builder: (context) {
        const List<double> listTableHorizontalFlex = [1, 1];
        TextStyle styleMetrics = Theme.of(context).textTheme.headline1!;
        const Color colorBorders = Colors.green;

        metrics.Metrics metric = metrics.Metrics(
            fX: valueInterpol == 0 ? roots.fExp : lsqr.fLine,
            args: listArgs,
            elapsedDays: elapsedDays,
            unitTime: strTimeUnit);

        return Center(
          child: Container(
            width: MediaQuery.of(context).size.width * fractionWidthDialog,
            height: MediaQuery.of(context).size.height * fractionHeightDialog,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              border: Border.all(color: colorBorders, width: widthBorderDialog),
              borderRadius: BorderRadius.circular(radiusBorderDialog),
            ),
            child: Table(
              columnWidths: {
                0: FlexColumnWidth(listTableHorizontalFlex[0]),
                1: FlexColumnWidth(listTableHorizontalFlex[1])
              },
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              border: TableBorder.symmetric(
                  inside: BorderSide(color: colorBorders, width: 2)),
              children: [
                TableRow(
                  children: [
                    Text(
                      valueInterpol == 0 ? 'Beta (k):' : 'Slope (m):',
                      style: styleMetrics,
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      '${valueInterpol == 0 ? metric.args[1].toStringAsFixed(3) : metric.averageVelocity.toStringAsFixed(3)} [$strTimeUnit\u207b\u00b9]',
                      style: styleMetrics,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    Text(
                      '${valueInterpol == 0 ? '' : 'Avg. '}${listStrScale[(valueInterpol == 0 ? metric.args[1] >= 0 : metric.args[0] >= 0) ? valueScale! : (listStrScale.length / 2).floor() + valueScale!]} Time:',
                      style: styleMetrics,
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      '${metric.getScalingTime(valueScale, listNScale).toStringAsFixed(1)} [$strTimeUnit]',
                      style: styleMetrics,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    Text(
                      'Avg. Velocity:',
                      style: styleMetrics,
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      '${metric.averageVelocity.toStringAsFixed(3)} [$strTimeUnit\u207b\u00b9]',
                      style: styleMetrics,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    Text(
                      'Mean Sq. Err.:',
                      style: styleMetrics,
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      '${metric.getMeanSquaredError(listRelX!, listY).toStringAsFixed(3)}',
                      style: styleMetrics,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
      context: context);
}

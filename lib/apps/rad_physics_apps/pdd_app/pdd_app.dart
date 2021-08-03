import 'dart:math' as maths;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rad_onc_project/functions/draw_plot.dart' as plt;
import 'package:vector_math/vector_math.dart' as vec;
import 'package:rad_onc_project/data/particle_data.dart' as particles;
import 'package:rad_onc_project/functions/preferences_functions.dart'
    as funcPrefs;

class PddApp extends StatefulWidget {
  static const routeName = '/pdd-app';

  static const int nSize = 4;
  static const int xSkip = 1;
  static const Color colorPhoton = Colors.pink;
  static const Color colorElectron = Colors.indigoAccent;
  static const List<int> listFlex = [15, 5];
  static const double fractionCanvasWidth = 0.95;
  static const double fractionCanvasHeight = 0.9;
  static const double fractionWidthCheckbox = 0.9;

  @override
  _PddAppState createState() => _PddAppState();
}

class _PddAppState extends State<PddApp> {
  Map<String, List<double>> _mapDepth = {};
  Map<String, Map<int, List<double>>> _mapPdd = {};
  int _nParticle = 0;
  bool _isPhoton = true;
  List<double?> _listCrosshairInfo = [0, 0, 0];
  String _strDose = 'N/A';
  String _strDepth = 'N/A';
  bool _isFixedAxis = false;

  Future<void> initPreferences() async {
    List<dynamic> results = await funcPrefs.readPreferences(context);
    _mapDepth = Map<String, List<double>>.from(results[0]);
    _mapPdd = Map<String, Map<int, List<double>>>.from(results[1]);
    setState(() {});
  }

  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
    ]);
    initPreferences();
    super.initState();
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    super.dispose();
  }

  void resetDefaults() {
    _listCrosshairInfo = [0, 0, 0];
    _strDose = 'N/A';
    _strDepth = 'N/A';
  }

  void gestureFunction(
      dynamic details,
      double canvasHeight,
      double canvasWidth,
      double x0,
      double maxDepthE,
      List<Offset> listCurve,
      List<double> listActiveDepth) {
    double? absX = (details.globalPosition.dx - x0);
    double maxAbsX = (listActiveDepth.last / maxDepthE) * canvasWidth;
    if (!(!_isPhoton && _isFixedAxis && absX! > maxAbsX)) {
      double fractionAbsY =
          (canvasHeight - getCrosshairY(listCurve, absX)) / canvasHeight;
      _listCrosshairInfo = [absX, fractionAbsY, 1];
      fractionAbsY = fractionAbsY > 1 ? 1 : fractionAbsY;
      double maxDepth =
          (!_isPhoton && _isFixedAxis) ? maxDepthE : listActiveDepth.last;
      _strDepth = (absX! * maxDepth / canvasWidth).toStringAsFixed(2);
      _strDose = (fractionAbsY * 100).toStringAsFixed(1);
    }
  }

  @override
  Widget build(BuildContext context) {
    String strParticle = particles.listStrParticle[_nParticle];
    late List<double> listActiveDepth;
    late List<double> listActivePdd;
    late double maxDepthE;
    bool canBuild = false;
    if (_mapDepth.isNotEmpty && _mapPdd.isNotEmpty) {
      listActiveDepth = _mapDepth[strParticle]!;
      listActivePdd = _mapPdd[strParticle]![PddApp.nSize]!;
      maxDepthE = _mapDepth['16E']!
          .reduce((value, element) => maths.max(value, element));
      canBuild = true;
    }

    if (canBuild &&
        MediaQuery.of(context).orientation == Orientation.landscape) {
      int sumFlex = PddApp.listFlex.reduce((value, element) => value + element);
      TextStyle textStyle = Theme.of(context).textTheme.headline1!;
      return SafeArea(
        child: Scaffold(
          body: Row(
            children: [
              Expanded(
                flex: PddApp.listFlex[0],
                child: LayoutBuilder(builder: (context, constraints) {
                  double canvasWidth =
                      constraints.maxWidth * PddApp.fractionCanvasWidth;
                  double canvasHeight =
                      constraints.maxHeight * PddApp.fractionCanvasHeight;
                  Size canvasSize = Size(canvasWidth, canvasHeight);
                  double x0 = MediaQuery.of(context).size.width *
                      PddApp.listFlex[0] /
                      sumFlex *
                      ((1 - PddApp.fractionCanvasWidth) / 2);
                  double x1 = x0 +
                      MediaQuery.of(context).size.width *
                          PddApp.listFlex[0] /
                          sumFlex *
                          PddApp.fractionCanvasWidth;
                  List<Offset> listCurve = getListOffsetCurve(
                      canvasSize,
                      _normList(canvasSize, listActiveDepth, false, _isPhoton,
                          _isFixedAxis, maxDepthE),
                      _normList(canvasSize, listActivePdd, true, _isPhoton,
                          _isFixedAxis, maxDepthE),
                      PddApp.xSkip);
                  return Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      color: Theme.of(context).textTheme.headline1!.color,
                      width: canvasWidth,
                      height: canvasHeight,
                      child: GestureDetector(
                        onHorizontalDragStart: (details) {
                          setState(() {
                            gestureFunction(details, canvasHeight, canvasWidth,
                                x0, maxDepthE, listCurve, listActiveDepth);
                          });
                        },
                        onHorizontalDragUpdate: (details) {
                          if (details.globalPosition.dx > x0 &&
                              details.globalPosition.dx < x1) {
                            setState(() {
                              gestureFunction(
                                  details,
                                  canvasHeight,
                                  canvasWidth,
                                  x0,
                                  maxDepthE,
                                  listCurve,
                                  listActiveDepth);
                            });
                          }
                        },
                        child: CustomPaint(
                          painter: PddPaint(
                              isPhoton: _isPhoton,
                              isFixedAxis: _isFixedAxis,
                              maxDepthE: maxDepthE,
                              listDepth: listActiveDepth,
                              listPdd: listActivePdd,
                              colorAxis: Theme.of(context).primaryColor,
                              colorCrosshair: Colors.blueGrey,
                              listCrosshairInfo: _listCrosshairInfo),
                        ),
                      ),
                    ),
                  );
                }),
              ),
              Expanded(
                flex: PddApp.listFlex[1],
                child: Container(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Text(
                            'Energy:',
                            style: textStyle,
                          ),
                          DropdownButton(
                            value: _nParticle,
                            dropdownColor: Colors.blueGrey,
                            items: particles.listStrParticle
                                .map((e) => DropdownMenuItem(
                                      value:
                                          particles.listStrParticle.indexOf(e),
                                      child: Text(
                                        e + '-PPD',
                                        style: textStyle,
                                      ),
                                    ))
                                .toList(),
                            onChanged: (int? val) {
                              if (val != null) {
                                String strParticle =
                                    particles.listStrParticle[val];
                                setState(() {
                                  _nParticle = val;
                                  _isPhoton =
                                      strParticle[strParticle.length - 1] ==
                                          'X';
                                  resetDefaults();
                                });
                              }
                            },
                          ),
                          Text(
                            'EqSqr (cm):',
                            style: textStyle,
                          ),
                          Text(
                            '10 x 10',
                            style: textStyle,
                          ),
                          Text(
                            'SSD (cm):',
                            style: textStyle,
                          ),
                          Text(
                            '100',
                            style: textStyle,
                          ),
                          LayoutBuilder(builder: (context, constraints) {
                            return (Container(
                              width: constraints.maxWidth *
                                  PddApp.fractionWidthCheckbox,
                              color: _isFixedAxis
                                  ? Theme.of(context).scaffoldBackgroundColor
                                  : Theme.of(context).primaryColor,
                              child: CheckboxListTile(
                                dense: true,
                                contentPadding: EdgeInsets.all(0),
                                value: _isFixedAxis,
                                title: Text(
                                  'Fix axis',
                                  style: Theme.of(context).textTheme.headline1,
                                  textAlign: TextAlign.center,
                                ),
                                onChanged: (checked) {
                                  setState(() {
                                    _isFixedAxis = !_isFixedAxis;
                                    resetDefaults();
                                  });
                                },
                              ),
                            ));
                          }),
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            'Dose (%):',
                            style: textStyle,
                          ),
                          Text(
                            _strDose,
                            style: textStyle,
                          ),
                          RichText(
                            text: TextSpan(
                              style: textStyle,
                              children: [
                                TextSpan(text: 'Depth '),
                                TextSpan(
                                  text: '(${_isPhoton ? 'cm' : 'mm'}):',
                                  style: TextStyle(
                                      fontSize: textStyle.fontSize,
                                      fontWeight: FontWeight.bold,
                                      color: _isPhoton
                                          ? PddApp.colorPhoton
                                          : PddApp.colorElectron),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            _strDepth,
                            style: textStyle,
                          ),
                        ],
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
      return Scaffold();
    }
  }
}

class PddPaint extends CustomPainter {
  final bool? isPhoton;
  final bool? isFixedAxis;
  final double? maxDepthE;
  final List<double>? listDepth;
  final List<double>? listPdd;
  final Color? colorAxis;
  final Color? colorCrosshair;
  final List<double?>? listCrosshairInfo;

  PddPaint(
      {this.isPhoton,
      this.isFixedAxis,
      this.maxDepthE,
      this.listDepth,
      this.listPdd,
      this.colorAxis,
      this.colorCrosshair,
      this.listCrosshairInfo});

  static const double sizeTickLength = 0.02;
  static const double strokeWidthAxis = 3;
  static const double strokeWidthPoints = 8;

  @override
  void paint(Canvas canvas, Size size) {
    double maxDepth =
        (isFixedAxis! && !isPhoton!) ? maxDepthE! : listDepth!.last;

    plt.drawFrame(canvas, size, maxDepth, 10.0, sizeTickLength, colorAxis!,
        strokeWidthAxis);

    //Normalize the list values to the canvas size
    List<double> _normListDepth =
        _normList(size, listDepth, false, isPhoton, isFixedAxis, maxDepthE);
    List<double> _normListPdd =
        _normList(size, listPdd, true, isPhoton, isFixedAxis, maxDepthE);

    //Draw PDD points and curves
    plt.drawPlotPoints(
        canvas,
        size,
        _normListDepth.map((e) => e / size.width).toList(),
        _normListPdd.map((e) => e / size.height).toList(),
        (isPhoton! ? PddApp.colorPhoton : PddApp.colorElectron),
        strokeWidthPoints);
    List<Offset> listCurve =
        getListOffsetCurve(size, _normListDepth, _normListPdd, PddApp.xSkip);
    drawPddCurve(
        canvas,
        listCurve,
        plt.getPaintAxis(
            (isPhoton! ? PddApp.colorPhoton : PddApp.colorElectron),
            strokeWidthAxis));

    //If ready, draw the crosshair
    if (listCrosshairInfo![2] == 1) {
      Paint paintCrosshair = Paint();
      paintCrosshair.color = colorCrosshair!;
      paintCrosshair.style = PaintingStyle.stroke;
      paintCrosshair.strokeWidth = 2;

      canvas.drawLine(
          Offset(listCrosshairInfo![0]!, size.height),
          Offset(listCrosshairInfo![0]!,
              size.height * (1 - listCrosshairInfo![1]!)),
          paintCrosshair);
      canvas.drawLine(
          Offset(0, size.height * (1 - listCrosshairInfo![1]!)),
          Offset(listCrosshairInfo![0]!,
              size.height * (1 - listCrosshairInfo![1]!)),
          paintCrosshair);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

//region General functions
List<double> _normList(Size size, List<double>? list, bool isPdd,
    bool? _isPhoton, bool? isFixedAxis, double? maxDepthE) {
  const int maxPercent = 100;
  if (isPdd) {
    return list!.map((e) => e * size.height / maxPercent).toList();
  } else {
    double? maxDepth = (!_isPhoton! && isFixedAxis!) ? maxDepthE : list!.last;
    return list!.map((e) => e * size.width / maxDepth!).toList();
  }
}

//absX is the absolute x within the canvas
//I will reserve globalX for x within the entire screen
List<Offset> getListOffsetCurve(Size size, List<double> _normListDepth,
    List<double> _normListPdd, int xSkip) {
  int iMax = _normListDepth.length - 2;
  double yMax = size.height;
  double maxAbsX = _normListDepth.last;
  late vec.Vector4 vk;
  List<Offset> listX = [];
  for (int i = 0; i < iMax; i++) {
    double segDx = (_normListDepth[i + 1] - _normListDepth[i]);
    vk = i == 0
        ? getVk0(_normListDepth, _normListPdd)
        : getVk(_normListDepth, _normListPdd, i, vk);
    if (i == 0) {
      for (int relX = 0; relX <= segDx.ceil(); relX += xSkip) {
        double absX = relX + _normListDepth[i];
        listX.add(Offset(absX, yMax - f(vk[0], vk[1], vk[2], vk[3], absX)));
      }
    } else if (i < iMax - 1) {
      for (int relX = 0; relX <= segDx.ceil(); relX += xSkip) {
        double absX = relX + _normListDepth[i];
        listX.add(Offset(absX, yMax - f(vk[0], vk[1], vk[2], vk[3], absX)));
      }
    } else {
      double absX = _normListDepth[i];
      while (absX < maxAbsX) {
        listX.add(Offset(absX, yMax - f(vk[0], vk[1], vk[2], vk[3], absX)));
        absX += xSkip;
      }
    }
  }
  return listX;
}

void drawPddCurve(Canvas canvas, List<Offset> listOffsets, Paint paintCurve) {
  canvas.drawPoints(PointMode.polygon, listOffsets, paintCurve);
}
//endregion General functions

//region Spline functions
double f(double a, double b, double c, double d, double x) {
  return (a + b * x + c * maths.pow(x, 2) + d * maths.pow(x, 3));
}

vec.Matrix4 getMx0(double x0, double x1, double x2, double x3) {
  vec.Vector4 col0 = vec.Vector4(
      maths.pow(x0, 0) as double,
      maths.pow(x0, 1) as double,
      maths.pow(x0, 2) as double,
      maths.pow(x0, 3) as double);
  vec.Vector4 col1 = vec.Vector4(
      maths.pow(x1, 0) as double,
      maths.pow(x1, 1) as double,
      maths.pow(x1, 2) as double,
      maths.pow(x1, 3) as double);
  vec.Vector4 col2 = vec.Vector4(
      maths.pow(x2, 0) as double,
      maths.pow(x2, 1) as double,
      maths.pow(x2, 2) as double,
      maths.pow(x2, 3) as double);
  vec.Vector4 col3 = vec.Vector4(
      maths.pow(x3, 0) as double,
      maths.pow(x3, 1) as double,
      maths.pow(x3, 2) as double,
      maths.pow(x3, 3) as double);
  return vec.Matrix4.columns(col0, col1, col2, col3);
}

vec.Matrix4 getMx(double x0, double x1, double x2) {
  vec.Vector4 col0 =
      vec.Vector4(0, 1, 2 * x0, 3 * (maths.pow(x0, 2) as double));
  vec.Vector4 col1 = vec.Vector4(
      maths.pow(x0, 0) as double,
      maths.pow(x0, 1) as double,
      maths.pow(x0, 2) as double,
      maths.pow(x0, 3) as double);
  vec.Vector4 col2 = vec.Vector4(
      maths.pow(x1, 0) as double,
      maths.pow(x1, 1) as double,
      maths.pow(x1, 2) as double,
      maths.pow(x1, 3) as double);
  vec.Vector4 col3 = vec.Vector4(
      maths.pow(x2, 0) as double,
      maths.pow(x2, 1) as double,
      maths.pow(x2, 2) as double,
      maths.pow(x2, 3) as double);
  return vec.Matrix4.columns(col0, col1, col2, col3);
}

vec.Vector4 getVk0(List<double> listX, List<double> listY) {
  vec.Vector4 vY0 = vec.Vector4(listY[0], listY[1], listY[2], listY[3]);
  vec.Matrix4 mX0 = getMx0(listX[0], listX[1], listX[2], listX[3]);
  vec.Matrix4 imX0 = vec.Matrix4.inverted(mX0);
  vY0.applyMatrix4(imX0.transposed());
  return vY0;
}

vec.Vector4 getVk(
    List<double> listX, List<double> listY, int i, vec.Vector4 vk0) {
  vec.Vector4 vYprime = vec.Vector4(
      (vk0[1] + 2 * vk0[2] * listX[i] + 3 * vk0[3] * maths.pow(listX[i], 2)),
      listY[i],
      listY[i + 1],
      listY[i + 2]);
  vec.Matrix4 mX = getMx(listX[i], listX[i + 1], listX[i + 2]);
  vec.Matrix4 imX = vec.Matrix4.inverted(mX);
  vYprime.applyMatrix4(imX.transposed());
  return vYprime;
}
//endregion Spline functions

//region Update functions
double getCrosshairY(List<Offset> listCurve, double? absX) {
  List<double> listDx = listCurve.map((e) => (e.dx - absX!).abs()).toList();
  double minDx = listDx.reduce((value, element) => maths.min(value, element));
  int argMin = listDx.indexOf(minDx);
  return listCurve[argMin].dy;
}
//endregion Update function

import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rad_onc_project/functions/draw_plot.dart' as plt;
import 'package:vector_math/vector_math.dart' as vec;
import 'package:rad_onc_project/data/particle_data.dart' as particles;

const int xSkip = 1;
const Color colorPhoton = Colors.pink;
const Color colorElectron = Colors.indigoAccent;

class PddApp extends StatefulWidget {
  static const routeName = '/pdd-app';

  @override
  _PddAppState createState() => _PddAppState();
}

class _PddAppState extends State<PddApp> {
  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
    ]);
    super.initState();
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    super.dispose();
  }

  //region listValues
  //Photon data
  Map<double, double> map6X = Map.fromIterables(particles.mapDefaultDepth['6X']!, particles.mapDefaultPdd['6X']!);
  Map<double, double> map10X = Map.fromIterables(particles.mapDefaultDepth['10X']!, particles.mapDefaultPdd['10X']!);
  Map<double, double> map15X = Map.fromIterables(particles.mapDefaultDepth['15X']!, particles.mapDefaultPdd['15X']!);

  //Electron data
  Map<double, double> map6E = Map.fromIterables(particles.mapDefaultDepth['6E']!, particles.mapDefaultPdd['6E']!);
  Map<double, double> map9E = Map.fromIterables(particles.mapDefaultDepth['9E']!, particles.mapDefaultPdd['9E']!);
  Map<double, double> map12E = Map.fromIterables(particles.mapDefaultDepth['12E']!, particles.mapDefaultPdd['12E']!);
  Map<double, double> map16E = Map.fromIterables(particles.mapDefaultDepth['16E']!, particles.mapDefaultPdd['16E']!);

  //endregion listValues

  static const List<int> listFlex = [15, 5];
  int sumFlex = listFlex.reduce((value, element) => value + element);
  static const double fractionCanvasWidth = 0.95;
  static const double fractionCanvasHeight = 0.9;
  static const double fractionWidthCheckbox = 0.9;
  bool _isFixedAxis = false;
  double? maxDepthE;

  int? valueDrop = 0;
  bool isPhoton = true;
  List<double?> listCrosshairInfo = [0, 0, 0];
  String strDose = 'N/A';
  String strDepth = 'N/A';

  void resetDefaults() {
    listCrosshairInfo = [0, 0, 0];
    strDose = 'N/A';
    strDepth = 'N/A';
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
    if (!(!isPhoton && _isFixedAxis && absX! > maxAbsX)) {
      double fractionAbsY =
          (canvasHeight - getCrosshairY(listCurve, absX)) / canvasHeight;
      listCrosshairInfo = [absX, fractionAbsY, 1];
      fractionAbsY = fractionAbsY > 1 ? 1 : fractionAbsY;
      double maxDepth =
          (!isPhoton && _isFixedAxis) ? maxDepthE : listActiveDepth.last;
      strDepth = (absX! * maxDepth / canvasWidth).toStringAsFixed(2);
      strDose = (fractionAbsY * 100).toStringAsFixed(1);
    }
  }

  @override
  Widget build(BuildContext context) {
    maxDepthE =
        map16E.keys.toList().reduce((value, element) => max(value, element));
    if (MediaQuery.of(context).orientation == Orientation.landscape) {
      TextStyle textStyle = Theme.of(context).textTheme.headline1!;
      return SafeArea(
        child: Scaffold(
          body: Row(
            children: [
              Expanded(
                flex: listFlex[0],
                child: LayoutBuilder(builder: (context, constraints) {
                  double canvasWidth =
                      constraints.maxWidth * fractionCanvasWidth;
                  double canvasHeight =
                      constraints.maxHeight * fractionCanvasHeight;
                  Size canvasSize = Size(canvasWidth, canvasHeight);
                  double x0 = MediaQuery.of(context).size.width *
                      listFlex[0] /
                      sumFlex *
                      ((1 - fractionCanvasWidth) / 2);
                  double x1 = x0 +
                      MediaQuery.of(context).size.width *
                          listFlex[0] /
                          sumFlex *
                          fractionCanvasWidth;
                  List<double>? listActiveDepth;
                  List<double>? listActivePdd;
                  switch (valueDrop) {
                    case 0:
                      {
                        listActiveDepth = map6X.keys.toList();
                        listActivePdd = map6X.values.toList();
                      }
                      break;
                    case 1:
                      {
                        listActiveDepth = map10X.keys.toList();
                        listActivePdd = map10X.values.toList();
                      }
                      break;
                    case 2:
                      {
                        listActiveDepth = map15X.keys.toList();
                        listActivePdd = map15X.values.toList();
                      }
                      break;
                    case 3:
                      {
                        listActiveDepth = map6E.keys.toList();
                        listActivePdd = map6E.values.toList();
                      }
                      break;
                    case 4:
                      {
                        listActiveDepth = map9E.keys.toList();
                        listActivePdd = map9E.values.toList();
                      }
                      break;
                    case 5:
                      {
                        listActiveDepth = map12E.keys.toList();
                        listActivePdd = map12E.values.toList();
                      }
                      break;
                    case 6:
                      {
                        listActiveDepth = map16E.keys.toList();
                        listActivePdd = map16E.values.toList();
                      }
                      break;
                  }
                  List<Offset> listCurve = getListOffsetCurve(
                      canvasSize,
                      _normList(canvasSize, listActiveDepth, false, isPhoton,
                          _isFixedAxis, maxDepthE),
                      _normList(canvasSize, listActivePdd, true, isPhoton,
                          _isFixedAxis, maxDepthE),
                      xSkip);
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
                                x0, maxDepthE!, listCurve, listActiveDepth!);
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
                                  maxDepthE!,
                                  listCurve,
                                  listActiveDepth!);
                            });
                          }
                        },
                        child: CustomPaint(
                          painter: PddPaint(
                              isPhoton: isPhoton,
                              isFixedAxis: _isFixedAxis,
                              maxDepthE: maxDepthE,
                              listDepth: listActiveDepth,
                              listPdd: listActivePdd,
                              colorAxis: Theme.of(context).primaryColor,
                              colorCrosshair: Theme.of(context).backgroundColor,
                              listCrosshairInfo: listCrosshairInfo),
                        ),
                      ),
                    ),
                  );
                }),
              ),
              Expanded(
                flex: listFlex[1],
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
                            value: valueDrop,
                            dropdownColor: Theme.of(context).backgroundColor,
                            items: [
                              DropdownMenuItem(
                                value: 0,
                                child: Text(
                                  '6X PDD',
                                  style: textStyle,
                                ),
                              ),
                              DropdownMenuItem(
                                value: 1,
                                child: Text(
                                  '10X PDD',
                                  style: textStyle,
                                ),
                              ),
                              DropdownMenuItem(
                                value: 2,
                                child: Text(
                                  '15X PDD',
                                  style: textStyle,
                                ),
                              ),
                              DropdownMenuItem(
                                value: 3,
                                child: Text(
                                  '6E PDD',
                                  style: textStyle,
                                ),
                              ),
                              DropdownMenuItem(
                                value: 4,
                                child: Text(
                                  '9E PDD',
                                  style: textStyle,
                                ),
                              ),
                              DropdownMenuItem(
                                value: 5,
                                child: Text(
                                  '12E PDD',
                                  style: textStyle,
                                ),
                              ),
                              DropdownMenuItem(
                                value: 6,
                                child: Text(
                                  '16E PDD',
                                  style: textStyle,
                                ),
                              ),
                            ],
                            onChanged: (int? val) {
                              setState(() {
                                valueDrop = val;
                                isPhoton = valueDrop! <= 2 ? true : false;
                                resetDefaults();
                              });
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
                              width:
                                  constraints.maxWidth * fractionWidthCheckbox,
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
                            strDose,
                            style: textStyle,
                          ),
                          RichText(
                            text: TextSpan(
                              style: textStyle,
                              children: [
                                TextSpan(text: 'Depth '),
                                TextSpan(
                                  text: '(${isPhoton ? 'cm' : 'mm'}):',
                                  style: TextStyle(
                                      fontSize: textStyle.fontSize,
                                      fontWeight: FontWeight.bold,
                                      color: isPhoton
                                          ? colorPhoton
                                          : colorElectron),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            strDepth,
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
    double maxDepth = (isFixedAxis! && !isPhoton!) ? maxDepthE! : listDepth!.last;

    plt.drawFrame(canvas, size, maxDepth, 10.0, sizeTickLength, colorAxis!, strokeWidthAxis);

    //Normalize the list values to the canvas size
    List<double> _normListDepth =
        _normList(size, listDepth, false, isPhoton, isFixedAxis, maxDepthE);
    List<double> _normListPdd =
        _normList(size, listPdd, true, isPhoton, isFixedAxis, maxDepthE);

    //Draw PDD points and curves
    plt.drawPlotPoints(canvas, size, _normListDepth.map((e) => e/size.width).toList(), _normListPdd.map((e) => e/size.height).toList(), (isPhoton! ? colorPhoton : colorElectron), strokeWidthPoints);
    List<Offset> listCurve =
        getListOffsetCurve(size, _normListDepth, _normListPdd, xSkip);
    drawPddCurve(canvas, listCurve, plt.getPaintAxis((isPhoton! ? colorPhoton : colorElectron), strokeWidthAxis));

    //If ready, draw the crosshair
    if (listCrosshairInfo![2] == 1) {
      Paint paintCrosshair = Paint();
      paintCrosshair.color = colorCrosshair!;
      paintCrosshair.style = PaintingStyle.stroke;
      paintCrosshair.strokeWidth = 2;

      canvas.drawLine(
          Offset(listCrosshairInfo![0]!, size.height),
          Offset(
              listCrosshairInfo![0]!, size.height * (1 - listCrosshairInfo![1]!)),
          paintCrosshair);
      canvas.drawLine(
          Offset(0, size.height * (1 - listCrosshairInfo![1]!)),
          Offset(
              listCrosshairInfo![0]!, size.height * (1 - listCrosshairInfo![1]!)),
          paintCrosshair);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

//region General functions
List<double> _normList(Size size, List<double>? list, bool isPdd, bool? isPhoton,
    bool? isFixedAxis, double? maxDepthE) {
  const int maxPercent = 100;
  if (isPdd) {
    return list!.map((e) => e * size.height / maxPercent).toList();
  } else {
    double? maxDepth = (!isPhoton! && isFixedAxis!) ? maxDepthE : list!.last;
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
  return (a + b * x + c * pow(x, 2) + d * pow(x, 3));
}

vec.Matrix4 getMx0(double x0, double x1, double x2, double x3) {
  vec.Vector4 col0 =
      vec.Vector4(pow(x0, 0) as double, pow(x0, 1) as double, pow(x0, 2) as double, pow(x0, 3) as double);
  vec.Vector4 col1 =
      vec.Vector4(pow(x1, 0) as double, pow(x1, 1) as double, pow(x1, 2) as double, pow(x1, 3) as double);
  vec.Vector4 col2 =
      vec.Vector4(pow(x2, 0) as double, pow(x2, 1) as double, pow(x2, 2) as double, pow(x2, 3) as double);
  vec.Vector4 col3 =
      vec.Vector4(pow(x3, 0) as double, pow(x3, 1) as double, pow(x3, 2) as double, pow(x3, 3) as double);
  return vec.Matrix4.columns(col0, col1, col2, col3);
}

vec.Matrix4 getMx(double x0, double x1, double x2) {
  vec.Vector4 col0 = vec.Vector4(0, 1, 2 * x0, 3 * (pow(x0, 2) as double));
  vec.Vector4 col1 =
      vec.Vector4(pow(x0, 0) as double, pow(x0, 1) as double, pow(x0, 2) as double, pow(x0, 3) as double);
  vec.Vector4 col2 =
      vec.Vector4(pow(x1, 0) as double, pow(x1, 1) as double, pow(x1, 2) as double, pow(x1, 3) as double);
  vec.Vector4 col3 =
      vec.Vector4(pow(x2, 0) as double, pow(x2, 1) as double, pow(x2, 2) as double, pow(x2, 3) as double);
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
      (vk0[1] + 2 * vk0[2] * listX[i] + 3 * vk0[3] * pow(listX[i], 2)),
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
  double minDx = listDx.reduce((value, element) => min(value, element));
  int argMin = listDx.indexOf(minDx);
  return listCurve[argMin].dy;
}
//endregion Update function

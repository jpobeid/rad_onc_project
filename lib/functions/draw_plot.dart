import 'dart:ui';

import 'dart:math';
import 'package:flutter/material.dart';

//region paints
Paint getPaintAxis(Color colorAxis, double strokeWidthAxis) {
  Paint paintAxis = Paint();
  paintAxis.color = colorAxis;
  paintAxis.style = PaintingStyle.stroke;
  paintAxis.strokeWidth = strokeWidthAxis;
  return paintAxis;
}

Paint getPaintPoints(Color colorPoints, double strokeWidthPoints) {
  Paint paintPoints = Paint();
  paintPoints.color = colorPoints;
  paintPoints.style = PaintingStyle.stroke;
  paintPoints.strokeCap = StrokeCap.round;
  paintPoints.strokeWidth = strokeWidthPoints;
  return paintPoints;
}

Paint getPaintCurve(Color colorCurve, double strokeWidthCurve) {
  Paint paintAxis = Paint();
  paintAxis.color = colorCurve;
  paintAxis.style = PaintingStyle.stroke;
  paintAxis.strokeWidth = strokeWidthCurve;
  return paintAxis;
}

Paint getPaintCrosshairs(Color colorCrosshairs, double strokeWidthCrosshairs) {
  Paint paintCrosshairs = Paint();
  paintCrosshairs.color = colorCrosshairs;
  paintCrosshairs.style = PaintingStyle.stroke;
  paintCrosshairs.strokeWidth = strokeWidthCrosshairs;
  return paintCrosshairs;
}
//endregion paints

//region frame
void drawFrame(Canvas canvas, Size size, double maxX, double nTicksY,
    double sizeTickLength, Color colorAxis, double strokeWidthAxis) {
  //Generate the paints
  Paint paintAxis = getPaintAxis(colorAxis, strokeWidthAxis);

  //Draw the axes
  canvas.drawPoints(PointMode.points, [Offset(0, 0)], paintAxis);
  canvas.drawLine(Offset(0, 0), Offset(0, size.height), paintAxis);
  canvas.drawLine(
      Offset(0, size.height), Offset(size.width, size.height), paintAxis);

  //Draw the ticks
  int nTicksX = maxX.floor();
  double sizeTick = min(size.width, size.height) * sizeTickLength;
  for (int i = 0; i <= nTicksX; i++) {
    double w = i * (size.width / maxX);
    canvas.drawLine(
        Offset(w, size.height - sizeTick), Offset(w, size.height), paintAxis);
  }
  for (int j = 1; j <= nTicksY; j++) {
    double h = size.height - j * (size.height / nTicksY);
    canvas.drawLine(Offset(0, h), Offset(sizeTick, h), paintAxis);
  }
}
//endregion frame

//region list functions and points/curve
List<double> getNormList(List<double>? list, bool isZeroed) {
  if (isZeroed) {
    double minElement = list!.reduce((value, element) => min(value, element));
    List<double> listZeroed = list.map((e) => e - minElement).toList();
    double maxElement =
        listZeroed.reduce((value, element) => max(value, element));
    return listZeroed.map((e) => e / maxElement).toList();
  } else {
    double maxElement = list!.reduce((value, element) => max(value, element));
    return list.map((e) => e / maxElement).toList();
  }
}

List<Offset> getListOffsets(
    Size size, List<double> normListX, List<double> normListY) {
  List<Offset> listOffsets = [];
  normListX = normListX.map((e) => e * size.width).toList();
  normListY = normListY.map((e) => e * size.height).toList();
  int i1 = 0;
  normListX.forEach((element) {
    listOffsets.add(Offset(element, size.height - normListY[i1]));
    i1++;
  });
  return listOffsets;
}

void drawPlotPoints(Canvas canvas, Size size, List<double> normListX,
    List<double> normListY, Color colorPoints, double strokeWidthPoints) {
  //Generate the paints
  Paint paintPoints = getPaintPoints(colorPoints, strokeWidthPoints);

  //Draw the points
  canvas.drawPoints(PointMode.points,
      getListOffsets(size, normListX, normListY), paintPoints);
}

void drawPlotCurve(Canvas canvas, Size size, int nPoints, Paint paintCurve,
    Function? fX, var normArgs) {
  List<double> normSeqX = [];
  List<double> seqFx;
  for (int i = 0; i <= nPoints; i++) {
    normSeqX.add(i / nPoints);
  }
  if (normArgs == null) {
    seqFx = List<double>.from(normSeqX.map((e) => fX!(e)).toList());
  } else {
    seqFx = List<double>.from(normSeqX.map((e) => fX!(normArgs, e)).toList());
  }
  canvas.drawPoints(
      PointMode.lines, getListOffsets(size, normSeqX, seqFx), paintCurve);
}
//endregion list functions and points/curve

//region crosshairs
void drawCrosshairs(
    Canvas canvas,
    Size size,
    Paint paintCrosshairs,
    Paint paintPoints,
    double absX,
    double absYd,
    double toDraw,
    List<String>? listDisplayCoordinates) {
  bool check2 = absYd < 0 ? false : true;
  if (toDraw == 1&&check2) {
    List<Offset> listCrosshairPoints = [
      Offset(0, absYd),
      Offset(absX, absYd),
      Offset(absX, size.height),
    ];
    canvas.drawLine(
        listCrosshairPoints[0], listCrosshairPoints[1], paintCrosshairs);
    canvas.drawPoints(PointMode.points, listCrosshairPoints, paintPoints);
    canvas.drawLine(
        listCrosshairPoints[1], listCrosshairPoints[2], paintCrosshairs);
    if (listDisplayCoordinates![2] == 'true') {
      TextPainter textX = TextPainter(
        text: TextSpan(
            text: ' ${listDisplayCoordinates[0]} ',
            style: TextStyle(
                color: paintCrosshairs.color, fontWeight: FontWeight.bold)),
        textAlign: TextAlign.end,
        textDirection: TextDirection.ltr,
      );
      TextPainter textY = TextPainter(
        text: TextSpan(
            text: ' ${listDisplayCoordinates[1]} ',
            style: TextStyle(
                color: paintCrosshairs.color, fontWeight: FontWeight.bold)),
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr,
      );
      textX.layout();
      textY.layout();
      textX.paint(
          canvas,
          Offset(absX / 2,
              absYd > size.height / 2 ? absYd - textX.height : absYd));
      textY.paint(
          canvas,
          Offset(absX > size.width / 2 ? absX - textY.width : absX,
              absYd + (size.height - absYd) / 2));
    }
  }
}
//endregion crosshairs

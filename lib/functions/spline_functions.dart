import 'dart:math' as maths;
import 'package:flutter/cupertino.dart';
import 'package:vector_math/vector_math_64.dart';

Vector4 getConstants(List<double> listX, List<double> listY) {
  Vector4 vecY = Vector4.array(listY);
  Matrix4 matX = Matrix4.columns(
      Vector4(1, 1, 1, 1),
      Vector4(listX[0], listX[1], listX[2], listX[3]),
      Vector4(
          maths.pow(listX[0], 2).toDouble(),
          maths.pow(listX[1], 2).toDouble(),
          maths.pow(listX[2], 2).toDouble(),
          maths.pow(listX[3], 2).toDouble()),
      Vector4(
          maths.pow(listX[0], 3).toDouble(),
          maths.pow(listX[1], 3).toDouble(),
          maths.pow(listX[2], 3).toDouble(),
          maths.pow(listX[3], 3).toDouble()));
  vecY.applyMatrix4(Matrix4.inverted(matX));
  return vecY;
}

double getInterpolatedY(Vector4 vecConstants, double x){
  return vecConstants[0] + vecConstants[1] * x + vecConstants[2] * maths.pow(x, 2) + vecConstants[3] * maths.pow(x, 3);
}

Map<double, double> filterMapDensity(Map<double, double> mapInput) {
  int nLengthThreshold = 60;
  if (mapInput.length > nLengthThreshold) {
    List<double> listDepth = mapInput.keys.toList();
    //Basic model!! ####
    while (listDepth.length > nLengthThreshold) {
      listDepth.retainWhere((element) => listDepth.indexOf(element) % 2 == 0);
    }
    mapInput.removeWhere((key, value) => !listDepth.contains(key));
    return mapInput;
  } else {
    return mapInput;
  }
}
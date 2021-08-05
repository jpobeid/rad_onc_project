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

double getInterpolatedY(Vector4 vecConstants, double x) {
  return vecConstants[0] +
      vecConstants[1] * x +
      vecConstants[2] * maths.pow(x, 2) +
      vecConstants[3] * maths.pow(x, 3);
}

double? getInterpolatedNFromLists(
    List<double> listX, List<double> listY, double x) {
  int i = listX.indexWhere((element) => element > x);
  if (i >= 2 && i <= listX.length - 2) {
    Vector4 vecConstants = getConstants(
        [listX[i - 2], listX[i - 1], listX[i], listX[i + 1]],
        [listY[i - 2], listY[i - 1], listY[i], listY[i + 1]]);
    return getInterpolatedY(vecConstants, x);
  } else if (i == 1) {
    Vector4 vecConstants = getConstants(
        [listX[i - 1], listX[i], listX[i + 1], listX[i + 2]],
        [listY[i - 1], listY[i], listY[i + 1], listY[i + 2]]);
    return getInterpolatedY(vecConstants, x);
  } else if (i == listX.length - 1) {
    Vector4 vecConstants = getConstants(
        [listX[i - 3], listX[i - 2], listX[i - 1], listX[i]],
        [listY[i - 3], listY[i - 2], listY[i - 1], listY[i]]);
    return getInterpolatedY(vecConstants, x);
  } else {
    return null;
  }
}

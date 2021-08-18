import 'dart:math' as maths;

import './find_roots.dart' as roots;
import './least_squares_line.dart' as lsqr;

class Metrics {
  Function fX;
  List<double> args;
  num elapsedDays;
  String unitTime;
  late double elapsedTimeConverted;
  late double averageVelocity;

  Metrics(
      {required this.fX,
        required this.args,
        required this.elapsedDays,
        required this.unitTime}) {
    this.elapsedTimeConverted = convertElapsedTime(this.elapsedDays.toDouble(), this.unitTime);
    this.averageVelocity = _getAvgVelocity();
  }

  static double convertElapsedTime(double elapsedDays, String unitTime) {
    double dt = elapsedDays.toDouble();
    if (unitTime == 'Months') {
      dt = dt * (12 / 365);
    } else if (unitTime == 'Years') {
      dt = dt / (365);
    }
    return dt;
  }

  double _getAvgVelocity() {
    if (this.fX == roots.fExp) {
      return (args[0] / this.elapsedTimeConverted) *
          (maths.exp(args[1] * this.elapsedTimeConverted) - 1);
    } else {
      return args[0] * (this.elapsedDays / this.elapsedTimeConverted);
    }
  }

  double getScalingTime(int indexScale, List<double> scaleValues) {
    //Must be the case that if beta/m>0:N>1 and that if beta/m<0:N<1
    int indexStart =
    (this.fX == roots.fExp ? this.args[1] >= 0 : this.args[0] >= 0)
        ? 0
        : (scaleValues.length / 2).floor();
    double N = scaleValues[indexStart + indexScale];
    double tNx;
    if (this.fX == roots.fExp) {
      tNx = maths.log(N) / this.args[1];
    } else {
      //This is an average tNx! Also equal to mid-line tNx since this changes with X in the linear case
      tNx = (N - 1) * (this.elapsedDays / 2 + this.args[1] / this.args[0]);
      tNx = convertElapsedTime(tNx, this.unitTime);
    }
    return tNx;
  }

  double getMeanSquaredError(List<double> listX, List<double>? listY) {
    List<double> listPredictedY;
    if (this.fX == lsqr.fLine) {
      listPredictedY =
      List<double>.from(listX.map((e) => this.fX(this.args, e)).toList());
    } else {
      double betaDays = this.args[1] * (this.elapsedTimeConverted / this.elapsedDays);
      listPredictedY = List<double>.from(
          listX.map((e) => this.fX([this.args[0], betaDays], e)).toList());
    }
    double sumDy = 0;
    int i = 0;
    listPredictedY.forEach((element) {
      sumDy += maths.pow((element - listY![i]), 2);
      i++;
    });
    return sumDy / listX.length;
  }
}
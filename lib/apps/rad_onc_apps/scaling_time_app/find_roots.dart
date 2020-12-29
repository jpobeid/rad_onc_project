import 'dart:math' as math;

double fExp(List<double> args, double x) {
  double a = args[0];
  double b = args[1];
  return a * math.exp(b * x);
}

List<double> getNormList(List<double> list, bool isZeroed) {
  if (!isZeroed) {
    double maxValue = list.reduce((value, element) => math.max(value, element));
    return list.map((e) => e / maxValue).toList();
  } else {
    double minValue = list.reduce((value, element) => math.min(value, element));
    List<double> listZeroed = list.map((e) => e - minValue).toList();
    double maxValue =
        listZeroed.reduce((value, element) => math.max(value, element));
    return listZeroed.map((e) => e / maxValue).toList();
  }
}

double getBetaPrime(List<double> normListX, List<double> normListY) {
  double netSum = 0;
  for (int i = 1; i < normListX.length; i++) {
    netSum += math.log(normListY[i] / normListY[0]) / normListX[i];
  }
  return netSum / (normListX.length - 1);
}

double tuneNormBeta(
    double betaPrime, List<double> normListX, List<double> normListY) {
  const epsilon0 = 5;
  List<double> listDifference = [];
  int epsilon;
  if(betaPrime.abs()>2.5){
    epsilon = (betaPrime * 2).abs().round();
  } else {
    epsilon = epsilon0;
  }
  double sizeStep = 0.0001;
  List<double> seqTuning = [];
  for (int i = (-epsilon / sizeStep).floor();
      i < (epsilon / sizeStep).ceil();
      i++) {
    seqTuning.add(i * sizeStep);
  }
  for (double b in seqTuning) {
    double sumExp = normListX
        .map((e) => fExp([normListY[0], b], e))
        .reduce((value, element) => value + element);
    double sumY = normListY.reduce((value, element) => value + element);
    listDifference.add((sumExp - sumY).abs());
  }
  double minDifference =
      listDifference.reduce((value, element) => math.min(value, element));
  return seqTuning[listDifference.indexOf(minDifference)];
}

double getBeta(double normBeta, double dt) {
  return normBeta / dt;
}
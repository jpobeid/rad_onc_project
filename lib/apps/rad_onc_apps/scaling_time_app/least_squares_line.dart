import 'dart:math' as math;

double fLine(List<double> args, double x){
  double m = args[0];
  double b = args[1];
  return m*x+b;
}

double getB(List<double> listX, List<double> listY){
  int N = listX.length;
  List<double> listXY = [];
  int i = 0;
  listX.forEach((element) {
    listXY.add(element*listY[i]);
    i++;
  });
  double sumX = listX.reduce((value, element) => value+element);
  double sumX2 = listX.map((e) => math.pow(e, 2)).reduce((value, element) => value+element) as double;
  double sumY = listY.reduce((value, element) => value+element);
  double sumXY = listXY.reduce((value, element) => value+element);
  double numerator = sumXY-(sumY/sumX)*sumX2;
  double denominator = sumX-N*(sumX2/sumX);
  return numerator/denominator;
}

double getM(List<double> listX, List<double> listY, double b){
  int N = listX.length;
  double sumX = listX.reduce((value, element) => value+element);
  double meanY = listY.reduce((value, element) => value+element)/N;
  return (N/sumX)*(meanY-b);
}
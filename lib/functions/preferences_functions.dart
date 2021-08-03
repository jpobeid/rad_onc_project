import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rad_onc_project/data/particle_data.dart' as particles;
import 'package:csv/csv.dart' as csv;

Map<String, List<double>> transposeToMap(
    List<List<dynamic>> matrixInput, int indexKeys) {
  List<String> keys = matrixInput[indexKeys].map((e) => e.toString()).toList();
  int nRowsOut = keys.length;
  matrixInput.removeAt(indexKeys);
  List<List<double>> matrixOutput = [];
  int nColsOut = matrixInput.length;
  List<double> listOutRow;
  for (int i = 0; i < nRowsOut; i++) {
    listOutRow = [];
    for (int j = 0; j < nColsOut; j++) {
      listOutRow.add((matrixInput[j][i]).toDouble());
    }
    matrixOutput.add(listOutRow);
  }
  Map<String, List<double>> mapOutput = {};
  matrixOutput.forEach((element) {
    mapOutput.addAll({keys[matrixOutput.indexOf(element)]: element});
  });
  return mapOutput;
}

Future<Map<String, List<double>>?> loadDefaults(BuildContext context) async {
  String strData =
      await DefaultAssetBundle.of(context).loadString('assets/PDD_6X.csv');
  if (strData.isNotEmpty) {
    return transposeToMap(csv.CsvToListConverter().convert(strData), 0);
  } else {
    return null;
  }
}

Future<List> readPreferences(BuildContext context) async {
  bool isAlreadyStored = false;
  Map<String, List<double>>? csvDefault;
  csvDefault = await loadDefaults(context);
  print(csvDefault);
  SharedPreferences prefs = await SharedPreferences.getInstance();
  // Depth initialize or read
  Map<String, List<double>> mapDepth = {};
  for (String e in particles.listStrParticle) {
    // String strKey = 'depth' + e;
    // List<double> listDepth;
    // if (!prefs.getKeys().any((element) => element == strKey)) {
    //   listDepth = particles.mapDefaultDepth[e]!;
    //   mapDepth.addAll({e: listDepth});
    //   prefs.setStringList(strKey, listDepth.map((e) => e.toString()).toList());
    // } else {
    //   isAlreadyStored = true;
    //   listDepth =
    //       prefs.getStringList(strKey)!.map((e) => double.parse(e)).toList();
    //   mapDepth.addAll({e: listDepth});
    // }
  }
  // PDD initialize or read
  Map<String, Map<int, List<double>>> mapPdd = {};
  for (String eParticle in particles.listStrParticle) {
    // String keyParticle = 'pdd' + eParticle;
    // List<int> keysSize = particles.mapDefaultPdd[eParticle]!.keys.toList();
    // for (int eSize in keysSize) {
    //   String keyPreference = keyParticle + '-' + eSize.toString();
    //   late List<double> pddValues;
    //   if (!prefs.getKeys().any((element) => element == keyPreference)) {
    //     pddValues = particles.mapDefaultPdd[eParticle]![eSize]!;
    //     prefs.setStringList(
    //         keyPreference, pddValues.map((e) => e.toString()).toList());
    //   } else {
    //     isAlreadyStored = true;
    //     pddValues = prefs
    //         .getStringList(keyPreference)!
    //         .map((e) => double.parse(e))
    //         .toList();
    //   }
    //   if (mapPdd[eParticle] == null) {
    //     mapPdd.addAll({
    //       eParticle: {eSize: pddValues}
    //     });
    //   } else {
    //     mapPdd[eParticle]!.addAll({eSize: pddValues});
    //   }
    // }
  }
  return [isAlreadyStored, mapDepth, mapPdd];
}

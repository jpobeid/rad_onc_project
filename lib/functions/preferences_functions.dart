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

Future<Map<String, Map<String, List<double>>>> loadDefaults(
    BuildContext context) async {
  Map<String, Map<String, List<double>>> mapPdd = {};
  for (String particle in particles.listStrParticle) {
    String strPath = 'assets/PDD_$particle.csv';
    String strData = await DefaultAssetBundle.of(context).loadString(strPath);
    mapPdd.addAll({
      particle: transposeToMap(csv.CsvToListConverter().convert(strData), 0)
    });
  }
  return mapPdd;
}

String makePreferenceKey(String particle, String fieldSize) {
  return 'pdd' + particle + '_' + fieldSize;
}

Future<List> readPreferences(BuildContext context) async {
  bool isAlreadyStored = false;
  late Map<String, Map<String, List<double>>> mapPddDefault;
  mapPddDefault = await loadDefaults(context);
  SharedPreferences prefs = await SharedPreferences.getInstance();
  // PDD & Depth initialize or read
  Map<String, Map<String, List<double>>> mapPdd = {};
  for (String particle in particles.listStrParticle) {
    //Loop through all particles in the larger Map
    List<String> sizeKeys = mapPddDefault[particle]!.keys.toList();
    for (String strSize in sizeKeys) {
      //For each particle, loop through depth and sizes arrays
      String preferenceKey = makePreferenceKey(particle, strSize);
      late List<double> listValues;
      if (!prefs.getKeys().any((element) => element == preferenceKey)) {
        //Shared preferences does NOT yet exist, so need to make it as well as assign default values
        listValues = mapPddDefault[particle]![strSize]!;
        prefs.setStringList(
            preferenceKey, listValues.map((e) => e.toString()).toList());
      } else {
        //Shared preferences exist, so need to load the values
        isAlreadyStored = true;
        listValues = prefs
            .getStringList(preferenceKey)!
            .map((e) => double.parse(e))
            .toList();
      }
      if (mapPdd[particle] == null) {
        //Add first instance
        mapPdd.addAll({
          particle: {strSize: listValues}
        });
      } else {
        mapPdd[particle]!.addAll({strSize: listValues});
      }
    }
  }
  return [isAlreadyStored, mapPdd];
}

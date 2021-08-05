import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rad_onc_project/data/particle_data.dart' as particles;
import 'package:csv/csv.dart' as csv;

Map<String, List<double?>> transposeToMap(
    List<List<dynamic>> matrixInput, int indexKeys) {
  List<String> keys = matrixInput[indexKeys].map((e) => e.toString()).toList();
  int nRowsOut = keys.length;
  matrixInput.removeAt(indexKeys);
  List<List<double?>> matrixOutput = [];
  int nColsOut = matrixInput.length;
  List<double?> listOutRow;
  for (int i = 0; i < nRowsOut; i++) {
    listOutRow = [];
    for (int j = 0; j < nColsOut; j++) {
      if (matrixInput[j][i].runtimeType != String) {
        listOutRow.add((matrixInput[j][i]).toDouble());
      } else {
        listOutRow.add(null);
      }
    }
    matrixOutput.add(listOutRow);
  }
  Map<String, List<double?>> mapOutput = {};
  matrixOutput.forEach((element) {
    mapOutput.addAll({keys[matrixOutput.indexOf(element)]: element});
  });
  return mapOutput;
}

Future<Map<String, Map<String, List<double?>>>> loadDefaults(
    BuildContext context) async {
  Map<String, Map<String, List<double?>>> mapPdd = {};
  for (String particle in particles.listStrParticle) {
    String strPath = 'assets/PDD_$particle.csv';
    String strData = await DefaultAssetBundle.of(context).loadString(strPath);
    mapPdd.addAll({
      particle: transposeToMap(csv.CsvToListConverter().convert(strData), 0)
    });
  }
  return mapPdd;
}

List<List<double>> filterLists(
    List<double?> listDepths, List<double?> listValues) {
  List<int> toRemove = [];
  for (int i = 0; i < listValues.length; i++) {
    if (listValues[i] == null) {
      toRemove.add(i);
    }
  }
  toRemove.reversed.forEach((element) {
    listDepths.removeAt(element);
    listValues.removeAt(element);
  });
  return [
    listDepths.map((e) => e!).toList(),
    listValues.map((e) => e!).toList()
  ];
}

String makePreferenceKey(
    String particle, String fieldSize, List<dynamic> listDepthMaterials) {
  //Example format: pdd6X_10 or pdd6X_10_cm
  //Therefore listDepthMaterials accepts [bool isDepth, String unitsDepth]
  String prefixKey = 'pdd' + particle + '_' + fieldSize;
  return listDepthMaterials[0] ? prefixKey + '_' + listDepthMaterials[1] : prefixKey;
}

Future<List> readPreferences(BuildContext context) async {
  bool isAlreadyStored = false;
  late Map<String, Map<String, List<double?>>> mapPddDefault;
  mapPddDefault = await loadDefaults(context);
  SharedPreferences prefs = await SharedPreferences.getInstance();
  // PDD & Depth initialize or read
  Map<String, Map<String, List<double>>> mapPdd = {};
  for (String particle in particles.listStrParticle) {
    //Loop through all particles in the larger Map
    List<String> mapKeys = mapPddDefault[particle]!.keys.toList();
    String keyDepth = mapKeys[particles.indexKeyDepth];
    String unitsDepth = keyDepth.split('-')[1];
    mapKeys.remove(keyDepth);
    for (String strSize in mapKeys) {
      //For each particle, loop through size keys (Depth already removed)
      String preferenceKeyDepths =
          makePreferenceKey(particle, strSize, [true, unitsDepth]);
      String preferenceKeyValues =
          makePreferenceKey(particle, strSize, [false, unitsDepth]);
      late List<double?> listDepths;
      late List<double?> listValues;
      List<List<double>> filteredLists = [];
      if (!prefs.getKeys().any((element) => element == preferenceKeyDepths)) {
        //Shared preferences does NOT yet exist, so need to make it as well as assign filtered default values
        listDepths = mapPddDefault[particle]![keyDepth]!;
        listValues = mapPddDefault[particle]![strSize]!;
        filteredLists = filterLists(List<double?>.from(listDepths), List<double?>.from(listValues));
        prefs.setStringList(preferenceKeyDepths,
            filteredLists[0].map((e) => e.toString()).toList());
        prefs.setStringList(preferenceKeyValues,
            filteredLists[1].map((e) => e.toString()).toList());
      } else {
        //Shared preferences exist, so need to load the depths/values - Already stored post-null filter
        isAlreadyStored = true;
        filteredLists.add(prefs
            .getStringList(preferenceKeyDepths)!
            .map((e) => double.parse(e))
            .toList());
        filteredLists.add(prefs
            .getStringList(preferenceKeyValues)!
            .map((e) => double.parse(e))
            .toList());
      }
      if (mapPdd[particle] == null) {
        //Add first instance
        mapPdd.addAll({
          particle: {strSize + '-' + unitsDepth: filteredLists[0]}
        });
        mapPdd[particle]!.addAll({strSize: filteredLists[1]});
      } else {
        mapPdd[particle]!
            .addAll({strSize + '-' + unitsDepth: filteredLists[0]});
        mapPdd[particle]!.addAll({strSize: filteredLists[1]});
      }
    }
  }
  return [isAlreadyStored, mapPdd];
}

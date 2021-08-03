import 'package:shared_preferences/shared_preferences.dart';
import 'package:rad_onc_project/data/particle_data.dart' as particles;

Future<List<Map>> readPreferences() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  // Depth initialize or read
  Map<String, List<double>> mapDepth = {};
  for (String e in particles.listStrParticle) {
    String strKey = 'depth' + e;
    List<double> listDepth;
    if (!prefs.getKeys().any((element) => element == strKey)) {
      listDepth = particles.mapDefaultDepth[e]!;
      mapDepth.addAll({e: listDepth});
      prefs.setStringList(strKey, listDepth.map((e) => e.toString()).toList());
    } else {
      listDepth =
          prefs.getStringList(strKey)!.map((e) => double.parse(e)).toList();
      mapDepth.addAll({e: listDepth});
    }
  }
  // PDD initialize or read
  Map<String, Map<int, List<double>>> mapPdd = {};
  for (String eParticle in particles.listStrParticle) {
    String keyParticle = 'pdd' + eParticle;
    List<int> keysSize = particles.mapDefaultPdd[eParticle]!.keys.toList();
    for (int eSize in keysSize) {
      String keyPreference = keyParticle + '-' + eSize.toString();
      late List<double> pddValues;
      if (!prefs.getKeys().any((element) => element == keyPreference)) {
        pddValues = particles.mapDefaultPdd[eParticle]![eSize]!;
        prefs.setStringList(
            keyPreference, pddValues.map((e) => e.toString()).toList());
      } else {
        pddValues = prefs
            .getStringList(keyPreference)!
            .map((e) => double.parse(e))
            .toList();
      }
      if (mapPdd[eParticle] == null) {
        mapPdd.addAll({
          eParticle: {eSize: pddValues}
        });
      } else {
        mapPdd[eParticle]!.addAll({eSize: pddValues});
      }
    }
  }
  return [mapDepth, mapPdd];
}

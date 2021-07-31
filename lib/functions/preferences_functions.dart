import 'package:shared_preferences/shared_preferences.dart';
import 'package:rad_onc_project/data/particle_data.dart' as particles;

Future<List<Map<String, List<double>>>> readPreferences() async {
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
  Map<String, List<double>> mapPdd = {};
  for (String e in particles.listStrParticle) {
    String strKey = 'pdd' + e;
    List<double> listPdd;
    if (!prefs.getKeys().any((element) => element == strKey)) {
      listPdd = particles.mapDefaultPdd[e]!;
      mapPdd.addAll({e: listPdd});
      prefs.setStringList(strKey, listPdd.map((e) => e.toString()).toList());
    } else {
      listPdd =
          prefs.getStringList(strKey)!.map((e) => double.parse(e)).toList();
      mapPdd.addAll({e: listPdd});
    }
  }
  return [mapDepth, mapPdd];
}

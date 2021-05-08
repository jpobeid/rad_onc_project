import 'package:flutter/material.dart';
import 'package:rad_onc_project/apps/rad_bio_apps/tolerance_app/tolerance_app.dart';
import 'package:rad_onc_project/apps/rad_onc_apps/probabilities_app/probabilities_app.dart';
import 'package:rad_onc_project/apps/rad_onc_apps/scaling_time_app/scaling_time_plot.dart';
import 'package:rad_onc_project/apps/rad_onc_apps/tumor_volume_app/tumor_volume_app.dart';
import 'package:rad_onc_project/widgets/rad_app_bar.dart';

import '../apps/rad_bio_apps/bed_qed_app/bed_qed_app.dart';
import '../apps/rad_bio_apps/effective_dose_app/effective_dose.dart';
import '../apps/rad_onc_apps/scaling_time_app/scaling_time_app.dart';
import '../apps/rad_physics_apps/isotopes_app/isotopes_app.dart';
import '../apps/rad_physics_apps/pdd_app/pdd_app.dart';
import '../apps/rad_physics_apps/time_decay_dose_app/time_decay_dose_app.dart';
import '../pages/rad_bio_page.dart';
import '../pages/rad_onc_page.dart';
import '../pages/rad_physics_page.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final List<dynamic> args = settings.arguments;
    switch (settings.name) {
      //region RadOnc
      case (RadOncPage.routeName):
        return MaterialPageRoute(builder: (context) => RadOncPage());
        break;
      case (TumorVolume.routeName):
        return MaterialPageRoute(builder: (context) => TumorVolume());
        break;
      case (ScalingTime.routeName):
        return MaterialPageRoute(builder: (context) => ScalingTime());
        break;
      case (ScalingTimePlot.routeName):
        if (args == null) {
          return MaterialPageRoute(builder: (context) => ScalingTimePlot());
        } else {
          return MaterialPageRoute(
              builder: (context) => ScalingTimePlot(
                    listDateTime: args[0],
                    listStrValues: args[1],
                  ));
        }
        break;
      case (ProbabilitiesApp.routeName):
        MaterialPageRoute(builder: (context) => ProbabilitiesApp());
        break;
      //endregion RadOnc

      //region RadBio
      case (RadBioPage.routeName):
        return MaterialPageRoute(builder: (context) => RadBioPage());
        break;
      case (BedQedCalc.routeName):
        return MaterialPageRoute(builder: (context) => BedQedCalc());
        break;
      case (EffectiveDose.routeName):
        return MaterialPageRoute(builder: (context) => EffectiveDose());
        break;
      case (ToleranceApp.routeName):
        return MaterialPageRoute(builder: (context) => ToleranceApp());
        break;
      //endregion RadBio

      //region RadPhys
      case (RadPhysicsPage.routeName):
        return MaterialPageRoute(builder: (context) => RadPhysicsPage());
        break;
      case (PddApp.routeName):
        return MaterialPageRoute(builder: (context) => PddApp());
        break;
      case (IsotopesApp.routeName):
        return MaterialPageRoute(builder: (context) => IsotopesApp());
        break;
      case (TimeDecayDoseApp.routeName):
        if (args == null) {
          return MaterialPageRoute(builder: (context) => TimeDecayDoseApp());
        } else {
          return MaterialPageRoute(
              builder: (context) => TimeDecayDoseApp(
                    fromIsotopes: args[0],
                    isBioPresent: args[1],
                    strUnits: args[2],
                    strImportedPHL: args[3],
                    strImportedBHL: args[4],
                    strSymbol: args[5],
                  ));
        }
        break;
      //endregion RadPhys
      default:
        return MaterialPageRoute(builder: (context) => ErrorApp());
    }
  }
}

class ErrorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: RadAppBar(
        strAppTitle: 'Error!',
      ),
      body: Container(
        color: Theme.of(context).primaryColor,
        child: Text(
          'Routing Error!',
          style: Theme.of(context).textTheme.headline2,
        ),
      ),
    );
  }
}

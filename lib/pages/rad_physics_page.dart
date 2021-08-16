import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rad_onc_project/widgets/nav_bar.dart';
import 'package:rad_onc_project/widgets/rad_app_bar.dart';
import 'package:rad_onc_project/widgets/list_card.dart';
import 'package:rad_onc_project/data/global_data.dart' as datas;

class RadPhysicsPage extends StatefulWidget {
  static const routeName = '/rad-physics-page';

  @override
  _RadPhysicsPageState createState() => _RadPhysicsPageState();
}

class _RadPhysicsPageState extends State<RadPhysicsPage> {
  int _indexPage = 2;

  void setIndex(index) {
    setState(() {
      _indexPage = index;
    });
  }

  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.of(context).orientation == Orientation.portrait) {
      return SafeArea(
        child: Scaffold(
          appBar: RadAppBar(
            strAppTitle: datas.appName,
            isActionable: true,
          ),
          body: Column(
            children: [
              ListCard(
                pathImage: 'assets/pdd.jpg',
                strTitle: datas.mapAppNames[2]![0],
                strSubtitle: 'Dose-depth relationships',
                trailingIcon: FontAwesomeIcons.chartLine,
                strRouteName: '/pdd-app',
              ),
              ListCard(
                pathImage: 'assets/isotope.jpg',
                strTitle: datas.mapAppNames[2]![1],
                strSubtitle: 'Info on important isotopes',
                trailingIcon: FontAwesomeIcons.list,
                strRouteName: '/isotopes-app',
              ),
              ListCard(
                pathImage: 'assets/time.jpg',
                strTitle: datas.mapAppNames[2]![2],
                strSubtitle: 'Activity rates/sums over time',
                trailingIcon: FontAwesomeIcons.calculator,
                strRouteName: '/time-decay-dose-app',
              ),
              ListCard(
                pathImage: 'assets/total_fluence.jpg',
                strTitle: datas.mapAppNames[2]![3],
                strSubtitle: 'Compute monitor units',
                trailingIcon: FontAwesomeIcons.calculator,
                strRouteName: '/mu-calc-app',
              ),
            ],
          ),
          bottomNavigationBar: NavBar(indexNav: _indexPage, callback: setIndex),
        ),
      );
    } else {
      return Container();
    }
  }
}

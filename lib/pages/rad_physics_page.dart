import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:rad_onc_project/widgets/nav_bar.dart';
import 'package:rad_onc_project/widgets/rad_app_bar.dart';
import 'package:rad_onc_project/widgets/list_card.dart';
import 'package:rad_onc_project/data/main_data.dart' as datas;

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
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: RadAppBar(
          strAppTitle: 'Radiation Oncology App',
          isActionable: true,
        ),
        body: Column(children: [
          ListCard(
            pathImage: 'assets/pdd.jpg',
            strTitle: datas.mapAppNames[2][0],
            strSubtitle: 'Dose-depth relationships',
            trailingIcon: FlutterIcons.chart_line_mco,
            strRouteName: '/pdd-app',
          ),
          ListCard(
            pathImage: 'assets/isotope.jpg',
            strTitle: datas.mapAppNames[2][1],
            strSubtitle: 'Info on important isotopes',
            trailingIcon: FlutterIcons.list_ul_faw,
            strRouteName: '/isotopes-app',
          ),
          ListCard(
            pathImage: 'assets/time.jpg',
            strTitle: datas.mapAppNames[2][2],
            strSubtitle: 'Activity rates/sums over time',
            trailingIcon: FlutterIcons.calculator_mco,
            strRouteName: '/time-decay-dose-app',
          ),
          ListCard(
            pathImage: 'assets/time.jpg',
            strTitle: datas.mapAppNames[2][3],
            strSubtitle: 'Compute monitor units',
            trailingIcon: FlutterIcons.calculator_mco,
            strRouteName: '/mu-calc-app',
          ),
        ]),
        bottomNavigationBar: NavBar(indexNav: _indexPage, callback: setIndex),
      ),
    );
  }
}

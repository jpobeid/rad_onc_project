import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:rad_onc_project/widgets/nav_bar.dart';
import 'package:rad_onc_project/widgets/rad_app_bar.dart';
import 'package:rad_onc_project/widgets/list_card.dart';

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
        appBar: RadAppBar(strAppTitle: 'Radiation Oncology App',),
        body: Column(children: [
          ListCard(
            pathImage: 'assets/pdd.jpg',
            strTitle: 'PDD Viewer',
            strSubtitle: 'Dose-depth relationships',
            trailingIcon: FlutterIcons.chart_line_mco,
            strRouteName: '/pdd-app',
          ),
          ListCard(
            pathImage: 'assets/isotope.jpg',
            strTitle: 'Radio-Isotopes',
            strSubtitle: 'Info on important isotopes',
            trailingIcon: FlutterIcons.list_ul_faw,
            strRouteName: '/isotopes-app',
          ),
          ListCard(
            pathImage: 'assets/time.jpg',
            strTitle: 'Time Decay/Dose',
            strSubtitle: 'Activity rates/sums over time',
            trailingIcon: FlutterIcons.calculator_mco,
            strRouteName: '/time-decay-dose-app',
          ),
        ]),
        bottomNavigationBar: NavBar(indexNav: _indexPage, callback: setIndex),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rad_onc_project/widgets/list_card.dart';
import 'package:rad_onc_project/widgets/nav_bar.dart';
import 'package:rad_onc_project/widgets/rad_app_bar.dart';
import 'package:rad_onc_project/data/global_data.dart' as datas;

class RadOncPage extends StatefulWidget {
  static const routeName = '/rad-onc-page';

  @override
  _RadOncPageState createState() => _RadOncPageState();
}

class _RadOncPageState extends State<RadOncPage> {
  int _indexPage = 0;

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
    return SafeArea(
      child: Scaffold(
        appBar: RadAppBar(
          strAppTitle: datas.appName,
          isActionable: true,
        ),
        body: Column(children: [
          ListCard(
            pathImage: 'assets/volume.jpg',
            strTitle: datas.mapAppNames[0]![0],
            strSubtitle: 'Estimate volume from size',
            trailingIcon: FontAwesomeIcons.calculator,
            strRouteName: '/tumor-volume-app',
          ),
          ListCard(
            pathImage: 'assets/scaling.jpg',
            strTitle: datas.mapAppNames[0]![1],
            strSubtitle: 'Compute/plot biomarker trend',
            trailingIcon: FontAwesomeIcons.chartLine,
            strRouteName: '/scaling-time-app',
          ),
          ListCard(
            pathImage: 'assets/dice.jpg',
            strTitle: datas.mapAppNames[0]![2],
            strSubtitle: 'Compute probabilities',
            trailingIcon: FontAwesomeIcons.calculator,
            strRouteName: '/probabilities-app',
          ),
        ]),
        bottomNavigationBar: NavBar(indexNav: _indexPage, callback: setIndex),
      ),
    );
  }
}

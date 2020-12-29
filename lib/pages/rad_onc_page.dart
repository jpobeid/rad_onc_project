import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:rad_onc_project/widgets/list_card.dart';
import 'package:rad_onc_project/widgets/nav_bar.dart';
import 'package:rad_onc_project/widgets/rad_app_bar.dart';

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
        appBar: RadAppBar(strAppTitle: 'Radiation Oncology App',),
        body: Column(children: [
          ListCard(
            pathImage: 'assets/volume.jpg',
            strTitle: 'Tumor Volume',
            strSubtitle: 'Estimate volume from size',
            trailingIcon: FlutterIcons.calculator_mco,
            strRouteName: '/tumor-volume-app',
          ),
          ListCard(
            pathImage: 'assets/scaling.jpg',
            strTitle: 'Scaling Time',
            strSubtitle: 'Compute/plot biomarker trend',
            trailingIcon: FlutterIcons.chart_line_mco,
            strRouteName: '/scaling-time-app',
          ),
        ]),
        bottomNavigationBar: NavBar(indexNav: _indexPage, callback: setIndex),
      ),
    );
  }
}

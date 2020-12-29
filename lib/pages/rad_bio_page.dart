import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:rad_onc_project/widgets/list_card.dart';
import 'package:rad_onc_project/widgets/nav_bar.dart';
import 'package:rad_onc_project/widgets/rad_app_bar.dart';

class RadBioPage extends StatefulWidget {
  static const routeName = '/rad-bio-page';

  @override
  _RadBioPageState createState() => _RadBioPageState();
}

class _RadBioPageState extends State<RadBioPage> {
  int _indexPage = 1;
  void setIndex(index){
    setState(() {
      _indexPage=index;
    });
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: RadAppBar(strAppTitle: 'Radiation Oncology App',),
        body: Column(children: [
          ListCard(
            pathImage: 'assets/alphabeta.jpg',
            strTitle: 'BED-QED Calculator',
            strSubtitle: 'Compute dose conversions',
            trailingIcon: FlutterIcons.calculator_mco,
            strRouteName: '/bed-qed-app',
          ),
          ListCard(
            pathImage: 'assets/ct.jpg',
            strTitle: 'Effective Doses',
            strSubtitle: 'Imaging effective dose list',
            trailingIcon: FlutterIcons.list_ul_faw,
            strRouteName: '/effective-dose-app',
          ),
          ListCard(
            pathImage: 'assets/summation.jpg',
            strTitle: 'Cumulative Dose',
            strSubtitle: 'Cumulative dose tolerance',
            trailingIcon: FlutterIcons.calculator_mco,
            strRouteName: '/tolerance-app',
          ),
        ]),
        bottomNavigationBar: NavBar(indexNav: _indexPage,callback: setIndex),
      ),
    );
  }
}

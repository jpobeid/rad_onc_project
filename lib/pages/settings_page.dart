import 'package:flutter/material.dart';
import 'package:rad_onc_project/widgets/list_card.dart';
import 'package:rad_onc_project/widgets/rad_app_bar.dart';
import 'package:rad_onc_project/data/main_data.dart' as datas;

class SettingsPage extends StatelessWidget {
  static const String routeName = '/settings-page';

  const SettingsPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: RadAppBar(
          strAppTitle: 'Settings',
        ),
        body: ListView(
          children: [
            ListCard(
              pathImage: 'assets/pdd.jpg',
              strTitle: datas.mapAppNames[3][0],
              strSubtitle: 'Modify PDD parameters',
              trailingIcon: Icons.settings,
              strRouteName: '/settings-curve',
            ),
          ],
        ),
      ),
    );
  }
}

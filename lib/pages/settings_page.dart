import 'package:flutter/material.dart';
import 'package:rad_onc_project/widgets/list_card.dart';
import 'package:rad_onc_project/widgets/rad_app_bar.dart';

class SettingsPage extends StatelessWidget {
  static const String routeName = '/settings-page';

  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: RadAppBar(
          strAppTitle: 'Settings',
          isActionable: false,
        ),
        body: Column(
          children: [
            ListCard(
              pathImage: 'assets/pdd.jpg',
              strTitle: 'PDD Data',
              strSubtitle: 'Edit standard tables',
              trailingIcon: Icons.edit,
              strRouteName: '/settings-pdd-app',
            ),
            ListCard(
              pathImage: 'assets/info.jpg',
              strTitle: 'About',
              strSubtitle: 'App info',
              trailingIcon: Icons.settings,
              iActionType: 1,
            ),
          ],
        ),
      ),
    );
  }
}


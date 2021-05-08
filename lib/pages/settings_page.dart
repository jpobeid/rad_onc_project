import 'package:flutter/material.dart';
import 'package:rad_onc_project/widgets/rad_app_bar.dart';
import 'package:rad_onc_project/data/photon_data.dart' as photons;

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
        body: ListView.builder(
            itemCount: photons.listDepth.length,
            itemBuilder: (context, index) {
              return Text(
                '${photons.listDepth[index]}',
                style: Theme.of(context).textTheme.headline1,
              );
            }),
      ),
    );
  }
}

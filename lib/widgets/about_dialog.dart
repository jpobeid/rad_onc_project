import 'package:flutter/material.dart';
import 'package:rad_onc_project/data/global_data.dart' as globals;

class RadOncAboutDialog extends StatelessWidget {
  const RadOncAboutDialog({Key? key}) : super(key: key);

  static const double size = 48;
  static const TextStyle style = TextStyle(color: Colors.black, fontSize: 14);

  @override
  Widget build(BuildContext context) {
    return AboutDialog(
      applicationName: globals.appName,
      applicationVersion: globals.appVersion,
      applicationIcon: Image(
        image: AssetImage('assets/logo.png'),
        width: size,
        height: size,
      ),
      children: [
        makeTextLine('Written by: ${globals.appAuthor}'),
        makeTextLine('Written at: ${globals.appInstitution}'),
        makeTextLine('Release year: ${globals.appYear}'),
      ],
    );
  }
}

Text makeTextLine(String text) {
  return Text(
    text,
    style: RadOncAboutDialog.style,
    textAlign: TextAlign.center,
  );
}

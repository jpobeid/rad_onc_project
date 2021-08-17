import 'package:flutter/material.dart';
import 'package:rad_onc_project/data/global_data.dart' as globals;
import 'package:package_info/package_info.dart';

class RadOncAboutDialog extends StatefulWidget {
  const RadOncAboutDialog({Key? key}) : super(key: key);

  static const double size = 48;
  static const TextStyle style = TextStyle(color: Colors.black, fontSize: 14);

  @override
  _RadOncAboutDialogState createState() => _RadOncAboutDialogState();
}

class _RadOncAboutDialogState extends State<RadOncAboutDialog> {
  String? _appName;
  String? _appVersion;
  String? _appBuildNumber;

  Future<void> initAppInfo() async {
    var info = await PackageInfo.fromPlatform();
    setState(() {
      _appName = info.appName;
      _appVersion = info.version;
      _appBuildNumber = info.buildNumber;
    });
  }

  @override
  void initState() {
    initAppInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool canBuild = _appName != null && _appVersion != null && _appBuildNumber != null;

    if (canBuild) {
      return AboutDialog(
        applicationName: _appName,
        applicationVersion: _appVersion! + '+$_appBuildNumber',
        applicationIcon: Image(
          image: AssetImage('assets/logo.png'),
          width: RadOncAboutDialog.size,
          height: RadOncAboutDialog.size,
        ),
        children: [
          makeTextLine('Written by: ${globals.appAuthor}'),
          makeTextLine('Written at: ${globals.appInstitution}'),
          makeTextLine('Release year: ${globals.appYear}'),
        ],
      );
    } else {
      return Container();
    }
  }
}

Text makeTextLine(String text) {
  return Text(
    text,
    style: RadOncAboutDialog.style,
    textAlign: TextAlign.center,
  );
}

import 'package:flutter/material.dart';
import 'package:rad_onc_project/widgets/rad_app_bar.dart';

class AboutApp extends StatelessWidget {
  static const String routeName = '/settings-about-app';

  const AboutApp({Key? key}) : super(key: key);

  static const String strAuthor = 'Jean-Pierre Obeid';
  static const String strInstitution = 'Stanford University';
  static const String strDate = '2021';
  static const String strVersion = '1.0.0';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: RadAppBar(
          strAppTitle: 'About',
        ),
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Designed & written by: \n ${AboutApp.strAuthor}',
                style: Theme.of(context).textTheme.headline2,
                textAlign: TextAlign.center,
              ),
              Text(
                '\n Written at: \n ${AboutApp.strInstitution}',
                style: Theme.of(context).textTheme.headline2,
                textAlign: TextAlign.center,
              ),
              Text(
                '\n Release date: ${AboutApp.strDate} \n Version: ${AboutApp.strVersion}',
                style: Theme.of(context).textTheme.headline1,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

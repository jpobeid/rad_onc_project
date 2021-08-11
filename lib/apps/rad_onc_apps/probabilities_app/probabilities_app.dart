import 'package:flutter/material.dart';
import 'package:rad_onc_project/widgets/rad_app_bar.dart';
import 'package:rad_onc_project/data/global_data.dart' as datas;

class ProbabilitiesApp extends StatefulWidget {
  static const String routeName = '/probabilities-app';

  static const List<String> probTypes = ['Fixed rate', 'Exp. Survival'];

  @override
  _ProbabilitiesAppState createState() => _ProbabilitiesAppState();
}

class _ProbabilitiesAppState extends State<ProbabilitiesApp> {
  int _iType = 0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: RadAppBar(
          strAppTitle: datas.mapAppNames[0]![2],
        ),
        body: Column(
          children: [
            DropdownButton(
              dropdownColor: Colors.blueGrey,
              value: _iType,
              items: ProbabilitiesApp.probTypes
                  .map(
                    (e) => DropdownMenuItem(
                      child: Text(
                        e,
                        style: Theme.of(context).textTheme.headline1,
                      ),
                      value: ProbabilitiesApp.probTypes.indexOf(e),
                    ),
                  )
                  .toList(),
              onChanged: (int? index) {
                setState(() {
                  _iType = index!;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}

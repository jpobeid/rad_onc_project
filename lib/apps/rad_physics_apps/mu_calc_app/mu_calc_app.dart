import 'package:flutter/material.dart';
import 'package:rad_onc_project/widgets/rad_app_bar.dart';
import 'package:rad_onc_project/data/main_data.dart' as datas;

class MUCalcApp extends StatelessWidget {
  static const String routeName = '/mu-calc-app';

  const MUCalcApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: RadAppBar(
        strAppTitle: datas.mapAppNames[2][3],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            color: Colors.green,
            child: ToggleButtons(
              isSelected: [true, false],
              children: [
                Text('SSD'),
                Text('SAD'),
              ],
            ),
          ),
          Table(
            children: [
              TableRow(
                children: [
                  Text('Dose (Gy):', style: Theme.of(context).textTheme.headline1,),
                  Text('You', style: Theme.of(context).textTheme.headline1,),
                ],
              ),
              TableRow(
                children: [
                  Text('Field Size (cm):', style: Theme.of(context).textTheme.headline1,),
                  Text('You', style: Theme.of(context).textTheme.headline1,),
                ],
              ),
              TableRow(
                children: [
                  Text('Depth (cm):', style: Theme.of(context).textTheme.headline1,),
                  Text('You', style: Theme.of(context).textTheme.headline1,),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

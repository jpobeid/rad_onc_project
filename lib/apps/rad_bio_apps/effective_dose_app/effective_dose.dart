import 'package:flutter/material.dart';
import 'package:csv/csv.dart' as csv;
import 'package:flutter/services.dart';
import 'package:rad_onc_project/widgets/rad_app_bar.dart';
import 'package:rad_onc_project/data/main_data.dart' as datas;

class EffectiveDose extends StatefulWidget {
  static const routeName = '/effective-dose-app';

  @override
  _EffectiveDoseState createState() => _EffectiveDoseState();
}

class _EffectiveDoseState extends State<EffectiveDose> {
  static const double fractionHeightRow = 0.1;
  static const double fractionHeightRowFirst = 0.125;
  static const double widthBorder = 1;
  static const List<int> listHorizontalFlex = [3, 2];

  List<List<dynamic>>? dataDose;

  Future<void> loadCSV(pathCsv) async {
    String strData = await rootBundle.loadString(pathCsv);
    setState(() {
      dataDose = csv.CsvToListConverter().convert(strData);
    });
  }

  @override
  Widget build(BuildContext context) {
    loadCSV('assets/effective_dose_data.csv');
    if (dataDose != null) {
      return SafeArea(
        child: Scaffold(
          appBar: RadAppBar(
            strAppTitle: datas.mapAppNames[1]![1],
          ),
          body: ListView.builder(
              itemCount: dataDose!.length,
              itemBuilder: (context, index) {
                return makeRow(context, fractionHeightRow, fractionHeightRowFirst,
                    widthBorder, listHorizontalFlex, dataDose!, index);
              }),
        ),
      );
    } else {
      return Scaffold();
    }
  }
}

Container makeRow(
    BuildContext context,
    double fractionHeightRow,
    double fractionHeightRowFirst,
    double widthBorder,
    List<int> listHorizontalFlex,
    List<List<dynamic>> dataDose,
    int index) {
  if (dataDose[index][1].toString() == '') {
    return Container(
      height: MediaQuery.of(context).size.height * fractionHeightRow,
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        border: Border.all(
            color: Theme.of(context).primaryColor, width: widthBorder),
      ),
      alignment: Alignment.center,
      child: Text(
        dataDose[index][0].toString(),
        style: TextStyle(
            fontSize: Theme.of(context).textTheme.headline2!.fontSize,
            fontWeight: Theme.of(context).textTheme.headline2!.fontWeight,
            color: Theme.of(context).scaffoldBackgroundColor),
      ),
    );
  } else {
    return Container(
      height: index == 0
          ? MediaQuery.of(context).size.height * fractionHeightRowFirst
          : MediaQuery.of(context).size.height * fractionHeightRow,
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: Border.all(
            color: Theme.of(context).primaryColor, width: widthBorder),
      ),
      child: Row(
        children: [
          Expanded(
            flex: listHorizontalFlex[0],
            child: Text(
              dataDose[index][0].toString(),
              style: index == 0
                  ? Theme.of(context).textTheme.headline2
                  : Theme.of(context).textTheme.headline1,
              textAlign: TextAlign.center,
            ),
          ),
          VerticalDivider(
            thickness: widthBorder,
            color: Theme.of(context).primaryColor,
          ),
          Expanded(
            flex: listHorizontalFlex[1],
            child: Text(
              dataDose[index][1].toString(),
              style: Theme.of(context).textTheme.headline2,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}

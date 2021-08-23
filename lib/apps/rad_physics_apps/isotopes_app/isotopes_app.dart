import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rad_onc_project/widgets/rad_app_bar.dart';
import 'package:rad_onc_project/data/global_data.dart' as datas;

List<List<dynamic>>? dataIsotopes;

class IsotopesApp extends StatefulWidget {
  static const routeName = '/isotopes-app';

  @override
  _IsotopesAppState createState() => _IsotopesAppState();
}

class _IsotopesAppState extends State<IsotopesApp> {
  static const List<String> listColumnNames = [
    'name',
    'symbol',
    'type',
    'halfLife',
    'bioHalfLife',
    'primaryDecay',
    'avgEnergy',
    'hvl',
    'eRC',
    'posMaxE',
    'doseRC',
  ];
  static const int indexRowKeys = 1;
  static const int indexColumnKeys = 3;

  static const Map<int, IconData> mapTrailIcon = {
    0: FontAwesomeIcons.radiation,
    1: FontAwesomeIcons.syringe,
    2: FontAwesomeIcons.pills,
  };

  static const double fractionDialogHeight = 0.65;
  static const double fractionMainDivider = 0.05;
  static const double thickBorderMain = 3;
  static const double thickBorderInner = 2;

  Future<void> loadCsv(String pathCsv) async {
    String strCsv = await rootBundle.loadString(pathCsv);
    setState(() {
      dataIsotopes = CsvToListConverter().convert(strCsv);
    });
  }

  @override
  void initState() {
    loadCsv('assets/isotopes_data.csv');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (dataIsotopes != null) {
      return SafeArea(
        child: Scaffold(
          appBar: RadAppBar(
            strAppTitle: datas.mapAppNames[2]![1],
          ),
          body: ListView.builder(
            itemCount: dataIsotopes!.length,
            itemBuilder: (context, index) {
              if (index > indexRowKeys) {
                return Card(
                  color: Theme.of(context).backgroundColor,
                  child: ListTile(
                    leading: Icon(
                      FontAwesomeIcons.atom,
                      color: Theme.of(context).textTheme.subtitle2!.color,
                    ),
                    title: Text(
                      dataIsotopes![index][0],
                      style: Theme.of(context).textTheme.headline1,
                    ),
                    subtitle: Text(
                      dataIsotopes![index][1],
                      style: Theme.of(context).textTheme.subtitle2,
                    ),
                    trailing: Icon(
                      mapTrailIcon[dataIsotopes![index]
                          [dataIsotopes![0].indexOf('type')]],
                      color: Theme.of(context).textTheme.subtitle2!.color,
                    ),
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return Dialog(
                              child: Container(
                                  height: MediaQuery.of(context).size.height *
                                      fractionDialogHeight,
                                  decoration: BoxDecoration(
                                    color:
                                        Theme.of(context).scaffoldBackgroundColor,
                                    border: Border.all(
                                        color: Theme.of(context).primaryColor,
                                        width: thickBorderMain),
                                  ),
                                  child: ListView(
                                    // mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${dataIsotopes![index][0]}',
                                        style:
                                            Theme.of(context).textTheme.headline2,
                                      ),
                                      Text(
                                        '(${dataIsotopes![index][1]})',
                                        style:
                                            Theme.of(context).textTheme.headline1,
                                      ),
                                      Divider(
                                        color: Theme.of(context).primaryColor,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                fractionMainDivider,
                                        thickness: thickBorderMain,
                                      ),
                                      Table(
                                        border: TableBorder.symmetric(
                                            inside: BorderSide(
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                width: thickBorderInner)),
                                        defaultVerticalAlignment:
                                            TableCellVerticalAlignment.middle,
                                        columnWidths: {
                                          0: FlexColumnWidth(2),
                                          1: FlexColumnWidth(1)
                                        },
                                        children: makeRows(
                                            context,
                                            index,
                                            indexRowKeys,
                                            indexColumnKeys,
                                            dataIsotopes!),
                                      ),
                                      Divider(
                                        color: Theme.of(context).primaryColor,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                fractionMainDivider,
                                        thickness: thickBorderMain,
                                      ),
                                      TextButton(
                                        child: Container(
                                            padding:
                                                EdgeInsets.all(thickBorderMain),
                                            decoration: BoxDecoration(
                                              color:
                                                  Theme.of(context).primaryColor,
                                              borderRadius: BorderRadius.circular(
                                                  thickBorderMain),
                                              border: Border.all(
                                                  color: Theme.of(context)
                                                      .textTheme
                                                      .headline1!
                                                      .color!,
                                                  width: thickBorderMain),
                                            ),
                                            child: Text(
                                              'Compute Activity',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline2,
                                            )),
                                        onPressed: () {
                                          bool isBioPresent = (dataIsotopes![index][
                                                      listColumnNames.indexOf(
                                                          'bioHalfLife')] !=
                                                  null&&dataIsotopes![index][
                                          listColumnNames.indexOf(
                                              'bioHalfLife')] !='')
                                              ? true
                                              : false;
                                          String? charTimeUnit =
                                              dataIsotopes![index][listColumnNames
                                                      .indexOf('halfLife')]
                                                  .split(' ')[1];
                                          String? strPHL = dataIsotopes![index][
                                                  listColumnNames
                                                      .indexOf('halfLife')]
                                              .split(' ')[0];
                                          String strTimeUnit =
                                              getTimeUnit(charTimeUnit);
                                          String? strBHL = isBioPresent
                                              ? dataIsotopes![index][
                                                      listColumnNames
                                                          .indexOf('bioHalfLife')]
                                                  .split(' ')[0]
                                              : '';
                                          String? strSymbol = dataIsotopes![index][listColumnNames
                                              .indexOf('symbol')];
                                          Navigator.pushNamed(
                                              context, '/time-decay-dose-app',
                                              arguments: [
                                                true,
                                                isBioPresent,
                                                strTimeUnit,
                                                strPHL,
                                                strBHL,
                                                strSymbol,
                                              ]);
                                        },
                                      ),
                                    ],
                                  )),
                            );
                          });
                    },
                  ),
                );
              } else {
                return Container();
              }
            },
          ),
        ),
      );
    } else {
      return Scaffold();
    }
  }
}

List<TableRow> makeRows(BuildContext context, int index, int intRowKeys,
    int intColumnKeys, List<List<dynamic>> data) {
  int nDataColumns = data[0].length;
  List<TableRow> listTableRows = [];
  for (int j = intColumnKeys; j < nDataColumns; j++) {
    String key = data[intRowKeys][j].toString();
    if (key.contains('(')) {
      key = key.split('(')[0] + '\n(' + key.split('(')[1];
    }
    String value = data[index][j].toString();
    if (key != '' && value != '') {
      listTableRows.add(TableRow(
        children: [
          Text(
            key,
            style: Theme.of(context).textTheme.headline1,
            textAlign: TextAlign.center,
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.headline1,
            textAlign: TextAlign.center,
          ),
        ],
      ));
    }
  }
  return listTableRows;
}

String getTimeUnit(String? char) {
  switch (char) {
    case ('m'):
      return '[Mins]';
    case ('h'):
      return '[Hours]';
    case ('d'):
      return '[Days]';
    case ('y'):
      return '[Years]';
    default:
      return '[User defined]';
  }
}

import 'package:flutter/material.dart';

import 'package:rad_onc_project/pages/rad_onc_page.dart';
import 'package:rad_onc_project/functions/route_generator.dart';

void main() => runApp(
      MaterialApp(
        theme: ThemeData(
          primaryColor: Colors.red,
          backgroundColor: Colors.grey[500],
          accentColor: Colors.red[300],
          scaffoldBackgroundColor: Colors.black,
          textTheme: TextTheme(
            headline1: TextStyle(
                fontSize: 24,
                color: Colors.grey[100],
                fontWeight: FontWeight.bold),
            headline2: TextStyle(
                fontSize: 32,
                color: Colors.grey[100],
                fontWeight: FontWeight.bold),
            subtitle1: TextStyle(fontSize: 14, color: Colors.grey[200]),
            subtitle2: TextStyle(fontSize: 16, color: Colors.black),
          ),
        ),
        //home: RadOncPage(),
        home: RadOncPage(),
        onGenerateRoute: RouteGenerator.generateRoute,
      ),
    );

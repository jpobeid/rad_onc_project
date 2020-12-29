import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:rad_onc_project/pages/rad_bio_page.dart';
import 'package:rad_onc_project/pages/rad_onc_page.dart';
import 'package:rad_onc_project/pages/rad_physics_page.dart';

class NavBar extends StatefulWidget {
  final int indexNav;
  final Function callback;

  const NavBar({Key key, this.indexNav, this.callback}) : super(key: key);

  @override
  _NavBarState createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      selectedItemColor: Theme.of(context).primaryColor,
      unselectedItemColor: Theme.of(context).accentColor,
      currentIndex: widget.indexNav,
      items: [
        BottomNavigationBarItem(
            icon: Icon(
              FlutterIcons.hospital_box_outline_mco,
            ),
            title: Text(
              'Clinical Rad-Onc',
              style: Theme.of(context).textTheme.subtitle1,
            )),
        BottomNavigationBarItem(
            icon: Icon(
              FlutterIcons.dna_mco,
            ),
            title: Text(
              'Rad-Bio',
              style: Theme.of(context).textTheme.subtitle1,
            )),
        BottomNavigationBarItem(
            icon: Icon(
              FlutterIcons.atom_mco,
            ),
            title: Text(
              'Rad-Physics',
              style: Theme.of(context).textTheme.subtitle1,
            )),
      ],
      onTap: (i) {
        widget.callback(i);
        switch (i) {
          case 0:
            Navigator.of(context).pushReplacementNamed(RadOncPage.routeName);
            break;
          case 1:
            Navigator.of(context).pushReplacementNamed(RadBioPage.routeName);
            break;
          case 2:
            Navigator.of(context)
                .pushReplacementNamed(RadPhysicsPage.routeName);
            break;
          default:
            Navigator.of(context).pushReplacementNamed(RadOncPage.routeName);
            break;
        }
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rad_onc_project/pages/rad_bio_page.dart';
import 'package:rad_onc_project/pages/rad_onc_page.dart';
import 'package:rad_onc_project/pages/rad_physics_page.dart';

class NavBar extends StatefulWidget {
  final int? indexNav;
  final Function? callback;

  const NavBar({Key? key, this.indexNav, this.callback}) : super(key: key);

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
      currentIndex: widget.indexNav!,
      items: [
        BottomNavigationBarItem(
          icon: Icon(
            FontAwesomeIcons.briefcaseMedical,
          ),
          label: 'Clinical Rad-Onc',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            FontAwesomeIcons.dna,
          ),
          label: 'Rad-Bio',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            FontAwesomeIcons.atom,
          ),
          label: 'Rad-Physics',
        ),
      ],
      onTap: (i) {
        widget.callback!(i);
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

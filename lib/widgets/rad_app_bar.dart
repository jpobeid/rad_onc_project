import 'package:flutter/material.dart';

class RadAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? strAppTitle;
  final bool isActionable;

  const RadAppBar({Key? key, this.strAppTitle, this.isActionable = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isActionable) {
      return AppBar(
        title: Text(
          strAppTitle!,
          style: Theme.of(context).textTheme.headline1,
        ),
        actions: [
          IconButton(
              icon: Icon(Icons.settings),
              onPressed: () {
                Navigator.of(context).pushNamed('/settings-page');
              }),
        ],
      );
    } else {
      return AppBar(
        title: Text(
          strAppTitle!,
          style: Theme.of(context).textTheme.headline1,
        ),
      );
    }
  }

  @override
  Size get preferredSize => const Size.fromHeight(50);
}

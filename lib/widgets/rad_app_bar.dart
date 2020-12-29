import 'package:flutter/material.dart';

class RadAppBar extends StatelessWidget implements PreferredSizeWidget {
  final strAppTitle;

  const RadAppBar({Key key, this.strAppTitle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
        title: Text(strAppTitle, style: Theme.of(context).textTheme.headline1,),
      );
  }

  @override
  Size get preferredSize => const Size.fromHeight(50);
}
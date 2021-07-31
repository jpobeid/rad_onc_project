import 'package:flutter/material.dart';

class ListCard extends StatelessWidget {
  final String? pathImage;
  final String? strTitle;
  final String? strSubtitle;
  final IconData? trailingIcon;
  final String? strRouteName;

  const ListCard({Key? key, this.pathImage, this.strTitle, this.strSubtitle, this.trailingIcon, this.strRouteName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).backgroundColor,
      child: ListTile(
        leading: ClipOval(child: Image.asset(pathImage!)),
        title: Text(
          strTitle!,
          style: Theme.of(context).textTheme.headline1,
        ),
        subtitle: Text(
          strSubtitle!,
          style: Theme.of(context).textTheme.subtitle2,
        ),
        trailing: Icon(
          trailingIcon,
          color: Theme.of(context).textTheme.subtitle2!.color,
        ),
        onTap: () {
          if(strRouteName!=null&&strRouteName!=''){
            Navigator.of(context).pushNamed(strRouteName!);
          }
        },
      ),
    );
  }
}

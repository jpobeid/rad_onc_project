import 'package:flutter/material.dart';
import 'package:rad_onc_project/widgets/about_dialog.dart';

class ListCard extends StatelessWidget {
  final String? pathImage;
  final String? strTitle;
  final String? strSubtitle;
  final IconData? trailingIcon;
  final String? strRouteName;
  final int? iActionType;

  const ListCard(
      {Key? key,
      this.pathImage,
      this.strTitle,
      this.strSubtitle,
      this.trailingIcon,
      this.strRouteName,
      this.iActionType})
      : super(key: key);

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
        onTap: () => listCardActions(context, strRouteName, iActionType),
      ),
    );
  }
}

void listCardActions(
    BuildContext context, String? strRouteName, int? iActionType) {
  bool isRouter = iActionType == null || iActionType == 0;
  if (isRouter && strRouteName != null && strRouteName != '') {
    Navigator.of(context).pushNamed(strRouteName);
  } else if (iActionType == 1) {
    showDialog(
        context: context,
        builder: (_) {
          return RadOncAboutDialog();
        });
  }
}

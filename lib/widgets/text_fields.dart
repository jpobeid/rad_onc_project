import 'package:flutter/material.dart';

TextField textFieldSetting(
    BuildContext context, TextEditingController controller) {
  return TextField(
    controller: controller,
    maxLength: 5,
    keyboardType: TextInputType.number,
    style: Theme.of(context).textTheme.headline1,
    textAlign: TextAlign.center,
    decoration: InputDecoration(
      contentPadding: EdgeInsets.all(0),
      isCollapsed: true,
      isDense: true,
    ),
  );
}

TextField textFieldDose(BuildContext context, TextEditingController controller,
    {Function? funcOnChanged}) {
  return TextField(
    controller: controller,
    maxLength: 5,
    keyboardType: TextInputType.number,
    style: Theme.of(context).textTheme.headline2,
    textAlign: TextAlign.center,
    decoration: InputDecoration(
      contentPadding: EdgeInsets.all(0),
    ),
    onChanged: funcOnChanged as void Function(String)?,
  );
}

TextField textFieldFraction(
    BuildContext context, TextEditingController controller,
    {Function? funcOnChanged}) {
  return TextField(
    controller: controller,
    maxLength: 2,
    keyboardType: TextInputType.number,
    style: Theme.of(context).textTheme.headline2,
    textAlign: TextAlign.center,
    decoration: InputDecoration(
      contentPadding: EdgeInsets.all(0),
    ),
    onChanged: funcOnChanged as void Function(String)?,
  );
}

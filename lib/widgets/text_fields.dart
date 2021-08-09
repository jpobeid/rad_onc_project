import 'package:flutter/material.dart';

InputDecoration standardDecoration() {
  return InputDecoration(
    enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.blue, width: 2)),
    contentPadding: EdgeInsets.all(4),
    isCollapsed: true,
    isDense: true,
  );
}

TextField textFieldStandard(
    BuildContext context, TextEditingController controller, bool isLarge) {
  return TextField(
    controller: controller,
    maxLength: 5,
    keyboardType: TextInputType.number,
    style: isLarge
        ? Theme.of(context).textTheme.headline2
        : Theme.of(context).textTheme.headline1,
    textAlign: TextAlign.center,
    decoration: standardDecoration(),
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
    decoration: standardDecoration(),
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
    decoration: standardDecoration(),
    onChanged: funcOnChanged as void Function(String)?,
  );
}

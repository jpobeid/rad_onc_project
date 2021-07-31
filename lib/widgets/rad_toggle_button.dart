import 'package:flutter/material.dart';

class RadToggleButton extends StatefulWidget {
  final String? strOption1;
  final String? strOption2;
  final double? fractionToggleWidth;
  final double? sizeBorderRadius;
  final List<bool>? listIsSelected;
  final Function? functionOnPressed;

  const RadToggleButton(
      {Key? key,
      this.strOption1,
      this.strOption2,
      this.fractionToggleWidth,
      this.sizeBorderRadius,
      this.listIsSelected,
      this.functionOnPressed})
      : super(key: key);

  @override
  _RadToggleButtonState createState() => _RadToggleButtonState();
}

class _RadToggleButtonState extends State<RadToggleButton> {
  @override
  Widget build(BuildContext context) {
    double buttonWidth =
        MediaQuery.of(context).size.width / 2 * widget.fractionToggleWidth!;
    return ToggleButtons(
      children: [
        Container(
          width: buttonWidth,
          child: Text(
            widget.strOption1!,
            style: TextStyle(
                fontSize: Theme.of(context).textTheme.headline1!.fontSize,
                fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ),
        Container(
          width: buttonWidth,
          child: Text(
            widget.strOption2!,
            style: TextStyle(
                fontSize: Theme.of(context).textTheme.headline1!.fontSize,
                fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ),
      ],
      borderRadius: BorderRadius.circular(widget.sizeBorderRadius!),
      color: Theme.of(context).textTheme.headline1!.color,
      borderColor: Theme.of(context).textTheme.headline1!.color,
      selectedBorderColor: Theme.of(context).textTheme.headline1!.color,
      fillColor: Theme.of(context).textTheme.headline1!.color,
      selectedColor: Theme.of(context).scaffoldBackgroundColor,
      isSelected: widget.listIsSelected!,
      onPressed: (index) {
        widget.functionOnPressed!();
      },
    );
  }
}

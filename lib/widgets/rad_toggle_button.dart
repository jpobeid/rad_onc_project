import 'package:flutter/material.dart';

class RadToggleButton extends StatefulWidget {
  final String? strOption1;
  final String? strOption2;
  final List<bool>? listIsSelected;
  final Function? functionOnPressed;
  final double? fractionToggleWidth;
  final double? sizeBorderRadius;

  const RadToggleButton({
    Key? key,
    required this.strOption1,
    required this.strOption2,
    required this.listIsSelected,
    required this.functionOnPressed,
    this.fractionToggleWidth = 0.8,
    this.sizeBorderRadius = 10,
  }) : super(key: key);

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

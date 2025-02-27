import 'package:flutter/material.dart';

class AppSlider extends StatefulWidget {
  const AppSlider({
    required this.value,
    required this.onChanged,
    super.key,
  });

  final double value;
  final ValueChanged<double> onChanged;

  @override
  State<AppSlider> createState() => _AppSliderState();
}

class _AppSliderState extends State<AppSlider> {
  late var value = widget.value;

  @override
  Widget build(BuildContext context) {
    return Slider(
      value: value,
      onChanged: (newValue) {
        setState(() => value = newValue);
        widget.onChanged(newValue);
      },
    );
  }
}

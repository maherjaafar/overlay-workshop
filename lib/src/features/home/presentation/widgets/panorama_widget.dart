import 'dart:async';
import 'package:flutter/material.dart';
import 'package:overlays_workshop/src/core/ui/widgets/app_asset.dart';

class PanoramaWidget extends StatefulWidget {
  const PanoramaWidget({
    super.key,
    required this.assets,
    this.period = const Duration(seconds: 30),
  });

  /// A list of SVG asset paths.
  final List<String> assets;

  /// Duration to display each asset before automatically switching.
  final Duration period;

  @override
  PanoramaWidgetState createState() => PanoramaWidgetState();
}

class PanoramaWidgetState extends State<PanoramaWidget> {
  late Timer _timer;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    // Start the automatic switching.
    _startPanorama();
  }

  /// Starts a timer that periodically changes the current asset index.
  void _startPanorama() {
    _timer = Timer.periodic(widget.period, (timer) {
      setState(() {
        // Move to the next index, wrapping back to zero if we go past the end.
        _currentIndex = (_currentIndex + 1) % widget.assets.length;
      });
    });
  }

  @override
  void dispose() {
    // Cancel the timer when the widget is disposed to avoid memory leaks.
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppAsset(
      assetPath: widget.assets[_currentIndex],
      fit: BoxFit
          .contain, // Adjust as needed (e.g. BoxFit.cover, BoxFit.fitWidth)
    );
  }
}

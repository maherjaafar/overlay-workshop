import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppAsset extends StatelessWidget {
  const AppAsset({
    required this.assetPath,
    this.fit = BoxFit.contain,
    this.width,
    this.height,
    this.color,
    super.key,
  });

  final String assetPath;
  final BoxFit fit;
  final double? width;
  final double? height;
  final Color? color; // optional: sometimes you want to color-tint your asset

  @override
  Widget build(BuildContext context) {
    // Simple check if the asset ends with .svg (case-insensitive)
    if (assetPath.toLowerCase().endsWith('.svg')) {
      return SvgPicture.asset(
        assetPath,
        width: width,
        height: height,
        fit: fit,
        color: color,
      );
    } else {
      return Image.asset(
        assetPath,
        width: width,
        height: height,
        fit: fit,
        color: color,
      );
    }
  }
}

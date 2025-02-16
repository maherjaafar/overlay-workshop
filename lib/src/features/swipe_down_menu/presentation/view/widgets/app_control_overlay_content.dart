import 'package:flutter/material.dart';
import 'package:overlays_workshop/src/features/app_control_menu/domain/extensions/app_control_overlay_build_context_extension.dart';

GlobalKey contentKey = GlobalKey();

class Content extends StatefulWidget {
  const Content({super.key});

  @override
  State<Content> createState() => _ContentState();
}

class _ContentState extends State<Content> {
  @override
  Widget build(BuildContext context) {
    return Container(
      key: contentKey,
      constraints: BoxConstraints.tight(
        Size(
          context.screenWidth,
          context.screenHeight * 0.3,
        ),
      ),
      height: context.screenHeight * 0.3,
      padding: const EdgeInsets.all(16).copyWith(top: 20),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Slider(
                value: 0.5,
                onChanged: (value) {},
              ),
              Slider(
                value: 0.5,
                onChanged: (value) {},
              ),
              _buildDragLine(width: width * 0.2),
            ],
          );
        },
      ),
    );
  }

  Widget _buildDragLine({
    required double width,
    double height = 12,
  }) {
    return Container(
      height: height,
      width: width,
      alignment: Alignment.bottomCenter,
      decoration: BoxDecoration(
        color: Colors.amber,
        borderRadius: BorderRadius.circular(16),
      ),
    );
  }
}

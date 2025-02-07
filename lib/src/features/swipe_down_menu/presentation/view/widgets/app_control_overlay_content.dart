import 'package:flutter/material.dart';

class Content extends StatelessWidget {
  const Content({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16).copyWith(top: 20),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          return Column(
            children: [
              Slider(
                value: 0.5,
                onChanged: (value) {},
              ),
              Slider(
                value: 0.5,
                onChanged: (value) {},
              ),
              const Spacer(),
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

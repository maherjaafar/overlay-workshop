import 'package:flutter/material.dart';
import 'package:overlays_workshop/src/core/ui/widgets/app_slider.dart';
import 'package:overlays_workshop/src/features/app_control_menu/domain/extensions/app_control_overlay_build_context_extension.dart';

GlobalKey contentKey = GlobalKey();

class Content extends StatelessWidget {
  const Content({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      key: contentKey,
      decoration: BoxDecoration(color: Colors.transparent),
      constraints: BoxConstraints.tight(
        Size(
          context.screenWidth * 0.8,
          context.screenHeight * 0.3,
        ),
      ),
      height: context.screenHeight * 0.3,
      padding: const EdgeInsets.all(16).copyWith(top: 24),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          late final separator = const Flexible(child: SizedBox(height: 24));
          return Column(
            children: [
              const _InformationsRow(),
              separator,
              _buildBrightnessSlider(context),
              separator,
              _buildVolumeSlider(context),
              separator,
              const Spacer(),
              separator,
              _buildDragLine(
                context: context,
                width: width * 0.2,
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildDragLine({
    required BuildContext context,
    required double width,
    double height = 8.0,
  }) {
    return Container(
      height: height,
      width: width,
      alignment: Alignment.bottomCenter,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onSurfaceVariant,
        borderRadius: BorderRadius.circular(16.0),
      ),
    );
  }

  Widget _buildBrightnessSlider(BuildContext context) {
    return _Slider(
      value: 0.5,
      onChanged: (value) {},
    );
  }

  Widget _buildVolumeSlider(BuildContext context) {
    return _Slider(
      value: 0.8,
      onChanged: (value) {},
    );
  }
}

class _InformationsRow extends StatelessWidget {
  const _InformationsRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 24,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const _WifiName(),
        const _MachineName(),
      ],
    );
  }
}

class _MachineName extends StatelessWidget {
  const _MachineName();

  @override
  Widget build(BuildContext context) {
    return _buildText('Name: 1080 Sprint', context);
  }
}

class _WifiName extends StatelessWidget {
  const _WifiName();

  @override
  Widget build(BuildContext context) {
    return _buildText('Wifi: Umain Guest', context);
  }
}

class _Slider extends StatelessWidget {
  const _Slider({
    required this.value,
    required this.onChanged,
  });

  final double value;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    return AppSlider(
      value: value,
      onChanged: onChanged,
    );
  }
}

Widget _buildText(String text, BuildContext context) {
  return Text(
    text,
    style: Theme.of(context).textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
        ),
  );
}

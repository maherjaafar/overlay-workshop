import 'package:flutter/material.dart';
import 'package:overlays_workshop/src/features/home/domain/constants/home_panorama_assets.dart';
import 'package:overlays_workshop/src/features/home/presentation/widgets/panorama_widget.dart';
import 'package:overlay_plus/overlay_plus.dart';
import 'package:overlays_workshop/src/features/swipe_down_menu/presentation/view/widgets/swipe_down_menu.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final overlayController = OverlayPlusController();
    return SwipeDownMenu(
      overlayController: overlayController,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(title),
        ),
        body: Center(
          child: PanoramaWidget(assets: kHomePanoramaAssets),
        ),
      ),
    );
  }
}

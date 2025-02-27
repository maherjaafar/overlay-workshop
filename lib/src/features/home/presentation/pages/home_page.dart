import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:overlays_workshop/src/core/constants/app_assets.dart';
import 'package:overlays_workshop/src/features/home/domain/constants/home_panorama_assets.dart';
import 'package:overlays_workshop/src/features/home/presentation/widgets/panorama_widget.dart';
import 'package:overlays_workshop/src/features/swipe_down_menu/presentation/view/widgets/app_control_overlay.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late final _overlayController = OverlayPortalController();

  @override
  Widget build(BuildContext context) {
    return SwipeDownMenu(
      overlayController: _overlayController,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
        ),
        body: Center(
          child: PanoramaWidget(assets: kHomePanoramaAssets),
        ),
      ),
    );
  }
}

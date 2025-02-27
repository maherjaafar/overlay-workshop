import 'package:flutter/material.dart';
import 'package:overlays_workshop/src/features/home/domain/constants/home_panorama_assets.dart';
import 'package:overlays_workshop/src/features/home/presentation/widgets/panorama_widget.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: PanoramaWidget(assets: kHomePanoramaAssets),
      ),
    );
  }
}

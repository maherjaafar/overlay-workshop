import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:overlays_workshop/src/features/swipe_down_menu/presentation/view_notifier/swipe_down_menu_view_notifier.dart';

extension AppControlOverlayBuildContextX on BuildContext {
  SwipeDownMenuViewNotifier get behaviourCubit =>
      read<SwipeDownMenuViewNotifier>();

  Size get screenSize => MediaQuery.of(this).size;
  double get screenWidth => screenSize.width;
  double get screenHeight => screenSize.height;
}

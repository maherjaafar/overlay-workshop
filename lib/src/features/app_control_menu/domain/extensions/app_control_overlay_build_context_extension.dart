import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:overlays_workshop/src/features/app_control_menu/app_control_menu.dart';

extension AppControlOverlayBuildContextX on BuildContext {
  AppControlOvelayBehaviourCubit get behaviourCubit =>
      read<AppControlOvelayBehaviourCubit>();

  Size get screenSize => MediaQuery.of(this).size;
  double get screenWidth => screenSize.width;
  double get screenHeight => screenSize.height;
}

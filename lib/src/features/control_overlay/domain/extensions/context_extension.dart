import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:overlays_workshop/src/features/control_overlay/view_notifier/overlay_view_notifier.dart';

extension BehaviourNotifierX on BuildContext {
  AppControlOvelayBehaviourCubit get behaviourCubit =>
      read<AppControlOvelayBehaviourCubit>();

  Size get screenSize => MediaQuery.of(this).size;
  double get screenWidth => screenSize.width;
  double get screenHeight => screenSize.height;
}

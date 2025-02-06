import 'package:equatable/equatable.dart';
import 'package:overlays_workshop/src/features/app_control_menu/app_control_menu.dart';

class AppControlOvelayBehaviourState extends Equatable {
  const AppControlOvelayBehaviourState({
    required this.status,
    required this.animate,
    required this.currentOverlayHeight,
    required this.topPosition,
  });

  AppControlOvelayBehaviourState copyWith({
    AppControlOvelayBehaviourStatus? status,
    bool? animate,
    double? currentOverlayHeight,
    double? topPosition,
  }) {
    return AppControlOvelayBehaviourState(
      status: status ?? this.status,
      animate: animate ?? this.animate,
      currentOverlayHeight: currentOverlayHeight ?? this.currentOverlayHeight,
      topPosition: topPosition ?? this.topPosition,
    );
  }

  bool get overlayCompletelyVisible => topPosition >= 0;

  @override
  List<Object> get props => [
        status,
        animate,
        currentOverlayHeight,
        topPosition,
      ];

  final AppControlOvelayBehaviourStatus status;
  final bool animate;
  final double currentOverlayHeight;
  final double topPosition;
}

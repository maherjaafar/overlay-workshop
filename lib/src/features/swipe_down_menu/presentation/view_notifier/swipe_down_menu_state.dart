import 'package:equatable/equatable.dart';
import 'package:overlays_workshop/src/features/app_control_menu/domain/enums/app_control_overlay_behavior_status.dart';

class SwipeDownMenuState extends Equatable {
  const SwipeDownMenuState({
    required this.status,
    required this.animate,
    required this.currentOverlayHeight,
    required this.topPosition,
  });

  SwipeDownMenuState copyWith({
    AppControlOvelayBehaviourStatus? status,
    bool? animate,
    double? currentOverlayHeight,
    double? topPosition,
  }) {
    return SwipeDownMenuState(
      status: status ?? this.status,
      animate: animate ?? this.animate,
      currentOverlayHeight: currentOverlayHeight ?? this.currentOverlayHeight,
      topPosition: topPosition ?? this.topPosition,
    );
  }

  final AppControlOvelayBehaviourStatus status;
  final bool animate;
  final double currentOverlayHeight;
  final double topPosition;

  bool get isCompletelyVisible => topPosition >= 0;

  @override
  List<Object> get props => [
        status,
        animate,
        currentOverlayHeight,
        topPosition,
      ];
}

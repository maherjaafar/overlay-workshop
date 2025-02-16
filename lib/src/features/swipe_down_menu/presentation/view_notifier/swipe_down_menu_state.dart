import 'package:equatable/equatable.dart';
import 'package:overlays_workshop/src/features/app_control_menu/domain/enums/app_control_overlay_behavior_status.dart';

class SwipeDownMenuState extends Equatable {
  const SwipeDownMenuState({
    required this.status,
    required this.animate,
    required this.currentOverlayHeight,
    required this.contentHeight,
    required this.topPosition,
  });

  SwipeDownMenuState copyWith({
    AppControlOvelayBehaviourStatus? status,
    bool? animate,
    double? currentOverlayHeight,
    double? contentHeight,
    double? topPosition,
  }) {
    return SwipeDownMenuState(
      status: status ?? this.status,
      animate: animate ?? this.animate,
      currentOverlayHeight: currentOverlayHeight ?? this.currentOverlayHeight,
      contentHeight: contentHeight ?? this.contentHeight,
      topPosition: topPosition ?? this.topPosition,
    );
  }

  final AppControlOvelayBehaviourStatus status;
  final bool animate;
  // This can change because of the drag
  final double? currentOverlayHeight;
  // This height is fixed
  final double? contentHeight;
  final double topPosition;

  bool get hasHeight => contentHeight != null;
  bool get isCompletelyVisible => hasHeight && topPosition >= 0;

  @override
  List<Object?> get props => [
        status,
        animate,
        currentOverlayHeight,
        contentHeight,
        topPosition,
      ];
}

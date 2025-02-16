import 'package:equatable/equatable.dart';
import 'package:overlays_workshop/src/features/swipe_down_menu/domain/model/swipe_down_menu_configuration.dart';

class SwipeDownMenuDragDetails extends Equatable {
  const SwipeDownMenuDragDetails({
    required this.startDragPosition,
    required this.currentDragPosition,
    required this.configuration,
  });

  const SwipeDownMenuDragDetails.defaultConfig(this.configuration)
      : startDragPosition = 0,
        currentDragPosition = 0;

  SwipeDownMenuDragDetails copyWith({
    double? startDragPosition,
    double? currentDragPosition,
    SwipeDownMenuConfiguration? configuration,
  }) {
    return SwipeDownMenuDragDetails(
      startDragPosition: startDragPosition ?? this.startDragPosition,
      currentDragPosition: currentDragPosition ?? this.currentDragPosition,
      configuration: configuration ?? this.configuration,
    );
  }

  final double startDragPosition;
  final double currentDragPosition;
  final SwipeDownMenuConfiguration configuration;

  double? get height => configuration.height;
  bool get hasHeight => height != null;

  // Drag up
  double get dragUpDistance => startDragPosition - currentDragPosition;
  double get _dragUpInterval => configuration.baseDragInterval / 1.7;
  bool get canStartDragUp =>
      !hasHeight ? false : startDragPosition >= height! - _dragUpInterval;
  double get dragDownDistance => currentDragPosition - startDragPosition;
  bool get correctDragUpRange =>
      canStartDragUp && dragUpDistance > configuration.minimumDistanceToMove;

  bool checkHasDragUpEnough(double topPosition, double currentOverlayHeight) {
    return correctDragUpRange || (topPosition <= -currentOverlayHeight / 2);
  }

  // Drag down
  bool get correctDragDownRange =>
      startDragPosition <= configuration.dragDownInterval &&
      dragDownDistance > configuration.minimumDistanceToMove;
  bool get hasDragDownEnough {
    return correctDragDownRange &&
        dragDownDistance > configuration.minimumDragDistance;
  }

  // Stretch overlay
  bool get canStretchOverlay => !hasHeight
      ? false
      : startDragPosition <= height! && currentDragPosition > height!;

  double get stretchHeight {
    if (!hasHeight) return 0;
    final stretchHeight = currentDragPosition - height!;
    return stretchHeight > 0 ? stretchHeight : 0;
  }

  @override
  List<Object?> get props => [startDragPosition, currentDragPosition, height];
}

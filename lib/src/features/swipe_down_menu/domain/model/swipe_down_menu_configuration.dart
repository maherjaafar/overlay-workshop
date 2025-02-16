import 'package:equatable/equatable.dart';

class SwipeDownMenuConfiguration extends Equatable {
  const SwipeDownMenuConfiguration({
    required this.minimumDragDistance,
    required this.minimumDistanceToMove,
    required this.baseDragInterval,
    required this.height,
  });

  const SwipeDownMenuConfiguration.defaultConfiguration()
      : minimumDragDistance = 80.0,
        minimumDistanceToMove = 10.0,
        baseDragInterval = 56.0,
        height = null;

  SwipeDownMenuConfiguration copyWith({
    double? height,
    double? minimumDragDistance,
    double? minimumDistanceToMove,
    double? baseDragInterval,
  }) {
    return SwipeDownMenuConfiguration(
      height: height ?? this.height,
      minimumDragDistance: minimumDragDistance ?? this.minimumDragDistance,
      minimumDistanceToMove:
          minimumDistanceToMove ?? this.minimumDistanceToMove,
      baseDragInterval: baseDragInterval ?? this.baseDragInterval,
    );
  }

  double get dragDownInterval => baseDragInterval * 1.6;

  final double? height;
  final double minimumDragDistance;
  final double minimumDistanceToMove;
  final double baseDragInterval;

  @override
  List<Object?> get props => [
        height,
        minimumDragDistance,
        minimumDistanceToMove,
        baseDragInterval,
      ];
}

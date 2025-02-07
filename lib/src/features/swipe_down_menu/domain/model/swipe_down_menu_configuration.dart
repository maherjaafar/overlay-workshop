class SwipeDownMenuConfiguration {
  SwipeDownMenuConfiguration({
    required this.height,
    required this.minimumDragDistance,
    required this.minimumDistanceToMove,
    required this.baseDragInterval,
  });

  const SwipeDownMenuConfiguration.defaultConfiguration(this.height)
      : minimumDragDistance = 80.0,
        minimumDistanceToMove = 10.0,
        baseDragInterval = 56.0;

  double get dragDownInterval => baseDragInterval * 1.6;

  final double height;
  final double minimumDragDistance;
  final double minimumDistanceToMove;
  final double baseDragInterval;
}

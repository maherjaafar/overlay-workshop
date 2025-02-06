import 'package:flutter/material.dart';
import 'package:overlays_workshop/src/features/app_control_menu/app_control_menu.dart';
import 'package:overlay_plus/overlay_plus.dart';

const kAppBarHeight = 56.0;

mixin OverlayDragHandler on StatelessWidget {
  /// The user starts dragging the overlay
  /// We update the [_startDragPosition] and [_currentDragPosition] variables
  void handleDragStart(BuildContext context, DragStartDetails details) {
    context.behaviourCubit.updateIsAnimating(false);
    _startDragPosition = details.globalPosition.dy;
    _currentDragPosition = _startDragPosition;
  }

  /// The user already started dragging the overlay
  /// We update the [_currentDragPosition] variable
  /// We check if the user is dragging up or down
  /// We update the overlay position and height if needed
  void handleDragUpdate(BuildContext context, DragUpdateDetails details) {
    final behaviorCubit = context.behaviourCubit;
    void setTopPosition([double? topPosition]) {
      final currentHeight = behaviorCubit.currentOverlayHeight;
      final newTopPosition =
          topPosition ?? _currentDragPosition - currentHeight;
      behaviorCubit.updateTopPosition(newTopPosition.clamp(-currentHeight, 0));
    }

    _updateDragPosition(details);
    final status = behaviorCubit.status;
    final shouldShowOverlay = !status.isShown && correctDragDownRange;
    final canDrag =
        shouldShowOverlay || (correctDragUpRange && !status.isHidden);
    if ((canDrag || canStretchOverlay) && !status.isInProgress) {
      final newStatus = shouldShowOverlay
          ? AppControlOvelayBehaviourStatus.showing
          : AppControlOvelayBehaviourStatus.hiding;
      behaviorCubit.updateStatus(newStatus);
    }

    // Update top position when dragging
    if (canDrag) setTopPosition();
    if (canStretchOverlay) _adjustHeight(context);
  }

  /// The user stops dragging the overlay
  /// We check if the user dragged enough to show or hide the overlay
  /// We update the overlay position and height if needed
  void handleDragEnd(
    BuildContext context,
    DragEndDetails details,
    OverlayPlusController controller,
  ) {
    final behaviorCubit = context.behaviourCubit;
    behaviorCubit.updateIsAnimating(true);
    final topPosition = behaviorCubit.topPosition;
    // Determine if drag down was enough to show the overlay
    if (_checkHasDragDownEnough()) return _showOverlay(context);

    // Determine if drag up was enough to hide the overlay
    if (_checkHasDragUpEnough(
        topPosition, behaviorCubit.currentOverlayHeight)) {
      return hideOverlay(context);
    }

    // Adjust overlay position if needed
    if (_shouldResetOverlay(controller)) _setBehaviorValues(context);
  }

  void hideOverlay(BuildContext context) {
    context.behaviourCubit.setValues(
      status: AppControlOvelayBehaviourStatus.hidden,
      topPosition: -height,
      newHeight: height,
    );
  }

  // Variables
  double _startDragPosition = 0.0;
  double _currentDragPosition = 0.0;

  double get height;
}

extension OverlayDragHandlerX on OverlayDragHandler {
  void _showOverlay(BuildContext context) {
    _setBehaviorValues(context, status: AppControlOvelayBehaviourStatus.shown);
  }

  void _adjustHeight(BuildContext context) {
    final behaviorCubit = context.behaviourCubit;
    if (behaviorCubit.overlayCompletelyVisible) {
      final screenHeight = context.screenHeight;
      final newHeight = height + (stretchHeight * 0.3);
      behaviorCubit.updateCurrentOverlayHeight(
          newHeight > screenHeight ? screenHeight : newHeight);
    }
  }

  double get stretchHeight {
    final stretchHeight = _currentDragPosition - height;
    return stretchHeight > 0 ? stretchHeight : 0;
  }

  void _updateDragPosition(DragUpdateDetails details) {
    _currentDragPosition = details.globalPosition.dy;
  }

  bool _shouldResetOverlay(OverlayPlusController controller) {
    return controller.isShowing;
  }

  void _setBehaviorValues(BuildContext context,
      {AppControlOvelayBehaviourStatus? status}) {
    context.behaviourCubit.setValues(newHeight: height, status: status);
  }

  // Getters
  double get _minimumDragDistance => height / 6;
  double get _minimumDistanceToMoveTheOverlay => 10;
  double get _baseDragInterval => kAppBarHeight;

  // Drag up
  double get dragUpDistance => _startDragPosition - _currentDragPosition;
  double get _dragUpInterval => _baseDragInterval / 1.7;
  bool get canStartDragUp => _startDragPosition >= height - _dragUpInterval;
  bool get correctDragUpRange =>
      canStartDragUp && dragUpDistance > _minimumDistanceToMoveTheOverlay;
  bool _checkHasDragUpEnough(double topPosition, double currentOverlayHeight) {
    return correctDragUpRange || (topPosition <= -currentOverlayHeight / 2);
  }

  // Drag down
  double get dragDownDistance => _currentDragPosition - _startDragPosition;
  double get _dragDownInterval => _baseDragInterval * 1.6;
  bool get correctDragDownRange =>
      _startDragPosition <= _dragDownInterval &&
      dragDownDistance > _minimumDistanceToMoveTheOverlay;

  bool _checkHasDragDownEnough() {
    return correctDragDownRange && dragDownDistance > _minimumDragDistance;
  }

  // Stretch overlay
  bool get canStretchOverlay =>
      _startDragPosition <= height && _currentDragPosition > height;
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:overlays_workshop/src/features/app_control_menu/domain/enums/app_control_overlay_behavior_status.dart';
import 'package:overlays_workshop/src/features/swipe_down_menu/domain/model/swipe_down_menu_details.dart';
import 'package:overlays_workshop/src/features/swipe_down_menu/domain/repository/gestures_repository.dart';
import 'package:overlay_plus/overlay_plus.dart';
import 'package:overlays_workshop/src/features/swipe_down_menu/presentation/view_notifier/swipe_down_menu_state.dart';

class SwipeDownMenuViewNotifier extends Cubit<SwipeDownMenuState> {
  SwipeDownMenuViewNotifier({
    required double initialOverlayHeight,
    required SwipeDownMenuRepository repository,
  })  : _repository = repository,
        super(
          SwipeDownMenuState(
            status: AppControlOvelayBehaviourStatus.hidden,
            animate: false,
            currentOverlayHeight: initialOverlayHeight,
            topPosition: -initialOverlayHeight,
          ),
        );

  /// The user starts dragging the overlay
  void handleDragStart(DragStartDetails details) {
    updateIsAnimating(false);
    _repository.handleDragStart(details);
  }

  /// The user already started dragging the overlay
  void handleDragUpdate(DragUpdateDetails details, double maxHeight) {
    void setTopPosition([double? topPosition]) {
      final newTopPosition = topPosition ??
          _repository.dragDetails.currentDragPosition - currentOverlayHeight;
      updateTopPosition(
        newTopPosition.clamp(
          -_repository.dragDetails.height,
          0,
        ),
      );
    }

    _repository.updateDragDetails(
      _repository.dragDetails.copyWith(
        currentDragPosition: details.globalPosition.dy,
      ),
    );

    final shouldShowOverlay =
        !status.isShown && _repository.dragDetails.correctDragDownRange;
    final canDrag = shouldShowOverlay ||
        (dragDetails.correctDragUpRange && !status.isHidden);
    if ((canDrag || dragDetails.canStretchOverlay) && !status.isInProgress) {
      final newStatus = shouldShowOverlay
          ? AppControlOvelayBehaviourStatus.showing
          : AppControlOvelayBehaviourStatus.hiding;
      updateStatus(newStatus);
    }

    // Update top position when dragging
    if (canDrag) setTopPosition();
    if (dragDetails.canStretchOverlay) _adjustHeight(maxHeight: maxHeight);
  }

  /// The user stops dragging the overlay
  /// We check if the user dragged enough to show or hide the overlay
  /// We update the overlay position and height if needed
  void handleDragEnd(OverlayPlusController controller) {
    updateIsAnimating(true);
    // Determine if drag down was enough to show the overlay
    if (dragDetails.hasDragDownEnough) {
      return setValues(newHeight: dragDetails.height, status: status);
    }

    // Determine if drag up was enough to hide the overlay
    if (dragDetails.checkHasDragUpEnough(
      topPosition,
      currentOverlayHeight,
    )) {
      hideOverlay();
    }

    // Adjust overlay position if needed
    if (controller.isShowing) {
      setValues(newHeight: dragDetails.height);
    }
  }

  void hideOverlay() {
    setValues(
      status: AppControlOvelayBehaviourStatus.hidden,
      topPosition: -dragDetails.height,
      newHeight: dragDetails.height,
    );
  }

  void _adjustHeight({required double maxHeight}) {
    if (overlayCompletelyVisible) {
      final newHeight = dragDetails.height + (dragDetails.stretchHeight * 0.3);
      updateCurrentOverlayHeight(
        newHeight > maxHeight ? maxHeight : newHeight,
      );
    }
  }

  void updateStatus(AppControlOvelayBehaviourStatus status) {
    if (state.status == status) return;
    emit(state.copyWith(status: status));
  }

  void updateIsAnimating(bool isAnimating) {
    if (state.animate == isAnimating) return;
    emit(state.copyWith(animate: isAnimating));
  }

  void updateCurrentOverlayHeight(double currentOverlayHeight) {
    emit(state.copyWith(currentOverlayHeight: currentOverlayHeight));
  }

  void updateTopPosition(double topPosition) {
    if (state.topPosition == topPosition) return;
    emit(state.copyWith(topPosition: topPosition));
  }

  void setValues({
    required double newHeight,
    double topPosition = 0,
    AppControlOvelayBehaviourStatus? status,
  }) {
    final currentTopPosition = state.topPosition;
    if (currentTopPosition == topPosition &&
        currentOverlayHeight == newHeight &&
        state.status == status) {
      return;
    }
    emit(
      state.copyWith(
        status: status,
        currentOverlayHeight: newHeight,
        topPosition: topPosition,
      ),
    );
  }

  void _hideOverlay() {
    emit(
      state.copyWith(
        animate: true,
        topPosition: -currentOverlayHeight,
        status: AppControlOvelayBehaviourStatus.hidden,
      ),
    );
  }

  @override
  Future<void> close() {
    _hideOverlay();
    return super.close();
  }

  AppControlOvelayBehaviourStatus get status => state.status;
  double get topPosition => state.topPosition;
  bool get overlayCompletelyVisible => state.isCompletelyVisible;
  double get currentOverlayHeight => state.currentOverlayHeight;

  SwipeDownMenuDragDetails get dragDetails => _repository.dragDetails;

  bool get shouldHideOverlay => topPosition == -currentOverlayHeight;

  final SwipeDownMenuRepository _repository;
}

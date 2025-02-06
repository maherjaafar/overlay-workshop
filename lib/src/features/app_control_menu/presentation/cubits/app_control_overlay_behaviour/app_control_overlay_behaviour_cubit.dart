import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:overlays_workshop/src/features/app_control_menu/app_control_menu.dart';

class AppControlOvelayBehaviourCubit
    extends Cubit<AppControlOvelayBehaviourState> {
  AppControlOvelayBehaviourCubit({
    required double initialOverlayHeight,
  }) : super(
          AppControlOvelayBehaviourState(
            status: AppControlOvelayBehaviourStatus.hidden,
            animate: false,
            currentOverlayHeight: initialOverlayHeight,
            topPosition: -initialOverlayHeight,
          ),
        );

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
        state.currentOverlayHeight == newHeight &&
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
  bool get overlayCompletelyVisible => state.overlayCompletelyVisible;
  double get currentOverlayHeight => state.currentOverlayHeight;

  bool get shouldHideOverlay => topPosition == -currentOverlayHeight;
}

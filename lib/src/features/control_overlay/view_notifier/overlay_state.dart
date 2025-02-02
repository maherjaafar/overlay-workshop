part of 'overlay_view_notifier.dart';

enum AppControlOvelayBehaviourStatus {
  hiding,
  showing,
  hidden,
  shown;

  bool get isShown => this == shown;
  bool get isInProgress => this == showing || this == hiding;
  bool get isHidden => this == hiding;
}

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

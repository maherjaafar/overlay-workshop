enum AppControlOvelayBehaviourStatus {
  hidden,
  showing,
  hiding,
  shown,
}

extension AppControlOvelayBehaviourStatusX on AppControlOvelayBehaviourStatus {
  bool get isHidden => this == AppControlOvelayBehaviourStatus.hidden;
  bool get isHiding => this == AppControlOvelayBehaviourStatus.hiding;
  bool get isShowing => this == AppControlOvelayBehaviourStatus.showing;
  bool get isInProgress => isHiding || isShowing;
  bool get isShown => this == AppControlOvelayBehaviourStatus.shown;
}

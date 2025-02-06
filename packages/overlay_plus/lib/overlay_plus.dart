library;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class OverlayPlus extends StatefulWidget {
  const OverlayPlus({
    required this.child,
    required this.overlayChildBuilder,
    required this.controller,
    this.entryWidth,
    this.entryHeight,
    this.hasPositioned = true,
    this.maintainState = true,
    super.key,
  }) : _targetsRootOverlay = false;

  const OverlayPlus.targetsRootOverlay({
    required this.child,
    required this.overlayChildBuilder,
    required this.controller,
    this.entryWidth,
    this.entryHeight,
    this.hasPositioned = true,
    this.maintainState = true,
    super.key,
  }) : _targetsRootOverlay = true;

  final Widget child;
  final Widget Function(BuildContext context) overlayChildBuilder;
  final OverlayPlusController controller;

  final double? entryWidth;
  final double? entryHeight;
  final bool hasPositioned;
  final bool _targetsRootOverlay;
  final bool maintainState;

  @override
  State<OverlayPlus> createState() => _OverlayPlusState();
}

class _OverlayPlusState extends State<OverlayPlus> {
  OverlayEntry? _entry;
  RenderBox? _renderWidget;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _findRenderObject();
      if (_renderWidget == null) {
        debugPrint('Rendered widget not found');
      }
    });
    _setupController(widget.controller);
    debugPrint('OverlayPlus initialized');
  }

  @override
  void didUpdateWidget(covariant OverlayPlus oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Re-attach the same controller to this new state instance
    // after hot reload or when the widget updates.
    _setupController(widget.controller);
  }

  @override
  void dispose() {
    // Detach the controller from this state before disposing
    if (widget.controller._attachTarget == this) {
      widget.controller._attachTarget = null;
    }
    _hideEntry();
    super.dispose();
  }

  void _setupController(OverlayPlusController controller) {
    assert(
      controller._attachTarget == null || controller._attachTarget == this,
      'Failed to attach $controller to $this. It is already attached to ${controller._attachTarget}.',
    );
    controller._attachTarget = this;
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  void show({OverlayEntry? below, OverlayEntry? above}) {
    _showEntry(context, below, above);
  }

  void hide() {
    _hideEntry();
  }

  void findEntry() {
    _entry ??= _getOverlayEntry();
  }

  void _showEntry(BuildContext context, OverlayEntry? below, OverlayEntry? above) {
    findEntry();
    final overlay = Overlay.of(context, rootOverlay: widget._targetsRootOverlay);

    final hasBelow = below != null;
    final hasAbove = above != null;

    if (!hasBelow && !hasAbove) {
      overlay.insert(_entry!);
      return;
    }
    if (hasBelow && hasAbove) {
      overlay.insert(_entry!, below: below, above: above);
      return;
    }
    if (hasBelow) {
      overlay.insert(_entry!, below: below);
      return;
    }
    overlay.insert(_entry!, above: above);
  }

  void _hideEntry() {
    try {
      if (_entry != null && _entry!.mounted) {
        _entry?.remove();
        _entry = null;
      }
    } on Exception catch (e) {
      debugPrint('Error removing entry: $e, It may be already removed.');
    }
  }

  void _findRenderObject() {
    _renderWidget = context.findRenderObject() as RenderBox?;
  }

  OverlayEntry _getOverlayEntry() {
    return OverlayEntry(
      builder: (context) {
        // The actual overlay content from overlayChildBuilder
        final overlayChild = widget.overlayChildBuilder(context);

        // If the user wants to position the overlay relative to the child:
        Widget positionedOverlay;
        if (widget.hasPositioned) {
          _findRenderObject();
          final size = _renderWidget?.size;
          final height = widget.entryHeight ?? size?.height;
          final width = widget.entryWidth ?? size?.width;
          // Example: overlay content is a smaller container
          // so the underlying child can still be tapped in tests
          positionedOverlay = Positioned(
            height: height ?? 300,
            width: width ?? 300,
            child: overlayChild,
          );
        } else {
          // No positioning
          positionedOverlay = overlayChild;
        }

        return positionedOverlay;
      },
      canSizeOverlay: true,
      maintainState: widget.maintainState,
    );
  }
}

class OverlayPlusController {
  /// Creates an [OverlayPlusController], optionally with a String identifier
  /// `debugLabel`.
  OverlayPlusController({String? debugLabel}) : _debugLabel = debugLabel;

  _OverlayPlusState? _attachTarget;
  final String? _debugLabel;

  /// Show the overlay child of the [OverlayPlus] this controller is attached
  /// to, at the top of the target [Overlay].
  ///
  /// When there are more than one [OverlayPlus]s that target the same
  /// [Overlay], the overlay child of the last [OverlayPlus] to have called
  /// [show] appears at the top level, unobstructed.
  ///
  /// If [isShowing] is already true, calling this method brings the overlay
  /// child it controls to the top.
  ///
  /// This method should typically not be called while the widget tree is being
  /// rebuilt.
  void show({
    OverlayEntry? below,
    OverlayEntry? above,
  }) {
    if (isShowing) {
      return debugPrint('OverlayPlusController is already showing');
    }
    final state = _attachTarget;
    if (state != null) {
      state.show(below: below, above: above);
    } else {
      debugPrint('OverlayPlusController is detached');
    }
  }

  /// Hide the [OverlayPlus]'s overlay child.
  ///
  /// Once hidden, the overlay child will be removed from the widget tree the
  /// next time the widget tree rebuilds, and stateful widgets in the overlay
  /// child may lose states as a result.
  ///
  /// This method should typically not be called while the widget tree is being
  /// rebuilt.
  void hide() {
    final state = _attachTarget;
    if (state != null) {
      state.hide();
    } else {
      debugPrint('OverlayPlusController is detached');
    }
  }

  /// Whether the associated [OverlayPlus] is showing its overlay child.
  bool get isShowing {
    final state = _attachTarget;
    return state != null && state._entry != null && state._entry!.mounted;
  }

  /// Convenience method for toggling the current [isShowing] status.
  void toggle() => isShowing ? hide() : show();

  @override
  String toString() {
    final debugLabel = _debugLabel;
    final label = debugLabel == null ? '' : '($debugLabel)';
    final isDetached = _attachTarget != null ? '' : ' DETACHED';
    return '${objectRuntimeType(this, 'OverlayPlusController')}$label$isDetached';
  }
}

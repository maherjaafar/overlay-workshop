import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:overlays_workshop/src/features/control_overlay.dart';

const _kAnimationDuration = Duration(milliseconds: 300);

class AppControlOverlay extends StatelessWidget {
  const AppControlOverlay({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AppControlOverlayBuilder(
      overlayContent: Container(
        height: 200,
        color: Colors.white,
        child: Column(
          children: [
            const SizedBox(height: 16),
            const Text('Overlay content'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {},
              child: const Text('Button'),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
      height: 300,
      child: child,
    );
  }
}

// ignore: must_be_immutable
class AppControlOverlayBuilder extends StatelessWidget with OverlayDragHandler {
  AppControlOverlayBuilder({
    required this.child,
    required this.overlayContent,
    required this.height,
    super.key,
  });

  final Widget child;
  final Widget overlayContent;

  @override
  final double height;

  OverlayEntry? _overlayEntry;

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<AppControlOvelayBehaviourCubit,
            AppControlOvelayBehaviourState>(
          listenWhen: (previous, current) {
            final differentHeight =
                previous.currentOverlayHeight != current.currentOverlayHeight;
            final differentTopPosition =
                previous.topPosition != current.topPosition;
            return differentHeight || differentTopPosition;
          },
          listener: (context, state) {
            // Entry cubit
            final status = state.status;
            final shouldBeVisible = !status.isHidden;
            final entryAlreadyExists = _overlayEntry != null;
            if (!entryAlreadyExists && shouldBeVisible) {
              showOverlay(context);
            }
            final isCompletelyHidden = state.topPosition == -height;
            if (status.isHidden && isCompletelyHidden) {
              // Waiting for the animation to finish before hiding the [TemOverlay]
              Timer(_kAnimationDuration, () => removeOverlay(context));
            }
          },
        ),
      ],
      child: _buildDragDetector(context: context, child: child),
    );
  }

  void removeOverlay(BuildContext context) {
    _overlayEntry?.remove();
    _overlayEntry = null;
    hideOverlay(context);
  }

  void showOverlay(BuildContext context) {
    _overlayEntry = OverlayEntry(
      maintainState: true,
      canSizeOverlay: true,
      builder: (innerContext) {
        return Positioned(
          child: BlocProvider.value(
            value: context.read<AppControlOvelayBehaviourCubit>(),
            child: _buildDragDetector(
              context: context,
              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  _OverlayBackground(
                    onBackgroundTap: () => removeOverlay(context),
                    isShown: _overlayEntry != null,
                  ),
                  // Positioned to define the size of the overlay
                  BlocBuilder<AppControlOvelayBehaviourCubit,
                      AppControlOvelayBehaviourState>(
                    buildWhen: (previous, current) {
                      final differentHeight = previous.currentOverlayHeight !=
                          current.currentOverlayHeight;
                      final differentTopPosition =
                          previous.topPosition != current.topPosition;
                      return differentHeight || differentTopPosition;
                    },
                    builder: (context, state) {
                      return _buildOverlayChild(
                        context: context,
                        width: 700,
                        isAnimating: state.animate,
                        currentOverlayHeight: state.currentOverlayHeight,
                        topPosition: state.topPosition,
                        child: overlayContent,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  Widget _buildOverlayChild({
    required BuildContext context,
    required Widget child,
    required bool isAnimating,
    required double width,
    required double currentOverlayHeight,
    required double topPosition,
  }) {
    return _buildPositioned(
      context: context,
      overlayWidth: width,
      isAnimating: isAnimating,
      currentOverlayHeight: currentOverlayHeight,
      topPosition: topPosition,
      // Gesture detector to handle drag events
      child: Material(
        color: Colors.black54,
        borderRadius: const BorderRadius.vertical(
          bottom: Radius.circular(16),
        ),
        child: AnimatedContainer(
          duration: _kAnimationDuration,
          padding: currentOverlayHeight - height > 0
              ? EdgeInsets.only(top: currentOverlayHeight - height)
              : EdgeInsets.zero,
          child: overlayContent,
        ),
      ),
    );
  }

  Widget _buildPositioned({
    required BuildContext context,
    required Widget child,
    required bool isAnimating,
    required double overlayWidth,
    required double currentOverlayHeight,
    required double topPosition,
    double? leftPosition,
  }) {
    return AnimatedPositioned(
      duration: isAnimating ? _kAnimationDuration : Duration.zero,
      curve: Curves.easeInOutCubic,
      width: overlayWidth,
      height: currentOverlayHeight,
      top: topPosition,
      left: leftPosition,
      child: child,
    );
  }

  Widget _buildDragDetector({
    required BuildContext context,
    required Widget child,
  }) {
    return OverlayWidgets.buildDragDetector(
      onDragStart: (details) => handleDragStart(context, details),
      onDragUpdate: (details) => handleDragUpdate(context, details),
      onDragEnd: (details) => handleDragEnd(context, details, _overlayEntry),
      child: child,
    );
  }
}

class OverlayWidgets {
  static Widget buildDragDetector({
    required Widget child,
    required Function(DragStartDetails) onDragStart,
    required Function(DragUpdateDetails) onDragUpdate,
    required Function(DragEndDetails) onDragEnd,
  }) {
    return GestureDetector(
      onVerticalDragStart: onDragStart,
      onVerticalDragUpdate: onDragUpdate,
      onVerticalDragEnd: onDragEnd,
      child: child,
    );
  }
}

class _OverlayBackground extends StatelessWidget {
  const _OverlayBackground({
    required this.onBackgroundTap,
    required this.isShown,
  });

  final VoidCallback onBackgroundTap;
  final bool isShown;

  @override
  Widget build(BuildContext context) {
    // Fade background when overlay is shown
    return BlocSelector<AppControlOvelayBehaviourCubit,
        AppControlOvelayBehaviourState, bool>(
      selector: (state) => state.overlayCompletelyVisible,
      builder: (context, isVisible) {
        final enabled = isVisible && isShown;
        return GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTapUp: enabled ? (_) => onBackgroundTap() : null,
          child: AnimatedContainer(
            duration: _kAnimationDuration,
            color: enabled ? Colors.black.withOpacity(0.6) : Colors.transparent,
          ),
        );
      },
    );
  }
}

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:overlays_workshop/src/features/app_control_menu/app_control_menu.dart';
import 'package:overlay_plus/overlay_plus.dart';

const _kAnimationDuration = Duration(milliseconds: 300);

class AppControlOverlay extends StatelessWidget {
  const AppControlOverlay({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final overlayHeight = context.screenHeight * 0.48;
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          lazy: false,
          create: (_) => AppControlOvelayBehaviourCubit(
              initialOverlayHeight: overlayHeight),
        ),
      ],
      child: AppControlOverlayBuilder(
        overlayContent: const AppControlOverlayContent(),
        height: overlayHeight,
        child: child,
      ),
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

  @override
  Widget build(BuildContext context) {
    final behaviorCubit = context.read<AppControlOvelayBehaviourCubit>();
    final width = context.screenWidth * 0.8;
    final overlayController = OverlayPlusController();
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
            final entryAlreadyExists = overlayController.isShowing;
            if (!entryAlreadyExists && shouldBeVisible) {
              overlayController.show();
            }
            final isCompletelyHidden = state.topPosition == -height;
            if (status.isHidden && isCompletelyHidden) {
              // Waiting for the animation to finish before hiding the [TemOverlay]
              Timer(_kAnimationDuration, overlayController.hide);
            }
          },
        ),
      ],
      child: OverlayPlus(
        controller: overlayController,
        hasPositioned: false,
        overlayChildBuilder: (_) {
          return BlocProvider.value(
            value: behaviorCubit,
            child: _buildDragDetector(
              context: context,
              controller: overlayController,
              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  _OverlayBackground(
                    overlayController: overlayController,
                    onBackgroundTap: () => hideOverlay(context),
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
                        width: width,
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
          );
        },
        child: _buildDragDetector(
            context: context, child: child, controller: overlayController),
      ),
    );
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
        color: Colors.grey,
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
    required OverlayPlusController controller,
  }) {
    return OverlayWidgets.buildDragDetector(
      onDragStart: (details) => handleDragStart(context, details),
      onDragUpdate: (details) => handleDragUpdate(context, details),
      onDragEnd: (details) => handleDragEnd(context, details, controller),
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
    required this.overlayController,
  });

  final VoidCallback onBackgroundTap;
  final OverlayPlusController overlayController;

  @override
  Widget build(BuildContext context) {
    // Fade background when overlay is shown
    return BlocSelector<AppControlOvelayBehaviourCubit,
        AppControlOvelayBehaviourState, bool>(
      selector: (state) => state.overlayCompletelyVisible,
      builder: (context, isVisible) {
        final isShown = overlayController.isShowing;
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

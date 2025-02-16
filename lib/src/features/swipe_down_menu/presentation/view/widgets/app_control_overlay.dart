import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:overlay_plus/overlay_plus.dart';
import 'package:overlays_workshop/src/features/app_control_menu/domain/enums/app_control_overlay_behavior_status.dart';
import 'package:overlays_workshop/src/features/app_control_menu/domain/extensions/app_control_overlay_build_context_extension.dart';
import 'package:overlays_workshop/src/features/swipe_down_menu/domain/model/swipe_down_menu_configuration.dart';
import 'package:overlays_workshop/src/features/swipe_down_menu/domain/model/swipe_down_menu_details.dart';
import 'package:overlays_workshop/src/features/swipe_down_menu/domain/repository/gestures_repository.dart';
import 'package:overlays_workshop/src/features/swipe_down_menu/presentation/view/widgets/app_control_overlay_content.dart';
import 'package:overlays_workshop/src/features/swipe_down_menu/presentation/view_notifier/swipe_down_menu_state.dart';
import 'package:overlays_workshop/src/features/swipe_down_menu/presentation/view_notifier/swipe_down_menu_view_notifier.dart';

const _kAnimationDuration = Duration(milliseconds: 300);

class SwipeDownMenu extends StatelessWidget {
  const SwipeDownMenu({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final overlayHeight = context.screenHeight * 0.48;
    final overlayController = OverlayPlusController();
    return RepositoryProvider(
      create: (context) => SwipeDownMenuRepositoryImpl(
        initialDetails: SwipeDownMenuDragDetails(
          startDragPosition: 0,
          currentDragPosition: 0,
          configuration: SwipeDownMenuConfiguration.defaultConfiguration(
            overlayHeight,
          ),
        ),
      ),
      child: BlocProvider(
        lazy: false,
        create: (context) => SwipeDownMenuViewNotifier(
          repository: context.read<SwipeDownMenuRepositoryImpl>(),
          initialOverlayHeight: overlayHeight,
        ),
        child: _SwipeDownMenuView(
          overlayContent: const Content(),
          height: overlayHeight,
          overlayController: overlayController,
          child: child,
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class _SwipeDownMenuView extends StatelessWidget {
  const _SwipeDownMenuView({
    required this.child,
    required this.overlayContent,
    required this.height,
    required this.overlayController,
  });

  final Widget child;
  final Widget overlayContent;
  final double height;
  final OverlayPlusController overlayController;

  @override
  Widget build(BuildContext context) {
    final behaviorCubit = context.read<SwipeDownMenuViewNotifier>();
    final width = context.screenWidth * 0.8;
    return MultiBlocListener(
      listeners: [
        BlocListener<SwipeDownMenuViewNotifier, SwipeDownMenuState>(
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
        maintainState: false,
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
                    onBackgroundTap:
                        context.read<SwipeDownMenuViewNotifier>().hideOverlay,
                  ),
                  // Positioned to define the size of the overlay
                  BlocBuilder<SwipeDownMenuViewNotifier, SwipeDownMenuState>(
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
          context: context,
          child: child,
          controller: overlayController,
        ),
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
    final cubit = context.read<SwipeDownMenuViewNotifier>();
    return OverlayWidgets.buildDragDetector(
      onDragStart: cubit.handleDragStart,
      onDragUpdate: (details) => cubit.handleDragUpdate(
        details,
        context.screenHeight,
      ),
      onDragEnd: (_) => cubit.handleDragEnd(controller),
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
    return BlocSelector<SwipeDownMenuViewNotifier, SwipeDownMenuState, bool>(
      selector: (state) => state.isCompletelyVisible,
      builder: (context, isVisible) {
        final isShown = overlayController.isShowing;
        final enabled = isVisible && isShown;
        return GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTapUp: enabled ? (_) => onBackgroundTap() : null,
          child: AnimatedContainer(
            duration: _kAnimationDuration,
            color: enabled ? Colors.black54 : Colors.transparent,
          ),
        );
      },
    );
  }
}

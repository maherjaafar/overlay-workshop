import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import '../model/swipe_down_menu_details.dart';

abstract class SwipeDownMenuRepository {
  void handleDragStart(DragStartDetails details);
  void handleDragUpdate(DragUpdateDetails details);
  void handleDragEnd(DragEndDetails details);

  void updateDragDetails(SwipeDownMenuDragDetails details);

  SwipeDownMenuDragDetails get dragDetails;
}

class SwipeDownMenuRepositoryImpl implements SwipeDownMenuRepository {
  SwipeDownMenuRepositoryImpl({
    required this.initialDetails,
  });

  /// The user starts dragging the overlay
  ///
  /// We update the [_startDragPosition] and [_currentDragPosition] variables
  @override
  void handleDragStart(DragStartDetails details) {
    final startDragPosition = details.globalPosition.dy;
    dragDetails = dragDetails.copyWith(
      startDragPosition: startDragPosition,
      currentDragPosition: startDragPosition,
    );
  }

  /// The user already started dragging the overlay
  /// We update the [dragDetails.currentDragPosition] variable
  /// We check if the user is dragging up or down
  /// We update the overlay position and height if needed
  @override
  void handleDragUpdate(DragUpdateDetails details) {
    dragDetails = dragDetails.copyWith(
      currentDragPosition: details.globalPosition.dy,
    );
  }

  /// The user stops dragging the overlay
  /// We check if the user dragged enough to show or hide the overlay
  /// We update the overlay position and height if needed
  @override
  void handleDragEnd(DragEndDetails details) {
    debugPrint('handleDragEnd called');
  }

  @override
  void updateDragDetails(SwipeDownMenuDragDetails details) {
    dragDetails = details;
  }

  void setHeight(double height) {
    dragDetails = dragDetails.copyWith(
      configuration: dragDetails.configuration.copyWith(height: height),
    );
  }

  @override
  SwipeDownMenuDragDetails get dragDetails => _dragDetailsSubject.value;

  set dragDetails(SwipeDownMenuDragDetails value) {
    _dragDetailsSubject.add(value);
  }

  late final _dragDetailsSubject =
      BehaviorSubject<SwipeDownMenuDragDetails>.seeded(initialDetails);

  final SwipeDownMenuDragDetails initialDetails;
}

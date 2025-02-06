import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:overlay_plus/overlay_plus.dart';

void main() {
  group('OverlayPlus & OverlayPlusController Tests', () {
    testWidgets('shows and hides overlay via controller', (tester) async {
      final overlayController = OverlayPlusController(debugLabel: 'testController');

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: OverlayPlus(
              controller: overlayController,
              child: const Text('Main Child'),
              overlayChildBuilder: (context) => const Text('Overlay Child'),
            ),
          ),
        ),
      );

      // Initially, overlay is not shown
      expect(find.text('Main Child'), findsOneWidget);
      expect(find.text('Overlay Child'), findsNothing);
      expect(overlayController.isShowing, isFalse);

      // Show overlay
      overlayController.show();
      await tester.pumpAndSettle();
      expect(find.text('Overlay Child'), findsOneWidget);
      expect(overlayController.isShowing, isTrue);

      // Hide overlay
      overlayController.hide();
      await tester.pumpAndSettle();
      expect(find.text('Overlay Child'), findsNothing);
      expect(overlayController.isShowing, isFalse);
    });

    testWidgets('toggle() switches between show and hide', (tester) async {
      final overlayController = OverlayPlusController(debugLabel: 'testController');

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: OverlayPlus(
              controller: overlayController,
              child: const Text('Main'),
              overlayChildBuilder: (context) => const Text('Toggled Overlay'),
            ),
          ),
        ),
      );

      // Initially hidden
      expect(find.text('Toggled Overlay'), findsNothing);
      expect(overlayController.isShowing, isFalse);

      // Toggle on
      overlayController.toggle();
      await tester.pumpAndSettle();
      expect(find.text('Toggled Overlay'), findsOneWidget);
      expect(overlayController.isShowing, isTrue);

      // Toggle off
      overlayController.toggle();
      await tester.pumpAndSettle();
      expect(find.text('Toggled Overlay'), findsNothing);
      expect(overlayController.isShowing, isFalse);
    });

    testWidgets('hasPositioned = false displays overlay without Positioned widget', (tester) async {
      final overlayController = OverlayPlusController(debugLabel: 'testController');

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: OverlayPlus(
              controller: overlayController,
              hasPositioned: false,
              child: const Text('Main Unpositioned'),
              overlayChildBuilder: (context) => const Text('Unpositioned Overlay'),
            ),
          ),
        ),
      );

      // Show overlay
      overlayController.show();
      await tester.pumpAndSettle();

      // Find the overlay
      expect(find.text('Unpositioned Overlay'), findsOneWidget);

      // Ensure it has no Positioned ancestor
      final unpositionedFinder = find.text('Unpositioned Overlay');
      var hasPositionedAncestor = false;

      for (final element in unpositionedFinder.evaluate()) {
        if (element.widget is Positioned) {
          hasPositionedAncestor = true;
          break;
        }
      }

      expect(
        hasPositionedAncestor,
        isFalse,
        reason: 'Overlay should not be wrapped in Positioned when hasPositioned=false',
      );
    });

    testWidgets('OverlayPlusController is detached after widget is disposed', (tester) async {
      final overlayController = OverlayPlusController(debugLabel: 'testController');

      Widget buildTestWidget(bool showOverlayPlus) {
        return MaterialApp(
          home: Scaffold(
            body: showOverlayPlus
                ? OverlayPlus(
                    controller: overlayController,
                    child: const Text('Will Dispose'),
                    overlayChildBuilder: (context) => const Text('Dispose Child'),
                  )
                : const Text('Removed'),
          ),
        );
      }

      // Pump with OverlayPlus present
      await tester.pumpWidget(buildTestWidget(true));
      await tester.pumpAndSettle();

      // Verify it’s attached
      expect(overlayController.toString(), contains('testController'));
      expect(overlayController.toString(), isNot(contains('DETACHED')));

      // Remove OverlayPlus from the tree
      await tester.pumpWidget(buildTestWidget(false));
      await tester.pumpAndSettle();

      // Now the state is disposed; the controller should be DETACHED
      expect(overlayController.toString(), contains('testController'));
      expect(overlayController.toString(), contains('DETACHED'));
    });
  });
}

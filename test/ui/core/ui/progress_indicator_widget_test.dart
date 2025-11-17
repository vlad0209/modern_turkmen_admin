import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:modern_turkmen_admin/ui/core/ui/progress_indicator_widget.dart';

void main() {
  group('ProgressIndicatorWidget', () {
    testWidgets('renders with correct progress value', (WidgetTester tester) async {
      const progress = 0.5;
      const isRunning = true;

      await tester.pumpWidget(
        const MaterialApp(
          home: ProgressIndicatorWidget(
            progress: progress,
            isRunning: isRunning,
          ),
        ),
      );

      expect(find.byType(ProgressIndicatorWidget), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('shows correct background color when isRunning is true', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ProgressIndicatorWidget(
            progress: 0.3,
            isRunning: true,
          ),
        ),
      );

      final progressIndicator = tester.widget<CircularProgressIndicator>(
        find.byType(CircularProgressIndicator),
      );

      expect(progressIndicator.backgroundColor, CupertinoColors.lightBackgroundGray);
    });

    testWidgets('shows correct background color when isRunning is false', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ProgressIndicatorWidget(
            progress: 0.7,
            isRunning: false,
          ),
        ),
      );

      final progressIndicator = tester.widget<CircularProgressIndicator>(
        find.byType(CircularProgressIndicator),
      );

      expect(progressIndicator.backgroundColor, Colors.white.withAlpha(0));
    });

    testWidgets('has correct stroke width', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ProgressIndicatorWidget(
            progress: 0.8,
            isRunning: true,
          ),
        ),
      );

      final progressIndicator = tester.widget<CircularProgressIndicator>(
        find.byType(CircularProgressIndicator),
      );

      expect(progressIndicator.strokeWidth, 2);
    });

    testWidgets('animates progress change', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ProgressIndicatorWidget(
            progress: 0.2,
            isRunning: true,
          ),
        ),
      );

      await tester.pump(const Duration(milliseconds: 100));

      expect(find.byType(TweenAnimationBuilder<double>), findsOneWidget);
    });
  });
}
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

@immutable
class ProgressIndicatorWidget extends StatelessWidget {
  const ProgressIndicatorWidget({
    super.key,
    required this.progress,
    required this.isRunning,
  });

  final double progress;
  final bool isRunning;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: progress),
      duration: const Duration(milliseconds: 200),
      builder: (context, progress, child) {
        return CircularProgressIndicator(
          backgroundColor: isRunning
              ? CupertinoColors.lightBackgroundGray
              : Colors.white.withOpacity(0),
          strokeWidth: 2,
          value: progress,
        );
      },
    );
  }
}
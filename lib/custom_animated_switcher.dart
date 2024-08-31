import 'package:flutter/material.dart';

class CustomAnimatedSwitcher extends StatelessWidget {
  final bool isRefreshing;
  final Widget child;
  final Duration duration;
  final Duration reverseDuration;
  final Curve switchInCurve;
  final Curve switchOutCurve;

  const CustomAnimatedSwitcher({
    super.key,
    required this.isRefreshing,
    required this.child,
    this.duration = const Duration(milliseconds: 620),
    this.reverseDuration = const Duration(milliseconds: 500),
    this.switchInCurve = Curves.easeInOutBack,
    this.switchOutCurve = Curves.easeOutQuint,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: duration,
      reverseDuration: reverseDuration,
      switchInCurve: switchInCurve,
      switchOutCurve: switchOutCurve,
      transitionBuilder: (Widget child, Animation<double> animation) {
        final slideAnimation = Tween<Offset>(
          begin: child.key == ValueKey(isRefreshing)
              ? const Offset(-1.0, 0.0)
              : const Offset(1.0, 0.0),
          end: const Offset(0.0, 0.0),
        ).animate(animation);

        return SlideTransition(
          position: slideAnimation,
          child: RotationTransition(
            turns: Tween<double>(begin: 1.2, end: 1).animate(animation),
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}

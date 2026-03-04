import 'package:flutter/material.dart';

/// Global responsive wrapper.
/// Keeps mobile layout but prevents ugly stretching on large screens.
/// This allows the entire app to work nicely on web without modifying screens.
class ResponsiveContainer extends StatelessWidget {
  final Widget child;

  const ResponsiveContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    double maxWidth;

    // Mobile
    if (width < 600) {
      maxWidth = width;
    }
    // Tablet
    else if (width < 1100) {
      maxWidth = 700;
    }
    // Desktop
    else {
      maxWidth = 900;
    }

    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: child,
      ),
    );
  }
}

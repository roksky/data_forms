import 'package:flutter/widgets.dart';
import 'smooth_border_radius.dart';

import 'smooth_rectangle_border.dart';

class ClipSmoothRect extends StatelessWidget {
  const ClipSmoothRect({
    super.key,
    required this.child,
    this.radius = SmoothBorderRadius.zero,
    this.clipBehavior = Clip.antiAlias,
  });

  final SmoothBorderRadius radius;
  final Clip clipBehavior;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ClipPath.shape(
      clipBehavior: clipBehavior,
      shape: SmoothRectangleBorder(borderRadius: radius),
      child: child,
    );
  }
}

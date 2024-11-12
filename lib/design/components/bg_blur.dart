import 'dart:ui';

import 'package:flutter/material.dart';

class BgBlur extends StatelessWidget {
  final bool enabled;
  final Widget child;
  final BorderRadius borderRadius;
  const BgBlur({
    Key? key,
    required this.child,
    this.enabled = true,
    this.borderRadius = BorderRadius.zero,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius,
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: enabled ? 5 : 0,
          sigmaY: enabled ? 5 : 0,
          tileMode: TileMode.mirror,
        ),
        child: child,
      ),
    );
  }
}

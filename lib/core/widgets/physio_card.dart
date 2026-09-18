import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class PhysioCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final Border? border;
  final double? borderRadius;
  final List<BoxShadow>? boxShadow;

  const PhysioCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.onTap,
    this.backgroundColor = PhysioColors.white,
    this.border,
    this.borderRadius,
    this.boxShadow,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveRadius = borderRadius ?? 16;
    final effectiveBorder = border ?? Border.all(color: PhysioColors.mist, width: 1);
    final effectiveShadow = boxShadow ??
        [
          BoxShadow(
            color: const Color(0xFF1E2A2E).withValues(alpha: 0.04),
            blurRadius: 16,
            offset: Offset(0, 4),
          ),
        ];

    Widget content = Container(
      padding: padding ?? EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(effectiveRadius),
        border: effectiveBorder,
        boxShadow: effectiveShadow,
      ),
      child: child,
    );

    if (margin != null) {
      content = Padding(padding: margin!, child: content);
    }

    if (onTap != null) {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(effectiveRadius),
          onTap: onTap,
          child: content,
        ),
      );
    }

    return content;
  }
}

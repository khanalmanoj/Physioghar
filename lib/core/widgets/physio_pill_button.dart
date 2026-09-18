import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';

enum PhysioPillButtonType {
  primary,     // Pine background, white text
  accent,      // Amber background, white text
  outlined,    // Clear background, Pine border & text
  destructive, // Danger Pale background, Danger text
  danger,      // Solid Danger background, white text
  subtle,      // Mist background, ink text
}

class PhysioPillButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final PhysioPillButtonType type;
  final IconData? icon;
  final bool isLoading;
  final bool isFullWidth;
  final double? height;
  final double? fontSize;

  const PhysioPillButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.type = PhysioPillButtonType.primary,
    this.icon,
    this.isLoading = false,
    this.isFullWidth = false,
    this.height,
    this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color textColor;
    Border? border;

    switch (type) {
      case PhysioPillButtonType.primary:
        bg = PhysioColors.pine;
        textColor = PhysioColors.white;
        border = null;
        break;
      case PhysioPillButtonType.accent:
        bg = PhysioColors.amber;
        textColor = PhysioColors.white;
        border = null;
        break;
      case PhysioPillButtonType.outlined:
        bg = Colors.transparent;
        textColor = PhysioColors.pine;
        border = Border.all(color: PhysioColors.pine, width: 1.5);
        break;
      case PhysioPillButtonType.destructive:
        bg = PhysioColors.dangerPale;
        textColor = PhysioColors.danger;
        border = Border.all(color: PhysioColors.danger.withValues(alpha: 0.3), width: 1);
        break;
      case PhysioPillButtonType.danger:
        bg = PhysioColors.danger;
        textColor = PhysioColors.white;
        border = null;
        break;
      case PhysioPillButtonType.subtle:
        bg = PhysioColors.mist;
        textColor = PhysioColors.ink;
        border = null;
        break;
    }

    if (onPressed == null) {
      bg = PhysioColors.mist;
      textColor = PhysioColors.inkMute;
      border = null;
    }

    final effectiveHeight = height ?? 48;
    final effectiveFontSize = fontSize ?? 14;

    final child = Row(
      mainAxisSize: isFullWidth ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (isLoading) ...[
          SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(textColor),
            ),
          ),
          SizedBox(width: 8),
        ] else if (icon != null) ...[
          Icon(icon, size: 18, color: textColor),
          SizedBox(width: 8),
        ],
        Flexible(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.inter(
              color: textColor,
              fontSize: effectiveFontSize,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.2,
            ),
          ),
        ),
      ],
    );

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: isLoading ? null : onPressed,
        borderRadius: BorderRadius.circular(24),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          height: effectiveHeight,
          constraints: BoxConstraints(minHeight: 44),
          padding: EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(24),
            border: border,
          ),
          child: isFullWidth ? Center(child: child) : child,
        ),
      ),
    );
  }
}

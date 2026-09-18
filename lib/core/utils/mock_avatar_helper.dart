import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';

class MockAvatarHelper {
  static Widget buildAvatar({
    required String name,
    double? radius,
    Color? backgroundColor,
    Color? textColor,
  }) {
    final effectiveRadius = radius ?? 22;
    final initials = getInitials(name);
    final bg = backgroundColor ?? _getColorForName(name);
    final textC = textColor ?? PhysioColors.ink;

    return CircleAvatar(
      radius: effectiveRadius,
      backgroundColor: bg,
      child: Text(
        initials,
        style: GoogleFonts.inter(
          fontSize: effectiveRadius * 0.75,
          fontWeight: FontWeight.w700,
          color: textC,
        ),
      ),
    );
  }

  static String getInitials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty) return 'P';
    if (parts.length == 1) return parts[0].substring(0, 1).toUpperCase();
    return (parts[0].substring(0, 1) + parts[1].substring(0, 1)).toUpperCase();
  }

  static Color _getColorForName(String name) {
    final colors = [
      PhysioColors.pinePale,
      PhysioColors.amberPale,
      const Color(0xFFE2E8F0),
      const Color(0xFFE0E7FF),
      const Color(0xFFFCE7F3),
      const Color(0xFFFEF3C7),
    ];
    final hash = name.codeUnits.fold(0, (prev, elem) => prev + elem);
    return colors[hash % colors.length];
  }
}

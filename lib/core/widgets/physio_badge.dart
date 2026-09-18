import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';

enum PhysioBadgeVariant {
  open,
  booked,
  blocked,
  request,
  upcoming,
  completed,
  cancelled,
  homeVisit,
  clinicVisit,
  available,
  unavailable,
  custom,
}

class PhysioBadge extends StatelessWidget {
  final String text;
  final PhysioBadgeVariant variant;
  final Color? customBgColor;
  final Color? customTextColor;
  final IconData? icon;
  final double? fontSize;

  const PhysioBadge({
    super.key,
    required this.text,
    this.variant = PhysioBadgeVariant.custom,
    this.customBgColor,
    this.customTextColor,
    this.icon,
    this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color textColor;
    Border? border;

    switch (variant) {
      case PhysioBadgeVariant.open:
      case PhysioBadgeVariant.available:
        bg = PhysioColors.pinePale;
        textColor = PhysioColors.pine;
        border = Border.all(color: PhysioColors.pine.withValues(alpha: 0.3), width: 1);
        break;
      case PhysioBadgeVariant.booked:
        bg = PhysioColors.amberPale;
        textColor = const Color(0xFFB87114);
        border = Border.all(color: PhysioColors.amber.withValues(alpha: 0.3), width: 1);
        break;
      case PhysioBadgeVariant.blocked:
      case PhysioBadgeVariant.cancelled:
      case PhysioBadgeVariant.unavailable:
        bg = PhysioColors.dangerPale;
        textColor = PhysioColors.danger;
        border = Border.all(color: PhysioColors.danger.withValues(alpha: 0.3), width: 1);
        break;
      case PhysioBadgeVariant.request:
        bg = PhysioColors.amberPale;
        textColor = const Color(0xFF9E5E0B);
        border = Border.all(color: PhysioColors.amber.withValues(alpha: 0.4), width: 1);
        break;
      case PhysioBadgeVariant.upcoming:
        bg = PhysioColors.pinePale;
        textColor = PhysioColors.pine;
        border = Border.all(color: PhysioColors.pine.withValues(alpha: 0.3), width: 1);
        break;
      case PhysioBadgeVariant.completed:
        bg = const Color(0xFFE3F3EC);
        textColor = const Color(0xFF236A4F);
        border = Border.all(color: const Color(0xFF236A4F).withValues(alpha: 0.2), width: 1);
        break;
      case PhysioBadgeVariant.homeVisit:
        bg = PhysioColors.pinePale;
        textColor = PhysioColors.pine;
        break;
      case PhysioBadgeVariant.clinicVisit:
        bg = PhysioColors.mist;
        textColor = PhysioColors.inkMid;
        break;
      case PhysioBadgeVariant.custom:
        bg = customBgColor ?? PhysioColors.mist;
        textColor = customTextColor ?? PhysioColors.ink;
        break;
    }

    final effectiveFontSize = fontSize ?? 11;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
        border: border,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (icon != null) ...[
            Icon(icon, size: effectiveFontSize + 1, color: textColor),
            SizedBox(width: 4),
          ],
          Text(
            text.toUpperCase(),
            style: GoogleFonts.ibmPlexMono(
              fontSize: effectiveFontSize,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.8,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}

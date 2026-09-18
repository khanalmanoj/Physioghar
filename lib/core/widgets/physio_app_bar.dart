import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';

class PhysioAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String? subtitle;
  final List<Widget>? actions;
  final bool showBackButton;
  final VoidCallback? onBackPressed;
  final Widget? leading;

  const PhysioAppBar({
    super.key,
    required this.title,
    this.subtitle,
    this.actions,
    this.showBackButton = true,
    this.onBackPressed,
    this.leading,
  });

  @override
  Widget build(BuildContext context) {
    final canPop = Navigator.of(context).canPop();

    return AppBar(
      backgroundColor: PhysioColors.cream,
      elevation: 0,
      scrolledUnderElevation: 0,
      leading: leading ??
          (showBackButton && canPop
              ? IconButton(
                  icon: Icon(Icons.arrow_back_ios_new_rounded,
                      size: 20, color: PhysioColors.ink),
                  onPressed: onBackPressed ?? () => Navigator.of(context).pop(),
                )
              : null),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: GoogleFonts.fraunces(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: PhysioColors.ink,
            ),
          ),
          if (subtitle != null) ...[
            SizedBox(height: 2),
            Text(
              subtitle!,
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: PhysioColors.inkMute,
              ),
            ),
          ],
        ],
      ),
      actions: actions != null
          ? [
              ...actions!,
              SizedBox(width: 8),
            ]
          : null,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(subtitle != null ? 64 : 56);
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';
import 'physio_pill_button.dart';

class EmptyStateView extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final String? actionLabel;
  final VoidCallback? onAction;

  const EmptyStateView({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: PhysioColors.pinePale.withValues(alpha: 0.5),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 36,
                color: PhysioColors.pine,
              ),
            ),
            SizedBox(height: 20),
            Text(
              title,
              textAlign: TextAlign.center,
              style: GoogleFonts.fraunces(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: PhysioColors.ink,
              ),
            ),
            SizedBox(height: 8),
            Text(
              description,
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: PhysioColors.inkMid,
                height: 1.4,
              ),
            ),
            if (actionLabel != null && onAction != null) ...[
              SizedBox(height: 24),
              PhysioPillButton(
                label: actionLabel!,
                onPressed: onAction,
                type: PhysioPillButtonType.primary,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

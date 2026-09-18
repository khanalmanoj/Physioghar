import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:physioghar/core/localization/app_language_provider.dart';
import 'package:physioghar/core/theme/app_colors.dart';
import 'package:physioghar/core/widgets/physio_card.dart';
import 'package:physioghar/features/dashboard/providers/dashboard_metrics_provider.dart';

class MetricSummaryRow extends ConsumerWidget {
  final Function(int targetTabIndex)? onMetricTap;

  const MetricSummaryRow({
    super.key,
    this.onMetricTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final metrics = ref.watch(dashboardMetricsProvider);

    return Row(
      children: [
        Expanded(
          child: _buildMetricCard(
            context: context,
            label: context.tr('todays_sessions'),
            count: metrics.todaySessionsCount.toString(),
            color: PhysioColors.pine,
            bgColor: PhysioColors.white,
            icon: Icons.calendar_month_rounded,
            onTap: () => onMetricTap?.call(1), // Schedule tab
          ),
        ),
        SizedBox(width: 10),
        Expanded(
          child: _buildMetricCard(
            context: context,
            label: context.tr('booking_requests'),
            count: metrics.bookingRequestsCount.toString(),
            color: metrics.bookingRequestsCount > 0 ? PhysioColors.amber : PhysioColors.inkMid,
            bgColor: metrics.bookingRequestsCount > 0
                ? PhysioColors.amberPale.withValues(alpha: 0.35)
                : PhysioColors.white,
            icon: Icons.notifications_active_rounded,
            badgeDot: metrics.bookingRequestsCount > 0,
            onTap: () => onMetricTap?.call(2), // Sessions tab
          ),
        ),
        SizedBox(width: 10),
        Expanded(
          child: _buildMetricCard(
            context: context,
            label: context.tr('completed_this_week'),
            count: metrics.completedThisWeekCount.toString(),
            color: const Color(0xFF236A4F),
            bgColor: PhysioColors.white,
            icon: Icons.check_circle_outline_rounded,
            onTap: () => onMetricTap?.call(2), // Sessions tab
          ),
        ),
      ],
    );
  }

  Widget _buildMetricCard({
    required BuildContext context,
    required String label,
    required String count,
    required Color color,
    required Color bgColor,
    required IconData icon,
    bool badgeDot = false,
    VoidCallback? onTap,
  }) {
    return PhysioCard(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      backgroundColor: bgColor,
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, size: 18, color: color),
              if (badgeDot)
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: PhysioColors.amber,
                    shape: BoxShape.circle,
                  ),
                ),
            ],
          ),
          SizedBox(height: 10),
          Text(
            count,
            style: GoogleFonts.fraunces(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: PhysioColors.ink,
            ),
          ),
          SizedBox(height: 4),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: PhysioColors.inkMid,
              height: 1.2,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

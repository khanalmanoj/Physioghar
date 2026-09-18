import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:physioghar/core/localization/app_language_provider.dart';
import 'package:physioghar/core/theme/app_colors.dart';
import 'package:physioghar/core/widgets/empty_state_view.dart';
import 'package:physioghar/features/sessions/presentation/session_detail_screen.dart';
import 'package:physioghar/features/sessions/providers/sessions_provider.dart';
import 'widgets/metric_summary_row.dart';
import 'widgets/therapist_header_card.dart';
import 'widgets/today_schedule_card.dart';

class DashboardScreen extends ConsumerWidget {
  final Function(int tabIndex)? onNavigateTab;
  final VoidCallback? onProfileTap;

  const DashboardScreen({
    super.key,
    this.onNavigateTab,
    this.onProfileTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todaySessions = ref.watch(todaySessionsProvider);

    return Scaffold(
      backgroundColor: PhysioColors.cream,
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: PhysioColors.pine,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.healing_rounded,
                color: Colors.white,
                size: 18,
              ),
            ),
            SizedBox(width: 8),
            Flexible(
              child: Text(
                'PhysioGhar',
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.fraunces(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: PhysioColors.pine,
                ),
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.language_rounded, color: PhysioColors.inkMid),
            tooltip: 'Toggle Language (EN / नेपाली)',
            onPressed: () {
              ref.read(languageNotifierProvider.notifier).toggleLanguage();
            },
          ),
          IconButton(
            icon: const Icon(Icons.person_outline_rounded, color: PhysioColors.inkMid),
            tooltip: 'Account Settings',
            onPressed: onProfileTap,
          ),
          SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TherapistHeaderCard(onProfileTap: onProfileTap),
            SizedBox(height: 16),

            MetricSummaryRow(
              onMetricTap: (index) => onNavigateTab?.call(index),
            ),
            SizedBox(height: 24),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    context.tr('todays_schedule'),
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.fraunces(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: PhysioColors.ink,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () => onNavigateTab?.call(1), // Schedule Tab
                  child: Text(
                    context.tr('view_all'),
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: PhysioColors.pine,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),

            if (todaySessions.isEmpty)
              EmptyStateView(
                icon: Icons.done_all_rounded,
                title: context.tr('no_sessions_today'),
                description: 'You have completed all sessions or have no bookings today.',
                actionLabel: context.tr('manage_availability'),
                onAction: () => onNavigateTab?.call(1),
              )
            else
              ...todaySessions.map(
                (session) => TodayScheduleCard(
                  session: session,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => SessionDetailScreen(sessionId: session.id),
                      ),
                    );
                  },
                ),
              ),

            SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

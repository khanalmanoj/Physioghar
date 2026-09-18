import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:physioghar/core/localization/app_language_provider.dart';
import 'package:physioghar/core/theme/app_colors.dart';
import 'package:physioghar/core/utils/date_time_utils.dart';
import 'package:physioghar/core/widgets/empty_state_view.dart';
import 'package:physioghar/core/widgets/physio_app_bar.dart';
import 'package:physioghar/core/widgets/physio_badge.dart';
import 'package:physioghar/core/widgets/physio_card.dart';
import 'package:physioghar/core/widgets/physio_pill_button.dart';
import '../domain/models/complaint_model.dart';
import '../providers/complaints_provider.dart';
import 'widgets/new_complaint_modal.dart';

class ComplaintsScreen extends ConsumerWidget {
  const ComplaintsScreen({super.key});

  void _showNewComplaintModal(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => NewComplaintModal(
        onSubmit: ({
          required ComplaintCategory category,
          required ComplaintPriority priority,
          required String subject,
          required String description,
        }) {
          ref.read(complaintsNotifierProvider.notifier).submitComplaint(
                category: category,
                priority: priority,
                subject: subject,
                description: description,
              );
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Support ticket submitted successfully! Ops team will review shortly.'),
              backgroundColor: PhysioColors.pine,
              behavior: SnackBarBehavior.floating,
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tickets = ref.watch(complaintsNotifierProvider);

    return Scaffold(
      backgroundColor: PhysioColors.cream,
      appBar: PhysioAppBar(
        title: context.tr('report_issue'),
        subtitle: 'Support & Dispute Resolution',
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: PhysioPillButton(
              isFullWidth: true,
              label: '+ Report New Issue / Dispute',
              type: PhysioPillButtonType.primary,
              icon: Icons.add_comment_rounded,
              onPressed: () => _showNewComplaintModal(context, ref),
            ),
          ),
          const Divider(color: PhysioColors.mist),
          Expanded(
            child: tickets.isEmpty
                ? EmptyStateView(
                    icon: Icons.support_agent_rounded,
                    title: 'No Support Tickets',
                    description: 'You have not submitted any complaints or dispute tickets.',
                    actionLabel: 'Report an Issue',
                    onAction: () => _showNewComplaintModal(context, ref),
                  )
                : ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    itemCount: tickets.length,
                    itemBuilder: (context, index) {
                      final t = tickets[index];
                      return PhysioCard(
                        margin: EdgeInsets.only(bottom: 12),
                        padding: EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    t.id.toUpperCase(),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.ibmPlexMono(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      color: PhysioColors.pine,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 8),
                                PhysioBadge(
                                  text: t.statusLabel,
                                  variant: t.status == ComplaintStatus.resolved
                                      ? PhysioBadgeVariant.completed
                                      : PhysioBadgeVariant.request,
                                ),
                              ],
                            ),
                            SizedBox(height: 8),
                            Text(
                              t.subject,
                              style: GoogleFonts.fraunces(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: PhysioColors.ink,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              t.description,
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                color: PhysioColors.inkMid,
                                height: 1.35,
                              ),
                            ),
                            SizedBox(height: 12),
                            const Divider(color: PhysioColors.mist),
                            SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  child: Text(
                                    '${t.categoryLabel} • ${t.priorityLabel} Priority',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.inter(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w500,
                                      color: PhysioColors.inkMute,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 8),
                                Text(
                                  DateTimeUtils.formatShortDate(t.createdAt),
                                  style: GoogleFonts.ibmPlexMono(
                                    fontSize: 11,
                                    color: PhysioColors.inkMute,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

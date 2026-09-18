import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:physioghar/core/localization/app_language_provider.dart';
import 'package:physioghar/core/theme/app_colors.dart';
import 'package:physioghar/core/utils/date_time_utils.dart';
import 'package:physioghar/core/utils/mock_avatar_helper.dart';
import 'package:physioghar/core/widgets/physio_badge.dart';
import 'package:physioghar/core/widgets/physio_card.dart';
import 'package:physioghar/core/widgets/physio_pill_button.dart';
import 'package:physioghar/features/schedule/domain/models/time_slot_model.dart';
import 'package:physioghar/features/sessions/domain/models/session_model.dart';

class SessionCard extends StatelessWidget {
  final SessionModel session;
  final VoidCallback? onAccept;
  final VoidCallback? onDecline;
  final VoidCallback? onComplete;
  final VoidCallback? onReschedule;
  final VoidCallback? onTap;

  const SessionCard({
    super.key,
    required this.session,
    this.onAccept,
    this.onDecline,
    this.onComplete,
    this.onReschedule,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isHome = session.visitType == VisitType.homeVisit;

    return PhysioCard(
      margin: EdgeInsets.only(bottom: 14),
      padding: EdgeInsets.all(16),
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MockAvatarHelper.buildAvatar(
                name: session.patientName,
                radius: 22,
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      session.patientName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.fraunces(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: PhysioColors.ink,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      '${session.patientGender}, ${session.patientAge} yrs • ${session.patientPhone}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(
                        fontSize: 11.5,
                        color: PhysioColors.inkMute,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 8),
              PhysioBadge(
                text: isHome ? context.tr('visit_home') : context.tr('visit_clinic'),
                variant: isHome ? PhysioBadgeVariant.homeVisit : PhysioBadgeVariant.clinicVisit,
                icon: isHome ? Icons.home_rounded : Icons.local_hospital_rounded,
                fontSize: 10,
              ),
            ],
          ),
          SizedBox(height: 12),

          Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: PhysioColors.cream,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: PhysioColors.mist),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.medical_services_outlined,
                  size: 15,
                  color: PhysioColors.pine,
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    session.condition,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: PhysioColors.ink,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Icon(Icons.event_rounded, size: 14, color: PhysioColors.inkMute),
                    SizedBox(width: 4),
                    Flexible(
                      child: Text(
                        '${DateTimeUtils.formatShortDate(session.dateTime)}, ${session.timeSlot}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.ibmPlexMono(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w600,
                          color: PhysioColors.inkMid,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 8),
              Text(
                'Rs. ${session.fee.toInt()}',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: PhysioColors.pine,
                ),
              ),
            ],
          ),
          SizedBox(height: 6),
          Row(
            children: [
              Icon(Icons.location_on_outlined, size: 14, color: PhysioColors.inkMute),
              SizedBox(width: 4),
              Expanded(
                child: Text(
                  session.address,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: PhysioColors.inkMid,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),

          if (session.status == SessionStatus.completed &&
              session.clinicalRemarks != null) ...[
            SizedBox(height: 10),
            const Divider(color: PhysioColors.mist, height: 1),
            SizedBox(height: 8),
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFFE8F3EE),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.notes_rounded, size: 14, color: PhysioColors.pine),
                      SizedBox(width: 4),
                      Text(
                        'Clinical Feedback:',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: PhysioColors.pine,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4),
                  Text(
                    session.clinicalRemarks!,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: PhysioColors.inkMid,
                      height: 1.3,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],

          if (session.status == SessionStatus.cancelled &&
              session.cancelledReason != null) ...[
            SizedBox(height: 10),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: PhysioColors.dangerPale,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                'Reason: ${session.cancelledReason!}',
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontStyle: FontStyle.italic,
                  color: PhysioColors.danger,
                ),
              ),
            ),
          ],

          if (session.status == SessionStatus.request) ...[
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: PhysioPillButton(
                    label: context.tr('decline'),
                    type: PhysioPillButtonType.destructive,
                    height: 42,
                    icon: Icons.close_rounded,
                    onPressed: onDecline,
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: PhysioPillButton(
                    label: context.tr('accept'),
                    type: PhysioPillButtonType.primary,
                    height: 42,
                    icon: Icons.check_rounded,
                    onPressed: onAccept,
                  ),
                ),
              ],
            ),
          ],

          if (session.status == SessionStatus.upcoming) ...[
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: PhysioPillButton(
                    label: context.tr('reschedule'),
                    type: PhysioPillButtonType.outlined,
                    height: 42,
                    icon: Icons.schedule_rounded,
                    onPressed: onReschedule,
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: PhysioPillButton(
                    label: context.tr('complete_session'),
                    type: PhysioPillButtonType.primary,
                    height: 42,
                    icon: Icons.done_all_rounded,
                    onPressed: onComplete,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

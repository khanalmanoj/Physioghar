import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:physioghar/core/localization/app_language_provider.dart';
import 'package:physioghar/core/theme/app_colors.dart';
import 'package:physioghar/core/widgets/physio_badge.dart';
import 'package:physioghar/core/widgets/physio_card.dart';
import 'package:physioghar/features/schedule/domain/models/time_slot_model.dart';
import 'package:physioghar/features/sessions/domain/models/session_model.dart';

class TodayScheduleCard extends StatelessWidget {
  final SessionModel session;
  final VoidCallback onTap;

  const TodayScheduleCard({
    super.key,
    required this.session,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isHome = session.visitType == VisitType.homeVisit;
    final isCompleted = session.status == SessionStatus.completed;

    return PhysioCard(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 8,
            runSpacing: 8,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: PhysioColors.mist,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.access_time_rounded,
                      size: 14,
                      color: PhysioColors.ink,
                    ),
                    SizedBox(width: 6),
                    Text(
                      session.timeSlot,
                      style: GoogleFonts.ibmPlexMono(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: PhysioColors.ink,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  PhysioBadge(
                    text: isHome ? context.tr('visit_home') : context.tr('visit_clinic'),
                    variant: isHome ? PhysioBadgeVariant.homeVisit : PhysioBadgeVariant.clinicVisit,
                    icon: isHome ? Icons.home_rounded : Icons.local_hospital_rounded,
                  ),
                  SizedBox(width: 6),
                  PhysioBadge(
                    text: isCompleted
                        ? context.tr('status_completed')
                        : context.tr('status_upcoming'),
                    variant: isCompleted
                        ? PhysioBadgeVariant.completed
                        : PhysioBadgeVariant.upcoming,
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 12),
          Text(
            session.patientName,
            style: GoogleFonts.fraunces(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: PhysioColors.ink,
            ),
          ),
          SizedBox(height: 4),
          Text(
            session.condition,
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: PhysioColors.pineLight,
            ),
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Icon(
                Icons.location_on_outlined,
                size: 14,
                color: PhysioColors.inkMute,
              ),
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
              Icon(
                Icons.chevron_right_rounded,
                size: 20,
                color: PhysioColors.inkMute,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

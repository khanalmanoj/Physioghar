import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:physioghar/core/localization/app_language_provider.dart';
import 'package:physioghar/core/theme/app_colors.dart';
import 'package:physioghar/core/widgets/physio_badge.dart';
import 'package:physioghar/core/widgets/physio_card.dart';
import 'package:physioghar/features/schedule/domain/models/time_slot_model.dart';

class SlotCard extends StatelessWidget {
  final TimeSlot slot;
  final VoidCallback onTap;

  const SlotCard({
    super.key,
    required this.slot,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color cardBg;
    Border? border;
    Widget statusBadge;

    switch (slot.status) {
      case SlotStatus.open:
        cardBg = PhysioColors.pinePale.withValues(alpha: 0.35);
        border = Border.all(color: PhysioColors.pine.withValues(alpha: 0.4), width: 1.2);
        statusBadge = PhysioBadge(
          text: context.tr('status_open'),
          variant: PhysioBadgeVariant.open,
          icon: Icons.check_circle_outline_rounded,
        );
        break;
      case SlotStatus.booked:
        cardBg = PhysioColors.amberPale.withValues(alpha: 0.4);
        border = Border.all(color: PhysioColors.amber.withValues(alpha: 0.4), width: 1.2);
        statusBadge = PhysioBadge(
          text: context.tr('status_booked'),
          variant: PhysioBadgeVariant.booked,
          icon: Icons.lock_outline_rounded,
        );
        break;
      case SlotStatus.blocked:
        cardBg = PhysioColors.mist.withValues(alpha: 0.65);
        border = Border.all(color: PhysioColors.danger.withValues(alpha: 0.2), width: 1.2);
        statusBadge = PhysioBadge(
          text: context.tr('status_blocked'),
          variant: PhysioBadgeVariant.blocked,
          icon: Icons.block_rounded,
        );
        break;
    }

    final timeString = '${slot.startTime} - ${slot.endTime}';

    return PhysioCard(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      backgroundColor: cardBg,
      border: border,
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Icon(
                      slot.status == SlotStatus.blocked
                          ? Icons.timer_off_outlined
                          : Icons.access_time_rounded,
                      size: 16,
                      color: slot.status == SlotStatus.blocked
                          ? PhysioColors.danger
                          : PhysioColors.ink,
                    ),
                    SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        timeString,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.ibmPlexMono(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: slot.status == SlotStatus.blocked
                              ? PhysioColors.inkMid
                              : PhysioColors.ink,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 8),
              statusBadge,
            ],
          ),
          if (slot.status == SlotStatus.booked && slot.patientName != null) ...[
            SizedBox(height: 12),
            const Divider(color: PhysioColors.mist, height: 1),
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        slot.patientName!,
                        style: GoogleFonts.fraunces(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: PhysioColors.ink,
                        ),
                      ),
                      if (slot.serviceName != null) ...[
                        SizedBox(height: 2),
                        Text(
                          slot.serviceName!,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: PhysioColors.pineLight,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                if (slot.visitType != null)
                  PhysioBadge(
                    text: slot.visitType == VisitType.homeVisit
                        ? context.tr('visit_home')
                        : context.tr('visit_clinic'),
                    variant: slot.visitType == VisitType.homeVisit
                        ? PhysioBadgeVariant.homeVisit
                        : PhysioBadgeVariant.clinicVisit,
                    icon: slot.visitType == VisitType.homeVisit
                        ? Icons.home_rounded
                        : Icons.local_hospital_rounded,
                  ),
              ],
            ),
          ],
          if (slot.status == SlotStatus.blocked) ...[
            SizedBox(height: 8),
            Text(
              'Slot unavailable for patient bookings. Tap to make available.',
              style: GoogleFonts.inter(
                fontSize: 12,
                fontStyle: FontStyle.italic,
                color: PhysioColors.inkMute,
              ),
            ),
          ],
          if (slot.status == SlotStatus.open) ...[
            SizedBox(height: 8),
            Text(
              'Available for online patient bookings. Tap to block or remove.',
              style: GoogleFonts.inter(
                fontSize: 12,
                color: PhysioColors.inkMid,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

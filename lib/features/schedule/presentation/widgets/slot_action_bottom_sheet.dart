import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:physioghar/core/localization/app_language_provider.dart';
import 'package:physioghar/core/theme/app_colors.dart';
import 'package:physioghar/core/widgets/physio_badge.dart';
import 'package:physioghar/core/widgets/physio_pill_button.dart';
import 'package:physioghar/features/schedule/domain/models/time_slot_model.dart';

class SlotActionBottomSheet extends StatelessWidget {
  final TimeSlot slot;
  final VoidCallback onBlock;
  final VoidCallback onUnblock;
  final VoidCallback onRemove;
  final VoidCallback? onViewDetails;

  const SlotActionBottomSheet({
    super.key,
    required this.slot,
    required this.onBlock,
    required this.onUnblock,
    required this.onRemove,
    this.onViewDetails,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: PhysioColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.fromLTRB(20, 12, 20, 28),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: PhysioColors.mist,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Time Slot Actions',
                      style: GoogleFonts.fraunces(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: PhysioColors.ink,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      '${slot.startTime} - ${slot.endTime}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.ibmPlexMono(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: PhysioColors.inkMid,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 8),
              if (slot.status == SlotStatus.open)
                PhysioBadge(
                  text: context.tr('status_open'),
                  variant: PhysioBadgeVariant.open,
                )
              else if (slot.status == SlotStatus.booked)
                PhysioBadge(
                  text: context.tr('status_booked'),
                  variant: PhysioBadgeVariant.booked,
                )
              else
                PhysioBadge(
                  text: context.tr('status_blocked'),
                  variant: PhysioBadgeVariant.blocked,
                ),
            ],
          ),
          SizedBox(height: 20),

          if (slot.status == SlotStatus.open) ...[
            Text(
              'This slot is currently open for patient bookings. You can temporarily block it for personal reasons or remove it entirely.',
              style: GoogleFonts.inter(
                fontSize: 14,
                color: PhysioColors.inkMid,
                height: 1.4,
              ),
            ),
            SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: PhysioPillButton(
                    label: context.tr('remove_slot'),
                    type: PhysioPillButtonType.destructive,
                    icon: Icons.delete_outline_rounded,
                    onPressed: () {
                      Navigator.of(context).pop();
                      onRemove();
                    },
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: PhysioPillButton(
                    label: context.tr('block_slot'),
                    type: PhysioPillButtonType.outlined,
                    icon: Icons.block_rounded,
                    onPressed: () {
                      Navigator.of(context).pop();
                      onBlock();
                    },
                  ),
                ),
              ],
            ),
          ] else if (slot.status == SlotStatus.blocked) ...[
            Text(
              'This slot is blocked and patients cannot book during this time. Make it available again to accept appointments.',
              style: GoogleFonts.inter(
                fontSize: 14,
                color: PhysioColors.inkMid,
                height: 1.4,
              ),
            ),
            SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: PhysioPillButton(
                    label: context.tr('remove_slot'),
                    type: PhysioPillButtonType.destructive,
                    icon: Icons.delete_outline_rounded,
                    onPressed: () {
                      Navigator.of(context).pop();
                      onRemove();
                    },
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: PhysioPillButton(
                    label: context.tr('unblock_slot'),
                    type: PhysioPillButtonType.primary,
                    icon: Icons.lock_open_rounded,
                    onPressed: () {
                      Navigator.of(context).pop();
                      onUnblock();
                    },
                  ),
                ),
              ],
            ),
          ] else ...[
            Container(
              padding: EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: PhysioColors.cream,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: PhysioColors.mist),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Booked By',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: PhysioColors.inkMute,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    slot.patientName ?? 'Patient Booking',
                    style: GoogleFonts.fraunces(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: PhysioColors.ink,
                    ),
                  ),
                  if (slot.serviceName != null) ...[
                    SizedBox(height: 4),
                    Text(
                      slot.serviceName!,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: PhysioColors.pineLight,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            SizedBox(height: 24),
            PhysioPillButton(
              isFullWidth: true,
              label: context.tr('view_booking_details'),
              type: PhysioPillButtonType.primary,
              icon: Icons.calendar_today_rounded,
              onPressed: () {
                Navigator.of(context).pop();
                onViewDetails?.call();
              },
            ),
          ],
        ],
      ),
    );
  }
}

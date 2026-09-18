import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:physioghar/core/localization/app_language_provider.dart';
import 'package:physioghar/core/theme/app_colors.dart';
import 'package:physioghar/core/utils/date_time_utils.dart';
import 'package:physioghar/core/utils/mock_avatar_helper.dart';
import 'package:physioghar/core/widgets/physio_badge.dart';
import 'package:physioghar/core/widgets/physio_card.dart';
import 'package:physioghar/features/profile/providers/therapist_profile_provider.dart';

class TherapistHeaderCard extends ConsumerWidget {
  final VoidCallback? onProfileTap;

  const TherapistHeaderCard({
    super.key,
    this.onProfileTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(therapistProfileProvider);
    final isAvailable = profile.isAvailable;
    final formattedDate = DateTimeUtils.formatFullDate(DateTime.now());

    return PhysioCard(
      padding: EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: onProfileTap,
                child: Hero(
                  tag: 'therapist_avatar',
                  child: MockAvatarHelper.buildAvatar(
                    name: profile.name,
                    radius: 26,
                    backgroundColor: PhysioColors.pinePale,
                    textColor: PhysioColors.pine,
                  ),
                ),
              ),
              SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${context.tr('greeting_namaste')},',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: PhysioColors.inkMute,
                      ),
                    ),
                    Text(
                      profile.name,
                      style: GoogleFonts.fraunces(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: PhysioColors.ink,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  ref.read(therapistProfileProvider.notifier).toggleAvailability();
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 220),
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: isAvailable ? PhysioColors.pinePale : PhysioColors.dangerPale,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isAvailable
                          ? PhysioColors.pine.withValues(alpha: 0.3)
                          : PhysioColors.danger.withValues(alpha: 0.3),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isAvailable ? PhysioColors.pine : PhysioColors.danger,
                        ),
                      ),
                      SizedBox(width: 6),
                      Text(
                        isAvailable
                            ? context.tr('status_available')
                            : context.tr('status_unavailable'),
                        style: GoogleFonts.ibmPlexMono(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                          color: isAvailable ? PhysioColors.pine : PhysioColors.danger,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 14),
          Row(
            children: [
              Icon(
                Icons.calendar_today_rounded,
                size: 14,
                color: PhysioColors.inkMute,
              ),
              SizedBox(width: 6),
              Expanded(
                child: Text(
                  formattedDate,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: PhysioColors.inkMid,
                  ),
                ),
              ),
              SizedBox(width: 8),
              PhysioBadge(
                text: profile.nmcNumber,
                variant: PhysioBadgeVariant.custom,
                customBgColor: PhysioColors.mist,
                customTextColor: PhysioColors.inkMid,
                fontSize: 10,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

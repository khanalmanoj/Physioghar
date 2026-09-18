import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:physioghar/core/localization/app_language_provider.dart';
import 'package:physioghar/core/theme/app_colors.dart';
import 'package:physioghar/core/utils/mock_avatar_helper.dart';
import 'package:physioghar/core/widgets/physio_app_bar.dart';
import 'package:physioghar/core/widgets/physio_badge.dart';
import 'package:physioghar/core/widgets/physio_card.dart';
import 'package:physioghar/core/widgets/physio_pill_button.dart';
import '../providers/therapist_profile_provider.dart';
import 'edit_profile_screen.dart';

class ProfileDetailScreen extends ConsumerWidget {
  const ProfileDetailScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(therapistProfileProvider);

    return Scaffold(
      backgroundColor: PhysioColors.cream,
      appBar: PhysioAppBar(
        title: context.tr('profile'),
        actions: [
          IconButton(
            icon: Icon(Icons.edit_note_rounded, color: PhysioColors.pine, size: 26),
            tooltip: context.tr('edit_profile'),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const EditProfileScreen()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PhysioCard(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  MockAvatarHelper.buildAvatar(
                    name: profile.name,
                    radius: 38,
                    backgroundColor: PhysioColors.pinePale,
                    textColor: PhysioColors.pine,
                  ),
                  SizedBox(height: 12),
                  Text(
                    profile.name,
                    style: GoogleFonts.fraunces(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: PhysioColors.ink,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 4),
                  Text(
                    profile.title,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: PhysioColors.inkMid,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 10),
                  PhysioBadge(
                    text: profile.nmcNumber,
                    variant: PhysioBadgeVariant.custom,
                    customBgColor: PhysioColors.mist,
                    customTextColor: PhysioColors.ink,
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: PhysioCard(
                    padding: EdgeInsets.all(14),
                    child: Column(
                      children: [
                        Text(
                          '${profile.yearsOfExperience}+',
                          style: GoogleFonts.fraunces(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: PhysioColors.pine,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          context.tr('experience_years'),
                          style: GoogleFonts.inter(fontSize: 11, color: PhysioColors.inkMid),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: PhysioCard(
                    padding: EdgeInsets.all(14),
                    child: Column(
                      children: [
                        Text(
                          '${profile.totalPatientsServed}+',
                          style: GoogleFonts.fraunces(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: PhysioColors.pine,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Patients Treated',
                          style: GoogleFonts.inter(fontSize: 11, color: PhysioColors.inkMid),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),

            PhysioCard(
              padding: EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.tr('specializations'),
                    style: GoogleFonts.fraunces(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: PhysioColors.ink,
                    ),
                  ),
                  SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: profile.specializations.map((spec) {
                      return Container(
                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: PhysioColors.pinePale.withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: PhysioColors.pine.withValues(alpha: 0.2)),
                        ),
                        child: Text(
                          spec,
                          style: GoogleFonts.inter(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w500,
                            color: PhysioColors.pine,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),

            PhysioCard(
              padding: EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'About & Background',
                    style: GoogleFonts.fraunces(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: PhysioColors.ink,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    profile.bio,
                    style: GoogleFonts.inter(
                      fontSize: 13.5,
                      color: PhysioColors.inkMid,
                      height: 1.45,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),

            PhysioCard(
              padding: EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.tr('clinic_address'),
                    style: GoogleFonts.fraunces(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: PhysioColors.ink,
                    ),
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.location_on_rounded, color: PhysioColors.pine, size: 20),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          profile.clinicAddress,
                          style: GoogleFonts.inter(
                            fontSize: 13.5,
                            color: PhysioColors.inkMid,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 24),

            PhysioPillButton(
              isFullWidth: true,
              label: context.tr('edit_profile'),
              icon: Icons.edit_rounded,
              type: PhysioPillButtonType.primary,
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const EditProfileScreen()),
                );
              },
            ),
            SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

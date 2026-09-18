import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:physioghar/core/localization/app_language_provider.dart';
import 'package:physioghar/core/localization/app_strings.dart';
import 'package:physioghar/core/theme/app_colors.dart';
import 'package:physioghar/core/utils/mock_avatar_helper.dart';
import 'package:physioghar/core/widgets/physio_card.dart';
import 'package:physioghar/features/complaints/presentation/complaints_screen.dart';
import '../providers/therapist_profile_provider.dart';
import 'edit_profile_screen.dart';
import 'profile_detail_screen.dart';

class AccountScreen extends ConsumerWidget {
  const AccountScreen({super.key});

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Log Out?', style: GoogleFonts.fraunces(fontWeight: FontWeight.w700, fontSize: 18)),
        content: Text(
          'Are you sure you want to sign out of your PhysioGhar therapist account?',
          style: GoogleFonts.inter(fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Session signed out (Demo Mode).'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            child: const Text('Log Out', style: TextStyle(color: PhysioColors.danger)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(therapistProfileProvider);
    final isAvailable = profile.isAvailable;
    final currentLang = ref.watch(languageNotifierProvider);

    return Scaffold(
      backgroundColor: PhysioColors.cream,
      appBar: AppBar(
        title: Text(
          context.tr('nav_account'),
          style: GoogleFonts.fraunces(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: PhysioColors.ink,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          children: [
            PhysioCard(
              padding: EdgeInsets.all(18),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const ProfileDetailScreen()),
                );
              },
              child: Row(
                children: [
                  MockAvatarHelper.buildAvatar(
                    name: profile.name,
                    radius: 28,
                    backgroundColor: PhysioColors.pinePale,
                    textColor: PhysioColors.pine,
                  ),
                  SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          profile.name,
                          style: GoogleFonts.fraunces(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: PhysioColors.ink,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          profile.nmcNumber,
                          style: GoogleFonts.ibmPlexMono(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: PhysioColors.inkMute,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.chevron_right_rounded, color: PhysioColors.inkMute, size: 20),
                ],
              ),
            ),
            SizedBox(height: 16),

            PhysioCard(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Practice Status',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: PhysioColors.ink,
                          ),
                        ),
                        Text(
                          isAvailable
                              ? 'Accepting new appointments'
                              : 'Currently offline / unavailable',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: PhysioColors.inkMute,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Switch(
                    value: isAvailable,
                    activeTrackColor: PhysioColors.pine,
                    onChanged: (val) {
                      ref.read(therapistProfileProvider.notifier).setAvailability(val);
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),

            PhysioCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  _buildSettingsTile(
                    icon: Icons.person_outline_rounded,
                    title: context.tr('profile'),
                    subtitle: 'View professional credentials',
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const ProfileDetailScreen()),
                      );
                    },
                  ),
                  const Divider(color: PhysioColors.mist, height: 1),
                  _buildSettingsTile(
                    icon: Icons.edit_note_rounded,
                    title: context.tr('edit_profile'),
                    subtitle: 'Update clinical specializations, fees & address',
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const EditProfileScreen()),
                      );
                    },
                  ),
                  const Divider(color: PhysioColors.mist, height: 1),
                  ListTile(
                    leading: Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: PhysioColors.pinePale.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(Icons.language_rounded, color: PhysioColors.pine, size: 20),
                    ),
                    title: Text(
                      context.tr('language_setting'),
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: PhysioColors.ink,
                      ),
                    ),
                    subtitle: Text(
                      currentLang == AppLanguage.en ? 'English' : 'नेपाली (Nepali)',
                      style: GoogleFonts.inter(fontSize: 12, color: PhysioColors.inkMute),
                    ),
                    trailing: Container(
                      decoration: BoxDecoration(
                        color: PhysioColors.mist,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          GestureDetector(
                            onTap: () {
                              ref
                                  .read(languageNotifierProvider.notifier)
                                  .setLanguage(AppLanguage.en);
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                color: currentLang == AppLanguage.en
                                    ? PhysioColors.pine
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                'EN',
                                style: GoogleFonts.ibmPlexMono(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: currentLang == AppLanguage.en
                                      ? Colors.white
                                      : PhysioColors.inkMid,
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              ref
                                  .read(languageNotifierProvider.notifier)
                                  .setLanguage(AppLanguage.ne);
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                color: currentLang == AppLanguage.ne
                                    ? PhysioColors.pine
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                'नेपाली',
                                style: GoogleFonts.inter(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: currentLang == AppLanguage.ne
                                      ? Colors.white
                                      : PhysioColors.inkMid,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Divider(color: PhysioColors.mist, height: 1),
                  _buildSettingsTile(
                    icon: Icons.report_problem_outlined,
                    title: context.tr('report_issue'),
                    subtitle: 'Submit tickets for disputes or technical issues',
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const ComplaintsScreen()),
                      );
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),

            PhysioCard(
              padding: EdgeInsets.zero,
              child: _buildSettingsTile(
                icon: Icons.logout_rounded,
                iconColor: PhysioColors.danger,
                title: context.tr('logout'),
                titleColor: PhysioColors.danger,
                subtitle: 'Sign out of this therapist device',
                onTap: () => _showLogoutDialog(context),
              ),
            ),
            SizedBox(height: 24),

            Text(
              'PhysioGhar Therapist App • v1.0.0 (Production Build)',
              style: GoogleFonts.ibmPlexMono(
                fontSize: 11,
                color: PhysioColors.inkMute,
              ),
            ),
            SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Color? iconColor,
    Color? titleColor,
  }) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: (iconColor ?? PhysioColors.pine).withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: iconColor ?? PhysioColors.pine, size: 20),
      ),
      title: Text(
        title,
        style: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: titleColor ?? PhysioColors.ink,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: GoogleFonts.inter(fontSize: 12, color: PhysioColors.inkMute),
      ),
      trailing: Icon(Icons.chevron_right_rounded, color: PhysioColors.inkMute, size: 20),
    );
  }
}

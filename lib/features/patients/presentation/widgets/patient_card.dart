import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:physioghar/core/theme/app_colors.dart';
import 'package:physioghar/core/utils/date_time_utils.dart';
import 'package:physioghar/core/utils/mock_avatar_helper.dart';
import 'package:physioghar/core/widgets/physio_card.dart';
import 'package:physioghar/features/patients/domain/models/patient_model.dart';

class PatientCard extends StatelessWidget {
  final PatientModel patient;
  final VoidCallback onTap;

  const PatientCard({
    super.key,
    required this.patient,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return PhysioCard(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          MockAvatarHelper.buildAvatar(
            name: patient.name,
            radius: 24,
          ),
          SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        patient.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.fraunces(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: PhysioColors.ink,
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: PhysioColors.mist,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        '${patient.totalSessionsCount} sessions',
                        style: GoogleFonts.ibmPlexMono(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: PhysioColors.inkMid,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 3),
                Text(
                  patient.condition,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: PhysioColors.pineLight,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 6),
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.history_rounded, size: 13, color: PhysioColors.inkMute),
                        SizedBox(width: 4),
                        Text(
                          'Last: ${DateTimeUtils.formatShortDate(patient.lastSessionDate)}',
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            color: PhysioColors.inkMute,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      '• ${patient.gender}, ${patient.age}y',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        color: PhysioColors.inkMute,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(width: 8),
          Icon(
            Icons.chevron_right_rounded,
            size: 20,
            color: PhysioColors.inkMute,
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:physioghar/core/theme/app_colors.dart';
import 'package:physioghar/core/utils/date_time_utils.dart';
import 'package:physioghar/core/utils/mock_avatar_helper.dart';
import 'package:physioghar/core/widgets/physio_app_bar.dart';
import 'package:physioghar/core/widgets/physio_badge.dart';
import 'package:physioghar/core/widgets/physio_card.dart';
import 'package:physioghar/core/widgets/physio_pill_button.dart';
import 'package:physioghar/features/patients/domain/models/patient_note_model.dart';
import 'package:physioghar/features/patients/presentation/patient_detail_screen.dart';
import 'package:physioghar/features/patients/providers/patients_provider.dart';
import 'package:physioghar/features/schedule/domain/models/time_slot_model.dart';
import 'package:physioghar/features/sessions/domain/models/session_model.dart';
import 'package:physioghar/features/sessions/presentation/widgets/complete_session_dialog.dart';
import 'package:physioghar/features/sessions/presentation/widgets/reschedule_dialog.dart';
import 'package:physioghar/features/sessions/providers/sessions_provider.dart';

class SessionDetailScreen extends ConsumerWidget {
  final String sessionId;

  const SessionDetailScreen({
    super.key,
    required this.sessionId,
  });

  void _showCompleteDialog(BuildContext context, WidgetRef ref, SessionModel session) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => CompleteSessionDialog(
        session: session,
        onComplete: ({
          required String remarks,
          required List<String> exercises,
          String? nextGoals,
        }) {
          ref.read(sessionsNotifierProvider.notifier).completeSession(
                sessionId: session.id,
                clinicalRemarks: remarks,
                prescribedExercises: exercises,
                nextSessionGoals: nextGoals,
              );

          final newNote = PatientNote(
            id: 'note-${DateTime.now().millisecondsSinceEpoch}',
            patientId: session.patientId,
            title: 'Session: ${session.condition}',
            content: remarks,
            exercises: exercises,
            nextGoals: nextGoals ?? 'Continue prescribed recovery regimen.',
            createdAt: DateTime.now(),
          );
          ref.read(patientsNotifierProvider.notifier).addNote(session.patientId, newNote);

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Session completed and clinical note logged successfully!'),
              backgroundColor: PhysioColors.pine,
              behavior: SnackBarBehavior.floating,
            ),
          );
        },
      ),
    );
  }

  void _showRescheduleDialog(BuildContext context, WidgetRef ref, SessionModel session) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => RescheduleDialog(
        session: session,
        onReschedule: (newDate, newTimeSlot) {
          ref.read(sessionsNotifierProvider.notifier).rescheduleSession(
                sessionId: session.id,
                newDate: newDate,
                newTimeSlot: newTimeSlot,
              );
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Rescheduled to ${DateTimeUtils.formatShortDate(newDate)} ($newTimeSlot)'),
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
    final allSessions = ref.watch(sessionsNotifierProvider);
    final session = allSessions.firstWhere(
      (s) => s.id == sessionId,
      orElse: () => allSessions.first,
    );

    final isHome = session.visitType == VisitType.homeVisit;

    return Scaffold(
      backgroundColor: PhysioColors.cream,
      appBar: PhysioAppBar(
        title: 'Session Details',
        subtitle: session.patientName,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PhysioCard(
              padding: EdgeInsets.all(18),
              child: Column(
                children: [
                  Row(
                    children: [
                      MockAvatarHelper.buildAvatar(
                        name: session.patientName,
                        radius: 28,
                      ),
                      SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              session.patientName,
                              style: GoogleFonts.fraunces(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: PhysioColors.ink,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              '${session.patientGender}, ${session.patientAge} years old',
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                color: PhysioColors.inkMid,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              session.patientPhone,
                              style: GoogleFonts.ibmPlexMono(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: PhysioColors.pine,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: PhysioPillButton(
                          label: 'Call Patient',
                          type: PhysioPillButtonType.subtle,
                          icon: Icons.phone_rounded,
                          height: 40,
                          fontSize: 12,
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Dialing ${session.patientPhone}...'),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: PhysioPillButton(
                          label: 'View History',
                          type: PhysioPillButtonType.outlined,
                          icon: Icons.folder_shared_outlined,
                          height: 40,
                          fontSize: 12,
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) =>
                                    PatientDetailScreen(patientId: session.patientId),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
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
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Appointment Status',
                          style: GoogleFonts.fraunces(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: PhysioColors.ink,
                          ),
                        ),
                      ),
                      SizedBox(width: 8),
                      PhysioBadge(
                        text: session.status.name.toUpperCase(),
                        variant: session.status == SessionStatus.upcoming
                            ? PhysioBadgeVariant.upcoming
                            : session.status == SessionStatus.completed
                                ? PhysioBadgeVariant.completed
                                : session.status == SessionStatus.request
                                    ? PhysioBadgeVariant.request
                                    : PhysioBadgeVariant.cancelled,
                      ),
                    ],
                  ),
                  SizedBox(height: 14),
                  const Divider(color: PhysioColors.mist),
                  SizedBox(height: 14),

                  _buildDetailRow(
                    icon: Icons.healing_rounded,
                    label: 'Clinical Condition',
                    value: session.condition,
                  ),
                  SizedBox(height: 12),
                  _buildDetailRow(
                    icon: Icons.calendar_today_rounded,
                    label: 'Date & Time',
                    value:
                        '${DateTimeUtils.formatFullDate(session.dateTime)}\n${session.timeSlot}',
                  ),
                  SizedBox(height: 12),
                  _buildDetailRow(
                    icon: isHome ? Icons.home_rounded : Icons.local_hospital_rounded,
                    label: 'Visit Type',
                    value: isHome ? 'Home Visit (Patient Residence)' : 'Clinic Visit (Jhamsikhel Center)',
                  ),
                  SizedBox(height: 12),
                  _buildDetailRow(
                    icon: Icons.location_on_outlined,
                    label: 'Service Location',
                    value: session.address,
                  ),
                  SizedBox(height: 12),
                  _buildDetailRow(
                    icon: Icons.payments_outlined,
                    label: 'Consultation Fee',
                    value: 'Rs. ${session.fee.toInt()} (Settled via PhysioGhar App)',
                  ),
                ],
              ),
            ),

            if (session.status == SessionStatus.completed) ...[
              SizedBox(height: 16),
              PhysioCard(
                padding: EdgeInsets.all(18),
                backgroundColor: const Color(0xFFE8F3EE),
                border: Border.all(color: PhysioColors.pine.withValues(alpha: 0.3)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.assignment_turned_in_rounded,
                            color: PhysioColors.pine, size: 20),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Clinical Session Notes',
                            style: GoogleFonts.fraunces(
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                              color: PhysioColors.pine,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Text(
                      session.clinicalRemarks ?? 'No observations recorded.',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: PhysioColors.ink,
                        height: 1.4,
                      ),
                    ),
                    if (session.prescribedExercises != null &&
                        session.prescribedExercises!.isNotEmpty) ...[
                      SizedBox(height: 14),
                      Text(
                        'PRESCRIBED HOME EXERCISES:',
                        style: GoogleFonts.ibmPlexMono(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: PhysioColors.inkMid,
                        ),
                      ),
                      SizedBox(height: 6),
                      ...session.prescribedExercises!.map(
                        (ex) => Padding(
                          padding: EdgeInsets.only(bottom: 4),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('• ', style: TextStyle(color: PhysioColors.pine, fontWeight: FontWeight.bold)),
                              Expanded(
                                child: Text(
                                  ex,
                                  style: GoogleFonts.inter(fontSize: 13, color: PhysioColors.ink),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                    if (session.nextSessionGoals != null) ...[
                      SizedBox(height: 12),
                      Text(
                        'GOALS FOR NEXT VISIT:',
                        style: GoogleFonts.ibmPlexMono(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: PhysioColors.inkMid,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        session.nextSessionGoals!,
                        style: GoogleFonts.inter(fontSize: 13, fontStyle: FontStyle.italic, color: PhysioColors.inkMid),
                      ),
                    ],
                  ],
                ),
              ),
            ],

            if (session.status == SessionStatus.cancelled &&
                session.cancelledReason != null) ...[
              SizedBox(height: 16),
              PhysioCard(
                padding: EdgeInsets.all(16),
                backgroundColor: PhysioColors.dangerPale,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.info_outline_rounded, color: PhysioColors.danger, size: 20),
                    SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Cancellation Reason',
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: PhysioColors.danger,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            session.cancelledReason!,
                            style: GoogleFonts.inter(fontSize: 13, color: PhysioColors.ink),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],

            SizedBox(height: 24),
            if (session.status == SessionStatus.upcoming) ...[
              PhysioPillButton(
                isFullWidth: true,
                label: 'Complete Session (Enter Clinical Notes)',
                icon: Icons.check_circle_outline_rounded,
                type: PhysioPillButtonType.primary,
                onPressed: () => _showCompleteDialog(context, ref, session),
              ),
              SizedBox(height: 12),
              PhysioPillButton(
                isFullWidth: true,
                label: 'Reschedule Session',
                icon: Icons.schedule_rounded,
                type: PhysioPillButtonType.outlined,
                onPressed: () => _showRescheduleDialog(context, ref, session),
              ),
            ],
            if (session.status == SessionStatus.request) ...[
              PhysioPillButton(
                isFullWidth: true,
                label: 'Accept Booking Request',
                icon: Icons.check_rounded,
                type: PhysioPillButtonType.primary,
                onPressed: () {
                  ref.read(sessionsNotifierProvider.notifier).acceptRequest(session.id);
                  Navigator.of(context).pop();
                },
              ),
              SizedBox(height: 12),
              PhysioPillButton(
                isFullWidth: true,
                label: 'Decline Booking Request',
                icon: Icons.close_rounded,
                type: PhysioPillButtonType.destructive,
                onPressed: () {
                  ref.read(sessionsNotifierProvider.notifier).declineRequest(session.id);
                  Navigator.of(context).pop();
                },
              ),
            ],
            SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: PhysioColors.inkMute),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label.toUpperCase(),
                style: GoogleFonts.ibmPlexMono(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: PhysioColors.inkMute,
                ),
              ),
              SizedBox(height: 2),
              Text(
                value,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: PhysioColors.ink,
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

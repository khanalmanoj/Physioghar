import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:physioghar/core/localization/app_language_provider.dart';
import 'package:physioghar/core/theme/app_colors.dart';
import 'package:physioghar/core/utils/date_time_utils.dart';
import 'package:physioghar/core/utils/mock_avatar_helper.dart';
import 'package:physioghar/core/widgets/physio_app_bar.dart';
import 'package:physioghar/core/widgets/physio_card.dart';
import 'package:physioghar/core/widgets/physio_pill_button.dart';
import '../domain/models/patient_note_model.dart';
import '../providers/patients_provider.dart';
import 'widgets/add_edit_note_modal.dart';
import 'package:physioghar/core/widgets/physio_badge.dart';
import 'package:physioghar/features/sessions/domain/models/session_model.dart';
import 'package:physioghar/features/sessions/presentation/session_detail_screen.dart';
import 'package:physioghar/features/sessions/providers/sessions_provider.dart';

class PatientDetailScreen extends ConsumerWidget {
  final String patientId;

  const PatientDetailScreen({
    super.key,
    required this.patientId,
  });

  void _showAddEditNoteModal(
    BuildContext context,
    WidgetRef ref,
    String patientId, {
    PatientNote? existingNote,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => AddEditNoteModal(
        patientId: patientId,
        existingNote: existingNote,
        onSaveNote: (note) {
          if (existingNote == null) {
            ref.read(patientsNotifierProvider.notifier).addNote(patientId, note);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Clinical note added to patient record'),
                backgroundColor: PhysioColors.pine,
                behavior: SnackBarBehavior.floating,
              ),
            );
          } else {
            ref.read(patientsNotifierProvider.notifier).editNote(patientId, note);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Clinical note updated'),
                backgroundColor: PhysioColors.pine,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
      ),
    );
  }

  void _confirmDeleteNote(
    BuildContext context,
    WidgetRef ref,
    String patientId,
    String noteId,
  ) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          'Delete Note?',
          style: GoogleFonts.fraunces(fontWeight: FontWeight.w700),
        ),
        content: const Text('Are you sure you want to remove this clinical note? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              ref.read(patientsNotifierProvider.notifier).deleteNote(patientId, noteId);
              Navigator.of(ctx).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Note deleted'),
                  backgroundColor: PhysioColors.danger,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            child: const Text('Delete', style: TextStyle(color: PhysioColors.danger)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final patientsState = ref.watch(patientsNotifierProvider);
    final patient = patientsState.allPatients.firstWhere(
      (p) => p.id == patientId,
      orElse: () => patientsState.allPatients.first,
    );

    final allSessions = ref.watch(sessionsNotifierProvider);
    final patientSessions = allSessions.where((s) => s.patientId == patient.id || s.patientName == patient.name).toList();

    return Scaffold(
      backgroundColor: PhysioColors.cream,
      appBar: PhysioAppBar(
        title: context.tr('patient_details'),
        subtitle: patient.name,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PhysioCard(
              padding: EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      MockAvatarHelper.buildAvatar(
                        name: patient.name,
                        radius: 30,
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              patient.name,
                              style: GoogleFonts.fraunces(
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                                color: PhysioColors.ink,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              '${patient.gender}, ${patient.age} yrs',
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                color: PhysioColors.inkMid,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              patient.condition,
                              style: GoogleFonts.inter(
                                fontSize: 13,
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
                  const Divider(color: PhysioColors.mist),
                  SizedBox(height: 12),

                  _buildInfoRow(
                    icon: Icons.phone_rounded,
                    label: 'Contact',
                    value: patient.phone,
                  ),
                  SizedBox(height: 10),
                  _buildInfoRow(
                    icon: Icons.home_rounded,
                    label: 'Address',
                    value: patient.address,
                  ),
                  SizedBox(height: 10),
                  _buildInfoRow(
                    icon: Icons.contact_emergency_rounded,
                    label: 'Emergency Contact',
                    value: patient.emergencyContact,
                  ),
                  SizedBox(height: 10),
                  _buildInfoRow(
                    icon: Icons.checklist_rounded,
                    label: 'Total Sessions Attended',
                    value: '${patient.totalSessionsCount} sessions completed',
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: PhysioPillButton(
                    label: 'Call Patient',
                    icon: Icons.phone_rounded,
                    type: PhysioPillButtonType.outlined,
                    height: 42,
                    fontSize: 12,
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Calling ${patient.name} (${patient.phone})...'),
                          backgroundColor: PhysioColors.pine,
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: PhysioPillButton(
                    label: 'Message',
                    icon: Icons.chat_bubble_outline_rounded,
                    type: PhysioPillButtonType.outlined,
                    height: 42,
                    fontSize: 12,
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Opening WhatsApp message for ${patient.name}...'),
                          backgroundColor: PhysioColors.pine,
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 24),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'Associated Sessions',
                    style: GoogleFonts.fraunces(
                      fontSize: 19,
                      fontWeight: FontWeight.w700,
                      color: PhysioColors.ink,
                    ),
                  ),
                ),
                SizedBox(width: 8),
                Text(
                  '${patientSessions.length} logged',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: PhysioColors.inkMute,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),

            if (patientSessions.isEmpty)
              PhysioCard(
                padding: EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(Icons.event_busy_rounded, color: PhysioColors.inkMute, size: 28),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'No appointment sessions found for this patient yet.',
                        style: GoogleFonts.inter(fontSize: 13, color: PhysioColors.inkMid),
                      ),
                    ),
                  ],
                ),
              )
            else
              ...patientSessions.map((sess) {
                return PhysioCard(
                  margin: EdgeInsets.only(bottom: 10),
                  padding: EdgeInsets.all(14),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => SessionDetailScreen(sessionId: sess.id),
                      ),
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              sess.condition,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.inter(
                                fontSize: 13.5,
                                fontWeight: FontWeight.w600,
                                color: PhysioColors.ink,
                              ),
                            ),
                            SizedBox(height: 3),
                            Text(
                              '${DateTimeUtils.formatShortDate(sess.dateTime)} • ${sess.timeSlot}',
                              style: GoogleFonts.ibmPlexMono(
                                fontSize: 11.5,
                                color: PhysioColors.inkMid,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 8),
                      PhysioBadge(
                        text: sess.status.name.toUpperCase(),
                        variant: sess.status == SessionStatus.completed
                            ? PhysioBadgeVariant.completed
                            : sess.status == SessionStatus.upcoming
                                ? PhysioBadgeVariant.upcoming
                                : sess.status == SessionStatus.request
                                    ? PhysioBadgeVariant.request
                                    : PhysioBadgeVariant.cancelled,
                        fontSize: 10,
                      ),
                    ],
                  ),
                );
              }),
            SizedBox(height: 24),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.tr('treatment_notes'),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.fraunces(
                          fontSize: 19,
                          fontWeight: FontWeight.w700,
                          color: PhysioColors.ink,
                        ),
                      ),
                      Text(
                        '${patient.notes.length} notes logged',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: PhysioColors.inkMute,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 8),
                PhysioPillButton(
                  label: context.tr('add_note'),
                  type: PhysioPillButtonType.primary,
                  height: 38,
                  fontSize: 12,
                  icon: Icons.add,
                  onPressed: () => _showAddEditNoteModal(context, ref, patient.id),
                ),
              ],
            ),
            SizedBox(height: 14),

            if (patient.notes.isEmpty)
              PhysioCard(
                padding: EdgeInsets.all(24),
                child: Center(
                  child: Column(
                    children: [
                      Icon(Icons.note_alt_outlined,
                          size: 36, color: PhysioColors.inkMute),
                      SizedBox(height: 10),
                      Text(
                        'No Clinical Notes Yet',
                        style: GoogleFonts.fraunces(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: PhysioColors.ink,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Record treatment observations, exercise prescriptions, and recovery goals.',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          color: PhysioColors.inkMid,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              ...patient.notes.map((note) {
                return PhysioCard(
                  margin: EdgeInsets.only(bottom: 14),
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              note.title,
                              style: GoogleFonts.fraunces(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: PhysioColors.ink,
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit_outlined,
                                    size: 18, color: PhysioColors.pine),
                                tooltip: context.tr('edit_note'),
                                constraints: const BoxConstraints(),
                                padding: EdgeInsets.all(6),
                                onPressed: () => _showAddEditNoteModal(
                                  context,
                                  ref,
                                  patient.id,
                                  existingNote: note,
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.delete_outline,
                                    size: 18, color: PhysioColors.danger),
                                tooltip: context.tr('delete_note'),
                                constraints: const BoxConstraints(),
                                padding: EdgeInsets.all(6),
                                onPressed: () => _confirmDeleteNote(
                                  context,
                                  ref,
                                  patient.id,
                                  note.id,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Text(
                        DateTimeUtils.formatFullDate(note.createdAt),
                        style: GoogleFonts.ibmPlexMono(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: PhysioColors.inkMute,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        note.content,
                        style: GoogleFonts.inter(
                          fontSize: 13.5,
                          color: PhysioColors.inkMid,
                          height: 1.4,
                        ),
                      ),
                      if (note.exercises.isNotEmpty) ...[
                        SizedBox(height: 12),
                        Text(
                          'HOME EXERCISES:',
                          style: GoogleFonts.ibmPlexMono(
                            fontSize: 10.5,
                            fontWeight: FontWeight.w600,
                            color: PhysioColors.pine,
                          ),
                        ),
                        SizedBox(height: 4),
                        Wrap(
                          spacing: 6,
                          runSpacing: 6,
                          children: note.exercises.map((ex) {
                            return Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: PhysioColors.mist,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                ex,
                                style: GoogleFonts.inter(
                                  fontSize: 11.5,
                                  color: PhysioColors.ink,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                      if (note.nextGoals.isNotEmpty) ...[
                        SizedBox(height: 10),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'GOAL: ',
                              style: GoogleFonts.ibmPlexMono(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: PhysioColors.amber,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                note.nextGoals,
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  fontStyle: FontStyle.italic,
                                  color: PhysioColors.inkMid,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                );
              }),
            SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: PhysioColors.inkMute),
        SizedBox(width: 8),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: GoogleFonts.inter(fontSize: 13, color: PhysioColors.inkMid),
              children: [
                TextSpan(
                  text: '$label: ',
                  style: const TextStyle(fontWeight: FontWeight.w600, color: PhysioColors.ink),
                ),
                TextSpan(text: value),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

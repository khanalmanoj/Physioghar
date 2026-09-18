import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:physioghar/core/localization/app_language_provider.dart';
import 'package:physioghar/core/theme/app_colors.dart';
import 'package:physioghar/core/widgets/empty_state_view.dart';
import 'package:physioghar/features/patients/domain/models/patient_note_model.dart';
import 'package:physioghar/features/patients/providers/patients_provider.dart';
import '../domain/models/session_model.dart';
import '../providers/sessions_provider.dart';
import 'session_detail_screen.dart';
import 'widgets/complete_session_dialog.dart';
import 'widgets/reschedule_dialog.dart';
import 'widgets/session_card.dart';

class SessionsScreen extends ConsumerStatefulWidget {
  final int initialTabIndex;

  const SessionsScreen({
    super.key,
    this.initialTabIndex = 0,
  });

  @override
  ConsumerState<SessionsScreen> createState() => _SessionsScreenState();
}

class _SessionsScreenState extends ConsumerState<SessionsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 4,
      vsync: this,
      initialIndex: widget.initialTabIndex,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _showCompleteDialog(SessionModel session) {
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
            title: 'Completed Session: ${session.condition}',
            content: remarks,
            exercises: exercises,
            nextGoals: nextGoals ?? 'Patient progressing towards functional goals.',
            createdAt: DateTime.now(),
          );
          ref.read(patientsNotifierProvider.notifier).addNote(session.patientId, newNote);

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Session completed & clinical note added to Patient Record!'),
              backgroundColor: PhysioColors.pine,
              behavior: SnackBarBehavior.floating,
            ),
          );
        },
      ),
    );
  }

  void _showRescheduleDialog(SessionModel session) {
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
            const SnackBar(
              content: Text('Session appointment rescheduled successfully'),
              backgroundColor: PhysioColors.pine,
              behavior: SnackBarBehavior.floating,
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final allSessions = ref.watch(sessionsNotifierProvider);

    final requests = allSessions.where((s) => s.status == SessionStatus.request).toList();
    final upcoming = allSessions.where((s) => s.status == SessionStatus.upcoming).toList();
    final completed = allSessions.where((s) => s.status == SessionStatus.completed).toList();
    final cancelled = allSessions.where((s) => s.status == SessionStatus.cancelled).toList();

    return Scaffold(
      backgroundColor: PhysioColors.cream,
      appBar: AppBar(
        title: Text(
          context.tr('nav_sessions'),
          style: GoogleFonts.fraunces(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: PhysioColors.ink,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(48),
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: PhysioColors.mist,
              borderRadius: BorderRadius.circular(12),
            ),
            child: TabBar(
              controller: _tabController,
              isScrollable: true,
              tabAlignment: TabAlignment.start,
              indicatorSize: TabBarIndicatorSize.tab,
              dividerColor: Colors.transparent,
              padding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
              labelPadding: EdgeInsets.symmetric(horizontal: 14),
              indicator: BoxDecoration(
                color: PhysioColors.pine,
                borderRadius: BorderRadius.circular(10),
              ),
              labelColor: Colors.white,
              unselectedLabelColor: PhysioColors.inkMid,
              labelStyle: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
              unselectedLabelStyle: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
              tabs: [
                Tab(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(context.tr('tab_requests')),
                      if (requests.isNotEmpty) ...[
                        SizedBox(width: 5),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                          decoration: BoxDecoration(
                            color: PhysioColors.amber,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            '${requests.length}',
                            style: TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                Tab(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(context.tr('tab_upcoming')),
                      if (upcoming.isNotEmpty) ...[
                        SizedBox(width: 5),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                          decoration: BoxDecoration(
                            color: PhysioColors.pinePale,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            '${upcoming.length}',
                            style: TextStyle(fontSize: 10, color: PhysioColors.pine, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                Tab(text: context.tr('tab_completed')),
                Tab(text: context.tr('tab_cancelled')),
              ],
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildSessionList(
            sessions: requests,
            emptyIcon: Icons.inbox_rounded,
            emptyTitle: 'No Pending Requests',
            emptyDescription: 'New booking requests from patients will appear here.',
            onAccept: (s) {
              ref.read(sessionsNotifierProvider.notifier).acceptRequest(s.id);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Accepted session for ${s.patientName}! Moved to Upcoming.'),
                  backgroundColor: PhysioColors.pine,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            onDecline: (s) {
              ref.read(sessionsNotifierProvider.notifier).declineRequest(s.id);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Declined booking request for ${s.patientName}.'),
                  backgroundColor: PhysioColors.danger,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
          ),

          _buildSessionList(
            sessions: upcoming,
            emptyIcon: Icons.event_available_rounded,
            emptyTitle: 'No Upcoming Sessions',
            emptyDescription: 'You currently have no upcoming confirmed appointments.',
            onComplete: _showCompleteDialog,
            onReschedule: _showRescheduleDialog,
          ),

          _buildSessionList(
            sessions: completed,
            emptyIcon: Icons.task_alt_rounded,
            emptyTitle: 'No Completed Sessions',
            emptyDescription: 'Finished sessions with clinical notes will appear here.',
          ),

          _buildSessionList(
            sessions: cancelled,
            emptyIcon: Icons.cancel_outlined,
            emptyTitle: 'No Cancelled Sessions',
            emptyDescription: 'Declined or cancelled visits will appear in audit history.',
          ),
        ],
      ),
    );
  }

  Widget _buildSessionList({
    required List<SessionModel> sessions,
    required IconData emptyIcon,
    required String emptyTitle,
    required String emptyDescription,
    Function(SessionModel)? onAccept,
    Function(SessionModel)? onDecline,
    Function(SessionModel)? onComplete,
    Function(SessionModel)? onReschedule,
  }) {
    if (sessions.isEmpty) {
      return EmptyStateView(
        icon: emptyIcon,
        title: emptyTitle,
        description: emptyDescription,
      );
    }

    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      itemCount: sessions.length,
      itemBuilder: (context, index) {
        final session = sessions[index];
        return SessionCard(
          session: session,
          onAccept: onAccept != null ? () => onAccept(session) : null,
          onDecline: onDecline != null ? () => onDecline(session) : null,
          onComplete: onComplete != null ? () => onComplete(session) : null,
          onReschedule: onReschedule != null ? () => onReschedule(session) : null,
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => SessionDetailScreen(sessionId: session.id),
              ),
            );
          },
        );
      },
    );
  }
}

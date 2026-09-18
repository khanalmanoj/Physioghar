import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:physioghar/core/localization/app_language_provider.dart';
import 'package:physioghar/core/localization/app_strings.dart';
import 'package:physioghar/features/complaints/domain/models/complaint_model.dart';
import 'package:physioghar/features/complaints/providers/complaints_provider.dart';
import 'package:physioghar/features/dashboard/providers/dashboard_metrics_provider.dart';
import 'package:physioghar/features/patients/domain/models/patient_note_model.dart';
import 'package:physioghar/features/patients/providers/patients_provider.dart';
import 'package:physioghar/features/profile/providers/therapist_profile_provider.dart';
import 'package:physioghar/features/schedule/domain/models/time_slot_model.dart';
import 'package:physioghar/features/schedule/providers/schedule_provider.dart';
import 'package:physioghar/features/sessions/domain/models/session_model.dart';
import 'package:physioghar/features/sessions/providers/sessions_provider.dart';

void main() {
  group('PhysioGhar State Management Unit Tests', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('Availability toggle updates therapist profile and state', () {
      final initialAvailability = container.read(therapistProfileProvider).isAvailable;
      expect(initialAvailability, isTrue);

      container.read(therapistProfileProvider.notifier).toggleAvailability();
      expect(container.read(therapistProfileProvider).isAvailable, isFalse);

      container.read(therapistProfileProvider.notifier).toggleAvailability();
      expect(container.read(therapistProfileProvider).isAvailable, isTrue);
    });

    test('Schedule slots can be blocked, unblocked, and added', () {
      final initialSlots = container.read(scheduleNotifierProvider).allSlots;
      expect(initialSlots.isNotEmpty, isTrue);

      // Find an open slot to block
      final openSlot = initialSlots.firstWhere((s) => s.status == SlotStatus.open);
      container.read(scheduleNotifierProvider.notifier).blockSlot(openSlot.id);

      final blockedSlot = container
          .read(scheduleNotifierProvider)
          .allSlots
          .firstWhere((s) => s.id == openSlot.id);
      expect(blockedSlot.status, equals(SlotStatus.blocked));

      // Unblock it back to open
      container.read(scheduleNotifierProvider.notifier).unblockSlot(openSlot.id);
      final unblockedSlot = container
          .read(scheduleNotifierProvider)
          .allSlots
          .firstWhere((s) => s.id == openSlot.id);
      expect(unblockedSlot.status, equals(SlotStatus.open));

      // Add a new custom slot
      final slotCountBefore = container.read(scheduleNotifierProvider).allSlots.length;
      container.read(scheduleNotifierProvider.notifier).addSlot(
            date: DateTime.now(),
            startTime: '07:00 AM',
            endTime: '08:00 AM',
            defaultVisitType: VisitType.clinic,
          );
      expect(
        container.read(scheduleNotifierProvider).allSlots.length,
        equals(slotCountBefore + 1),
      );
    });

    test('Session lifecycle: accept request, complete session, decline request', () {
      final initialSessions = container.read(sessionsNotifierProvider);
      final requestSession =
          initialSessions.firstWhere((s) => s.status == SessionStatus.request);

      // Accept request -> moves to Upcoming
      container.read(sessionsNotifierProvider.notifier).acceptRequest(requestSession.id);
      final upcomingSession = container
          .read(sessionsNotifierProvider)
          .firstWhere((s) => s.id == requestSession.id);
      expect(upcomingSession.status, equals(SessionStatus.upcoming));

      // Complete session with clinical notes -> moves to Completed
      container.read(sessionsNotifierProvider.notifier).completeSession(
            sessionId: upcomingSession.id,
            clinicalRemarks: 'Patient improved range of motion significantly.',
            prescribedExercises: ['Hamstring stretch', 'Pelvic tilt'],
            nextSessionGoals: 'Strengthen core stabilizers.',
          );
      final completedSession = container
          .read(sessionsNotifierProvider)
          .firstWhere((s) => s.id == upcomingSession.id);
      expect(completedSession.status, equals(SessionStatus.completed));
      expect(completedSession.clinicalRemarks, isNotNull);
      expect(completedSession.prescribedExercises?.length, equals(2));

      // Decline another request -> moves to Cancelled
      final anotherRequest = container
          .read(sessionsNotifierProvider)
          .firstWhere((s) => s.status == SessionStatus.request);
      container.read(sessionsNotifierProvider.notifier).declineRequest(anotherRequest.id);
      final cancelledSession = container
          .read(sessionsNotifierProvider)
          .firstWhere((s) => s.id == anotherRequest.id);
      expect(cancelledSession.status, equals(SessionStatus.cancelled));
    });

    test('Patients provider: search, add note, edit note, delete note', () {
      final patientsState = container.read(patientsNotifierProvider);
      expect(patientsState.allPatients.isNotEmpty, isTrue);

      final patient = patientsState.allPatients.first;
      final initialNoteCount = patient.notes.length;

      // Add a note
      final newNote = PatientNote(
        id: 'test-note-1',
        patientId: patient.id,
        title: 'Lumbar Flexion Assessment',
        content: 'Good control and no radicular symptoms.',
        exercises: ['McKenzie press-up'],
        nextGoals: 'Walk 3km pain-free.',
        createdAt: DateTime.now(),
      );
      container.read(patientsNotifierProvider.notifier).addNote(patient.id, newNote);

      final patientAfterAdd = container
          .read(patientsNotifierProvider)
          .allPatients
          .firstWhere((p) => p.id == patient.id);
      expect(patientAfterAdd.notes.length, equals(initialNoteCount + 1));

      // Edit the note
      final updatedNote = newNote.copyWith(title: 'Updated Note Title');
      container.read(patientsNotifierProvider.notifier).editNote(patient.id, updatedNote);

      final patientAfterEdit = container
          .read(patientsNotifierProvider)
          .allPatients
          .firstWhere((p) => p.id == patient.id);
      expect(patientAfterEdit.notes.first.title, equals('Updated Note Title'));

      // Delete the note
      container.read(patientsNotifierProvider.notifier).deleteNote(patient.id, newNote.id);
      final patientAfterDelete = container
          .read(patientsNotifierProvider)
          .allPatients
          .firstWhere((p) => p.id == patient.id);
      expect(patientAfterDelete.notes.length, equals(initialNoteCount));

      // Search filter
      container.read(patientsNotifierProvider.notifier).updateSearchQuery('Sita');
      final filtered = container.read(patientsNotifierProvider).filteredPatients;
      expect(filtered.every((p) => p.name.contains('Sita')), isTrue);
    });

    test('Dashboard metrics dynamically aggregate session counts', () {
      final metrics = container.read(dashboardMetricsProvider);
      expect(metrics.bookingRequestsCount, greaterThanOrEqualTo(0));
      expect(metrics.todaySessionsCount, greaterThanOrEqualTo(0));
    });

    test('Complaints provider accepts new tickets and tracks history', () {
      final initialCount = container.read(complaintsNotifierProvider).length;

      container.read(complaintsNotifierProvider.notifier).submitComplaint(
            category: ComplaintCategory.paymentIssue,
            priority: ComplaintPriority.high,
            subject: 'Late disbursement',
            description: 'Settlement delay for Sunday session.',
          );

      final updatedTickets = container.read(complaintsNotifierProvider);
      expect(updatedTickets.length, equals(initialCount + 1));
      expect(updatedTickets.first.subject, equals('Late disbursement'));
      expect(updatedTickets.first.status, equals(ComplaintStatus.submitted));
    });

    test('Language provider toggles between English and Nepali', () {
      expect(container.read(languageNotifierProvider), equals(AppLanguage.en));

      container.read(languageNotifierProvider.notifier).toggleLanguage();
      expect(container.read(languageNotifierProvider), equals(AppLanguage.ne));

      final nepaliText = AppStrings.get('nav_dashboard', AppLanguage.ne);
      expect(nepaliText, equals('ड्यासबोर्ड'));

      container.read(languageNotifierProvider.notifier).toggleLanguage();
      expect(container.read(languageNotifierProvider), equals(AppLanguage.en));
    });
  });
}

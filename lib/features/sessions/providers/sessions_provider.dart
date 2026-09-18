import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/mock_sessions_data.dart';
import '../domain/models/session_model.dart';

class SessionsNotifier extends StateNotifier<List<SessionModel>> {
  final Ref ref;

  SessionsNotifier(this.ref) : super(generateInitialMockSessions());

  void acceptRequest(String sessionId) {
    state = state.map((s) {
      if (s.id == sessionId) {
        return s.copyWith(status: SessionStatus.upcoming);
      }
      return s;
    }).toList();
  }

  void declineRequest(String sessionId, {String? reason}) {
    state = state.map((s) {
      if (s.id == sessionId) {
        return s.copyWith(
          status: SessionStatus.cancelled,
          cancelledReason: reason ?? 'Declined by therapist due to schedule conflict',
        );
      }
      return s;
    }).toList();
  }

  void completeSession({
    required String sessionId,
    required String clinicalRemarks,
    List<String>? prescribedExercises,
    String? nextSessionGoals,
  }) {
    state = state.map((s) {
      if (s.id == sessionId) {
        return s.copyWith(
          status: SessionStatus.completed,
          clinicalRemarks: clinicalRemarks,
          prescribedExercises: prescribedExercises,
          nextSessionGoals: nextSessionGoals,
        );
      }
      return s;
    }).toList();
  }

  void rescheduleSession({
    required String sessionId,
    required DateTime newDate,
    required String newTimeSlot,
  }) {
    state = state.map((s) {
      if (s.id == sessionId) {
        return s.copyWith(
          dateTime: newDate,
          timeSlot: newTimeSlot,
        );
      }
      return s;
    }).toList();
  }
}

final sessionsNotifierProvider =
    StateNotifierProvider<SessionsNotifier, List<SessionModel>>((ref) {
  return SessionsNotifier(ref);
});

final pendingRequestsCountProvider = Provider<int>((ref) {
  final sessions = ref.watch(sessionsNotifierProvider);
  return sessions.where((s) => s.status == SessionStatus.request).length;
});

final todaySessionsProvider = Provider<List<SessionModel>>((ref) {
  final sessions = ref.watch(sessionsNotifierProvider);
  final now = DateTime.now();
  return sessions.where((s) {
    final isToday = s.dateTime.year == now.year &&
        s.dateTime.month == now.month &&
        s.dateTime.day == now.day;
    return isToday && (s.status == SessionStatus.upcoming || s.status == SessionStatus.completed);
  }).toList();
});

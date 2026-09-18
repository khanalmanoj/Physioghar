import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../sessions/domain/models/session_model.dart';
import '../../sessions/providers/sessions_provider.dart';

class DashboardMetrics {
  final int todaySessionsCount;
  final int bookingRequestsCount;
  final int completedThisWeekCount;

  const DashboardMetrics({
    required this.todaySessionsCount,
    required this.bookingRequestsCount,
    required this.completedThisWeekCount,
  });
}

final dashboardMetricsProvider = Provider<DashboardMetrics>((ref) {
  final allSessions = ref.watch(sessionsNotifierProvider);
  final now = DateTime.now();

  int todaySessions = 0;
  int bookingRequests = 0;
  int completedThisWeek = 0;

  final weekStart = now.subtract(Duration(days: now.weekday - 1));
  final weekStartDate = DateTime(weekStart.year, weekStart.month, weekStart.day);

  for (final s in allSessions) {
    final sDate = DateTime(s.dateTime.year, s.dateTime.month, s.dateTime.day);
    final isToday = sDate.year == now.year && sDate.month == now.month && sDate.day == now.day;

    if (s.status == SessionStatus.request) {
      bookingRequests++;
    }

    if (isToday && (s.status == SessionStatus.upcoming || s.status == SessionStatus.completed)) {
      todaySessions++;
    }

    if (s.status == SessionStatus.completed &&
        sDate.isAfter(weekStartDate.subtract(const Duration(seconds: 1)))) {
      completedThisWeek++;
    }
  }

  return DashboardMetrics(
    todaySessionsCount: todaySessions,
    bookingRequestsCount: bookingRequests,
    completedThisWeekCount: completedThisWeek,
  );
});

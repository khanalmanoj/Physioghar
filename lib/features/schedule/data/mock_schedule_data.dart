import '../domain/models/time_slot_model.dart';

List<TimeSlot> generateInitialMockSlots() {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final mondayThisWeek = today.subtract(Duration(days: today.weekday - 1));

  final List<TimeSlot> slots = [];

  // Generate slots for 14 days (current week + next week)
  for (int dayOffset = -1; dayOffset < 14; dayOffset++) {
    final date = mondayThisWeek.add(Duration(days: dayOffset));
    final dayOfWeek = date.weekday; // 1 = Mon, 7 = Sun

    // Default morning slot
    slots.add(
      TimeSlot(
        id: 'slot-$dayOffset-1',
        date: date,
        startTime: '08:30 AM',
        endTime: '09:30 AM',
        status: (dayOffset % 2 == 0) ? SlotStatus.booked : SlotStatus.open,
        patientName: (dayOffset % 2 == 0) ? (dayOffset % 4 == 0 ? 'Sita Sharma' : 'Maya Gurung') : null,
        visitType: (dayOffset % 2 == 0) ? VisitType.homeVisit : null,
        serviceName: (dayOffset % 2 == 0) ? 'Rehabilitation Therapy' : null,
      ),
    );

    // Mid-day slot
    slots.add(
      TimeSlot(
        id: 'slot-$dayOffset-2',
        date: date,
        startTime: '10:30 AM',
        endTime: '11:30 AM',
        status: SlotStatus.open,
      ),
    );

    // Afternoon slot
    slots.add(
      TimeSlot(
        id: 'slot-$dayOffset-3',
        date: date,
        startTime: '01:30 PM',
        endTime: '02:30 PM',
        status: (dayOffset % 3 == 0) ? SlotStatus.blocked : SlotStatus.open,
      ),
    );

    // Late afternoon / evening slot
    if (dayOfWeek != 6 && dayOfWeek != 7) {
      // Weekdays get an evening booked/open slot
      slots.add(
        TimeSlot(
          id: 'slot-$dayOffset-4',
          date: date,
          startTime: '04:00 PM',
          endTime: '05:00 PM',
          status: (dayOffset % 2 != 0) ? SlotStatus.booked : SlotStatus.open,
          patientName: (dayOffset % 2 != 0) ? (dayOffset % 3 == 0 ? 'Ramesh Thapa' : 'Bikash Adhikari') : null,
          visitType: (dayOffset % 2 != 0) ? VisitType.clinic : null,
          serviceName: (dayOffset % 2 != 0) ? 'Knee & Joint Mobilization' : null,
        ),
      );
    }
  }

  // Ensure specific known today slots for smooth UX
  final todaySlots = slots.where((s) => s.date.year == today.year && s.date.month == today.month && s.date.day == today.day).toList();
  if (todaySlots.isEmpty) {
    slots.addAll([
      TimeSlot(
        id: 'slot-today-1',
        date: today,
        startTime: '08:30 AM',
        endTime: '09:30 AM',
        status: SlotStatus.booked,
        patientName: 'Sita Sharma',
        visitType: VisitType.homeVisit,
        serviceName: 'Lower Back Rehabilitation',
      ),
      TimeSlot(
        id: 'slot-today-2',
        date: today,
        startTime: '10:00 AM',
        endTime: '11:00 AM',
        status: SlotStatus.open,
      ),
      TimeSlot(
        id: 'slot-today-3',
        date: today,
        startTime: '11:30 AM',
        endTime: '12:30 PM',
        status: SlotStatus.booked,
        patientName: 'Ramesh Thapa',
        visitType: VisitType.clinic,
        serviceName: 'Post-Surgery Knee Recovery',
      ),
      TimeSlot(
        id: 'slot-today-4',
        date: today,
        startTime: '02:00 PM',
        endTime: '03:00 PM',
        status: SlotStatus.blocked,
      ),
      TimeSlot(
        id: 'slot-today-5',
        date: today,
        startTime: '04:00 PM',
        endTime: '05:00 PM',
        status: SlotStatus.open,
      ),
    ]);
  }

  return slots;
}

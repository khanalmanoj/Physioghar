enum SlotStatus { open, booked, blocked }

enum VisitType { homeVisit, clinic }

class TimeSlot {
  final String id;
  final DateTime date;
  final String startTime; // e.g. "09:00 AM"
  final String endTime;   // e.g. "10:00 AM"
  final SlotStatus status;
  final String? patientName;
  final VisitType? visitType;
  final String? serviceName;

  const TimeSlot({
    required this.id,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.status,
    this.patientName,
    this.visitType,
    this.serviceName,
  });

  TimeSlot copyWith({
    String? id,
    DateTime? date,
    String? startTime,
    String? endTime,
    SlotStatus? status,
    String? patientName,
    VisitType? visitType,
    String? serviceName,
  }) {
    return TimeSlot(
      id: id ?? this.id,
      date: date ?? this.date,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      status: status ?? this.status,
      patientName: patientName ?? this.patientName,
      visitType: visitType ?? this.visitType,
      serviceName: serviceName ?? this.serviceName,
    );
  }
}

import 'package:physioghar/features/schedule/domain/models/time_slot_model.dart';

enum SessionStatus { request, upcoming, completed, cancelled }

class SessionModel {
  final String id;
  final String patientId;
  final String patientName;
  final int patientAge;
  final String patientGender;
  final String patientPhone;
  final String address;
  final VisitType visitType;
  final String condition;
  final DateTime dateTime;
  final String timeSlot;
  final double fee;
  final SessionStatus status;
  final String? clinicalRemarks;
  final List<String>? prescribedExercises;
  final String? nextSessionGoals;
  final String? cancelledReason;

  const SessionModel({
    required this.id,
    required this.patientId,
    required this.patientName,
    required this.patientAge,
    required this.patientGender,
    required this.patientPhone,
    required this.address,
    required this.visitType,
    required this.condition,
    required this.dateTime,
    required this.timeSlot,
    required this.fee,
    required this.status,
    this.clinicalRemarks,
    this.prescribedExercises,
    this.nextSessionGoals,
    this.cancelledReason,
  });

  SessionModel copyWith({
    String? id,
    String? patientId,
    String? patientName,
    int? patientAge,
    String? patientGender,
    String? patientPhone,
    String? address,
    VisitType? visitType,
    String? condition,
    DateTime? dateTime,
    String? timeSlot,
    double? fee,
    SessionStatus? status,
    String? clinicalRemarks,
    List<String>? prescribedExercises,
    String? nextSessionGoals,
    String? cancelledReason,
  }) {
    return SessionModel(
      id: id ?? this.id,
      patientId: patientId ?? this.patientId,
      patientName: patientName ?? this.patientName,
      patientAge: patientAge ?? this.patientAge,
      patientGender: patientGender ?? this.patientGender,
      patientPhone: patientPhone ?? this.patientPhone,
      address: address ?? this.address,
      visitType: visitType ?? this.visitType,
      condition: condition ?? this.condition,
      dateTime: dateTime ?? this.dateTime,
      timeSlot: timeSlot ?? this.timeSlot,
      fee: fee ?? this.fee,
      status: status ?? this.status,
      clinicalRemarks: clinicalRemarks ?? this.clinicalRemarks,
      prescribedExercises: prescribedExercises ?? this.prescribedExercises,
      nextSessionGoals: nextSessionGoals ?? this.nextSessionGoals,
      cancelledReason: cancelledReason ?? this.cancelledReason,
    );
  }
}

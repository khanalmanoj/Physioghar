import 'patient_note_model.dart';

class PatientModel {
  final String id;
  final String name;
  final int age;
  final String gender;
  final String phone;
  final String address;
  final String emergencyContact;
  final String condition;
  final DateTime lastSessionDate;
  final int totalSessionsCount;
  final List<PatientNote> notes;

  const PatientModel({
    required this.id,
    required this.name,
    required this.age,
    required this.gender,
    required this.phone,
    required this.address,
    required this.emergencyContact,
    required this.condition,
    required this.lastSessionDate,
    required this.totalSessionsCount,
    required this.notes,
  });

  PatientModel copyWith({
    String? id,
    String? name,
    int? age,
    String? gender,
    String? phone,
    String? address,
    String? emergencyContact,
    String? condition,
    DateTime? lastSessionDate,
    int? totalSessionsCount,
    List<PatientNote>? notes,
  }) {
    return PatientModel(
      id: id ?? this.id,
      name: name ?? this.name,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      emergencyContact: emergencyContact ?? this.emergencyContact,
      condition: condition ?? this.condition,
      lastSessionDate: lastSessionDate ?? this.lastSessionDate,
      totalSessionsCount: totalSessionsCount ?? this.totalSessionsCount,
      notes: notes ?? this.notes,
    );
  }
}

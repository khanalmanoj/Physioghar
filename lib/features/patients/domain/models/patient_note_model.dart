class PatientNote {
  final String id;
  final String patientId;
  final String title;
  final String content;
  final List<String> exercises;
  final String nextGoals;
  final DateTime createdAt;

  const PatientNote({
    required this.id,
    required this.patientId,
    required this.title,
    required this.content,
    required this.exercises,
    required this.nextGoals,
    required this.createdAt,
  });

  PatientNote copyWith({
    String? id,
    String? patientId,
    String? title,
    String? content,
    List<String>? exercises,
    String? nextGoals,
    DateTime? createdAt,
  }) {
    return PatientNote(
      id: id ?? this.id,
      patientId: patientId ?? this.patientId,
      title: title ?? this.title,
      content: content ?? this.content,
      exercises: exercises ?? this.exercises,
      nextGoals: nextGoals ?? this.nextGoals,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

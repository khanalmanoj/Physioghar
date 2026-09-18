import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/mock_patient_data.dart';
import '../domain/models/patient_model.dart';
import '../domain/models/patient_note_model.dart';

class PatientsState {
  final List<PatientModel> allPatients;
  final String searchQuery;

  const PatientsState({
    required this.allPatients,
    this.searchQuery = '',
  });

  List<PatientModel> get filteredPatients {
    if (searchQuery.trim().isEmpty) return allPatients;
    final q = searchQuery.toLowerCase().trim();
    return allPatients.where((p) {
      return p.name.toLowerCase().contains(q) ||
          p.condition.toLowerCase().contains(q) ||
          p.phone.contains(q);
    }).toList();
  }

  PatientsState copyWith({
    List<PatientModel>? allPatients,
    String? searchQuery,
  }) {
    return PatientsState(
      allPatients: allPatients ?? this.allPatients,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

class PatientsNotifier extends StateNotifier<PatientsState> {
  PatientsNotifier()
      : super(
          PatientsState(allPatients: generateInitialMockPatients()),
        );

  void updateSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  void addPatient(PatientModel newPatient) {
    state = state.copyWith(
      allPatients: [newPatient, ...state.allPatients],
    );
  }

  void addNote(String patientId, PatientNote note) {
    final updatedList = state.allPatients.map((patient) {
      if (patient.id == patientId) {
        return patient.copyWith(
          notes: [note, ...patient.notes],
        );
      }
      return patient;
    }).toList();
    state = state.copyWith(allPatients: updatedList);
  }

  void editNote(String patientId, PatientNote updatedNote) {
    final updatedList = state.allPatients.map((patient) {
      if (patient.id == patientId) {
        final updatedNotes = patient.notes.map((n) {
          return n.id == updatedNote.id ? updatedNote : n;
        }).toList();
        return patient.copyWith(notes: updatedNotes);
      }
      return patient;
    }).toList();
    state = state.copyWith(allPatients: updatedList);
  }

  void deleteNote(String patientId, String noteId) {
    final updatedList = state.allPatients.map((patient) {
      if (patient.id == patientId) {
        final updatedNotes =
            patient.notes.where((n) => n.id != noteId).toList();
        return patient.copyWith(notes: updatedNotes);
      }
      return patient;
    }).toList();
    state = state.copyWith(allPatients: updatedList);
  }

  PatientModel? getPatientById(String id) {
    try {
      return state.allPatients.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }
}

final patientsNotifierProvider =
    StateNotifierProvider<PatientsNotifier, PatientsState>((ref) {
  return PatientsNotifier();
});

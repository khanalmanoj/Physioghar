import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:physioghar/core/localization/app_language_provider.dart';
import 'package:physioghar/core/theme/app_colors.dart';
import 'package:physioghar/core/widgets/empty_state_view.dart';
import '../providers/patients_provider.dart';
import 'patient_detail_screen.dart';
import 'widgets/add_patient_modal.dart';
import 'widgets/patient_card.dart';

class PatientsScreen extends ConsumerStatefulWidget {
  const PatientsScreen({super.key});

  @override
  ConsumerState<PatientsScreen> createState() => _PatientsScreenState();
}

class _PatientsScreenState extends ConsumerState<PatientsScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showAddPatientModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => AddPatientModal(
        onAddPatient: (newPatient) {
          ref.read(patientsNotifierProvider.notifier).addPatient(newPatient);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Patient ${newPatient.name} registered successfully!'),
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
    final patientsState = ref.watch(patientsNotifierProvider);
    final filtered = patientsState.filteredPatients;

    return Scaffold(
      backgroundColor: PhysioColors.cream,
      appBar: AppBar(
        title: Text(
          context.tr('nav_patients'),
          style: GoogleFonts.fraunces(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: PhysioColors.ink,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.person_add_rounded, color: PhysioColors.pine, size: 26),
            tooltip: 'Add New Patient',
            onPressed: _showAddPatientModal,
          ),
          SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              controller: _searchController,
              onChanged: (val) {
                ref.read(patientsNotifierProvider.notifier).updateSearchQuery(val);
              },
              style: GoogleFonts.inter(fontSize: 14),
              decoration: InputDecoration(
                hintText: context.tr('search_patients'),
                hintStyle: GoogleFonts.inter(fontSize: 13, color: PhysioColors.inkMute),
                prefixIcon: const Icon(Icons.search_rounded, color: PhysioColors.pine),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: Icon(Icons.clear_rounded, size: 18),
                        onPressed: () {
                          _searchController.clear();
                          ref.read(patientsNotifierProvider.notifier).updateSearchQuery('');
                        },
                      )
                    : null,
                filled: true,
                fillColor: PhysioColors.white,
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: PhysioColors.mist),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: PhysioColors.mist),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: PhysioColors.pine, width: 1.5),
                ),
              ),
            ),
          ),
          SizedBox(height: 6),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${filtered.length} PATIENTS FOUND',
                  style: GoogleFonts.ibmPlexMono(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                    color: PhysioColors.inkMute,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 8),

          Expanded(
            child: filtered.isEmpty
                ? EmptyStateView(
                    icon: Icons.person_search_rounded,
                    title: 'No Patients Found',
                    description: 'Try adjusting your search query or clear the filter.',
                    actionLabel: 'Clear Search',
                    onAction: () {
                      _searchController.clear();
                      ref.read(patientsNotifierProvider.notifier).updateSearchQuery('');
                    },
                  )
                : ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final patient = filtered[index];
                      return PatientCard(
                        patient: patient,
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => PatientDetailScreen(patientId: patient.id),
                            ),
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

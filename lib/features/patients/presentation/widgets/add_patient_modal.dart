import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:physioghar/core/theme/app_colors.dart';
import 'package:physioghar/core/widgets/physio_pill_button.dart';
import 'package:physioghar/features/patients/domain/models/patient_model.dart';

class AddPatientModal extends StatefulWidget {
  final Function(PatientModel) onAddPatient;

  const AddPatientModal({
    super.key,
    required this.onAddPatient,
  });

  @override
  State<AddPatientModal> createState() => _AddPatientModalState();
}

class _AddPatientModalState extends State<AddPatientModal> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _conditionController = TextEditingController();
  final _emergencyController = TextEditingController();

  String _gender = 'Female';

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _conditionController.dispose();
    _emergencyController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final newPatient = PatientModel(
        id: 'pat-${DateTime.now().millisecondsSinceEpoch}',
        name: _nameController.text.trim(),
        age: int.tryParse(_ageController.text.trim()) ?? 30,
        gender: _gender,
        phone: _phoneController.text.trim(),
        address: _addressController.text.trim(),
        emergencyContact: _emergencyController.text.trim().isNotEmpty
            ? _emergencyController.text.trim()
            : '${_phoneController.text.trim()} (Primary)',
        condition: _conditionController.text.trim(),
        lastSessionDate: DateTime.now(),
        totalSessionsCount: 0,
        notes: [],
      );

      widget.onAddPatient(newPatient);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: PhysioColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 28,
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: PhysioColors.mist,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Register New Patient',
                style: GoogleFonts.fraunces(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: PhysioColors.ink,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Create a clinical profile record for treatment sessions',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: PhysioColors.inkMid,
                ),
              ),
              SizedBox(height: 18),

              _buildLabel('PATIENT FULL NAME *'),
              TextFormField(
                controller: _nameController,
                style: GoogleFonts.inter(fontSize: 14),
                decoration: _inputDecoration('e.g., Anjali Sharma'),
                validator: (val) => val == null || val.trim().isEmpty ? 'Please enter full name' : null,
              ),
              SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel('AGE *'),
                        TextFormField(
                          controller: _ageController,
                          keyboardType: TextInputType.number,
                          style: GoogleFonts.inter(fontSize: 14),
                          decoration: _inputDecoration('e.g., 42'),
                          validator: (val) => val == null || val.trim().isEmpty ? 'Enter age' : null,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel('GENDER'),
                        DropdownButtonFormField<String>(
                          initialValue: _gender,
                          decoration: _inputDecoration(''),
                          items: ['Female', 'Male', 'Other'].map((g) {
                            return DropdownMenuItem(value: g, child: Text(g, style: GoogleFonts.inter(fontSize: 14)));
                          }).toList(),
                          onChanged: (val) {
                            if (val != null) setState(() => _gender = val);
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),

              _buildLabel('PHONE NUMBER *'),
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                style: GoogleFonts.inter(fontSize: 14),
                decoration: _inputDecoration('+977 98XXXXXXXX'),
                validator: (val) => val == null || val.trim().isEmpty ? 'Enter phone' : null,
              ),
              SizedBox(height: 12),

              _buildLabel('CLINICAL CONDITION / COMPLAINT *'),
              TextFormField(
                controller: _conditionController,
                style: GoogleFonts.inter(fontSize: 14),
                decoration: _inputDecoration('e.g., Cervical Radiculopathy & Shoulder Stiffness'),
                validator: (val) => val == null || val.trim().isEmpty ? 'Enter condition' : null,
              ),
              SizedBox(height: 12),

              _buildLabel('HOME / CLINICAL ADDRESS *'),
              TextFormField(
                controller: _addressController,
                style: GoogleFonts.inter(fontSize: 14),
                decoration: _inputDecoration('e.g., Jhamsikhel, Lalitpur (Ward 3)'),
                validator: (val) => val == null || val.trim().isEmpty ? 'Enter address' : null,
              ),
              SizedBox(height: 12),

              _buildLabel('EMERGENCY CONTACT (OPTIONAL)'),
              TextFormField(
                controller: _emergencyController,
                style: GoogleFonts.inter(fontSize: 14),
                decoration: _inputDecoration('+977 98XXXXXXXX (Kin)'),
              ),
              SizedBox(height: 24),

              PhysioPillButton(
                isFullWidth: true,
                label: 'Save & Register Patient',
                icon: Icons.person_add_alt_1_rounded,
                type: PhysioPillButtonType.primary,
                onPressed: _submit,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: GoogleFonts.ibmPlexMono(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: PhysioColors.inkMute,
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: GoogleFonts.inter(fontSize: 13, color: PhysioColors.inkMute),
      filled: true,
      fillColor: PhysioColors.cream,
      contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: PhysioColors.mist),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: PhysioColors.mist),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: PhysioColors.pine, width: 1.5),
      ),
    );
  }
}

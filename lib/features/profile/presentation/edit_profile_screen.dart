import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:physioghar/core/localization/app_language_provider.dart';
import 'package:physioghar/core/theme/app_colors.dart';
import 'package:physioghar/core/widgets/physio_app_bar.dart';
import 'package:physioghar/core/widgets/physio_pill_button.dart';
import '../providers/therapist_profile_provider.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _titleController;
  late TextEditingController _nmcController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  late TextEditingController _experienceController;
  late TextEditingController _specializationsController;
  late TextEditingController _addressController;
  late TextEditingController _bioController;

  @override
  void initState() {
    super.initState();
    final profile = ref.read(therapistProfileProvider);
    _nameController = TextEditingController(text: profile.name);
    _titleController = TextEditingController(text: profile.title);
    _nmcController = TextEditingController(text: profile.nmcNumber);
    _phoneController = TextEditingController(text: profile.phone);
    _emailController = TextEditingController(text: profile.email);
    _experienceController =
        TextEditingController(text: profile.yearsOfExperience.toString());
    _specializationsController =
        TextEditingController(text: profile.specializations.join(', '));
    _addressController = TextEditingController(text: profile.clinicAddress);
    _bioController = TextEditingController(text: profile.bio);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _titleController.dispose();
    _nmcController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _experienceController.dispose();
    _specializationsController.dispose();
    _addressController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  void _saveProfile() {
    if (_formKey.currentState!.validate()) {
      final specializationsList = _specializationsController.text
          .split(',')
          .map((s) => s.trim())
          .where((s) => s.isNotEmpty)
          .toList();

      ref.read(therapistProfileProvider.notifier).updateProfile(
            name: _nameController.text.trim(),
            title: _titleController.text.trim(),
            nmcNumber: _nmcController.text.trim(),
            phone: _phoneController.text.trim(),
            email: _emailController.text.trim(),
            yearsOfExperience: int.tryParse(_experienceController.text.trim()) ?? 5,
            specializations: specializationsList,
            clinicAddress: _addressController.text.trim(),
            bio: _bioController.text.trim(),
          );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profile information updated successfully!'),
          backgroundColor: PhysioColors.pine,
          behavior: SnackBarBehavior.floating,
        ),
      );
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PhysioColors.cream,
      appBar: PhysioAppBar(
        title: context.tr('edit_profile'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildField(
                label: 'FULL NAME *',
                controller: _nameController,
                hint: 'e.g. Dr. Aarav Shrestha',
                validator: (v) => v == null || v.trim().isEmpty ? 'Name cannot be empty' : null,
              ),
              SizedBox(height: 14),
              _buildField(
                label: 'PROFESSIONAL TITLE *',
                controller: _titleController,
                hint: 'e.g. Lead Consultant Physiotherapist',
                validator: (v) => v == null || v.trim().isEmpty ? 'Title required' : null,
              ),
              SizedBox(height: 14),
              _buildField(
                label: 'NMC REGISTRATION NUMBER *',
                controller: _nmcController,
                hint: 'e.g. NMC-PT-14820',
                validator: (v) => v == null || v.trim().isEmpty ? 'NMC number required' : null,
              ),
              SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: _buildField(
                      label: 'PHONE NUMBER *',
                      controller: _phoneController,
                      hint: '+977 9841...',
                      validator: (v) => v == null || v.trim().isEmpty ? 'Phone required' : null,
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: _buildField(
                      label: 'YEARS OF EXP *',
                      controller: _experienceController,
                      hint: '8',
                      keyboardType: TextInputType.number,
                      validator: (v) =>
                          v == null || int.tryParse(v.trim()) == null ? 'Valid number' : null,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 14),
              _buildField(
                label: 'EMAIL ADDRESS *',
                controller: _emailController,
                hint: 'doctor@physioghar.np',
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Email required';
                  if (!v.contains('@')) return 'Invalid email';
                  return null;
                },
              ),
              SizedBox(height: 14),
              _buildField(
                label: 'SPECIALIZATIONS (COMMA SEPARATED) *',
                controller: _specializationsController,
                hint: 'Orthopedic Rehab, Sports Injury, Spine Mobilization',
                validator: (v) =>
                    v == null || v.trim().isEmpty ? 'Please list specializations' : null,
              ),
              SizedBox(height: 14),
              _buildField(
                label: 'CLINIC / PRACTICE ADDRESS *',
                controller: _addressController,
                hint: 'Center address for clinic visits',
                validator: (v) => v == null || v.trim().isEmpty ? 'Address required' : null,
              ),
              SizedBox(height: 14),
              _buildField(
                label: 'PROFESSIONAL BIO',
                controller: _bioController,
                hint: 'Summary of clinical background, clinical philosophy, and expertise...',
                maxLines: 4,
              ),
              SizedBox(height: 28),

              PhysioPillButton(
                isFullWidth: true,
                label: context.tr('save_changes'),
                icon: Icons.check_circle_outline_rounded,
                type: PhysioPillButtonType.primary,
                onPressed: _saveProfile,
              ),
              SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildField({
    required String label,
    required TextEditingController controller,
    required String hint,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.ibmPlexMono(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: PhysioColors.inkMute,
          ),
        ),
        SizedBox(height: 6),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          style: GoogleFonts.inter(fontSize: 14, color: PhysioColors.ink),
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: PhysioColors.white,
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
          ),
          validator: validator,
        ),
      ],
    );
  }
}

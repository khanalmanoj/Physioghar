import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:physioghar/core/theme/app_colors.dart';
import 'package:physioghar/core/widgets/physio_pill_button.dart';
import 'package:physioghar/features/patients/domain/models/patient_note_model.dart';

class AddEditNoteModal extends StatefulWidget {
  final String patientId;
  final PatientNote? existingNote;
  final Function(PatientNote note) onSaveNote;

  const AddEditNoteModal({
    super.key,
    required this.patientId,
    this.existingNote,
    required this.onSaveNote,
  });

  @override
  State<AddEditNoteModal> createState() => _AddEditNoteModalState();
}

class _AddEditNoteModalState extends State<AddEditNoteModal> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  late TextEditingController _goalsController;
  final TextEditingController _exerciseInputController = TextEditingController();
  late List<String> _exercises;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.existingNote?.title ?? '');
    _contentController = TextEditingController(text: widget.existingNote?.content ?? '');
    _goalsController = TextEditingController(text: widget.existingNote?.nextGoals ?? '');
    _exercises = List.from(widget.existingNote?.exercises ?? []);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _goalsController.dispose();
    _exerciseInputController.dispose();
    super.dispose();
  }

  void _addExercise() {
    final text = _exerciseInputController.text.trim();
    if (text.isNotEmpty) {
      setState(() {
        _exercises.add(text);
        _exerciseInputController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.existingNote != null;

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
                isEditing ? 'Edit Clinical Note' : 'Add Clinical Treatment Note',
                style: GoogleFonts.fraunces(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: PhysioColors.ink,
                ),
              ),
              SizedBox(height: 16),

              Text(
                'NOTE TITLE / FOCUS *',
                style: GoogleFonts.ibmPlexMono(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: PhysioColors.inkMute,
                ),
              ),
              SizedBox(height: 6),
              TextFormField(
                controller: _titleController,
                style: GoogleFonts.inter(fontSize: 14),
                decoration: InputDecoration(
                  hintText: 'e.g., Lumbar Traction & Joint Mobilization',
                  filled: true,
                  fillColor: PhysioColors.cream,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: PhysioColors.mist),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: PhysioColors.mist),
                  ),
                ),
                validator: (val) =>
                    val == null || val.trim().isEmpty ? 'Please enter note title' : null,
              ),
              SizedBox(height: 14),

              Text(
                'CLINICAL OBSERVATIONS & PROGRESS *',
                style: GoogleFonts.ibmPlexMono(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: PhysioColors.inkMute,
                ),
              ),
              SizedBox(height: 6),
              TextFormField(
                controller: _contentController,
                maxLines: 3,
                style: GoogleFonts.inter(fontSize: 14),
                decoration: InputDecoration(
                  hintText: 'Detailed progress, range of motion tests, pain levels...',
                  filled: true,
                  fillColor: PhysioColors.cream,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: PhysioColors.mist),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: PhysioColors.mist),
                  ),
                ),
                validator: (val) =>
                    val == null || val.trim().isEmpty ? 'Please enter observations' : null,
              ),
              SizedBox(height: 14),

              Text(
                'PRESCRIBED HOME EXERCISES',
                style: GoogleFonts.ibmPlexMono(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: PhysioColors.inkMute,
                ),
              ),
              SizedBox(height: 6),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _exerciseInputController,
                      style: GoogleFonts.inter(fontSize: 13),
                      decoration: InputDecoration(
                        hintText: 'e.g., Prone knee bends (10x3)',
                        filled: true,
                        fillColor: PhysioColors.cream,
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: PhysioColors.mist),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: PhysioColors.mist),
                        ),
                      ),
                      onSubmitted: (_) => _addExercise(),
                    ),
                  ),
                  SizedBox(width: 8),
                  IconButton.filled(
                    onPressed: _addExercise,
                    icon: const Icon(Icons.add, color: Colors.white),
                    style: IconButton.styleFrom(backgroundColor: PhysioColors.pine),
                  ),
                ],
              ),
              if (_exercises.isNotEmpty) ...[
                SizedBox(height: 8),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: _exercises.map((ex) {
                    return Chip(
                      label: Text(ex, style: GoogleFonts.inter(fontSize: 12)),
                      backgroundColor: PhysioColors.mist,
                      deleteIcon: Icon(Icons.close, size: 14),
                      onDeleted: () {
                        setState(() => _exercises.remove(ex));
                      },
                    );
                  }).toList(),
                ),
              ],
              SizedBox(height: 14),

              Text(
                'NEXT SESSION GOALS',
                style: GoogleFonts.ibmPlexMono(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: PhysioColors.inkMute,
                ),
              ),
              SizedBox(height: 6),
              TextField(
                controller: _goalsController,
                style: GoogleFonts.inter(fontSize: 13),
                decoration: InputDecoration(
                  hintText: 'e.g., Assess unilateral standing balance and gait',
                  filled: true,
                  fillColor: PhysioColors.cream,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: PhysioColors.mist),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: PhysioColors.mist),
                  ),
                ),
              ),
              SizedBox(height: 24),

              PhysioPillButton(
                isFullWidth: true,
                label: isEditing ? 'Save Changes' : 'Add Note to Patient File',
                type: PhysioPillButtonType.primary,
                icon: Icons.save_rounded,
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final note = PatientNote(
                      id: widget.existingNote?.id ??
                          'note-${DateTime.now().millisecondsSinceEpoch}',
                      patientId: widget.patientId,
                      title: _titleController.text.trim(),
                      content: _contentController.text.trim(),
                      exercises: _exercises,
                      nextGoals: _goalsController.text.trim(),
                      createdAt: widget.existingNote?.createdAt ?? DateTime.now(),
                    );
                    widget.onSaveNote(note);
                    Navigator.of(context).pop();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

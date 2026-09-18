import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:physioghar/core/theme/app_colors.dart';
import 'package:physioghar/core/widgets/physio_pill_button.dart';
import 'package:physioghar/features/sessions/domain/models/session_model.dart';

class CompleteSessionDialog extends StatefulWidget {
  final SessionModel session;
  final Function({
    required String remarks,
    required List<String> exercises,
    String? nextGoals,
  }) onComplete;

  const CompleteSessionDialog({
    super.key,
    required this.session,
    required this.onComplete,
  });

  @override
  State<CompleteSessionDialog> createState() => _CompleteSessionDialogState();
}

class _CompleteSessionDialogState extends State<CompleteSessionDialog> {
  final _formKey = GlobalKey<FormState>();
  final _remarksController = TextEditingController();
  final _exerciseController = TextEditingController();
  final _goalsController = TextEditingController();
  final List<String> _exercises = [];

  @override
  void initState() {
    super.initState();
    _remarksController.text =
        'Patient reported positive pain alleviation. Good compliance with joint mobilization techniques.';
  }

  @override
  void dispose() {
    _remarksController.dispose();
    _exerciseController.dispose();
    _goalsController.dispose();
    super.dispose();
  }

  void _addExercise() {
    final text = _exerciseController.text.trim();
    if (text.isNotEmpty) {
      setState(() {
        _exercises.add(text);
        _exerciseController.clear();
      });
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Complete Session',
                    style: GoogleFonts.fraunces(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: PhysioColors.ink,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: PhysioColors.pinePale,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      'CLINICAL NOTES',
                      style: GoogleFonts.ibmPlexMono(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: PhysioColors.pine,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 4),
              Text(
                'Patient: ${widget.session.patientName} (${widget.session.condition})',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: PhysioColors.inkMid,
                ),
              ),
              SizedBox(height: 20),

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
                controller: _remarksController,
                maxLines: 3,
                style: GoogleFonts.inter(fontSize: 14, color: PhysioColors.ink),
                decoration: InputDecoration(
                  hintText: 'e.g., Reported 40% reduction in lumbar stiffness...',
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
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter clinical observation remarks';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

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
                      controller: _exerciseController,
                      style: GoogleFonts.inter(fontSize: 13),
                      decoration: InputDecoration(
                        hintText: 'e.g., Cat-cow stretches (10 reps x 3 sets)',
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
                        setState(() {
                          _exercises.remove(ex);
                        });
                      },
                    );
                  }).toList(),
                ),
              ],
              SizedBox(height: 16),

              Text(
                'NEXT SESSION GOALS / INSTRUCTIONS',
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
                  hintText: 'e.g., Re-test lumbar extension range of motion',
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
              ),
              SizedBox(height: 24),

              PhysioPillButton(
                isFullWidth: true,
                label: 'Save & Mark Session Completed',
                icon: Icons.check_circle_rounded,
                type: PhysioPillButtonType.primary,
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    widget.onComplete(
                      remarks: _remarksController.text.trim(),
                      exercises: _exercises.isEmpty
                          ? [
                              'Prescribed therapeutic home movements',
                              'Gentle mobility & posture maintenance',
                            ]
                          : _exercises,
                      nextGoals: _goalsController.text.trim().isNotEmpty
                          ? _goalsController.text.trim()
                          : 'Progressive range expansion & functional strengthening.',
                    );
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

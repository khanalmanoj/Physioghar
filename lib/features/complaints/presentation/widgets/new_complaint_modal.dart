import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:physioghar/core/theme/app_colors.dart';
import 'package:physioghar/core/widgets/physio_pill_button.dart';
import 'package:physioghar/features/complaints/domain/models/complaint_model.dart';

class NewComplaintModal extends StatefulWidget {
  final Function({
    required ComplaintCategory category,
    required ComplaintPriority priority,
    required String subject,
    required String description,
  }) onSubmit;

  const NewComplaintModal({
    super.key,
    required this.onSubmit,
  });

  @override
  State<NewComplaintModal> createState() => _NewComplaintModalState();
}

class _NewComplaintModalState extends State<NewComplaintModal> {
  final _formKey = GlobalKey<FormState>();
  ComplaintCategory _category = ComplaintCategory.bookingIssue;
  ComplaintPriority _priority = ComplaintPriority.medium;
  final _subjectController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void dispose() {
    _subjectController.dispose();
    _descriptionController.dispose();
    super.dispose();
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
                'Report an Issue',
                style: GoogleFonts.fraunces(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: PhysioColors.ink,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Submit an issue or clinical dispute to PhysioGhar operations support.',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: PhysioColors.inkMid,
                ),
              ),
              SizedBox(height: 20),

              Text(
                'ISSUE CATEGORY *',
                style: GoogleFonts.ibmPlexMono(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: PhysioColors.inkMute,
                ),
              ),
              SizedBox(height: 6),
              DropdownButtonFormField<ComplaintCategory>(
                initialValue: _category,
                decoration: InputDecoration(
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
                ),
                items: ComplaintCategory.values.map((cat) {
                  String label = 'Other';
                  switch (cat) {
                    case ComplaintCategory.patientIssue:
                      label = 'Patient / Clinical Conduct Issue';
                      break;
                    case ComplaintCategory.bookingIssue:
                      label = 'Booking / Scheduling Dispute';
                      break;
                    case ComplaintCategory.paymentIssue:
                      label = 'Payment / Payout Settlement Delay';
                      break;
                    case ComplaintCategory.technicalIssue:
                      label = 'App Technical Bug';
                      break;
                    case ComplaintCategory.other:
                      label = 'Other';
                      break;
                  }
                  return DropdownMenuItem(
                    value: cat,
                    child: Text(label, style: GoogleFonts.inter(fontSize: 13)),
                  );
                }).toList(),
                onChanged: (val) {
                  if (val != null) setState(() => _category = val);
                },
              ),
              SizedBox(height: 14),

              Text(
                'PRIORITY *',
                style: GoogleFonts.ibmPlexMono(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: PhysioColors.inkMute,
                ),
              ),
              SizedBox(height: 6),
              Row(
                children: ComplaintPriority.values.map((p) {
                  final isSelected = _priority == p;
                  return Padding(
                    padding: EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(
                        p.name.toUpperCase(),
                        style: GoogleFonts.ibmPlexMono(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: isSelected ? Colors.white : PhysioColors.inkMid,
                        ),
                      ),
                      selected: isSelected,
                      selectedColor: PhysioColors.pine,
                      backgroundColor: PhysioColors.cream,
                      onSelected: (val) {
                        if (val) setState(() => _priority = p);
                      },
                    ),
                  );
                }).toList(),
              ),
              SizedBox(height: 14),

              Text(
                'SUBJECT *',
                style: GoogleFonts.ibmPlexMono(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: PhysioColors.inkMute,
                ),
              ),
              SizedBox(height: 6),
              TextFormField(
                controller: _subjectController,
                style: GoogleFonts.inter(fontSize: 14),
                decoration: InputDecoration(
                  hintText: 'Brief summary of the issue',
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
                ),
                validator: (v) =>
                    v == null || v.trim().isEmpty ? 'Please enter subject' : null,
              ),
              SizedBox(height: 14),

              Text(
                'DETAILED DESCRIPTION *',
                style: GoogleFonts.ibmPlexMono(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: PhysioColors.inkMute,
                ),
              ),
              SizedBox(height: 6),
              TextFormField(
                controller: _descriptionController,
                maxLines: 4,
                style: GoogleFonts.inter(fontSize: 14),
                decoration: InputDecoration(
                  hintText: 'Describe the issue, involved booking ID, dates, and details...',
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
                validator: (v) =>
                    v == null || v.trim().isEmpty ? 'Please describe the problem' : null,
              ),
              SizedBox(height: 24),

              PhysioPillButton(
                isFullWidth: true,
                label: 'Submit Ticket',
                type: PhysioPillButtonType.primary,
                icon: Icons.send_rounded,
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    widget.onSubmit(
                      category: _category,
                      priority: _priority,
                      subject: _subjectController.text.trim(),
                      description: _descriptionController.text.trim(),
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

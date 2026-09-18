import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:physioghar/core/theme/app_colors.dart';
import 'package:physioghar/core/utils/date_time_utils.dart';
import 'package:physioghar/core/widgets/physio_pill_button.dart';
import 'package:physioghar/features/sessions/domain/models/session_model.dart';

class RescheduleDialog extends StatefulWidget {
  final SessionModel session;
  final Function(DateTime newDate, String newTimeSlot) onReschedule;

  const RescheduleDialog({
    super.key,
    required this.session,
    required this.onReschedule,
  });

  @override
  State<RescheduleDialog> createState() => _RescheduleDialogState();
}

class _RescheduleDialogState extends State<RescheduleDialog> {
  late DateTime _selectedDate;
  String _selectedSlot = '10:00 AM - 11:00 AM';

  final List<String> _availableSlots = [
    '08:30 AM - 09:30 AM',
    '10:00 AM - 11:00 AM',
    '11:30 AM - 12:30 PM',
    '02:00 PM - 03:00 PM',
    '03:30 PM - 04:30 PM',
    '05:00 PM - 06:00 PM',
  ];

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.session.dateTime.add(const Duration(days: 1));
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: PhysioColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.fromLTRB(20, 16, 20, 28),
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
            'Reschedule Appointment',
            style: GoogleFonts.fraunces(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: PhysioColors.ink,
            ),
          ),
          SizedBox(height: 4),
          Text(
            'Patient: ${widget.session.patientName}',
            style: GoogleFonts.inter(
              fontSize: 13,
              color: PhysioColors.inkMid,
            ),
          ),
          SizedBox(height: 20),

          Text(
            'SELECT NEW DATE',
            style: GoogleFonts.ibmPlexMono(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: PhysioColors.inkMute,
            ),
          ),
          SizedBox(height: 6),
          InkWell(
            onTap: _pickDate,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: PhysioColors.cream,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: PhysioColors.mist),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    DateTimeUtils.formatFullDate(_selectedDate),
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: PhysioColors.ink,
                    ),
                  ),
                  Icon(Icons.calendar_month_rounded,
                      size: 20, color: PhysioColors.pine),
                ],
              ),
            ),
          ),
          SizedBox(height: 18),

          Text(
            'AVAILABLE TIME SLOTS',
            style: GoogleFonts.ibmPlexMono(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: PhysioColors.inkMute,
            ),
          ),
          SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _availableSlots.map((slot) {
              final isSelected = _selectedSlot == slot;
              return ChoiceChip(
                label: Text(
                  slot,
                  style: GoogleFonts.ibmPlexMono(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isSelected ? Colors.white : PhysioColors.ink,
                  ),
                ),
                selected: isSelected,
                selectedColor: PhysioColors.pine,
                backgroundColor: PhysioColors.cream,
                onSelected: (val) {
                  if (val) setState(() => _selectedSlot = slot);
                },
              );
            }).toList(),
          ),
          SizedBox(height: 24),

          PhysioPillButton(
            isFullWidth: true,
            label: 'Confirm Reschedule',
            icon: Icons.update_rounded,
            type: PhysioPillButtonType.primary,
            onPressed: () {
              widget.onReschedule(_selectedDate, _selectedSlot);
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    ),
    );
  }
}

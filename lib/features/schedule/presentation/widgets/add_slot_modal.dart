import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:physioghar/core/theme/app_colors.dart';
import 'package:physioghar/core/utils/date_time_utils.dart';
import 'package:physioghar/core/widgets/physio_pill_button.dart';
import 'package:physioghar/features/schedule/domain/models/time_slot_model.dart';

class AddSlotModal extends StatefulWidget {
  final DateTime selectedDate;
  final Function({
    required DateTime date,
    required String startTime,
    required String endTime,
    VisitType? defaultVisitType,
  }) onAddSlot;

  const AddSlotModal({
    super.key,
    required this.selectedDate,
    required this.onAddSlot,
  });

  @override
  State<AddSlotModal> createState() => _AddSlotModalState();
}

class _AddSlotModalState extends State<AddSlotModal> {
  TimeOfDay _startTime = const TimeOfDay(hour: 9, minute: 0);
  TimeOfDay _endTime = const TimeOfDay(hour: 10, minute: 0);
  VisitType _visitType = VisitType.homeVisit;

  String _formatTime(TimeOfDay time) {
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '${hour.toString().padLeft(2, '0')}:$minute $period';
  }

  Future<void> _pickStartTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _startTime,
    );
    if (picked != null) {
      setState(() {
        _startTime = picked;
        _endTime = TimeOfDay(
          hour: (picked.hour + 1) % 24,
          minute: picked.minute,
        );
      });
    }
  }

  Future<void> _pickEndTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _endTime,
    );
    if (picked != null) {
      setState(() {
        _endTime = picked;
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
            'Add Availability Slot',
            style: GoogleFonts.fraunces(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: PhysioColors.ink,
            ),
          ),
          SizedBox(height: 4),
          Text(
            'Date: ${DateTimeUtils.formatFullDate(widget.selectedDate)}',
            style: GoogleFonts.inter(
              fontSize: 13,
              color: PhysioColors.inkMid,
            ),
          ),
          SizedBox(height: 20),

          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'START TIME',
                      style: GoogleFonts.ibmPlexMono(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: PhysioColors.inkMute,
                      ),
                    ),
                    SizedBox(height: 6),
                    InkWell(
                      onTap: _pickStartTime,
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
                              _formatTime(_startTime),
                              style: GoogleFonts.ibmPlexMono(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: PhysioColors.ink,
                              ),
                            ),
                            Icon(Icons.access_time_rounded,
                                size: 18, color: PhysioColors.pine),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'END TIME',
                      style: GoogleFonts.ibmPlexMono(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: PhysioColors.inkMute,
                      ),
                    ),
                    SizedBox(height: 6),
                    InkWell(
                      onTap: _pickEndTime,
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
                              _formatTime(_endTime),
                              style: GoogleFonts.ibmPlexMono(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: PhysioColors.ink,
                              ),
                            ),
                            Icon(Icons.access_time_rounded,
                                size: 18, color: PhysioColors.pine),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 18),

          Text(
            'VISIT TYPE PREFERENCE',
            style: GoogleFonts.ibmPlexMono(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: PhysioColors.inkMute,
            ),
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: ChoiceChip(
                  label: Text('Home Visit',
                      style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w500)),
                  selected: _visitType == VisitType.homeVisit,
                  selectedColor: PhysioColors.pinePale,
                  backgroundColor: PhysioColors.cream,
                  onSelected: (selected) {
                    if (selected) setState(() => _visitType = VisitType.homeVisit);
                  },
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: ChoiceChip(
                  label: Text('Clinic Visit',
                      style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w500)),
                  selected: _visitType == VisitType.clinic,
                  selectedColor: PhysioColors.pinePale,
                  backgroundColor: PhysioColors.cream,
                  onSelected: (selected) {
                    if (selected) setState(() => _visitType = VisitType.clinic);
                  },
                ),
              ),
            ],
          ),
          SizedBox(height: 26),

          PhysioPillButton(
            isFullWidth: true,
            label: 'Add Open Slot',
            icon: Icons.add_circle_outline_rounded,
            type: PhysioPillButtonType.primary,
            onPressed: () {
              widget.onAddSlot(
                date: widget.selectedDate,
                startTime: _formatTime(_startTime),
                endTime: _formatTime(_endTime),
                defaultVisitType: _visitType,
              );
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:physioghar/core/theme/app_colors.dart';
import 'package:physioghar/core/utils/date_time_utils.dart';
import 'package:physioghar/features/schedule/domain/models/time_slot_model.dart';

class WeekDaySelector extends StatelessWidget {
  final DateTime selectedDate;
  final Function(DateTime) onSelectDate;
  final List<TimeSlot> allSlots;

  const WeekDaySelector({
    super.key,
    required this.selectedDate,
    required this.onSelectDate,
    required this.allSlots,
  });

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final weekDates = DateTimeUtils.getWeekDates(selectedDate);

    return Container(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: weekDates.map((date) {
          final isSelected = DateTimeUtils.isSameDay(date, selectedDate);
          final isToday = DateTimeUtils.isSameDay(date, today);

          final daySlots = allSlots.where(
            (slot) => DateTimeUtils.isSameDay(slot.date, date),
          );
          final hasOpen = daySlots.any((s) => s.status == SlotStatus.open);
          final hasBooked = daySlots.any((s) => s.status == SlotStatus.booked);

          return Expanded(
            child: GestureDetector(
              onTap: () => onSelectDate(date),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                margin: EdgeInsets.symmetric(horizontal: 2),
                padding: EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected
                      ? PhysioColors.pine
                      : isToday
                          ? PhysioColors.pinePale.withValues(alpha: 0.5)
                          : PhysioColors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: isSelected
                        ? PhysioColors.pine
                        : isToday
                            ? PhysioColors.pine.withValues(alpha: 0.4)
                            : PhysioColors.mist,
                    width: 1.2,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: PhysioColors.pine.withValues(alpha: 0.25),
                            blurRadius: 8,
                            offset: Offset(0, 3),
                          ),
                        ]
                      : null,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      DateTimeUtils.formatDayOfWeek(date).toUpperCase(),
                      style: GoogleFonts.ibmPlexMono(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: isSelected
                            ? Colors.white.withValues(alpha: 0.85)
                            : PhysioColors.inkMute,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      DateTimeUtils.formatDayNumber(date),
                      style: GoogleFonts.fraunces(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: isSelected ? Colors.white : PhysioColors.ink,
                      ),
                    ),
                    SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (hasOpen)
                          Container(
                            width: 5,
                            height: 5,
                            margin: EdgeInsets.symmetric(horizontal: 1.5),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isSelected ? Colors.white : PhysioColors.pine,
                            ),
                          ),
                        if (hasBooked)
                          Container(
                            width: 5,
                            height: 5,
                            margin: EdgeInsets.symmetric(horizontal: 1.5),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isSelected ? PhysioColors.amberPale : PhysioColors.amber,
                            ),
                          ),
                        if (!hasOpen && !hasBooked)
                          SizedBox(height: 5),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

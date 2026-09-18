import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:physioghar/core/localization/app_language_provider.dart';
import 'package:physioghar/core/theme/app_colors.dart';
import 'package:physioghar/core/utils/date_time_utils.dart';
import 'package:physioghar/core/widgets/empty_state_view.dart';
import 'package:physioghar/features/patients/presentation/patient_detail_screen.dart';
import 'package:physioghar/features/patients/providers/patients_provider.dart';
import 'package:physioghar/features/sessions/presentation/session_detail_screen.dart';
import 'package:physioghar/features/sessions/providers/sessions_provider.dart';
import '../domain/models/time_slot_model.dart';
import '../providers/schedule_provider.dart';
import 'widgets/add_slot_modal.dart';
import 'widgets/slot_action_bottom_sheet.dart';
import 'widgets/slot_card.dart';
import 'widgets/week_day_selector.dart';

class ScheduleScreen extends ConsumerStatefulWidget {
  const ScheduleScreen({super.key});

  @override
  ConsumerState<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends ConsumerState<ScheduleScreen> {
  SlotStatus? _selectedFilter;

  void _showAddSlotModal(BuildContext context, DateTime selectedDate) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => AddSlotModal(
        selectedDate: selectedDate,
        onAddSlot: ({
          required DateTime date,
          required String startTime,
          required String endTime,
          VisitType? defaultVisitType,
        }) {
          ref.read(scheduleNotifierProvider.notifier).addSlot(
                date: date,
                startTime: startTime,
                endTime: endTime,
                defaultVisitType: defaultVisitType,
              );
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Added new open slot ($startTime - $endTime)'),
              backgroundColor: PhysioColors.pine,
              behavior: SnackBarBehavior.floating,
            ),
          );
        },
      ),
    );
  }

  void _showSlotActionSheet(BuildContext context, TimeSlot slot) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => SlotActionBottomSheet(
        slot: slot,
        onBlock: () {
          ref.read(scheduleNotifierProvider.notifier).blockSlot(slot.id);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Slot marked as Blocked'),
              backgroundColor: PhysioColors.danger,
              behavior: SnackBarBehavior.floating,
            ),
          );
        },
        onUnblock: () {
          ref.read(scheduleNotifierProvider.notifier).unblockSlot(slot.id);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Slot is now Available for bookings'),
              backgroundColor: PhysioColors.pine,
              behavior: SnackBarBehavior.floating,
            ),
          );
        },
        onRemove: () {
          ref.read(scheduleNotifierProvider.notifier).removeSlot(slot.id);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Slot removed'),
              behavior: SnackBarBehavior.floating,
            ),
          );
        },
        onViewDetails: () {
          final allSessions = ref.read(sessionsNotifierProvider);
          final match = allSessions.where((s) => s.patientName == slot.patientName).firstOrNull;
          if (match != null) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => SessionDetailScreen(sessionId: match.id),
              ),
            );
          } else {
            final allPatients = ref.read(patientsNotifierProvider).allPatients;
            final patMatch = allPatients.where((p) => p.name == slot.patientName).firstOrNull;
            if (patMatch != null) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => PatientDetailScreen(patientId: patMatch.id),
                ),
              );
            }
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheduleState = ref.watch(scheduleNotifierProvider);
    final allSelectedSlots = scheduleState.slotsForSelectedDate;
    final selectedDate = scheduleState.selectedDate;

    final openCount = allSelectedSlots.where((s) => s.status == SlotStatus.open).length;
    final bookedCount = allSelectedSlots.where((s) => s.status == SlotStatus.booked).length;
    final blockedCount = allSelectedSlots.where((s) => s.status == SlotStatus.blocked).length;

    final filteredSlots = _selectedFilter == null
        ? allSelectedSlots
        : allSelectedSlots.where((s) => s.status == _selectedFilter).toList();

    return Scaffold(
      backgroundColor: PhysioColors.cream,
      appBar: AppBar(
        title: Text(
          context.tr('nav_schedule'),
          style: GoogleFonts.fraunces(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: PhysioColors.ink,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.add_circle_rounded, color: PhysioColors.pine, size: 28),
            tooltip: context.tr('add_custom_slot'),
            onPressed: () => _showAddSlotModal(context, selectedDate),
          ),
          SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.chevron_left_rounded, size: 24, color: PhysioColors.ink),
                      tooltip: 'Previous Week',
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      onPressed: () {
                        ref.read(scheduleNotifierProvider.notifier).selectDate(
                              selectedDate.subtract(const Duration(days: 7)),
                            );
                      },
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: InkWell(
                        onTap: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: selectedDate,
                            firstDate: DateTime.now().subtract(const Duration(days: 90)),
                            lastDate: DateTime.now().add(const Duration(days: 90)),
                          );
                          if (picked != null) {
                            ref.read(scheduleNotifierProvider.notifier).selectDate(picked);
                          }
                        },
                        borderRadius: BorderRadius.circular(8),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Flexible(
                                child: Text(
                                  DateTimeUtils.formatMonthYear(selectedDate),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.fraunces(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: PhysioColors.ink,
                                  ),
                                ),
                              ),
                              SizedBox(width: 6),
                              Icon(Icons.calendar_month_rounded, size: 16, color: PhysioColors.pine),
                            ],
                          ),
                        ),
                      ),
                    ),
                    if (!DateTimeUtils.isSameDay(selectedDate, DateTime.now())) ...[
                      TextButton(
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        onPressed: () {
                          ref.read(scheduleNotifierProvider.notifier).selectDate(DateTime.now());
                        },
                        child: Text(
                          'Today',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: PhysioColors.pine,
                          ),
                        ),
                      ),
                      SizedBox(width: 6),
                    ],
                    IconButton(
                      icon: Icon(Icons.chevron_right_rounded, size: 24, color: PhysioColors.ink),
                      tooltip: 'Next Week',
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      onPressed: () {
                        ref.read(scheduleNotifierProvider.notifier).selectDate(
                              selectedDate.add(const Duration(days: 7)),
                            );
                      },
                    ),
                  ],
                ),
                SizedBox(height: 6),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        DateTimeUtils.formatFullDate(selectedDate),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: PhysioColors.inkMute,
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(
                      '${allSelectedSlots.length} Slots',
                      style: GoogleFonts.ibmPlexMono(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: PhysioColors.pine,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),

                WeekDaySelector(
                  selectedDate: selectedDate,
                  allSlots: scheduleState.allSlots,
                  onSelectDate: (date) {
                    ref.read(scheduleNotifierProvider.notifier).selectDate(date);
                  },
                ),
                SizedBox(height: 10),

                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildInteractiveFilterChip(
                        label: 'All',
                        count: allSelectedSlots.length,
                        isSelected: _selectedFilter == null,
                        color: PhysioColors.ink,
                        bgColor: PhysioColors.mist,
                        onTap: () => setState(() => _selectedFilter = null),
                      ),
                      SizedBox(width: 8),
                      _buildInteractiveFilterChip(
                        label: 'Open',
                        count: openCount,
                        isSelected: _selectedFilter == SlotStatus.open,
                        color: PhysioColors.pine,
                        bgColor: PhysioColors.pinePale.withValues(alpha: 0.5),
                        onTap: () => setState(() =>
                            _selectedFilter = _selectedFilter == SlotStatus.open ? null : SlotStatus.open),
                      ),
                      SizedBox(width: 8),
                      _buildInteractiveFilterChip(
                        label: 'Booked',
                        count: bookedCount,
                        isSelected: _selectedFilter == SlotStatus.booked,
                        color: const Color(0xFFB87114),
                        bgColor: PhysioColors.amberPale.withValues(alpha: 0.5),
                        onTap: () => setState(() =>
                            _selectedFilter = _selectedFilter == SlotStatus.booked ? null : SlotStatus.booked),
                      ),
                      SizedBox(width: 8),
                      _buildInteractiveFilterChip(
                        label: 'Blocked',
                        count: blockedCount,
                        isSelected: _selectedFilter == SlotStatus.blocked,
                        color: PhysioColors.danger,
                        bgColor: PhysioColors.dangerPale.withValues(alpha: 0.5),
                        onTap: () => setState(() =>
                            _selectedFilter = _selectedFilter == SlotStatus.blocked ? null : SlotStatus.blocked),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10),
          const Divider(color: PhysioColors.mist, height: 1),

          Expanded(
            child: filteredSlots.isEmpty
                ? EmptyStateView(
                    icon: Icons.calendar_today_outlined,
                    title: _selectedFilter != null ? 'No Matching Slots' : 'No Slots for this Day',
                    description: _selectedFilter != null
                        ? 'There are no ${_selectedFilter!.name} slots scheduled.'
                        : 'You currently have no scheduled slots for ${DateTimeUtils.formatShortDate(selectedDate)}.',
                    actionLabel: '+ Add Custom Slot',
                    onAction: () => _showAddSlotModal(context, selectedDate),
                  )
                : ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    itemCount: filteredSlots.length,
                    itemBuilder: (context, index) {
                      final slot = filteredSlots[index];
                      return SlotCard(
                        slot: slot,
                        onTap: () => _showSlotActionSheet(context, slot),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildInteractiveFilterChip({
    required String label,
    required int count,
    required bool isSelected,
    required Color color,
    required Color bgColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? color : bgColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? color : color.withValues(alpha: 0.3),
            width: 1.2,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '$count',
              style: GoogleFonts.ibmPlexMono(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: isSelected ? Colors.white : color,
              ),
            ),
            SizedBox(width: 5),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

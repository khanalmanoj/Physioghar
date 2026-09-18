import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:physioghar/core/utils/date_time_utils.dart';
import 'package:physioghar/features/schedule/data/mock_schedule_data.dart';
import 'package:physioghar/features/schedule/domain/models/time_slot_model.dart';

class ScheduleState {
  final DateTime selectedDate;
  final List<TimeSlot> allSlots;

  const ScheduleState({
    required this.selectedDate,
    required this.allSlots,
  });

  List<TimeSlot> get slotsForSelectedDate {
    return allSlots
        .where((slot) => DateTimeUtils.isSameDay(slot.date, selectedDate))
        .toList()
      ..sort((a, b) => a.startTime.compareTo(b.startTime));
  }

  ScheduleState copyWith({
    DateTime? selectedDate,
    List<TimeSlot>? allSlots,
  }) {
    return ScheduleState(
      selectedDate: selectedDate ?? this.selectedDate,
      allSlots: allSlots ?? this.allSlots,
    );
  }
}

class ScheduleNotifier extends StateNotifier<ScheduleState> {
  ScheduleNotifier()
      : super(
          ScheduleState(
            selectedDate: DateTime(
              DateTime.now().year,
              DateTime.now().month,
              DateTime.now().day,
            ),
            allSlots: generateInitialMockSlots(),
          ),
        );

  void selectDate(DateTime date) {
    state = state.copyWith(
      selectedDate: DateTime(date.year, date.month, date.day),
    );
  }

  void blockSlot(String slotId) {
    final updated = state.allSlots.map((slot) {
      if (slot.id == slotId) {
        return slot.copyWith(status: SlotStatus.blocked);
      }
      return slot;
    }).toList();
    state = state.copyWith(allSlots: updated);
  }

  void unblockSlot(String slotId) {
    final updated = state.allSlots.map((slot) {
      if (slot.id == slotId) {
        return slot.copyWith(status: SlotStatus.open);
      }
      return slot;
    }).toList();
    state = state.copyWith(allSlots: updated);
  }

  void removeSlot(String slotId) {
    final updated = state.allSlots.where((slot) => slot.id != slotId).toList();
    state = state.copyWith(allSlots: updated);
  }

  void addSlot({
    required DateTime date,
    required String startTime,
    required String endTime,
    VisitType? defaultVisitType,
  }) {
    final newSlot = TimeSlot(
      id: 'slot-${DateTime.now().millisecondsSinceEpoch}',
      date: DateTime(date.year, date.month, date.day),
      startTime: startTime,
      endTime: endTime,
      status: SlotStatus.open,
      visitType: defaultVisitType,
    );
    state = state.copyWith(allSlots: [...state.allSlots, newSlot]);
  }
}

final scheduleNotifierProvider =
    StateNotifierProvider<ScheduleNotifier, ScheduleState>((ref) {
  return ScheduleNotifier();
});

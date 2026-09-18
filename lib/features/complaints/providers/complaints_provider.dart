import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/models/complaint_model.dart';

class ComplaintsNotifier extends StateNotifier<List<ComplaintModel>> {
  ComplaintsNotifier()
      : super([
          ComplaintModel(
            id: 'ticket-101',
            category: ComplaintCategory.paymentIssue,
            priority: ComplaintPriority.medium,
            subject: 'Esewa payout settlement delay',
            description:
                'Session payout for patient Anita KC completed on Sunday has not reflected in linked bank account yet.',
            status: ComplaintStatus.underReview,
            createdAt: DateTime.now().subtract(const Duration(days: 2)),
          ),
        ]);

  void submitComplaint({
    required ComplaintCategory category,
    required ComplaintPriority priority,
    required String subject,
    required String description,
  }) {
    final newTicket = ComplaintModel(
      id: 'ticket-${DateTime.now().millisecondsSinceEpoch % 10000}',
      category: category,
      priority: priority,
      subject: subject,
      description: description,
      status: ComplaintStatus.submitted,
      createdAt: DateTime.now(),
    );
    state = [newTicket, ...state];
  }
}

final complaintsNotifierProvider =
    StateNotifierProvider<ComplaintsNotifier, List<ComplaintModel>>((ref) {
  return ComplaintsNotifier();
});

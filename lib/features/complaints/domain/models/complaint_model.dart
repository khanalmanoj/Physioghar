enum ComplaintCategory {
  patientIssue,
  bookingIssue,
  paymentIssue,
  technicalIssue,
  other,
}

enum ComplaintPriority {
  low,
  medium,
  high,
  urgent,
}

enum ComplaintStatus {
  submitted,
  underReview,
  resolved,
}

class ComplaintModel {
  final String id;
  final ComplaintCategory category;
  final ComplaintPriority priority;
  final String subject;
  final String description;
  final ComplaintStatus status;
  final DateTime createdAt;

  const ComplaintModel({
    required this.id,
    required this.category,
    required this.priority,
    required this.subject,
    required this.description,
    required this.status,
    required this.createdAt,
  });

  String get categoryLabel {
    switch (category) {
      case ComplaintCategory.patientIssue:
        return 'Patient Issue';
      case ComplaintCategory.bookingIssue:
        return 'Booking Issue';
      case ComplaintCategory.paymentIssue:
        return 'Payment Issue';
      case ComplaintCategory.technicalIssue:
        return 'Technical Issue';
      case ComplaintCategory.other:
        return 'Other';
    }
  }

  String get priorityLabel {
    switch (priority) {
      case ComplaintPriority.low:
        return 'Low';
      case ComplaintPriority.medium:
        return 'Medium';
      case ComplaintPriority.high:
        return 'High';
      case ComplaintPriority.urgent:
        return 'Urgent';
    }
  }

  String get statusLabel {
    switch (status) {
      case ComplaintStatus.submitted:
        return 'Submitted';
      case ComplaintStatus.underReview:
        return 'Under Review';
      case ComplaintStatus.resolved:
        return 'Resolved';
    }
  }
}

import 'package:physioghar/features/schedule/domain/models/time_slot_model.dart';
import 'package:physioghar/features/sessions/domain/models/session_model.dart';

List<SessionModel> generateInitialMockSessions() {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final tomorrow = today.add(const Duration(days: 1));
  final yesterday = today.subtract(const Duration(days: 1));

  return [
    // Requests
    SessionModel(
      id: 'sess-req-1',
      patientId: 'pat-1',
      patientName: 'Sunita Rai',
      patientAge: 42,
      patientGender: 'Female',
      patientPhone: '+977 9841234567',
      address: 'Baluwatar, Kathmandu (Near Russian Embassy)',
      visitType: VisitType.homeVisit,
      condition: 'Acute Neck Strain & Upper Trapezius Spasm',
      dateTime: today.add(const Duration(hours: 15)),
      timeSlot: '03:00 PM - 04:00 PM',
      fee: 1500.0,
      status: SessionStatus.request,
    ),
    SessionModel(
      id: 'sess-req-2',
      patientId: 'pat-2',
      patientName: 'Binod Khadka',
      patientAge: 58,
      patientGender: 'Male',
      patientPhone: '+977 9812345678',
      address: 'PhysioGhar Clinic, Jhamsikhel, Lalitpur',
      visitType: VisitType.clinic,
      condition: 'Bilateral Knee Osteoarthritis Stage II',
      dateTime: tomorrow.add(const Duration(hours: 11)),
      timeSlot: '11:00 AM - 12:00 PM',
      fee: 1200.0,
      status: SessionStatus.request,
    ),

    // Upcoming (Today and Tomorrow)
    SessionModel(
      id: 'sess-up-1',
      patientId: 'pat-3',
      patientName: 'Sita Sharma',
      patientAge: 35,
      patientGender: 'Female',
      patientPhone: '+977 9851098765',
      address: 'Sanepa-2, Lalitpur (House 42)',
      visitType: VisitType.homeVisit,
      condition: 'Lower Back Rehabilitation (L4-L5 Disc Bulge)',
      dateTime: today.add(const Duration(hours: 8, minutes: 30)),
      timeSlot: '08:30 AM - 09:30 AM',
      fee: 1500.0,
      status: SessionStatus.upcoming,
    ),
    SessionModel(
      id: 'sess-up-2',
      patientId: 'pat-4',
      patientName: 'Ramesh Thapa',
      patientAge: 62,
      patientGender: 'Male',
      patientPhone: '+977 9860123987',
      address: 'PhysioGhar Clinic, Jhamsikhel',
      visitType: VisitType.clinic,
      condition: 'Post-Surgery ACL & Meniscus Rehabilitation',
      dateTime: today.add(const Duration(hours: 11, minutes: 30)),
      timeSlot: '11:30 AM - 12:30 PM',
      fee: 1200.0,
      status: SessionStatus.upcoming,
    ),
    SessionModel(
      id: 'sess-up-3',
      patientId: 'pat-5',
      patientName: 'Bikash Adhikari',
      patientAge: 29,
      patientGender: 'Male',
      patientPhone: '+977 9803456712',
      address: 'Baneshwor, Kathmandu (Near Eyeplex Mall)',
      visitType: VisitType.homeVisit,
      condition: 'Frozen Shoulder (Adhesive Capsulitis)',
      dateTime: tomorrow.add(const Duration(hours: 10, minutes: 30)),
      timeSlot: '10:30 AM - 11:30 AM',
      fee: 1500.0,
      status: SessionStatus.upcoming,
    ),

    // Completed
    SessionModel(
      id: 'sess-comp-1',
      patientId: 'pat-6',
      patientName: 'Maya Gurung',
      patientAge: 48,
      patientGender: 'Female',
      patientPhone: '+977 9849876543',
      address: 'Maharajgunj, Kathmandu',
      visitType: VisitType.homeVisit,
      condition: 'Cervical Spondylosis & Radiating Arm Pain',
      dateTime: yesterday.add(const Duration(hours: 14)),
      timeSlot: '02:00 PM - 03:00 PM',
      fee: 1500.0,
      status: SessionStatus.completed,
      clinicalRemarks:
          'Patient experienced 40% reduction in cervical stiffness after isometric traction and deep tissue release. Range of motion rotation improved to 65 degrees without dizziness.',
      prescribedExercises: [
        'Isometric neck flexion & extension (5s hold x 10 reps)',
        'Chin tucks against resistance (3 sets of 10)',
        'Scapular retractions with light resistance band',
      ],
      nextSessionGoals: 'Progress to active rotational resistance exercises.',
    ),
    SessionModel(
      id: 'sess-comp-2',
      patientId: 'pat-7',
      patientName: 'Hari Prasad Dahal',
      patientAge: 65,
      patientGender: 'Male',
      patientPhone: '+977 9811223344',
      address: 'PhysioGhar Clinic, Jhamsikhel',
      visitType: VisitType.clinic,
      condition: 'Total Hip Replacement Recovery (Week 6)',
      dateTime: yesterday.subtract(const Duration(days: 2)),
      timeSlot: '10:00 AM - 11:00 AM',
      fee: 1200.0,
      status: SessionStatus.completed,
      clinicalRemarks:
          'Gait analysis shows significant reduction in Trendelenburg lurch. Full weight bearing tolerated with single elbow crutch.',
      prescribedExercises: [
        'Bridging on mat (12 reps x 3 sets)',
        'Side-lying hip abductions (10 reps each leg)',
        'Stationary cycling with zero resistance for 10 mins',
      ],
      nextSessionGoals: 'Transition to independent unassisted walking pattern.',
    ),

    // Cancelled
    SessionModel(
      id: 'sess-canc-1',
      patientId: 'pat-8',
      patientName: 'Dipesh Shrestha',
      patientAge: 31,
      patientGender: 'Male',
      patientPhone: '+977 9845566778',
      address: 'Koteshwor, Kathmandu',
      visitType: VisitType.homeVisit,
      condition: 'Ankle Inversion Sprain (Grade II)',
      dateTime: yesterday.subtract(const Duration(days: 1)),
      timeSlot: '04:00 PM - 05:00 PM',
      fee: 1500.0,
      status: SessionStatus.cancelled,
      cancelledReason: 'Patient had urgent office travel out of Kathmandu valley.',
    ),
  ];
}

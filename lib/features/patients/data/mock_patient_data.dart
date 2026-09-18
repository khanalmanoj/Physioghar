import '../domain/models/patient_model.dart';
import '../domain/models/patient_note_model.dart';

List<PatientModel> generateInitialMockPatients() {
  final now = DateTime.now();

  return [
    PatientModel(
      id: 'pat-3',
      name: 'Sita Sharma',
      age: 35,
      gender: 'Female',
      phone: '+977 9851098765',
      address: 'Sanepa-2, Lalitpur (House 42)',
      emergencyContact: '+977 9851011223 (Husband - Bikram)',
      condition: 'Lower Back Rehabilitation (L4-L5 Disc Bulge)',
      lastSessionDate: now.subtract(const Duration(days: 3)),
      totalSessionsCount: 6,
      notes: [
        PatientNote(
          id: 'note-1',
          patientId: 'pat-3',
          title: 'Initial Assessment & Core Activation',
          content:
              'Patient presented with acute radiating lower back ache after prolonged sitting. Straight Leg Raise test positive at 45 deg on right side. Focused on gentle pelvic tilts and trans-abdominal bracing.',
          exercises: [
            'Pelvic tilts on mat (10 reps x 2 sets)',
            'Prone press-ups / McKenzie extensions (5 reps)',
            'Diaphragmatic breathing 10 mins daily',
          ],
          nextGoals: 'Reduce pain visual analog scale from 7/10 to 4/10.',
          createdAt: now.subtract(const Duration(days: 14)),
        ),
        PatientNote(
          id: 'note-2',
          patientId: 'pat-3',
          title: 'Session 4: Lumbar Mobility & Stabilization',
          content:
              'Significant reduction in morning stiffness. Patient able to sit for 45 minutes continuously without lumbar numbness. Introduced bird-dog exercise.',
          exercises: [
            'Bird-dog hold (5 sec hold x 10 reps alternating)',
            'Cat-cow gentle mobility (10 cycles)',
            'Wall sits for quad and pelvic support (30 sec x 3)',
          ],
          nextGoals: 'Improve endurance in lumbar stabilizer musculature.',
          createdAt: now.subtract(const Duration(days: 3)),
        ),
      ],
    ),
    PatientModel(
      id: 'pat-4',
      name: 'Ramesh Thapa',
      age: 62,
      gender: 'Male',
      phone: '+977 9860123987',
      address: 'PhysioGhar Clinic, Jhamsikhel',
      emergencyContact: '+977 9841002233 (Son - Prakash)',
      condition: 'Post-Surgery ACL & Meniscus Rehabilitation',
      lastSessionDate: now.subtract(const Duration(days: 4)),
      totalSessionsCount: 8,
      notes: [
        PatientNote(
          id: 'note-3',
          patientId: 'pat-4',
          title: 'Post-op Week 5 Check & Range Expansion',
          content:
              'Active knee flexion reached 110 degrees without joint line crepitus. Swelling reduced to grade 1. Good quad contraction without extensor lag.',
          exercises: [
            'Heel slides with towel assistance',
            'Straight leg raises with 1kg ankle weight (10 reps x 3 sets)',
            'Stationary cycle forward pedaling (10 mins)',
          ],
          nextGoals: 'Achieve 125 degrees flexion and initiate closed-chain squats.',
          createdAt: now.subtract(const Duration(days: 4)),
        ),
      ],
    ),
    PatientModel(
      id: 'pat-6',
      name: 'Maya Gurung',
      age: 48,
      gender: 'Female',
      phone: '+977 9849876543',
      address: 'Maharajgunj, Kathmandu',
      emergencyContact: '+977 9801998877 (Brother - Anil)',
      condition: 'Cervical Spondylosis & Radiating Arm Pain',
      lastSessionDate: now.subtract(const Duration(days: 1)),
      totalSessionsCount: 4,
      notes: [
        PatientNote(
          id: 'note-4',
          patientId: 'pat-6',
          title: 'Spurling Assessment & Cervical Mobilization',
          content:
              'Arm parasthesia significantly reduced following manual cervical distraction. Rotational neck range improved from 40 to 65 degrees.',
          exercises: [
            'Cervical isometrics (Flexion, Extension, Lateral)',
            'Scapular retractions with yellow resistance band',
            'Thoracic extension against foam roller',
          ],
          nextGoals: 'Eliminate numbness during sleep and sustained desk work.',
          createdAt: now.subtract(const Duration(days: 1)),
        ),
      ],
    ),
    PatientModel(
      id: 'pat-5',
      name: 'Bikash Adhikari',
      age: 29,
      gender: 'Male',
      phone: '+977 9803456712',
      address: 'Baneshwor, Kathmandu',
      emergencyContact: '+977 9841887766 (Wife - Pooja)',
      condition: 'Frozen Shoulder (Adhesive Capsulitis)',
      lastSessionDate: now.subtract(const Duration(days: 6)),
      totalSessionsCount: 3,
      notes: [],
    ),
    PatientModel(
      id: 'pat-1',
      name: 'Sunita Rai',
      age: 42,
      gender: 'Female',
      phone: '+977 9841234567',
      address: 'Baluwatar, Kathmandu',
      emergencyContact: '+977 9851122334 (Husband - Ashok)',
      condition: 'Acute Neck Strain & Upper Trapezius Spasm',
      lastSessionDate: now.subtract(const Duration(days: 10)),
      totalSessionsCount: 1,
      notes: [],
    ),
  ];
}

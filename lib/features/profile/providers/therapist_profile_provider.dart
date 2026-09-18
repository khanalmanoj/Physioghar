import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/models/therapist_profile_model.dart';

class TherapistProfileNotifier extends StateNotifier<TherapistProfile> {
  TherapistProfileNotifier()
      : super(
          const TherapistProfile(
            id: 'dr-aarav-shrestha',
            name: 'Dr. Aarav Shrestha',
            title: 'Lead Consultant Physiotherapist (MPT Neuro-Musculoskeletal)',
            nmcNumber: 'NMC-PT-14820',
            email: 'aarav.physio@gmail.com',
            phone: '+977 9841987654',
            yearsOfExperience: 8,
            specializations: [
              'Orthopedic Rehabilitation',
              'Sports Injury Recovery',
              'Spine & Postural Correction',
              'Geriatric Mobility Care',
            ],
            bio:
                'Dedicated physiotherapist with over 8 years of clinical and home rehabilitation experience across Kathmandu and Lalitpur. Specialized in manual joint mobilization, dry needling, and evidence-based post-operative therapy.',
            clinicAddress: 'PhysioGhar Center, 2nd Floor, Jhamsikhel, Lalitpur',
            totalPatientsServed: 340,
            isAvailable: true,
          ),
        );

  void toggleAvailability() {
    state = state.copyWith(isAvailable: !state.isAvailable);
  }

  void setAvailability(bool available) {
    state = state.copyWith(isAvailable: available);
  }

  void updateProfile({
    required String name,
    required String title,
    required String nmcNumber,
    required String phone,
    required String email,
    required int yearsOfExperience,
    required List<String> specializations,
    required String clinicAddress,
    required String bio,
  }) {
    state = state.copyWith(
      name: name,
      title: title,
      nmcNumber: nmcNumber,
      phone: phone,
      email: email,
      yearsOfExperience: yearsOfExperience,
      specializations: specializations,
      clinicAddress: clinicAddress,
      bio: bio,
    );
  }
}

final therapistProfileProvider =
    StateNotifierProvider<TherapistProfileNotifier, TherapistProfile>((ref) {
  return TherapistProfileNotifier();
});

class TherapistProfile {
  final String id;
  final String name;
  final String title;
  final String nmcNumber;
  final String email;
  final String phone;
  final int yearsOfExperience;
  final List<String> specializations;
  final String bio;
  final String clinicAddress;
  final int totalPatientsServed;
  final bool isAvailable;

  const TherapistProfile({
    required this.id,
    required this.name,
    required this.title,
    required this.nmcNumber,
    required this.email,
    required this.phone,
    required this.yearsOfExperience,
    required this.specializations,
    required this.bio,
    required this.clinicAddress,
    required this.totalPatientsServed,
    required this.isAvailable,
  });

  TherapistProfile copyWith({
    String? id,
    String? name,
    String? title,
    String? nmcNumber,
    String? email,
    String? phone,
    int? yearsOfExperience,
    List<String>? specializations,
    String? bio,
    String? clinicAddress,
    int? totalPatientsServed,
    bool? isAvailable,
  }) {
    return TherapistProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      title: title ?? this.title,
      nmcNumber: nmcNumber ?? this.nmcNumber,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      yearsOfExperience: yearsOfExperience ?? this.yearsOfExperience,
      specializations: specializations ?? this.specializations,
      bio: bio ?? this.bio,
      clinicAddress: clinicAddress ?? this.clinicAddress,
      totalPatientsServed: totalPatientsServed ?? this.totalPatientsServed,
      isAvailable: isAvailable ?? this.isAvailable,
    );
  }
}

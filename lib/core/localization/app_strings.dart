enum AppLanguage { en, ne }

class AppStrings {
  static const Map<String, Map<AppLanguage, String>> _localizedValues = {
    // Navigation
    'nav_dashboard': {
      AppLanguage.en: 'Dashboard',
      AppLanguage.ne: 'ड्यासबोर्ड',
    },
    'nav_schedule': {
      AppLanguage.en: 'Schedule',
      AppLanguage.ne: 'तालिका',
    },
    'nav_sessions': {
      AppLanguage.en: 'Sessions',
      AppLanguage.ne: 'सत्रहरू',
    },
    'nav_patients': {
      AppLanguage.en: 'Patients',
      AppLanguage.ne: 'बिरामीहरू',
    },
    'nav_account': {
      AppLanguage.en: 'Account',
      AppLanguage.ne: 'खाता',
    },

    // Common Status
    'status_available': {
      AppLanguage.en: 'Available',
      AppLanguage.ne: 'उपलब्ध',
    },
    'status_unavailable': {
      AppLanguage.en: 'Unavailable',
      AppLanguage.ne: 'अनुपलब्ध',
    },
    'status_open': {
      AppLanguage.en: 'OPEN',
      AppLanguage.ne: 'खुला',
    },
    'status_booked': {
      AppLanguage.en: 'BOOKED',
      AppLanguage.ne: 'बुक गरिएको',
    },
    'status_blocked': {
      AppLanguage.en: 'BLOCKED',
      AppLanguage.ne: 'बन्द गरिएको',
    },
    'status_request': {
      AppLanguage.en: 'REQUEST',
      AppLanguage.ne: 'अनुरोध',
    },
    'status_upcoming': {
      AppLanguage.en: 'UPCOMING',
      AppLanguage.ne: 'आगामी',
    },
    'status_completed': {
      AppLanguage.en: 'COMPLETED',
      AppLanguage.ne: 'सम्पन्न',
    },
    'status_cancelled': {
      AppLanguage.en: 'CANCELLED',
      AppLanguage.ne: 'रद्द गरिएको',
    },

    // Visit Types
    'visit_home': {
      AppLanguage.en: 'HOME VISIT',
      AppLanguage.ne: 'घर भ्रमण',
    },
    'visit_clinic': {
      AppLanguage.en: 'CLINIC VISIT',
      AppLanguage.ne: 'क्लिनिक भ्रमण',
    },

    // Dashboard
    'greeting_namaste': {
      AppLanguage.en: 'Namaste',
      AppLanguage.ne: 'नमस्ते',
    },
    'todays_sessions': {
      AppLanguage.en: "Today's Sessions",
      AppLanguage.ne: 'आजका सत्रहरू',
    },
    'booking_requests': {
      AppLanguage.en: 'Booking Requests',
      AppLanguage.ne: 'बुकिङ अनुरोधहरू',
    },
    'completed_this_week': {
      AppLanguage.en: 'Completed This Week',
      AppLanguage.ne: 'यस हप्ता सम्पन्न',
    },
    'todays_schedule': {
      AppLanguage.en: "Today's Schedule",
      AppLanguage.ne: 'आजको तालिका',
    },
    'view_all': {
      AppLanguage.en: 'View All',
      AppLanguage.ne: 'सबै हेर्नुहोस्',
    },
    'no_sessions_today': {
      AppLanguage.en: 'No sessions scheduled for today.',
      AppLanguage.ne: 'आज कुनै सत्र तालिकामा छैन।',
    },

    // Schedule
    'manage_availability': {
      AppLanguage.en: 'Manage Availability',
      AppLanguage.ne: 'उपलब्धता व्यवस्थापन',
    },
    'add_custom_slot': {
      AppLanguage.en: '+ Add Slot',
      AppLanguage.ne: '+ स्लट थप्नुहोस्',
    },
    'block_slot': {
      AppLanguage.en: 'Block Slot',
      AppLanguage.ne: 'स्लट बन्द गर्नुहोस्',
    },
    'unblock_slot': {
      AppLanguage.en: 'Make Available (Unblock)',
      AppLanguage.ne: 'उपलब्ध बनाउनुहोस्',
    },
    'remove_slot': {
      AppLanguage.en: 'Remove Slot',
      AppLanguage.ne: 'स्लट हटाउनुहोस्',
    },
    'view_booking_details': {
      AppLanguage.en: 'View Booking Details',
      AppLanguage.ne: 'बुकिङ विवरण हेर्नुहोस्',
    },

    // Sessions Tabs
    'tab_requests': {
      AppLanguage.en: 'Requests',
      AppLanguage.ne: 'अनुरोधहरू',
    },
    'tab_upcoming': {
      AppLanguage.en: 'Upcoming',
      AppLanguage.ne: 'आगामी',
    },
    'tab_completed': {
      AppLanguage.en: 'Completed',
      AppLanguage.ne: 'सम्पन्न',
    },
    'tab_cancelled': {
      AppLanguage.en: 'Cancelled',
      AppLanguage.ne: 'रद्द',
    },

    // Actions
    'accept': {
      AppLanguage.en: 'Accept',
      AppLanguage.ne: 'स्वीकार गर्नुहोस्',
    },
    'decline': {
      AppLanguage.en: 'Decline',
      AppLanguage.ne: 'अस्वीकार गर्नुहोस्',
    },
    'complete_session': {
      AppLanguage.en: 'Complete Session',
      AppLanguage.ne: 'सत्र सम्पन्न गर्नुहोस्',
    },
    'reschedule': {
      AppLanguage.en: 'Reschedule',
      AppLanguage.ne: 'पुनः तालिका बनाउनुहोस्',
    },
    'call_patient': {
      AppLanguage.en: 'Call Patient',
      AppLanguage.ne: 'सम्पर्क गर्नुहोस्',
    },
    'view_directions': {
      AppLanguage.en: 'Directions',
      AppLanguage.ne: 'दिशा हेर्नुहोस्',
    },
    'save_notes': {
      AppLanguage.en: 'Save Notes',
      AppLanguage.ne: 'टिप्पणी सेभ गर्नुहोस्',
    },
    'cancel': {
      AppLanguage.en: 'Cancel',
      AppLanguage.ne: 'रद्द गर्नुहोस्',
    },
    'confirm': {
      AppLanguage.en: 'Confirm',
      AppLanguage.ne: 'पुष्टि गर्नुहोस्',
    },
    'save_changes': {
      AppLanguage.en: 'Save Changes',
      AppLanguage.ne: 'परिवर्तन सेभ गर्नुहोस्',
    },

    // Patients
    'search_patients': {
      AppLanguage.en: 'Search patients by name or condition...',
      AppLanguage.ne: 'नाम वा रोग अनुसार खोज्नुहोस्...',
    },
    'patient_details': {
      AppLanguage.en: 'Patient Details',
      AppLanguage.ne: 'बिरामी विवरण',
    },
    'treatment_notes': {
      AppLanguage.en: 'Clinical Treatment Notes',
      AppLanguage.ne: 'उपचारका क्लिनिकल नोटहरू',
    },
    'add_note': {
      AppLanguage.en: '+ Add Note',
      AppLanguage.ne: '+ नयाँ नोट थप्नुहोस्',
    },
    'edit_note': {
      AppLanguage.en: 'Edit Note',
      AppLanguage.ne: 'नोट सम्पादन गर्नुहोस्',
    },
    'delete_note': {
      AppLanguage.en: 'Delete Note',
      AppLanguage.ne: 'नोट मेटाउनुहोस्',
    },

    // Profile & Complaints
    'profile': {
      AppLanguage.en: 'My Profile',
      AppLanguage.ne: 'मेरो प्रोफाइल',
    },
    'edit_profile': {
      AppLanguage.en: 'Edit Profile',
      AppLanguage.ne: 'प्रोफाइल सम्पादन',
    },
    'language_setting': {
      AppLanguage.en: 'Language / भाषा',
      AppLanguage.ne: 'भाषा / Language',
    },
    'report_issue': {
      AppLanguage.en: 'Report an Issue / Complaints',
      AppLanguage.ne: 'गुनासो / समस्या दर्ता गर्नुहोस्',
    },
    'logout': {
      AppLanguage.en: 'Log Out',
      AppLanguage.ne: 'लग आउट',
    },
    'experience_years': {
      AppLanguage.en: 'Years Experience',
      AppLanguage.ne: 'वर्ष अनुभव',
    },
    'nmc_number': {
      AppLanguage.en: 'NMC Reg Number',
      AppLanguage.ne: 'एन.एम.सी दर्ता नं.',
    },
    'specializations': {
      AppLanguage.en: 'Specializations',
      AppLanguage.ne: 'विशेषज्ञता',
    },
    'clinic_address': {
      AppLanguage.en: 'Clinic / Practice Address',
      AppLanguage.ne: 'क्लिनिकको ठेगाना',
    },
  };

  static String get(String key, AppLanguage lang) {
    final entry = _localizedValues[key];
    if (entry == null) return key;
    return entry[lang] ?? entry[AppLanguage.en] ?? key;
  }
}

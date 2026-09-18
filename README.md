# PhysioGhar

A therapist-side dashboard app built with Flutter for managing physiotherapy sessions, patient records, schedules, and clinical notes. Includes built-in support for English and Nepali (नेपाली).

---

## How to Run

**Prerequisites:** Flutter SDK 3.47.3+ and Dart 3.13.3+

```bash
# Clone the repository
git clone <repository-url>
cd Physioghar

# Fetch dependencies & run
flutter pub get
flutter run
```

*Note: Google Fonts downloads font assets on first launch and caches them locally.*

---

## Tech Stack & Dependencies

- **Flutter 3.47.3 / Dart 3.13.3**
- **`flutter_riverpod` (^2.5.1)** — State management using `StateNotifier` and derived providers.
- **`google_fonts` (^6.2.1)** — Typography (*Fraunces* for headings, *Inter* for body, *IBM Plex Mono* for tags/labels).
- **`intl` (^0.19.0)** — Date and time formatting utilities.

---

## State Management

I used **Riverpod + StateNotifier** for managing app state.

### Why this approach?
- **No BuildContext dependency:** Notifiers operate independently of the UI tree, making business logic easy to read, test, and isolate.
- **Derived state with `Provider`:** Metrics like total pending requests or today's session counts don't need manual sync logic. A simple `Provider` that watches `sessionsNotifierProvider` automatically recalculates whenever sessions change.
- **Feature isolation:** State is split into dedicated notifiers (`PatientsNotifier`, `SessionsNotifier`, `ScheduleNotifier`, `TherapistProfileNotifier`, `ComplaintsNotifier`, `LanguageNotifier`).

---

## Project Structure

The project uses a **feature-first** structure:

```text
lib/
├── core/
│   ├── localization/   # String maps (EN/NE) and language state
│   ├── theme/          # App colors & Material 3 ThemeData
│   ├── utils/          # Date formatters & avatar helpers
│   └── widgets/        # Shared components (cards, pill buttons, badges)
│
└── features/
    ├── dashboard/      # Metrics summary & today's session timeline
    ├── schedule/       # Date picker & time slot management
    ├── sessions/       # Session requests, upcoming, completed & cancelled tabs
    ├── patients/       # Patient directory, details & clinical treatment notes
    ├── profile/        # Therapist profile, availability toggle & settings
    ├── complaints/     # Support ticket submission & status tracking
    └── navigation/     # Main bottom navigation bar
```

Inside each feature folder:
- `domain/models/` — Immutable data models with `copyWith`
- `data/` — Initial mock data generators
- `providers/` — Riverpod `StateNotifier` and computed providers
- `presentation/` — Screens and feature-specific UI widgets

---

## How Mock Data is Handled

Because there is no backend configured, the app initializes with in-memory mock data:
- `generateInitialMockPatients()` — Seed patients with medical history and clinical notes.
- `generateInitialMockSessions()` — Mix of pending requests, upcoming visits, and completed sessions.
- `generateInitialMockSlots()` — 14 days of time slots (home & clinic visits).

All mock dates use relative offsets from `DateTime.now()`, ensuring session timelines remain current whenever you launch the app. Replacing mock data with a real API only requires updating the data layer / notifier initializers; the UI and provider logic remain untouched.

---

## Key Assumptions & Design Decisions

1. **Therapist-centric flow:** Designed strictly as a practitioner workspace. No patient login or auth flow is included.
2. **Nepali context:** Localized for Nepal (phone format `+977`, Kathmandu/Lalitpur address options, NMC registration IDs, and English/Nepali language switcher).
3. **Clinical notes attached to patients:** Notes and exercise prescriptions are tied to the patient's record rather than individual session logs, matching standard clinical recordkeeping.
4. **Custom lightweight localization:** Used a simple `Map<AppLanguage, String>` lookup extension (`context.tr()`) instead of heavy `intl` code-generation since only two languages are targeted.

---

## Future Improvements

- **Local Persistence:** Add Hive or SQLite to persist session updates across app restarts.
- **Backend Integration:** Replace mock data providers with `AsyncNotifier` connecting to a REST API.
- **Push Notifications:** Alert therapists for incoming session requests or upcoming home visits.
- **Dark Theme:** Extend existing color system to support dark mode switching.

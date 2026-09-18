# PhysioGhar — Therapist Dashboard App

**PhysioGhar** is a Flutter-based mobile application designed for physiotherapists operating in Nepal. It provides a comprehensive therapist-side dashboard to manage daily sessions, patient records, schedule availability, clinical treatment notes, and complaint/support tickets — all with built-in **English / Nepali (नेपाली)** bilingual support.

---

## How to Run the Project

### Prerequisites

| Requirement | Version Used |
|---|---|
| Flutter SDK | **3.47.3** (stable channel) |
| Dart SDK | **3.13.3** |
| DevTools | 2.60.0 |

### Steps

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd Physioghar
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   # On a connected device or emulator
   flutter run

   # For a specific platform
   flutter run -d chrome      # Web
   flutter run -d windows     # Windows desktop
   flutter run -d <device_id> # Specific device
   ```

4. **Build for release** *(optional)*
   ```bash
   flutter build apk          # Android
   flutter build ios           # iOS
   ```

> **Note:** The app uses Google Fonts, which requires an internet connection on first launch to download font files. Subsequent launches will use the cached fonts.

---

## Flutter / Dart Version

| Tool | Version |
|---|---|
| **Flutter** | 3.47.3 (stable) |
| **Dart** | 3.13.3 |
| **Minimum Dart SDK** | `^3.13.3` |

---

## Packages Used

| Package | Version | Purpose |
|---|---|---|
| [`flutter_riverpod`](https://pub.dev/packages/flutter_riverpod) | `^2.5.1` | State management — provides `StateNotifier`, `Provider`, and `ConsumerWidget` for reactive, compile-safe state across the entire app. |
| [`google_fonts`](https://pub.dev/packages/google_fonts) | `^6.2.1` | Typography — loads **Fraunces** (serif headings), **Inter** (body text), and **IBM Plex Mono** (labels/badges) directly from Google Fonts. |
| [`intl`](https://pub.dev/packages/intl) | `^0.19.0` | Date/time formatting — used by utility functions for human-readable date strings (e.g., "Sep 15, 2026"). |
| `cupertino_icons` | `^1.0.8` | iOS-style icons for Cupertino-themed UI elements. |

### Dev Dependencies

| Package | Version | Purpose |
|---|---|---|
| `flutter_test` | SDK | Widget and unit testing framework. |
| `flutter_lints` | `^6.0.0` | Recommended lint rules for code quality. |

---

## State Management Approach

The app uses **Riverpod** (`flutter_riverpod`) with the **`StateNotifier`** pattern.

### Why Riverpod?

- **Compile-safe:** Providers are global declarations — no runtime `ProviderNotFoundException` errors.
- **No `BuildContext` dependency:** State can be read/watched from anywhere via `ref`, making logic testable and independent of the widget tree.
- **Derived providers:** Computed state (e.g., dashboard metrics, filtered lists) is expressed as `Provider`s that `ref.watch()` the source data — automatic rebuilds with zero duplication.
- **Scalable:** Each feature owns its own `StateNotifier` + provider. Adding a new feature requires no changes to a central store.

### Provider Architecture

```
ProviderScope (main.dart)
│
├── languageNotifierProvider          ← App-wide language toggle (EN / NE)
├── therapistProfileProvider          ← Therapist profile state
│
├── sessionsNotifierProvider          ← Master sessions list
│   ├── pendingRequestsCountProvider  ← Derived: count of requests
│   ├── todaySessionsProvider         ← Derived: today's sessions
│   └── dashboardMetricsProvider      ← Derived: dashboard summary card metrics
│
├── patientsNotifierProvider          ← Patients list + search
├── scheduleNotifierProvider          ← Schedule slots + selected date
└── complaintsNotifierProvider        ← Support tickets
```

Each `StateNotifier` encapsulates its own mutation methods (e.g., `acceptRequest()`, `addNote()`, `blockSlot()`), keeping business logic cleanly separated from UI widgets.

---

## Project Structure

```
lib/
├── main.dart                            ← App entry point (ProviderScope + MaterialApp)
│
├── core/                                ← Shared / cross-cutting concerns
│   ├── theme/
│   │   ├── app_colors.dart              ← PhysioColors palette (pine, amber, cream, etc.)
│   │   └── app_theme.dart               ← Material 3 ThemeData (fonts, cards, AppBar)
│   ├── localization/
│   │   ├── app_strings.dart             ← EN/NE string map for all UI text
│   │   └── app_language_provider.dart   ← LanguageNotifier + context.tr() extension
│   ├── widgets/                         ← Reusable design-system components
│   │   ├── physio_card.dart             ← Styled card wrapper
│   │   ├── physio_pill_button.dart      ← Pill-shaped action button
│   │   ├── physio_app_bar.dart          ← Consistent app bar
│   │   ├── physio_badge.dart            ← Status/visit-type badge
│   │   └── empty_state_view.dart        ← Empty list placeholder
│   └── utils/
│       ├── date_time_utils.dart         ← Date comparison & formatting helpers
│       └── mock_avatar_helper.dart      ← Avatar color/initial generator
│
├── features/                            ← Feature modules (self-contained)
│   ├── navigation/
│   │   └── presentation/
│   │       └── main_navigation_screen.dart  ← Bottom nav (5 tabs)
│   │
│   ├── dashboard/
│   │   ├── presentation/
│   │   │   ├── dashboard_screen.dart    ← Summary cards + today's timeline
│   │   │   └── widgets/                 ← Dashboard-specific widgets
│   │   └── providers/
│   │       └── dashboard_metrics_provider.dart  ← Computed metrics from sessions
│   │
│   ├── schedule/
│   │   ├── data/
│   │   │   └── mock_schedule_data.dart  ← Seed time slots
│   │   ├── domain/models/
│   │   │   └── time_slot_model.dart     ← TimeSlot + SlotStatus + VisitType
│   │   ├── presentation/
│   │   │   ├── schedule_screen.dart     ← Date strip + slot list + actions
│   │   │   └── widgets/
│   │   └── providers/
│   │       └── schedule_provider.dart   ← ScheduleNotifier (block/unblock/add/remove)
│   │
│   ├── sessions/
│   │   ├── data/
│   │   │   └── mock_sessions_data.dart  ← Seed sessions (request/upcoming/completed/cancelled)
│   │   ├── domain/models/
│   │   │   └── session_model.dart       ← SessionModel + SessionStatus
│   │   ├── presentation/
│   │   │   ├── sessions_screen.dart     ← Tabbed view (Requests/Upcoming/Completed/Cancelled)
│   │   │   ├── session_detail_screen.dart  ← Full session view with actions
│   │   │   └── widgets/
│   │   └── providers/
│   │       └── sessions_provider.dart   ← SessionsNotifier + derived providers
│   │
│   ├── patients/
│   │   ├── data/
│   │   │   └── mock_patient_data.dart   ← Seed patients with clinical notes
│   │   ├── domain/models/
│   │   │   ├── patient_model.dart       ← PatientModel
│   │   │   └── patient_note_model.dart  ← PatientNote
│   │   ├── presentation/
│   │   │   ├── patients_screen.dart     ← Searchable patient list
│   │   │   ├── patient_detail_screen.dart  ← Profile + notes CRUD
│   │   │   └── widgets/
│   │   └── providers/
│   │       └── patients_provider.dart   ← PatientsNotifier (search, add/edit/delete notes)
│   │
│   ├── profile/
│   │   ├── domain/models/
│   │   │   └── therapist_profile_model.dart  ← TherapistProfile
│   │   ├── presentation/
│   │   │   ├── account_screen.dart      ← Account hub (profile, language, complaints, logout)
│   │   │   ├── profile_detail_screen.dart  ← Read-only profile view
│   │   │   └── edit_profile_screen.dart ← Editable profile form
│   │   └── providers/
│   │       └── therapist_profile_provider.dart  ← TherapistProfileNotifier
│   │
│   └── complaints/
│       ├── domain/models/
│       │   └── complaint_model.dart     ← ComplaintModel + enums
│       ├── presentation/
│       │   ├── complaints_screen.dart   ← Ticket list + submit form
│       │   └── widgets/
│       └── providers/
│           └── complaints_provider.dart ← ComplaintsNotifier (submit ticket)
```

### Layering Convention (per feature)

```
domain/models/   → Immutable data classes with copyWith()
data/            → Mock data factory functions (swap point for real API)
providers/       → Riverpod StateNotifier + derived providers
presentation/    → Screens and feature-specific widgets
```

---

## Assumptions Made

1. **Therapist-only interface:** The app is designed exclusively for the physiotherapist's perspective. There is no patient-facing side, admin panel, or multi-user login. A single hardcoded therapist profile is used.

2. **No backend / API:** All data is mock/in-memory. There is no network layer, database, or persistent storage. Data resets on every app restart. This was intentional to focus on UI, state management, and app architecture.

3. **Nepal-specific context:** Patient details (phone numbers with +977, addresses in Kathmandu/Lalitpur, NMC registration, blood group conventions) and the Nepali language toggle reflect the app's target market.

4. **Two languages only:** The localization system supports English and Nepali via a lightweight string map rather than Flutter's full `intl` code-generation pipeline, since only two languages are needed.

5. **Home + Clinic visits:** The schedule and session models support two visit types (home visit and clinic visit), reflecting the real-world PhysioGhar service model where therapists travel to patients' homes.

6. **Session workflow:** Sessions follow a linear status flow: `Request → Upcoming (accepted) → Completed` or `Request → Cancelled (declined)`. Rescheduling updates the date/time but keeps the status as upcoming.

7. **Clinical notes are per-patient:** Treatment notes (exercises, goals, clinical remarks) are attached to individual patient records, not to sessions. This matches the common physiotherapy documentation pattern.

8. **No authentication / authorization:** There are no login, signup, or role-based access control screens. The app launches directly into the dashboard.

9. **Single-device usage:** The app is designed for single-device use by one therapist. There is no data sync, real-time collaboration, or multi-device support.

10. **Internet required on first run:** Google Fonts are fetched over the network on first launch and cached locally afterward.

---

## Key Screens

| Screen | Description |
|---|---|
| **Dashboard** | At-a-glance summary cards (today's sessions, pending requests, weekly completions) + today's schedule timeline |
| **Schedule** | Horizontal date selector + time slot management (add, block, unblock, remove slots) |
| **Sessions** | Tabbed view across 4 statuses — accept/decline requests, complete sessions with clinical remarks, reschedule |
| **Patients** | Searchable patient list → detailed patient profile with full CRUD for clinical treatment notes |
| **Account** | Therapist profile view/edit, language toggle (EN ↔ NE), complaints/issue reporting, availability toggle |
| **Complaints** | Submit support tickets with category & priority, view existing ticket statuses |

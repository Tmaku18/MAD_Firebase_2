# mad_firebase_2 — ICA #12 Inventory (Flutter + Firestore)

Real-time inventory app for **Georgia State University — Mobile App Development**, In-Class Activity #12. Uses **Cloud Firestore** collection `items`, **`StreamBuilder` + `ListView.builder`**, a dedicated **service layer**, and validated add/edit forms.

## Prerequisites

- Flutter SDK (this project targets **Dart ^3.10** per `pubspec.yaml`).
- Firebase project with **Firestore** enabled (test rules OK for class work).
- For a fresh Firebase project, run [`flutterfire configure`](https://firebase.flutter.dev/) and replace `lib/firebase_options.dart` and platform config files—**do not commit private keys** you are told to keep local.

This repo is wired to Firebase project **`mad-ica12-inventory-tmaku`** (class demo).

## Run

```bash
flutter pub get
flutter run
```

## Architecture

| Layer | Role |
|--------|------|
| `lib/models/item.dart` | `Item` with `toMap()` / `fromMap(id, data)` |
| `lib/services/item_firestore_service.dart` | `add`, `streamItems`, `update`, `delete` on `items` |
| `lib/widgets/item_form_sheet.dart` | Reusable add/edit form + validation |
| `lib/screens/inventory_home_screen.dart` | `StreamBuilder`, search, list, totals |
| `lib/main.dart` | `WidgetsFlutterBinding.ensureInitialized()`, `Firebase.initializeApp()` |

## Enhanced features (README requirement)

1. **Live search filter** — Filter the list by name as you type (client-side on the streamed list).
2. **Low-stock highlighting + footer totals** — Rows with quantity **below 5** use bold/orange styling; bottom bar shows **filtered count** and **total inventory value** (sum of `quantity × price` for visible rows).

## APK

```bash
flutter build apk
```

Release APK path (typical): `build/app/outputs/flutter-apk/app-release.apk`. Submit per course instructions (GitHub and/or LMS).

## Reflection

See **`REFLECTION.md`** (first-person answers and critical-thinking prompts for the assignment).

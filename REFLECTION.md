# ICA #12 — Reflection (Tanaka Makuvaza)

 This activity was about wiring **Flutter + Firestore** with **streams**, **CRUD**, and **validation** in a way that still feels maintainable.

---

## 1) Objective + expectation

I expected that once I pointed `StreamBuilder` at a `Stream<List<Item>>` from a service, the list would **stay in sync** with Firestore without me calling `setState` after every write. I also expected that pushing CRUD into a **service class** would keep the UI file readable, which matters when the rubric talks about “clean architecture.”

---

## 2) What I obtained

The inventory list **does** update when I add, edit, or delete documents in the `items` collection. The loading spinner shows on the first subscription, errors surface with a simple error line, and the empty state tells me when there is nothing in Firestore yet. Forms block empty names, non-numeric quantity, bad prices, and negative numbers, so I don’t silently write garbage.

---

## 3) Evidence

- **Behavior:** Add two items on one device/emulator; the list updates immediately. Edit quantity; the row and the footer total update. Delete; the row disappears.
- **Code:** `ItemFirestoreService.streamItems()` maps snapshots to `List<Item>`; `InventoryHomeScreen` uses `StreamBuilder` in the PDF order (waiting → error → empty / list). `ItemFormSheet` is a separate widget so add/edit isn’t copy-pasted.
- **Git:** Commit history shows setup → model → service → UI pieces → README/reflection, which is what the submission checklist asks for.

*(Screenshots: I’ll attach those to Canvas / the hub the way Dr. Henry’s PDF describes.)*

---

## 4) Analysis

**StreamBuilder vs FutureBuilder:** Firestore `snapshots()` is a stream, so **`StreamBuilder`** is the right widget; a one-shot `FutureBuilder` wouldn’t give me live updates when the collection changes.

**Service layer:** Keeping `FirebaseFirestore.instance.collection('items')` inside `ItemFirestoreService` means my widgets mostly care about **display and input**, not about document paths. That matches what the knowledge check says about where CRUD should live.

**Validation:** Quantity and price need parsing and range checks because Firestore will accept whatever map I send; the UI is the first gate. I used numeric keyboards where it made sense so typing feels less error-prone.

**Search vs stream:** I filter in memory after the stream delivers the list. That’s fine for a class-scale dataset; at huge scale I’d move filtering into queries with indexes.

---

## 5) Improvement plan

Next I’d add **pagination or query limits** and maybe **server-side security rules** keyed to auth, because right now test-mode style rules are fine for development but not for production multi-user inventory. I’d also add **offline caching UX** (banner or retry) if I expect spotty Wi‑Fi.

---

## Mini knowledge check (my answers, conversational)

- **Best widget for real-time Firestore updates?** I’d pick **`StreamBuilder`** — the snapshot stream is continuous, not a single future.
- **Where should CRUD live?** In a **dedicated service** (or repository), not crammed into `build()` or only in `main()`.
- **Why validate quantity and price?** So I don’t **write invalid data** and so users get **immediate feedback** instead of a confusing broken state later.

---

## Critical thinking prompts

**Easiest objective:** For me, modeling `Item` with `toMap` / `fromMap` was the quickest win because it’s mostly typing and thinking about field names.

**Hardest objective:** Getting **Firebase + Gradle + `google-services`** lined up on Android is always the fussy part; one missing plugin line and the build fails before Dart even runs.

**Expected vs obtained:** I once assumed `StreamBuilder` would always hit `waiting` first; in practice, if data is already cached, I had to combine **`waiting` with `!snapshot.hasData`** so I didn’t flash a spinner forever. I fixed it by matching the pattern from the activity PDF.

**Commit history:** Early commits are config and dependencies; later ones are model → service → UI → docs. You can literally see when the app went from “shell” to “inventory.”

**If this scaled:** First change would be **Firestore security rules + authenticated users**, then **indexed queries** instead of downloading the whole collection for search.

---

Thanks for reading — this one made the “cloud-backed mobile app” story click for me.

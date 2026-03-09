## Demo Video Script (7–12 minutes)

This file is ONLY for the video. Use `DESIGN_DOC_GUIDE.md` for the written document.

### 1. Intro (30–60s)
- **Who you are & goal**: “This is my Kigali City Services & Places Directory app built with Flutter, Firebase Authentication, and Cloud Firestore.”
- **What it does**: Briefly mention directory, my listings, map, settings, auth, real‑time updates.

### 2. Firebase Overview (1–2 min)
- Show **Firebase Console → Authentication**:
  - Point out an example user: email + UID.
  - Say: “Each user is created by Firebase Auth and the UID links to their listings.”
- Show **Firestore → users + listings**:
  - `users` document fields: `uid`, `email`, `createdAt`.
  - `listings` document fields: `name`, `category`, `address`, `contactNumber`, `description`, `latitude`, `longitude`, `createdBy`, `createdAt`.

### 3. Authentication Flow (2–3 min)
- On the emulator:
  - Log out from **Settings**.
  - On the auth screen, sign up with a new email/password → show verify email screen.
  - Open your email in the browser, click the verification link.
  - Back in app, tap **“I have verified my email”** → show that tabs appear.
- Briefly show code:
  - `lib/src/app_root.dart` → `KigaliApp` + `home: AuthGate()`.
  - `lib/src/features/auth/presentation/auth_gate.dart` → decides between `AuthScreen` and main shell.
  - `lib/src/features/auth/presentation/auth_screen.dart` → form calling `authControllerProvider.signIn/signUp`.
  - `lib/src/features/auth/shared/auth_providers.dart` → `authStateChangesProvider` + `AuthController`.

### 4. Directory & CRUD (3–4 min)
- In **Directory** tab:
  - Show search bar and category chips.
  - Explain: “This list is driven by a Firestore stream and filtered by Riverpod providers.”
- **Create listing**:
  - Tap **+** in AppBar.
  - Fill in all fields (including numeric latitude/longitude).
  - Tap **Create listing**; show:
    - New card appears in Directory.
    - New marker appears in Map View.
    - New document appears in Firestore `listings` collection.
  - Show code:
    - `lib/src/features/listings/data/listing_repository.dart` → `Listing` model + `create()`.
    - `lib/src/features/listings/presentation/edit_listing_screen.dart` → form and `_save()` using repository.
- **Edit listing**:
  - Open menu on your listing → **Edit**, change some text → **Save changes**.
  - Show Firestore document updating.
  - Mention `update()` in `listing_repository.dart`.
- **Delete listing**:
  - Use menu → **Delete**, confirm.
  - Show card disappearing and Firestore doc removed.
  - Mention `delete()` in `listing_repository.dart`.

### 5. My Listings (1–2 min)
- Switch to **My Listings** tab:
  - Explain: “This only shows listings where `createdBy` equals the current user UID.”
  - Show code:
    - `myListingsStreamProvider` in `listing_repository.dart`.
    - `lib/src/features/listings/presentation/my_listings_screen.dart` using that provider.

### 6. Map View & Detail Map (1–2 min)
- Open **Map View** tab:
  - Show markers over Kigali.
  - Mention:
    - Uses `flutter_map` with OpenStreetMap tiles.
    - Reads the same Firestore stream (`listingsStreamProvider`).
  - Show code: `lib/src/features/listings/presentation/map_view_screen.dart`.
- Open a listing from Directory:
  - Show embedded OSM map & marker at the top of **detail** page.
  - Show code: `listing_detail_screen.dart` → `FlutterMap` + `TileLayer` + `MarkerLayer`.

### 7. Navigation Directions (Google Maps) (30–60s)
- On the detail page, tap **“Open in Google Maps”**:
  - Show Google Maps (or browser) opening with the destination coordinates.
  - Briefly show code in `listing_detail_screen.dart` using `url_launcher.launchUrl` with the Google Maps directions URL.

### 8. Settings & Theme (1–2 min)
- Go to **Settings** tab:
  - Show profile card with email and UID.
  - Show “Email verified” row.
  - Toggle location notifications (explain: simulated only).
  - Toggle **Dark mode** and show theme change.
  - Log out to end.
- Show code:
  - `settings_screen.dart` for UI and toggles.
  - `shared/theme/theme_providers.dart` + `app_root.dart` for `themeModeProvider`.

### 9. Closing (30–60s)
- Summarize:
  - Firebase Auth + Firestore.
  - Real‑time listings CRUD with Riverpod state management.
  - Directory search/filter, My Listings, Map with OSM + Google Maps directions.
  - Settings: profile, email verification, dark mode, logout.


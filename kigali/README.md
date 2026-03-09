## Kigali City Services Directory

A Flutter mobile app that helps Kigali residents find key public services and lifestyle locations (hospitals, police stations, libraries, restaurants, cafés, parks, tourist attractions, etc.).  
The app is fully integrated with **Firebase Authentication** and **Cloud Firestore**, and uses **OpenStreetMap** for embedded maps plus **Google Maps** for navigation directions.

---

### Main Features

- **Authentication**
  - Email/password sign up and login using Firebase Auth.
  - Email verification flow (users must verify before entering the app).
  - User profile document stored in Firestore (`users` collection) linked by UID.

- **Listings (CRUD)**
  - Create new listings with:
    - Place/Service name
    - Category (Hospital, Police Station, Library, Restaurant, Café, Park, Tourist Attraction)
    - Address, contact number, description
    - Latitude and longitude
  - View all listings in a shared directory.
  - Edit and delete listings created by the authenticated user only.
  - Real‑time UI updates via Firestore streams.

- **Directory Search & Filtering**
  - Search by listing name.
  - Filter by category using chips (All, Hospital, Library, etc.).
  - Directory list is driven by Riverpod providers combining Firestore stream + filters.

- **Detail Page & Map Integration**
  - Detail screen shows all listing information.
  - Embedded **OpenStreetMap** map (via `flutter_map`) with a marker at the listing location.
  - "Open in Google Maps" button launches Google Maps (or browser) with turn‑by‑turn directions to the coordinates.

- **Bottom Navigation**
  - **Directory** – browse all listings, search and filter.
  - **My Listings** – only listings created by the current user.
  - **Map View** – map of Kigali with markers for all listings.
  - **Settings** – profile info, email verification status, toggles, logout.

- **Settings & Preferences**
  - Show authenticated user’s email and UID.
  - Show whether email is verified.
  - Toggle for simulated location‑based notifications (local only).
  - Dark/Light mode toggle (theme controlled via Riverpod).
  - Logout button.

---

### Tech Stack

- **Flutter** (Dart 3)
- **Firebase**
  - `firebase_core`
  - `firebase_auth`
  - `cloud_firestore`
- **State Management**
  - `flutter_riverpod`
- **Maps & Navigation**
  - `flutter_map` + `latlong2` for embedded OpenStreetMap tiles
  - `url_launcher` to open Google Maps for navigation

---

### Firestore Data Model

- **Collection: `users`**
  - `uid` – Firebase UID
  - `email` – user email
  - `createdAt` – timestamp

- **Collection: `listings`**
  - `name` – place/service name
  - `category` – Hospital / Police Station / Library / Restaurant / Café / Park / Tourist Attraction
  - `address` – physical address
  - `contactNumber` – phone number (string)
  - `description` – text description
  - `latitude` – double
  - `longitude` – double
  - `createdBy` – user UID (links to `users` collection)
  - `createdAt` – timestamp when listing was created

---

### Architecture & State Management

- **Entry point**
  - `lib/main.dart` initializes Firebase and wraps the app in `ProviderScope`.
  - `lib/src/app_root.dart` (`KigaliApp`) sets up theming and uses `AuthGate` as the home widget.

- **Authentication**
  - `auth_providers.dart` exposes FirebaseAuth and `AuthController` via Riverpod.
  - `auth_gate.dart` listens to auth state changes and shows either the login screen or the main shell.

- **Listings**
  - `listing_repository.dart` encapsulates all Firestore access for `listings`.
  - Riverpod providers expose:
    - All listings stream (`listingsStreamProvider`)
    - Filtered listings (`filteredListingsProvider`)
    - Current user’s listings (`myListingsStreamProvider`)

- **Navigation & Screens**
  - `scaffold_shell.dart` holds the `BottomNavigationBar` and swaps between:
    - `DirectoryScreen`
    - `MyListingsScreen`
    - `MapViewScreen`
    - `SettingsScreen`

---

### Setup & Running the App

1. **Clone and install dependencies**
   ```bash
   flutter pub get
   ```

2. **Configure Firebase (Android)**
   - Create a Firebase project.
   - Add an Android app with package name **`com.kigali`**.
   - Download `google-services.json` and place it in `android/app/`.
   - Ensure `android/app/build.gradle.kts` uses `applicationId = "com.kigali"` and the Google Services plugin is applied.

3. **(Optional, but recommended) Firestore security rules for development**
   - For local development you can temporarily use relaxed rules; for production you must tighten them.  
   - Follow Firebase docs to set rules appropriate for your course requirements.

4. **Run on emulator or device**
   ```bash
   flutter run
   ```

---

### How to Use (Quick Walkthrough)

1. **Sign up / Log in**
   - Create an account with email and password.
   - Check your email, click the verification link.
   - Return to the app and tap **“I have verified my email”**.

2. **Create a listing**
   - Go to **Directory** → tap **+**.
   - Fill in all fields, including valid latitude/longitude.
   - Tap **Create listing**. The item appears in Directory, My Listings, and Map View.

3. **Edit / Delete**
   - Open the menu on a listing you own (in Directory or My Listings).
   - Choose **Edit** to change data or **Delete** to remove it.

4. **Search & Filter**
   - In Directory, type in the search bar to filter by name.
   - Tap category chips to filter by category.

5. **Maps & Navigation**
   - Tap a listing to open its detail page with an embedded map.
   - Tap **Open in Google Maps** to launch navigation to the coordinates.

6. **Settings**
   - View your email, UID, and email verification status.
   - Toggle dark mode and simulated location notifications.
   - Tap **Log out** to sign out.

---

### Notes

- This project is intended as an educational assignment demonstrating:
  - Firebase Authentication + Firestore integration.
  - Clean separation between UI and data access using Riverpod.
  - Real‑time updates and map integration in a Flutter app.
- Please review and adapt the code and documentation to match your own understanding and course requirements.


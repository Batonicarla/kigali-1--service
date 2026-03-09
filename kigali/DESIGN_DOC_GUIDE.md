## Design & Code Explanation – Outline for 1–2 Page Document

This file is ONLY for your written PDF/Word document. Use `VIDEO_DEMO_GUIDE.md` for the video.

You should use these headings and write explanations in **your own words**.

### 1. Firestore Database Structure
- **Collections**:
  - `users`:
    - `uid` (Firebase UID)
    - `email`
    - `createdAt` (Timestamp)
  - `listings`:
    - `name`
    - `category` (Hospital, Police Station, Library, Restaurant, Café, Park, Tourist Attraction)
    - `address`
    - `contactNumber`
    - `description`
    - `latitude` (double)
    - `longitude` (double)
    - `createdBy` (user UID)
    - `createdAt` (Timestamp)

In your document, explain:
- Why user data and listing data are separated into two collections.
- How `createdBy` links each listing back to the `users` collection.

### 2. State Management with Riverpod
Explain how you used **Riverpod** instead of calling Firebase directly in widgets.

Mention these providers / files:
- `auth_providers.dart`:
  - `firebaseAuthProvider`
  - `authStateChangesProvider`
  - `authControllerProvider` and `AuthState` (loading, error messages).
- `listing_repository.dart`:
  - `listingRepositoryProvider`
  - `listingsStreamProvider` and `myListingsStreamProvider`
  - `listingsFilterProvider` and `filteredListingsProvider`.
- `theme_providers.dart`:
  - `themeModeProvider` used to switch light/dark themes.

Make clear that:
- UI widgets subscribe to providers.
- All Firestore reads/writes go through the repository and controllers.

### 3. UI & Navigation Design
Describe the main screens and how navigation works.

- **Main entry**: `main.dart` and `KigaliApp` in `app_root.dart`.
  - `MaterialApp` with `theme`, `darkTheme`, and `themeMode` from Riverpod.
- **Navigation shell**: `scaffold_shell.dart`.
  - BottomNavigationBar with tabs:
    - Directory
    - My Listings
    - Map View
    - Settings
  - How the shell selects the correct screen based on the index.
- **Directory**: `directory_screen.dart`.
  - Search bar and category chips.
  - Cards showing `name`, `category`, `address` and owner menu.
- **My Listings**: `my_listings_screen.dart`.
  - Shows only the current user’s listings; reuse of edit/delete logic.
- **Map View**: `map_view_screen.dart`.
  - Uses `flutter_map` with OpenStreetMap tiles.
  - Shows markers for each listing from Firestore.
- **Settings**: `settings_screen.dart`.
  - Profile info (email, UID, email verified flag).
  - Notification toggle (local simulation).
  - Dark mode toggle.
  - Logout button.

### 4. Authentication & Email Verification Flow
Describe steps from a user perspective and link to code.

- Sign up:
  - `AuthScreen` calls `authControllerProvider.signUp`.
  - Firebase Authentication creates the user.
  - `UserProfileRepository` writes a profile document into `users` collection.
  - `sendEmailVerification()` sends an email.
- Email verification:
  - `ScaffoldShell` checks `user.emailVerified`.
  - If not verified, shows verify screen with:
    - Button to resend email.
    - “I have verified my email” button which calls `user.reload()`.
- After verification, user is allowed to access the tabbed main app.

Explain why this is important for security and assignment requirements.

### 5. Listings CRUD & Map Integration
Explain how you model listings and connect them to the UI and maps.

- Model: `Listing` class in `listing_repository.dart` with mapping to/from Firestore.
- Create / Edit / Delete:
  - `EditListingScreen` builds the form and calls `create` or `update`.
  - Directory and My Listings use the same repository to refresh automatically.
- Search & Filter:
  - `ListingsFilterController` stores `searchQuery` and `category`.
  - `filteredListingsProvider` applies this on top of the Firestore stream.
- Map (OpenStreetMap) integration:
  - `flutter_map` and `latlong2` packages.
  - In `map_view_screen.dart`, markers for each listing.
  - In `listing_detail_screen.dart`, a map centered on a single listing.
  - External navigation using `url_launcher` to open Google Maps with destination coordinates.

### 6. Technical Challenges & Trade‑offs
Use this section to show your thinking and problem‑solving. Examples you can mention:

- **Firebase configuration**:
  - Matching `applicationId` and `google-services.json` package name (`com.kigali`).
  - Choosing compatible versions of `firebase_core`, `firebase_auth`, `cloud_firestore`.
- **Asynchronous issues**:
  - Using `authStateChangesProvider` and `mounted` checks to avoid context errors.
- **Map choice**:
  - Why you chose `flutter_map` + OpenStreetMap for the embedded map (no API key) and still used Google Maps externally for navigation.
- **UX choices**:
  - Always‑enabled save button with error messages via SnackBars.
  - Using Riverpod to keep widgets simple and reactive.

Conclude your document with a short reflection:
- What you learned about integrating Flutter with Firebase.
- How you might extend the app in the future (e.g., push notifications, role‑based access, more categories).


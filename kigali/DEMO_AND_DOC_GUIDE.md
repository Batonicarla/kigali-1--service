## Demo Video Script (7–12 minutes)

### 1. Intro (30–60s)
- **Who you are & goal**: “This is my Kigali City Services & Places Directory app built with Flutter, Firebase Authentication, and Cloud Firestore.”
- **What it does**: Briefly mention directory, my listings, map, settings, auth, and real‑time updates.

### 2. Firebase Overview (Console on screen) (1–2 min)
- **Show Authentication** tab:
  - Point out an example user: email + UID.
  - Explain: “Each user is created via Firebase Auth; the UID is used as `createdBy` on listings.”
- **Show Firestore** tab:
  - Collection **`users`**: show one example document (fields: `uid`, `email`, `createdAt`).
  - Collection **`listings`**: show fields:  
    - `name`, `category`, `address`, `contactNumber`, `description`,  
      `latitude`, `longitude`, `createdBy`, `createdAt`.

### 3. Authentication Flow (2–3 min)
- On the emulator, **log out** if needed from Settings.
- **Sign up**:
  - Enter a new email/password in the auth screen and tap **Sign Up**.
  - Show the **Verify email** screen in the app.
  - In your browser, open the **verification email**, click the link.
  - Back in the app, tap **“I have verified my email”**:
    - Explain that this calls `user.reload()` and checks `emailVerified` before letting you in.
- In Firebase Console → **Authentication**, show that this user now exists and email is verified.

### 4. Directory & Listings CRUD (3–4 min)
- Go to the **Directory** tab (BottomNavigation item 1).
- Explain UI:
  - Search bar bound to `listingsFilterProvider.setSearch`.
  - Category chips (`All`, `Hospital`, etc.) bound to `listingsFilterProvider.setCategory`.
  - Cards are driven by **`filteredListingsProvider`** which filters the Firestore stream.
- **Create listing**:
  - Tap the **+** icon in the AppBar.
  - Fill in:
    - Name, Category, Address, Contact, Description, Latitude, Longitude.
  - Tap **Create listing**; mention:
    - Uses `ListingRepository.create()`, writing to `listings` collection with `createdBy = currentUser.uid`.
  - Show:
    - Listing appears instantly in Directory and Map View (real‑time via `StreamProvider`).
    - In Firestore Console → `listings`, highlight the new document.
- **Edit listing**:
  - In Directory or My Listings, open the **menu** on your own listing → **Edit**.
  - Change e.g. the address or description; tap **Save changes**.
  - Show Firestore document updating live.
- **Delete listing**:
  - Use the menu → **Delete**, confirm in dialog.
  - Show it disappears from Directory, My Listings, and Map View.
  - Show deletion in Firestore Console.

### 5. My Listings tab (1–2 min)
- Switch to **My Listings** tab.
- Explain:
  - Uses `myListingsStreamProvider`, which queries listings where `createdBy==currentUser.uid`.
  - Same edit/delete menu as Directory, but only your own items are visible.

### 6. Map View & OpenStreetMap (1–2 min)
- Open **Map View** tab.
  - Explain:
    - Uses `flutter_map` + OpenStreetMap tiles.
    - Markers built from the Firestore listings stream.
    - Initial center: Kigali coordinates.
- Tap one listing in **Directory** to open **detail screen**:
  - Show embedded **OpenStreetMap** with a marker.
  - Tap **Open in Google Maps**:
    - Directions open in the Google Maps app or browser using URL scheme.

### 7. Settings (1–2 min)
- Go to **Settings** tab.
- Point out:
  - Profile card: shows email and UID; explain UID is used to link user and listings.
  - “Email verified” row with green check if `emailVerified == true`.
  - **Location‑based notifications** toggle (local only; not connected to real push).
  - **Dark mode** toggle:
    - Explain:
      - Uses a Riverpod `themeModeProvider`.
      - `MaterialApp` reads this to switch between light and dark themes.
  - **Log out** button:
    - Calls `FirebaseAuth.signOut()` via `authControllerProvider`.

### 8. Closing Summary (30–60s)
- Recap:
  - Firebase Auth + Firestore integration.
  - Real‑time CRUD listings.
  - Search/filter, profile/settings, theming.
  - Map integration with OpenStreetMap + external Google Maps directions.

---

## Design & Code Explanation (for 1–2 page document)

Use these headings in your write‑up (you will explain in your own words):

### 1. Firestore Database Structure
- **Collections**:
  - `users`:
    - `uid` (string, Firebase UID)
    - `email` (string)
    - `createdAt` (Timestamp)
  - `listings`:
    - `name` (string)
    - `category` (string; one of Hospital, Police Station, Library, Restaurant, Café, Park, Tourist Attraction)
    - `address` (string)
    - `contactNumber` (string)
    - `description` (string)
    - `latitude` (double)
    - `longitude` (double)
    - `createdBy` (string; user UID)
    - `createdAt` (Timestamp)
- Explain:
  - Why you separate users and listings.
  - How `createdBy` creates a relationship between user and listings.

### 2. State Management with Riverpod
- **Auth**:
  - `firebaseAuthProvider` (wraps `FirebaseAuth.instance`).
  - `authStateChangesProvider` (reactive auth gate).
  - `authControllerProvider` (`StateNotifier`) handles `signIn`, `signUp`, `signOut` and exposes `AuthState` (loading + error).
- **Listings**:
  - `listingRepositoryProvider` encapsulates Firestore reads/writes.
  - `listingsStreamProvider` and `myListingsStreamProvider` expose live streams.
  - `listingsFilterProvider` + `filteredListingsProvider` manage search & category filter.
- **Theme**:
  - `themeModeProvider` (simple `StateProvider<ThemeMode>`) read in `KigaliApp`.

Explain why:
- UI widgets **do not** call Firestore directly.
- All database operations go through the repository + Riverpod providers.

### 3. UI & Navigation Design
- **BottomNavigationBar**:
  - Tabs: Directory, My Listings, Map, Settings.
  - `ScaffoldShell` keeps the current index and swaps screens.
- **Directory**:
  - Search field + chips filter the `filteredListingsProvider`.
  - Card layout inspired by city directory designs.
- **My Listings**:
  - Driven by `myListingsStreamProvider`, showing only user’s listings.
- **Map View**:
  - `flutter_map` with OpenStreetMap tiles.
  - Markers from Firestore listings.
- **Settings**:
  - Shows profile (email + UID), email verification status, toggles, and logout.

### 4. Authentication & Email Verification Flow
- Describe:
  - Sign up → Firebase Auth user created → user profile written to `users` collection.
  - Email verification sent; app blocks access until `emailVerified==true`.
  - “I have verified my email” button calls `user.reload()` and re‑checks.

### 5. Technical Challenges & Trade‑offs
- Examples you can discuss:
  - Matching Android `applicationId` with `google-services.json` package name.
  - Version compatibility between `firebase_core`, `firebase_auth`, and `cloud_firestore`.
  - Handling asynchronous auth states and avoiding `BuildContext` issues.
  - Choosing `flutter_map` + OSM for embedded map, while still using Google Maps externally for directions.
  - UX choices like always‑enabled save button vs. disabled while saving, showing feedback via SnackBars.

---

## How to Record the Demo Video (Step‑by‑Step)

1. **Prepare environment**
   - Open Android emulator with your app installed.
   - Open Firebase Console (Auth + Firestore) in a browser window.
   - Open your IDE (Cursor) showing key files: `main.dart`, `listing_repository.dart`, `directory_screen.dart`, `map_view_screen.dart`, `settings_screen.dart`.
2. **Start screen recording**
   - On Windows, you can use OBS Studio, Xbox Game Bar, or any screen‑record tool.
   - Ensure microphone is on so you can narrate.
3. **Follow the Demo Video Script above in order**
   - Move slowly enough for text to be readable.
   - When you talk about a feature, briefly show the relevant code file in the IDE.
4. **Stop and save the recording**
   - Export as MP4 or the format your course requires.
5. **Upload**
   - Upload the video (e.g., to Google Drive or YouTube unlisted) and include the link in your submission document.

---

## Notes for Your Written Documentation

When you write your own PDF/Doc:
- Use the headings from **Design & Code Explanation** above.
- Insert **screenshots** of:
  - Auth screen, Directory, My Listings, Map View, Settings.
  - Firebase Console (Auth + Firestore documents).
- Explain challenges in **your own words** (do not copy this file verbatim).
- Mention that some UI ideas were inspired by a mockup, but the implementation is your own.


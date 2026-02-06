# Driver Application – Where Is My Bus
## Overview

The Driver App is responsible for real-time location broadcasting of buses and route awareness for drivers.
It acts as the data producer in the Smart Bus Tracking System, continuously sending location updates to Firebase for use by the Admin and User applications.

This app is designed to work even when the app is in the background or killed, ensuring uninterrupted tracking.

---

## Core Responsibilities
- Secure driver authentication
- Live GPS location tracking
- Background location sharing via foreground service
- Route visualization for drivers
- Permission-aware behavior controlled by Admin
- Driver feedback when access is revoked

---

## Feature Breakdown
### Driver Authentication
- Drivers log in using:
  - Username
  - Password
- Credentials are created and managed only by Admin

Drivers cannot self-register, ensuring controlled system access.

---

### Live Location Tracking

- Driver’s GPS location is:
  - Continuously captured
  - Pushed to Cloud Firestore

- Location updates occur:
  - When app is in foreground
  - When app is minimized
  - Even when app is removed from recent apps

This guarantees real-time bus visibility for Admin and Users.

---

### Background Location Sharing (Critical Feature)

Implemented using:
- flutter_background_service
- Android foreground service
- Persistent notification

**Why foreground service?**
- Android prevents background GPS access without it
- Ensures reliability and OS compliance

---

### Permission-Aware Logic
Each driver document contains:
```
isAllowed = true / false
```
Behavior:
- true → Location visible to users
- false → Location hidden from users

Important:
- Location tracking never stops
- Admin still sees live location
- Driver sees a restricted access screen instructing them to contact Admin

This avoids force-stopping drivers while maintaining administrative control.

---

### Route Awareness

- Drivers can see:
  - Assigned route
  - All stops along the route

- Routes are:
  - Stored as List<LatLng> in Firestore
  - Rendered using Google Maps polylines

Note:

Google Directions API is intentionally not used to avoid quota and billing constraints.

---

### Map View
- Displays:
  - Current bus position
  - Route overlay
  - Stops along the route
- Updates in real time as GPS coordinates change

---

## App Architecture
### State Management

The Driver App uses BLoC architecture to separate concerns:

**Primary BLoCs:**

- LoginBloc – authentication logic
- MarkerBloc – map marker & location updates

This ensures:

- Clean UI
- Predictable state changes
- Easy debugging and scaling

---

### Firebase Integration

Firebase services used:
- Firebase Authentication (username/password)
- Cloud Firestore (driver data, routes, permissions)

Firestore acts as the central communication layer between:
- Driver App
- Admin App
- User App

---

### Folder Structure (lib)
```
lib/
│
├── bloc/
│   ├── login_bloc.dart
│   ├── login_event.dart
│   ├── login_state.dart
│   ├── marker_bloc.dart
│   ├── marker_event.dart
│   └── marker_state.dart
│
├── global/
│   └── globalVariables.dart
│
├── screens/
│   ├── animation.dart
│   ├── CustomBigElevatedButton.dart
│   ├── CustomTextFieldWithIcon.dart
│   ├── home_screen.dart
│   ├── login_screen.dart
│   ├── permission_denied.dart
│   ├── splash_screen.dart
│   └── variable.dart
│
├── firebase_options.dart
│
└── main.dart
```

---

## Setup Instructions (After Cloning)
### 1️ Firebase Setup
You must provide your own Firebase configuration:
- Add google-services.json (Android)
- Add GoogleService-Info.plist (iOS)
- Generate firebase_options.dart

These files are intentionally excluded from Git.

---

### 2️ Google Maps API Key
Add your API key via Gradle properties:

*android\gradle.properties*
```
MAPS_API_KEY=YOUR_GOOGLE_MAPS_API_KEY
```
The app uses manifestPlaceholders to inject this securely.

----

### 3️ Permissions
Ensure the following permissions exist in AndroidManifest.xml:
- ACCESS_FINE_LOCATION
- ACCESS_COARSE_LOCATION
- FOREGROUND_SERVICE
- FOREGROUND_SERVICE_LOCATION
- INTERNET

---

### 4️ Run the App
```
flutter clean
flutter pub get
flutter run
```

---



## Design Decisions
- **Tracking ≠ Visibility**
  - Location always collected
  - Visibility controlled by Admin

- **Foreground service**
  - Reliable background tracking
  - Android-compliant

- **Firestore-driven system**
  - No direct app-to-app dependency

- **Operational resilience**
  - App survives kills, backgrounding, and restarts

---

## Known Limitations
- Routes use polylines instead of Directions API
- No offline caching for routes
- Drivers cannot modify routes

---

## Intended Users
- Bus drivers
- Transport operators
  
This app is not intended for public use and is managed entirely by system administrators.

---

## Related Applications
Admin App – Control, permissions, monitoring
- https://github.com/denimsahu/admin.git

User App – Bus discovery & live tracking
- https://github.com/denimsahu/user.git
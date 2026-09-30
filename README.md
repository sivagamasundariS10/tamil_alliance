# 💍 TAMIL ALLIANCE - Matrimony Application

> **"Your Trustworthy Indo Alliance"**  
> *Developed for Indo Alliance Pvt Limited*

---

## 📌 1. Project Overview

**Tamil Alliance** is a modern, high-security matrimony mobile application tailored for Tamil matrimonial alliances worldwide. It seamlessly integrates traditional Vedic horoscope compatibility with contemporary matchmaking capabilities, end-to-end privacy controls, government ID verification badges, and real-time communication channels.

---

## 🏗️ 2. Project Directory Structure

```
tamil_alliance/
├── .gitignore                      # Git tracking rules (Build artifacts, IDE configs, Terminal screenshots excluded)
├── pubspec.yaml                    # Flutter dependencies, SDK constraints & Asset bundle registry
├── README.md                       # Comprehensive Technical Documentation
│
├── assets/                         # Static Assets Directory
│   ├── icons/                      # Custom vector icons & badges (.gitkeep)
│   └── images/                     # Graphic illustrations, avatars & backgrounds (.gitkeep)
│
└── lib/                            # Application Source Code
    ├── main.dart                   # Main Application Entry Point
    │
    ├── core/                       # Global Core Utilities & Design System
    │   ├── constants/
    │   │   ├── app_assets.dart     # Static asset path mappings
    │   │   ├── app_colors.dart     # Centralized brand color definitions & hex constants
    │   │   └── app_strings.dart    # App-wide string constants
    │   ├── theme/
    │   │   └── app_theme.dart      # Material 3 light theme definitions
    │   └── utils/
    │       └── validators.dart     # Input validation rules (Phone, Email, OTP, Password)
    │
    └── screens/                    # Feature & UI Screen Modules
        ├── splash/                 # Splash screen with animated dot pulse
        ├── welcome/                # Onboarding & landing screen
        ├── auth/                   # Authentication & Account Security screens
        │   ├── mobile_auth_screen.dart
        │   ├── otp_login_screen.dart
        │   ├── otp_verification_screen.dart
        │   ├── password_login_screen.dart
        │   └── account_security_screen.dart
        ├── registration/           # 7-Step Multi-step Onboarding Flow
        │   ├── basic_info_screen.dart
        │   ├── education_career_screen.dart
        │   ├── family_details_screen.dart
        │   ├── partner_preferences_screen.dart
        │   ├── photos_privacy_screen.dart
        │   ├── govt_id_verification_screen.dart
        │   └── registration_success_screen.dart
        ├── home/                   # Main Dashboard Screen
        ├── alliance/               # Alliance Discovery & Search Filters
        │   ├── alliance_screen.dart
        │   └── alliance_filter_screen.dart
        ├── chat/                   # Messaging & Conversation Details
        │   ├── chat_screen.dart
        │   └── chat_detail_screen.dart
        ├── interests/              # Sent, Received & Accepted Interests
        ├── premium/                # Membership Tiers & Subscription Plans
        ├── profile/                # User Profile Management
        │   ├── my_profile_screen.dart
        │   ├── edit_profile_screen.dart
        │   └── edit_preferences_screen.dart
        └── settings/               # App Settings & Privacy Controls
            ├── settings_screen.dart
            └── privacy_settings_screen.dart
```

---

## 🔄 3. Application Flow & Navigation Lifecycle

```mermaid
graph TD
    A[Splash Screen] -->|3s Auto Timer| B[Welcome Screen]
    B -->|Register Free| C[Registration Step 1: Basic Info]
    B -->|Login / OTP Login| D[OTP Login / Password Login]
    
    subgraph Registration Flow (7 Steps)
        C --> C1[Step 2: Education & Career]
        C1 --> C2[Step 3: Family Details]
        C2 --> C3[Step 4: Partner Preferences]
        C3 --> C4[Step 5: Photos & Privacy]
        C4 --> C5[Step 6: Govt ID Verification]
        C5 --> C6[Step 7: Registration Success]
    end
    
    C6 --> E[Home Dashboard]
    D -->|Verify OTP / Sign In| E
    
    subgraph Main Navigation
        E <--> F[Alliance Screen & Filters]
        E <--> G[Chat Screen & Chat Detail]
        E <--> H[Interests Screen]
        E <--> I[Premium Plans Screen]
        E <--> J[My Profile & Edit Screens]
        E <--> K[Settings & Privacy Settings]
    end
```

---

## 🎨 4. Complete Design System & Color Palette (`AppColors`)

The application utilizes a curated, authentic Royal South Indian Matrimonial color scheme:

| Color Name | Hex Code | Description & Usage |
|---|---|---|
| **Primary Maroon** | `#7A0C2E` / `#701A33` | Deep Rich Crimson Maroon - Primary brand color, AppBars, active switches, main CTA buttons |
| **Primary Dark** | `#5E0520` | Dark Crimson tone for active pressed states and header shadows |
| **Primary Light** | `#9E1B42` | Light Crimson accent for highlights |
| **Royal Gold** | `#E5B84B` | Metallic Gold for premium badges, borders, star ratings, and VIP accents |
| **Gold Light** | `#F3D27C` | Light gold accent for secondary badges |
| **Gold Dark** | `#B88A24` | Deep gold border tone |
| **Soft Gold / Cream** | `#FFF4D9` / `#FDF5E6` | Background tint for Gold & VIP membership pills |
| **Background (Main)** | `#FAF8F8` / `#FCFAF6` / `#FBF9F9` | Warm ivory soft background across screens |
| **Surface / Card** | `#FFFFFF` | Pure white card surfaces and dialog containers |
| **Text Primary** | `#1E293B` / `#1E1E1E` | Slate dark text for high legibility and contrast |
| **Text Secondary** | `#64748B` / `#6B7280` | Muted subtitle and description text |
| **Text Muted** | `#9CA3AF` | Placeholder and inactive hint text |
| **Success** | `#10B981` | Emerald green for verified badges, online indicators, and success snackbars |
| **Error** | `#EF4444` | Red for validation errors and decline actions |
| **Warning / Amber** | `#F59E0B` / `#D97706` | Amber for alerts and security badges |
| **Border / Divider** | `#EDE9E3` / `#E5E7EB` / `#F1F5F9` | Subtle dividers and card outline borders |

---

## 🔤 5. Typography & Font System

The application combines the classical Roman-inspired **Cinzel** typeface for iconic brand identity, heritage **Serif** for section headings, and **Plus Jakarta Sans** for interactive UI elements.

### 1. Brand Header Font: `Cinzel` (Classical Roman Royal Serif)
* **Font Family**: `Cinzel` (via `google_fonts: ^6.2.1` / `GoogleFonts.cinzel`)
* **Where It Is Used**:
  * **Splash Screen**: `TAMIL ALLIANCE` brand insignia (`fontSize: 27`, `fontWeight: FontWeight.w800`, `letterSpacing: 2.8`) & `INDO ALLIANCE PVT LIMITED` footer (`fontSize: 11`, `fontWeight: FontWeight.w700`, `letterSpacing: 1.0`)
  * **Welcome Screen**: `TAMIL ALLIANCE` top brand header (`fontSize: 22`, `fontWeight: FontWeight.w800`, `letterSpacing: 1.2`)
* **Rationale**: Cinzel conveys timeless dignity, royal craftsmanship, and classical matrimonial heritage.

### 2. Section Headings: `serif` (Traditional Serif)
* **Font Family**: `'serif'` (Built-in Flutter Serif engine / Roboto Serif on Android / New York Serif on iOS)
* **Where It Is Used**:
  * **7-Step Registration Flow**: Section headings (`Basic Information`, `Education & Career`, `Family Details`, `Partner Preferences`, `Photo Privacy`, `ID Verification`, `Registration Success`)
  * **Home Dashboard**: Section titles (`Today's Matches`, `New Recommendations`)
  * **Privacy Settings**: `Mobile Number Privacy` title (`fontSize: 18`, `fontWeight: FontWeight.w800`)
  * **Alliance & Chat**: Profile card names and category headers

### 3. Body, Controls & Form Elements: `Plus Jakarta Sans` (Modern & Geometric Sans-Serif)
* **Font Family**: `Plus Jakarta Sans` (via `google_fonts: ^6.2.1` / `GoogleFonts.plusJakartaSansTextTheme`)
* **Where It Is Used**:
  * **Form Input Fields & Labels**: Mobile Number, Name, Email, Password, OTP Inputs (`fontSize: 14`, `fontWeight: FontWeight.w600`)
  * **Dropdowns & Selection Chips**: Caste, Sub-sect, Star/Raasi, Education, Annual Income
  * **Action Buttons**: `Continue`, `Submit`, `Sign In`, `Register Free`, `Save Privacy Preferences` (`fontSize: 13.5` - `16`, `fontWeight: FontWeight.w700`/`w800`)
  * **Subtitles & Information Text**: Explanatory notes, terms, and privacy descriptions (`fontSize: 10.5` - `12`, `fontWeight: FontWeight.w400`/`w600`)
  * **Badges & Tags**: `Gold & VIP`, `SECURE PRIVACY CONTROL`, `Verified Badge` (`fontSize: 9.5`, `fontWeight: FontWeight.w800`, `letterSpacing: 0.3`)
* **Rationale**: Plus Jakarta Sans is a contemporary geometric grotesque typeface that delivers ultra-clean legibility, crisp rendering, and a state-of-the-art modern premium feel across mobile displays.

---

## 📱 6. Comprehensive Module & Screen Breakdown

### 1. Splash Module (`lib/screens/splash/splash_screen.dart`)
* **Purpose**: Animated launch screen displaying the Tamil Alliance insignia, synchronized dot pulse animations, and automated routing.
* **Colors**: Background `#7A0C2E` (Maroon), Accents `#E5B84B` (Gold), Text `#FFFFFF` / `#F0DCD8`.
* **Typography**: `'serif'` (26px, Bold, letter spacing 1.8) for brand name; Sans-serif (11.5px) for tagline.
* **Behavior**: Fades in over 1200ms and automatically transitions to `WelcomeScreen` after 3000ms.

### 2. Welcome Module (`lib/screens/welcome/welcome_screen.dart`)
* **Purpose**: Visual onboarding landing page introducing verified profiles, Vedic matching, and direct entry points.
* **Colors**: Background `#FAF8F8`, Brand Maroon `#701A33`, Badge `#F3E8FF`, Card `#FFFFFF`, Border `#EDE9E3`.
* **Typography**: `'serif'` (25px, Bold) for heading; Sans-serif (11px–14px) for body text and buttons.
* **Actions**: Routes to `BasicInfoScreen` (Register) or `OtpLoginScreen` / `PasswordLoginScreen` (Sign In).

### 3. Auth Module (`lib/screens/auth/`)
* **`mobile_auth_screen.dart`**: Phone number entry with country code prefix (`+91`), format validation, and OTP request handler.
* **`otp_login_screen.dart` & `otp_verification_screen.dart`**: Individual 4/6-digit numeric input boxes with auto-focus, countdown resend timer, and instant verification.
* **`password_login_screen.dart`**: Email/mobile authentication with secure password field and show/hide toggle.
* **`account_security_screen.dart`**: Security management including password modification, biometric authentication settings, and active session monitoring.
* **Colors**: Active borders `#701A33`, Inactive borders `#E2E8F0`, Error highlights `#EF4444`.

### 4. Registration Flow (`lib/screens/registration/`)
1. **`basic_info_screen.dart` (Step 1/7)**: Profile creation entity (Self/Son/Daughter/Sibling), Gender, Full Name, DOB, Religion, Caste, and Sub-sect.
2. **`education_career_screen.dart` (Step 2/7)**: Highest qualification, College/University, Employment type, Occupation, and Annual Income range.
3. **`family_details_screen.dart` (Step 3/7)**: Family values (Orthodox/Traditional/Moderate/Liberal), Family status, Parents' occupation, and Siblings details.
4. **`partner_preferences_screen.dart` (Step 4/7)**: Expected age gap, height range, education requirements, marital status, and location filters.
5. **`photos_privacy_screen.dart` (Step 5/7)**: Multi-photo uploader with profile photo guidelines and preliminary visibility preferences.
6. **`govt_id_verification_screen.dart` (Step 6/7)**: Trust verification upload for Government photo ID (Aadhaar, Passport, Driving License, or Voter ID).
7. **`registration_success_screen.dart` (Step 7/7)**: Animated celebration screen revealing the unique Matrimony Profile ID (e.g., `TA-882941`).
* **Colors**: Step progress bar `#701A33`, Inactive tracker `#E2E8F0`, Card backgrounds `#FFFFFF`.

### 5. Home Module (`lib/screens/home/home_screen.dart`)
* **Purpose**: Central dashboard showcasing curated daily recommendations, horoscope-compatible matches, profile stats, and discovery shortcuts.
* **Colors**: Header Maroon gradient, Gold status badges `#E5B84B`, Card surfaces `#FFFFFF`.

### 6. Alliance Module (`lib/screens/alliance/`)
* **`alliance_screen.dart`**: Grid/List discovery feed of prospective brides and grooms with photo gallery preview, trust badge, horoscope score, and "Express Interest" CTA.
* **`alliance_filter_screen.dart`**: Filter drawer by Age, Height, Religion, Caste, Star (Nakshatra), Raasi, Education, City, and Income.
* **Colors**: Filter pill selection `#FDF2F4` with maroon text `#701A33`, Card borders `#EDE9E3`.

### 7. Chat & Messaging Module (`lib/screens/chat/`)
* **`chat_screen.dart`**: Conversation inbox with unread count badges, active online dots, and message previews.
* **`chat_detail_screen.dart`**: Real-time 1-on-1 messaging screen with bubble layouts, media sharing actions, and calling shortcuts.
* **Colors**: Sender message bubble `#701A33` (white text), Receiver bubble `#F1F5F9` (dark text `#1E293B`), Online status `#10B981`.

### 8. Interests Module (`lib/screens/interests/interests_screen.dart`)
* **Purpose**: Three-tab management for **Received**, **Sent**, and **Accepted** marriage alliance interests with Accept/Decline actions.
* **Colors**: Active tab indicator `#701A33`, Accept CTA `#10B981`, Decline CTA `#EF4444`.

### 9. Premium Module (`lib/screens/premium/premium_screen.dart`)
* **Purpose**: Premium subscription catalog highlighting **Silver**, **Gold**, and **VIP Royal** membership tiers.
* **Colors**: Gold headers `#E5B84B`, Maroon CTA `#701A33`, Soft cream background `#FFFBEB`.

### 10. Profile Module (`lib/screens/profile/`)
* **`my_profile_screen.dart`**: Complete user biodata preview as visible to prospective matches.
* **`edit_profile_screen.dart`**: Form editor for personal, educational, professional, and family details.
* **`edit_preferences_screen.dart`**: Partner expectation criteria editor.

### 11. Settings & Privacy Module (`lib/screens/settings/`)
* **`settings_screen.dart`**: App preferences, notification settings, blocked members list, and support links.
* **`privacy_settings_screen.dart`**: Granular contact and photo privacy controls:
  * **Mobile Number Privacy**:
    * *Visible to Accepted Matches Only* (Default: **ON**)
    * *Visible to Verified Premium Members* (Default: **ON**)
    * *Hide from Everyone (Strict Privacy)* (Default: **ON**)
  * **Photo Privacy**:
    * *Open to View* (Default: **ON**)
    * *Show to Premium Only* (Default: **ON**)
    * *Request-to-View mode* (Default: **ON**)
    * *Blur photos for unverified profiles* (Default: **ON**)
* **Colors**: Header shield `#B45309`, Maroon switch thumb/track `#701A33`, Inactive track `#DDE2ED`.

---

## 🔒 7. Assets & Git Tracking Configuration

### 📁 Asset Registration (`pubspec.yaml`)
Assets are bundled at the directory level to eliminate missing file path runtime exceptions:
```yaml
flutter:
  uses-material-design: true
  assets:
    - assets/images/
    - assets/icons/
```

### 🛡️ `.gitignore` Security Rules
The [.gitignore](file:///c:/Users/sivagamasundariS/Desktop/Matrimony/tamil_alliance/.gitignore) is comprehensively configured to ensure build artifacts and debugging screenshots are strictly excluded from remote commits:
* **Flutter & Dart**: `build/`, `.dart_tool/`, `.pub/`, `.pub-cache/`, `*.symbols`
* **IDE Files**: `.idea/`, `*.iml`, `.vscode/`
* **Terminal Screenshots & Captures**: `flutter_*.png`, `flutter_*.jpg`, `screenshot*.png`, `/screenshots/`, `*.screenshot.*`
* This guarantees that pressing `s` in the Flutter terminal will **never** commit local debug screenshots into version control.

---

## 💻 8. Step-by-Step Terminal Execution Guide

Follow these exact commands to run and test the project from your terminal:

### Step 1: Navigate to Project Root
Open PowerShell or your preferred terminal and navigate to the project directory:
```powershell
cd c:\Users\sivagamasundariS\Desktop\Matrimony\tamil_alliance
```

### Step 2: Check Flutter Health & Toolchains
Verify that the Flutter SDK, Dart SDK, and platform dependencies are correctly installed:
```powershell
flutter doctor
```

### Step 3: Install Package Dependencies
Fetch and link all packages listed in `pubspec.yaml`:
```powershell
flutter pub get
```

### Step 4: List Available Devices & Emulators
Display all connected Android physical devices, emulators, Chrome, and Windows targets:
```powershell
flutter devices
```

### Step 5: Run the Project
To run on your default connected device or emulator:
```powershell
flutter run
```

To run specifically on a selected target:
* **Android Emulator / Physical Device**:
  ```powershell
  flutter run -d android
  ```
* **Google Chrome (Web)**:
  ```powershell
  flutter run -d chrome
  ```
* **Windows Desktop**:
  ```powershell
  flutter run -d windows
  ```

### Step 6: Interactive Terminal Controls
While `flutter run` is active in your terminal:
* Press `r` -> **Hot Reload** (Instant UI state refresh without losing state)
* Press `R` -> **Hot Restart** (Reinitializes the entire application state)
* Press `h` -> **List Help** (Show all available Flutter interactive commands)
* Press `q` -> **Quit** (Terminates the running application session)

### Step 7: Build Production Android APK (Optional)
To generate an optimized release APK:
```powershell
flutter build apk --release
```
The compiled binary will be located at:
`build/app/outputs/flutter-apk/app-release.apk`

---

## 📜 9. Architecture Summary Table

| Category | Specification Details |
|---|---|
| **Framework** | Flutter (Dart SDK `>=3.13.4 <4.0.0`) |
| **Design Language** | Material 3 with Custom Tamil Matrimony Aesthetics |
| **Primary Theme Colors** | Crimson Maroon (`#7A0C2E` / `#701A33`), Royal Gold (`#E5B84B`) |
| **Typography System** | Heritage `'serif'` for Headings; `Plus Jakarta Sans` for UI, Controls & Body |
| **Architecture Pattern** | Feature-Driven Modular Architecture (`core/`, `screens/`, `constants/`) |
| **State Management** | Native StatefulWidgets with modular component separation |

# Setup Guide

Phase 4 – Flutter Project Setup · 2026-11-11

How to get the project running on a developer machine.

## 1. Requirements

| Tool | Version used | Needed for |
|---|---|---|
| Flutter (stable) | 3.47.7 | Everything |
| Dart | 3.13.5 (bundled with Flutter) | Everything |
| Git | any recent | Version control |
| Android Studio + Android SDK, platform tools, an emulator (AVD) or USB device | latest | **Android builds** |
| macOS + Xcode + CocoaPods | latest | **iOS builds** (cannot be done on Windows) |
| Chrome | any | Quick local checks (`-d chrome`) |
| VS Code + Flutter/Dart extensions (or Android Studio) | latest | Development |

Check the machine:

```bash
flutter doctor -v
```

> **Current machine status (2026-11-11):** Flutter ✅, Chrome ✅, **Android SDK ❌ not installed**, Visual Studio ❌ (only needed for Windows desktop — not a target). Android Studio must be installed before Android builds; iOS requires a Mac.

## 2. Get the Code and Dependencies

```bash
git clone <repository-url>
cd masjid_system
flutter pub get
```

## 3. Verify

```bash
flutter analyze        # expect: No issues found!
flutter test           # expect: All tests passed!
```

## 4. Run the App

```bash
flutter devices                    # list available devices
flutter run -d <android-device-id> # Android emulator / phone
flutter run -d <ios-device-id>     # iPhone / simulator (macOS only)
flutter run -d chrome              # quick check in the browser
```

Expected result: the green **Splash** screen (logo, Bismillah, "Masjid Management App") for ~1.5 s, then the **Home** placeholder ("Project setup complete").

### Android setup (one time, Windows)

1. Install Android Studio → open it → SDK Manager: install latest Android SDK Platform, Build-Tools, Command-line Tools, Platform-Tools.
2. Device Manager → create a virtual device (e.g. Pixel, recent Android image).
3. `flutter doctor --android-licenses` and accept all.
4. `flutter doctor` should show Android toolchain ✅.
5. `flutter emulators --launch <id>` then `flutter run`.

### iOS setup (one time, macOS)

1. Install Xcode from the App Store, then `sudo xcode-select --switch /Applications/Xcode.app` and `sudo xcodebuild -runFirstLaunch`.
2. Install CocoaPods (`brew install cocoapods`).
3. Open `ios/Runner.xcworkspace` once to set the signing team.
4. `open -a Simulator` then `flutter run`.

## 5. Useful Commands

| Command | Purpose |
|---|---|
| `flutter pub get` | Install dependencies |
| `flutter analyze` | Static analysis / lints |
| `dart format lib test` | Format code |
| `flutter test` | Run all tests |
| `flutter test test/core/theme/app_theme_test.dart` | Run one test file |
| `flutter build apk --release` | Android release APK (needs Android SDK) |
| `flutter build appbundle` | Play Store bundle |
| `flutter build ipa` | iOS archive (macOS) |
| `flutter build web` | Web build (local check only) |
| `flutter clean` | Remove build outputs when things behave strangely |

## 6. Project Identity

| Item | Value | Note |
|---|---|---|
| Dart package | `masjid_management` | `pubspec.yaml` |
| App display name | Masjid Management App | Android `AndroidManifest.xml` label, iOS `CFBundleDisplayName` |
| Android applicationId | `com.example.masjid_system` | **Must be changed before store release** to a real reverse-domain ID (e.g. `com.<yourorg>.masjid`) |
| iOS bundle identifier | `com.example.masjidSystem` (template default) | Same — change before release |
| Version | 1.0.0+1 | `pubspec.yaml` |

## 7. Conventions

- Branch from `main`; small pull requests; `flutter analyze` and `flutter test` must pass.
- Follow [architecture.md](architecture.md) and [folder-structure.md](folder-structure.md).
- Use design tokens from `lib/core/theme/` — never raw hex colors in screens.
- No secrets in the repository (Supabase/Firebase keys come later via environment config).

# Architecture

Phase 4 – Flutter Project Setup · 2026-11-11

How the Flutter app is organized and why. Folder-by-folder details are in [folder-structure.md](folder-structure.md); packages in [dependencies.md](dependencies.md).

---

## 1. Goals

- **Feature-based:** each feature (prayer times, donations, events…) lives in its own folder and can be built, tested and changed independently.
- **UI separated from logic:** widgets only display state and forward user actions; decisions and data access live outside widgets.
- **Simple:** no code generation, no heavy architecture frameworks. Three runtime packages beyond Flutter's Material library.
- **Ready for later phases:** Supabase, Firebase, localization and offline cache plug into defined places without restructuring.

## 2. High-Level Structure

```
lib/
├── main.dart          Entry point: bindings, licenses, ProviderScope
├── app.dart           Root widget: MaterialApp.router + theme
├── core/              Shared, feature-agnostic building blocks
│   ├── theme/         Design-system tokens → ThemeData
│   ├── constants/     App-wide constants
│   ├── utils/         Pure helpers (date formatting, licenses)
│   └── widgets/       Reusable widgets used by 2+ features
├── features/          One folder per feature (independent)
├── services/          App-wide services (Supabase, notifications, storage — later)
├── models/            Data models shared by several features
└── routing/           GoRouter configuration and route paths
```

## 3. Layers Inside a Feature

Each feature uses up to three layers. A layer is created **only when the feature needs it** (avoid empty boilerplate).

```
features/<feature>/
├── presentation/     Screens and feature-specific widgets (UI only)
├── application/      Riverpod providers/notifiers: state, use-case logic, decisions
└── data/             Repositories and data sources (Supabase, local cache) — added in backend phases
```

Dependency direction (one way only):

```
presentation  ──►  application  ──►  data  ──►  services / models
     │                                   
     └──► core (theme, widgets, utils)     (any layer may use core)
```

Rules:
1. `presentation` never calls Supabase, storage or HTTP directly — it reads providers.
2. `application` contains no widgets (no `BuildContext` except for navigation callbacks passed in).
3. A feature **must not import another feature's internals**. Shared things move to `core/`, `models/` or `services/`.
4. Widgets used by only one feature stay in that feature's `presentation/widgets/`; when a second feature needs one, it moves to `core/widgets/`.

### Example already in the code — Splash

| Layer | File | Responsibility |
|---|---|---|
| application | `features/splash/application/app_startup_provider.dart` | Runs start-up work and **decides** the next route (today: wait 1.5 s → Home; later: session & version checks) |
| presentation | `features/splash/presentation/splash_screen.dart` | Shows the brand screen and **reacts** to the provider by navigating |

## 4. State Management — Riverpod

- `ProviderScope` wraps the app in `main.dart`.
- Providers are declared manually (`Provider`, `FutureProvider`, `NotifierProvider`) — **no code generation**, so no `build_runner` step.
- Typical use per feature:
  - `FutureProvider` / `AsyncNotifierProvider` for data loading (prayer times, donations list).
  - `NotifierProvider` for form/screen state (record donation form, attendance session).
- Testing: providers can be overridden in `ProviderScope(overrides: [...])`, so screens are tested without a backend.

## 5. Navigation — go_router

- One `GoRouter`, exposed as `appRouterProvider` (`routing/app_router.dart`) so redirects can later depend on auth/mosque state.
- Path constants in `routing/app_routes.dart`; never hard-code path strings in features.
- Unknown routes / bad deep links → `NotFoundScreen`.
- Planned (when Home is built): `StatefulShellRoute.indexedStack` for the 5-tab bottom navigation with an independent back stack per tab, as specified in `docs/design/navigation-flow.md`.

## 6. Theming

The theme is built from the approved design system (`docs/design/`):

| File | Content |
|---|---|
| `core/theme/app_colors.dart` | All color tokens (brand, green/gold/neutral scales, semantic) |
| `core/theme/app_typography.dart` | Inter / Noto Sans Arabic / Amiri, Material 3 text roles mapped to the type scale, countdown & figure styles with tabular numerals |
| `core/theme/app_spacing.dart` | Spacing (4/8 grid), radius, minimum sizes |
| `core/theme/app_semantic_colors.dart` | `ThemeExtension` for gold variants, status colors, gradients (no slot in `ColorScheme`) |
| `core/theme/app_theme.dart` | `ThemeData` (light): `ColorScheme` + component themes (buttons, inputs, cards, chips, navigation bar, sheets, dialogs, snackbars…) |

Rules:
- Screens read colors from `Theme.of(context).colorScheme` or `context.semanticColors`, not raw hex values.
- Gold is never used for text on white (2.10:1) — enforced by a contrast test in `test/core/theme/app_theme_test.dart`.
- Dark mode (v1.1) = add a dark `ColorScheme` + `AppSemanticColors.dark`; screens need no changes.

## 7. Material Library Note (Flutter 3.47)

In this Flutter version the Material and Cupertino libraries are published as separate packages (`material_ui`, `cupertino_ui`). `go_router` and `flutter_riverpod` already depend on `material_ui`, so the app imports **`package:material_ui/material_ui.dart`** (not the legacy `package:flutter/material.dart`). This keeps one Material implementation — and one `ThemeData` — across the app and its packages. Non-UI framework imports (`package:flutter/services.dart`, `foundation.dart`) are unchanged.

## 8. Where Later Phases Plug In

| Concern | Location |
|---|---|
| Supabase client & auth | `services/` (client), `features/authentication/` (UI + providers), router redirect in `routing/app_router.dart` |
| Push notifications (FCM) | `services/notification_service.dart`, `features/notifications/` |
| Local storage / cache | `services/` (wrapping `shared_preferences` / secure storage) |
| Localization (EN / SO / AR + RTL) | `lib/l10n/` (ARB files via `flutter gen-l10n`), configured in `app.dart` |
| Shared data models | `models/` |
| Prayer-time calculation | `features/prayer_times/` (`application/` + calculation package) |

## 9. Testing Strategy

| Type | Location | Now |
|---|---|---|
| Unit tests (theme, utils, providers) | `test/core/…`, `test/features/<feature>/…` | Theme colors & contrast tests |
| Widget tests (screens, navigation) | `test/…` | Splash → Home navigation |
| Responsive tests (phone sizes, 200% text) | `test/responsive_layout_test.dart` | 4 device profiles |
| Integration tests (real device) | `integration_test/` | Added with first real feature |

Test folders mirror `lib/`.

# Dependencies

Phase 4 – Flutter Project Setup · 2026-11-11

Principle: **add a package only when a feature needs it.** Each package below has a reason, a location, and an owner phase.

## 1. Installed

### Runtime

| Package | Version | Why it is needed | Where it is used |
|---|---|---|---|
| `material_ui` | ^1.11.0 | Flutter's official Material library. Since Flutter 3.47 it is published as a separate package; `go_router` and `flutter_riverpod` depend on it, so the app uses it directly to keep a single Material implementation and theme | Every UI file (`import 'package:material_ui/material_ui.dart'`) |
| `go_router` | ^18.1.4 | Official declarative router (Flutter team): URL-based routes, deep links from notifications, redirects (auth later), bottom-nav shell with per-tab stacks | `lib/routing/` |
| `flutter_riverpod` | ^3.5.0 | State management that separates UI from logic, is testable via overrides, and needs no code generation | `main.dart` (ProviderScope), `routing/app_router.dart`, `features/*/application/` |
| `intl` | ^0.20.3 | Date, time, number and currency formatting; base for localization (EN/SO/AR) | `core/utils/date_formatter.dart`; later money & prayer times |
| `cupertino_icons` | ^1.0.8 | Already in template; iOS-style icons (share, back chevron) where iOS conventions apply | Later, iOS-specific icons |

### Development

| Package | Why |
|---|---|
| `flutter_test` (SDK) | Unit and widget tests |
| `flutter_lints` ^6.0.0 | Recommended lint rules (plus extra rules in `analysis_options.yaml`) |

### Fonts (bundled assets, not packages)

| Font | Files | License |
|---|---|---|
| Inter | Regular 400, Medium 500, SemiBold 600, Bold 700 | SIL OFL 1.1 |
| Noto Sans Arabic | Regular, Medium, SemiBold, Bold | SIL OFL 1.1 |
| Amiri | Regular, Bold | SIL OFL 1.1 |

Fonts are bundled in `assets/fonts/` (no runtime download → works offline). The `google_fonts` package was intentionally **not** used. Licenses are registered in the app's license page (`core/utils/font_licenses.dart`).

## 2. Considered and Deferred

| Need | Package (planned) | Why not now | Phase |
|---|---|---|---|
| Local storage (onboarding flag, language) | `shared_preferences` | No feature stores data yet | With onboarding/settings |
| Secure token storage | `flutter_secure_storage` | Needed only with authentication | Authentication |
| Localization codegen | `flutter_localizations` (SDK) + `flutter gen-l10n` | Requires final strings; Somali needs a fallback for Material localizations | Localization step |
| SVG icons/illustrations | `flutter_svg` | No SVG assets yet | When icon set is delivered |
| Prayer-time calculation | `adhan` | Prayer feature not started | Prayer times |
| Hijri calendar | e.g. `hijri` | Prayer/home features | Prayer times |
| Backend | `supabase_flutter` | Explicitly excluded in Phase 4 | Backend phase |
| Push notifications | `firebase_core`, `firebase_messaging` | Explicitly excluded in Phase 4 | Notifications phase |
| Local notifications | `flutter_local_notifications` | Prayer reminders | Prayer times |
| Icons | Material Symbols package | Built-in Material **rounded** icons cover current needs | Re-evaluate with design icon set |

## 3. Rejected

| Package | Reason |
|---|---|
| `riverpod_generator` / `build_runner` | Code generation adds build steps; manual providers are enough |
| `get` / GetX | Mixes routing, state and DI; harder to test; conflicts with go_router |
| `bloc` + `flutter_bloc` | More boilerplate than needed for this team size |
| `freezed`, `json_serializable` | Revisit when data models arrive; avoid codegen until clearly worth it |
| `google_fonts` | Runtime fetching; fonts are bundled instead |

## 4. Upgrade Policy

- Run `flutter pub outdated` before each release; upgrade minor versions regularly.
- Major upgrades on a separate branch with full test run.
- `pubspec.lock` is committed (this is an app, not a library).

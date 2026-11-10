import 'package:flutter_test/flutter_test.dart';
import 'package:masjid_management/core/theme/app_colors.dart';
import 'package:masjid_management/core/theme/app_semantic_colors.dart';
import 'package:masjid_management/core/theme/app_theme.dart';
import 'package:masjid_management/core/theme/app_typography.dart';
import 'package:material_ui/material_ui.dart';

/// WCAG 2.1 contrast ratio between two colors.
double contrastRatio(Color a, Color b) {
  final la = a.computeLuminance();
  final lb = b.computeLuminance();
  final lighter = la > lb ? la : lb;
  final darker = la > lb ? lb : la;
  return (lighter + 0.05) / (darker + 0.05);
}

void main() {
  group('Brand colors', () {
    test('match the approved palette', () {
      expect(AppColors.primary, const Color(0xFF176B45));
      expect(AppColors.white, const Color(0xFFFFFFFF));
      expect(AppColors.gold, const Color(0xFFD4AF37));
      expect(AppColors.darkText, const Color(0xFF1F2937));
      expect(AppColors.lightBackground, const Color(0xFFF7F9F7));
    });
  });

  group('Light theme', () {
    final theme = AppTheme.light;

    test('uses brand colors in the color scheme', () {
      expect(theme.useMaterial3, isTrue);
      expect(theme.colorScheme.primary, AppColors.primary);
      expect(theme.colorScheme.onPrimary, AppColors.white);
      expect(theme.colorScheme.secondary, AppColors.gold);
      expect(theme.colorScheme.onSecondary, AppColors.darkText);
      expect(theme.colorScheme.onSurface, AppColors.darkText);
      expect(theme.scaffoldBackgroundColor, AppColors.lightBackground);
    });

    test('registers semantic colors extension', () {
      expect(theme.extension<AppSemanticColors>(), isNotNull);
    });

    test('uses Inter with Arabic fallback', () {
      expect(
        theme.textTheme.bodyLarge?.fontFamily,
        AppTypography.latinFontFamily,
      );
      expect(
        theme.textTheme.bodyLarge?.fontFamilyFallback,
        contains(AppTypography.arabicFontFamily),
      );
    });
  });

  group('Accessibility contrast (WCAG AA, normal text >= 4.5)', () {
    final pairs = <String, (Color, Color)>{
      'white on primary': (AppColors.white, AppColors.primary),
      'dark text on white': (AppColors.darkText, AppColors.white),
      'dark text on light background': (
        AppColors.darkText,
        AppColors.lightBackground,
      ),
      'dark text on gold (gold buttons)': (AppColors.darkText, AppColors.gold),
      'gold-300 on green-800 (countdown)': (
        AppColors.gold300,
        AppColors.green800,
      ),
      'gold-800 on white (gold text)': (AppColors.gold800, AppColors.white),
      'secondary text on light background': (
        AppColors.neutral500,
        AppColors.lightBackground,
      ),
      'error on white': (AppColors.error, AppColors.white),
      'warning on white': (AppColors.warning, AppColors.white),
      'info on white': (AppColors.info, AppColors.white),
    };

    pairs.forEach((name, pair) {
      test(name, () {
        expect(contrastRatio(pair.$1, pair.$2), greaterThanOrEqualTo(4.5));
      });
    });

    test('gold on white is below AA (must never be used for text)', () {
      expect(contrastRatio(AppColors.gold, AppColors.white), lessThan(3));
    });
  });
}

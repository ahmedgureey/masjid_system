import 'package:material_ui/material_ui.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';

/// A Qur'anic verse as real, selectable right-to-left text (Amiri Quran),
/// followed by its reference between thin gold ornamental dividers.
class QuranVerse extends StatelessWidget {
  const QuranVerse({super.key, required this.verse, required this.reference});

  final String verse;

  /// e.g. "(الجن: 18)".
  final String reference;

  @override
  Widget build(BuildContext context) {
    // Screen-based cap (LayoutBuilder is not usable here: the welcome screen
    // measures this widget with IntrinsicHeight).
    final maxWidth = MediaQuery.sizeOf(context).width;
    return Directionality(
      // Qur'anic text is always right-to-left, whatever the app language.
      textDirection: TextDirection.rtl,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SelectableText(
            verse,
            textAlign: TextAlign.center,
            style: AppTypography.quranVerse.copyWith(color: AppColors.green800),
          ),
          const SizedBox(height: AppSpacing.space1),
          Row(
            children: [
              const Expanded(
                child: _GoldDivider(fadeTo: Alignment.centerRight),
              ),
              const _Ornament(),
              // Natural width, capped at half the screen so it wraps (very
              // large text) instead of pushing past the edge. The dividers
              // take all remaining space.
              ConstrainedBox(
                constraints: BoxConstraints(maxWidth: maxWidth * 0.5),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.space2,
                  ),
                  child: Text(
                    reference,
                    textAlign: TextAlign.center,
                    style: AppTypography.quranic.copyWith(
                      fontSize: 16,
                      height: 1.6,
                      // gold-800 on light background (6.05:1).
                      color: AppColors.gold800,
                    ),
                  ),
                ),
              ),
              const _Ornament(),
              const Expanded(child: _GoldDivider(fadeTo: Alignment.centerLeft)),
            ],
          ),
        ],
      ),
    );
  }
}

/// Thin gold line that fades out towards the outer edge ([fadeTo]).
class _GoldDivider extends StatelessWidget {
  const _GoldDivider({required this.fadeTo});

  final Alignment fadeTo;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1.2,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: fadeTo,
          end: -fadeTo,
          colors: const [Color(0x00D4AF37), AppColors.gold],
        ),
      ),
    );
  }
}

/// Small gold diamond.
class _Ornament extends StatelessWidget {
  const _Ornament();

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: Transform.rotate(
        angle: 0.785398, // 45°
        child: Container(width: 6, height: 6, color: AppColors.gold),
      ),
    );
  }
}

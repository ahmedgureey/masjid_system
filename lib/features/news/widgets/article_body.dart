import 'package:material_ui/material_ui.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../models/article.dart';
import 'article_cards.dart';

/// Renders the article blocks with comfortable reading typography. Each
/// block picks its own text direction (Arabic paragraphs are RTL even in a
/// Somali UI). Quotes without a source are skipped on purpose.
class ArticleBody extends StatelessWidget {
  const ArticleBody({super.key, required this.blocks, required this.lang});

  final List<ArticleBlock> blocks;
  final String lang;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final bodyStyle = textTheme.bodyLarge?.copyWith(
      fontSize: 17,
      height: 1.6,
      color: AppColors.darkText,
    );

    final children = <Widget>[];
    for (final block in blocks) {
      final Widget? widget = switch (block) {
        ParagraphBlock(:final text) when !text.isEmpty => DirectionalText(
          text.resolve(lang),
          style: bodyStyle,
        ),
        HeadingBlock(:final text) when !text.isEmpty => DirectionalText(
          text.resolve(lang),
          style: textTheme.titleLarge?.copyWith(
            color: AppColors.green800,
            fontWeight: FontWeight.w700,
          ),
        ),
        ImageBlock(:final url, :final caption) => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.lg),
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Image.network(
                  url,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => const ColoredBox(
                    color: AppColors.green50,
                    child: Center(
                      child: Icon(
                        Icons.image_not_supported_outlined,
                        color: AppColors.neutral400,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            if (caption != null && !caption.isEmpty)
              Padding(
                padding: const EdgeInsets.only(top: AppSpacing.space1),
                child: DirectionalText(
                  caption.resolve(lang),
                  style: textTheme.bodySmall?.copyWith(
                    color: AppColors.neutral500,
                  ),
                ),
              ),
          ],
        ),
        QuoteBlock(:final text, :final source)
            when !text.isEmpty && source.trim().isNotEmpty =>
          Container(
            padding: const EdgeInsets.all(AppSpacing.space4),
            decoration: const BoxDecoration(
              color: AppColors.gold50,
              border: BorderDirectional(
                start: BorderSide(color: AppColors.gold400, width: 4),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DirectionalText(
                  text.resolve(lang),
                  style: bodyStyle?.copyWith(fontStyle: FontStyle.italic),
                ),
                const SizedBox(height: AppSpacing.space2),
                Text(
                  '— $source',
                  style: textTheme.bodySmall?.copyWith(
                    color: AppColors.gold800,
                  ),
                ),
              ],
            ),
          ),
        _ => null,
      };
      if (widget != null) {
        children.add(
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.space4),
            child: widget,
          ),
        );
      }
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: children,
    );
  }
}

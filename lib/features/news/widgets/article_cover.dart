import 'package:material_ui/material_ui.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/widgets.dart';

/// Icon of a category (by slug); unknown categories get a generic icon.
IconData categoryIcon(String slug) => switch (slug) {
  'mosque-news' => Icons.mosque_rounded,
  'announcements' => Icons.campaign_rounded,
  'islamic-articles' => Icons.auto_stories_rounded,
  'quran-sunnah' => Icons.menu_book_rounded,
  'education' => Icons.school_rounded,
  'youth-family' => Icons.family_restroom_rounded,
  'projects' => Icons.construction_rounded,
  'community' => Icons.groups_rounded,
  _ => Icons.article_rounded,
};

/// Article image. Without an uploaded image (all articles today) a branded
/// placeholder is drawn — green gradient, Islamic pattern and the category
/// icon — instead of an unrelated stock photo.
class ArticleCover extends StatelessWidget {
  const ArticleCover({
    super.key,
    required this.imageUrl,
    required this.categorySlug,
    this.iconSize = 40,
  });

  final String? imageUrl;
  final String categorySlug;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    final placeholder = _Placeholder(
      icon: categoryIcon(categorySlug),
      iconSize: iconSize,
    );
    final url = imageUrl;
    if (url == null) return placeholder;
    return Image.network(
      url,
      fit: BoxFit.cover,
      errorBuilder: (_, _, _) => placeholder,
      loadingBuilder: (context, child, progress) =>
          progress == null ? child : placeholder,
    );
  }
}

class _Placeholder extends StatelessWidget {
  const _Placeholder({required this.icon, required this.iconSize});

  final IconData icon;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: AlignmentDirectional.topStart,
          end: AlignmentDirectional.bottomEnd,
          colors: [AppColors.green600, AppColors.green800],
        ),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          const IslamicPattern(),
          Center(
            child: Icon(icon, size: iconSize, color: AppColors.gold300),
          ),
        ],
      ),
    );
  }
}

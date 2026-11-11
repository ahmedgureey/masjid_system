import 'package:material_ui/material_ui.dart';

import '../../../models/localized_text.dart';

/// A project category. All categories are defined once in
/// [projectCategories] (future table `project_categories`), never as
/// scattered strings.
@immutable
class ProjectCategory {
  const ProjectCategory({
    required this.id,
    required this.name,
    required this.icon,
  });

  final String id;
  final LocalizedText name;
  final IconData icon;
}

/// The configured categories, in display order.
const List<ProjectCategory> projectCategories = [
  ProjectCategory(
    id: 'construction',
    icon: Icons.mosque_rounded,
    name: LocalizedText({
      'so': 'Dhismaha Masaajidka',
      'en': 'Mosque Construction',
      'ar': 'بناء المسجد',
    }),
  ),
  ProjectCategory(
    id: 'maintenance',
    icon: Icons.handyman_rounded,
    name: LocalizedText({
      'so': 'Dayactirka Masaajidka',
      'en': 'Mosque Maintenance',
      'ar': 'صيانة المسجد',
    }),
  ),
  ProjectCategory(
    id: 'electricity',
    icon: Icons.solar_power_rounded,
    name: LocalizedText({
      'so': 'Koronto iyo Qalab',
      'en': 'Electricity and Equipment',
      'ar': 'الكهرباء والمعدات',
    }),
  ),
  ProjectCategory(
    id: 'water',
    icon: Icons.water_drop_rounded,
    name: LocalizedText({
      'so': 'Biyo iyo Nadaafad',
      'en': 'Water and Sanitation',
      'ar': 'المياه والنظافة',
    }),
  ),
  ProjectCategory(
    id: 'quran-education',
    icon: Icons.menu_book_rounded,
    name: LocalizedText({
      'so': "Dugsi Qur'aan iyo Waxbarasho",
      'en': 'Quran Education',
      'ar': 'تعليم القرآن',
    }),
  ),
  ProjectCategory(
    id: 'library',
    icon: Icons.local_library_rounded,
    name: LocalizedText({
      'so': 'Maktabad iyo Kutub',
      'en': 'Library and Books',
      'ar': 'المكتبة والكتب',
    }),
  ),
  ProjectCategory(
    id: 'community',
    icon: Icons.groups_rounded,
    name: LocalizedText({
      'so': 'Mashaariicda Bulshada',
      'en': 'Community Projects',
      'ar': 'مشاريع المجتمع',
    }),
  ),
  ProjectCategory(
    id: 'equipment',
    icon: Icons.speaker_rounded,
    name: LocalizedText({
      'so': 'Qalabaynta Masaajidka',
      'en': 'Mosque Equipment',
      'ar': 'تجهيز المسجد',
    }),
  ),
  ProjectCategory(
    id: 'expansion',
    icon: Icons.open_in_full_rounded,
    name: LocalizedText({
      'so': 'Ballaarinta Masaajidka',
      'en': 'Mosque Expansion',
      'ar': 'توسعة المسجد',
    }),
  ),
  ProjectCategory(
    id: 'other',
    icon: Icons.category_rounded,
    name: LocalizedText({'so': 'Kuwo Kale', 'en': 'Other', 'ar': 'أخرى'}),
  ),
];

/// Category by id; unknown ids fall back to "Other".
ProjectCategory projectCategoryById(String id) => projectCategories.firstWhere(
  (c) => c.id == id,
  orElse: () => projectCategories.last,
);

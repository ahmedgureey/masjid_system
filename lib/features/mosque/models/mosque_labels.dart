import 'package:material_ui/material_ui.dart';

import '../../../core/localization/l10n.dart';
import 'mosque.dart';

/// Translated labels and icons for mosque enums.
extension MosqueCategoryLabel on MosqueCategory {
  String label(AppLocalizations l10n) => switch (this) {
    MosqueCategory.jamia => l10n.categoryJamia,
    MosqueCategory.masjid => l10n.categoryMasjid,
    MosqueCategory.musalla => l10n.categoryMusalla,
  };
}

extension MosqueFacilityLabel on MosqueFacility {
  String label(AppLocalizations l10n) => switch (this) {
    MosqueFacility.womenPrayerArea => l10n.facilityWomen,
    MosqueFacility.quranRooms => l10n.facilityQuranRooms,
    MosqueFacility.ablution => l10n.facilityAblution,
    MosqueFacility.parking => l10n.facilityParking,
    MosqueFacility.accessibility => l10n.facilityAccessibility,
  };

  IconData get icon => switch (this) {
    MosqueFacility.womenPrayerArea => Icons.woman_rounded,
    MosqueFacility.quranRooms => Icons.menu_book_rounded,
    MosqueFacility.ablution => Icons.water_drop_outlined,
    MosqueFacility.parking => Icons.local_parking_rounded,
    MosqueFacility.accessibility => Icons.accessible_rounded,
  };
}

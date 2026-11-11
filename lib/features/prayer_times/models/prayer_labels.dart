import 'package:material_ui/material_ui.dart';

import '../../../core/localization/l10n.dart';
import 'prayer_schedule.dart';

/// Display helpers for [Prayer].
extension PrayerLabels on Prayer {
  String label(AppLocalizations l10n) => switch (this) {
    Prayer.fajr => l10n.prayerFajr,
    Prayer.dhuhr => l10n.prayerDhuhr,
    Prayer.asr => l10n.prayerAsr,
    Prayer.maghrib => l10n.prayerMaghrib,
    Prayer.isha => l10n.prayerIsha,
  };

  IconData get icon => switch (this) {
    Prayer.fajr => Icons.wb_twilight_rounded,
    Prayer.dhuhr => Icons.light_mode_rounded,
    Prayer.asr => Icons.wb_sunny_outlined,
    Prayer.maghrib => Icons.nights_stay_outlined,
    Prayer.isha => Icons.dark_mode_rounded,
  };
}

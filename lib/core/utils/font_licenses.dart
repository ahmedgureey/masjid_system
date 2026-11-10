import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// Registers the SIL OFL licenses of the bundled fonts so they appear on the
/// app's licenses page (required by the font licenses).
void registerFontLicenses() {
  const fonts = <(String, String)>[
    ('Inter', 'assets/fonts/OFL-inter.txt'),
    ('Noto Sans Arabic', 'assets/fonts/OFL-notosansarabic.txt'),
    ('Amiri', 'assets/fonts/OFL-amiri.txt'),
  ];

  LicenseRegistry.addLicense(() async* {
    for (final (family, path) in fonts) {
      final text = await rootBundle.loadString(path);
      yield LicenseEntryWithLineBreaks([family], text);
    }
  });
}

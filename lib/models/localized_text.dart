import 'package:flutter/foundation.dart';

/// Text stored in several languages, matching the database `jsonb` format
/// `{"so": "...", "ar": "...", "en": "..."}`.
///
/// [resolve] returns the requested language, falling back to Somali, then
/// English, then Arabic, then any non-empty value.
@immutable
class LocalizedText {
  const LocalizedText(this.values);

  /// Same text in every language (e.g. a proper name).
  LocalizedText.all(String text)
    : values = {'so': text, 'en': text, 'ar': text};

  factory LocalizedText.fromJson(Map<String, dynamic> json) => LocalizedText({
    for (final entry in json.entries)
      if (entry.value is String) entry.key: entry.value as String,
  });

  final Map<String, String> values;

  static const List<String> _fallbackOrder = ['so', 'en', 'ar'];

  bool get isEmpty => values.values.every((v) => v.trim().isEmpty);

  String resolve(String languageCode) {
    final exact = values[languageCode];
    if (exact != null && exact.trim().isNotEmpty) return exact;
    for (final code in _fallbackOrder) {
      final value = values[code];
      if (value != null && value.trim().isNotEmpty) return value;
    }
    return values.values.firstWhere(
      (v) => v.trim().isNotEmpty,
      orElse: () => '',
    );
  }

  Map<String, dynamic> toJson() => Map<String, dynamic>.from(values);

  @override
  bool operator ==(Object other) =>
      other is LocalizedText && mapEquals(other.values, values);

  @override
  int get hashCode =>
      Object.hashAll(values.entries.map((e) => (e.key, e.value)));
}

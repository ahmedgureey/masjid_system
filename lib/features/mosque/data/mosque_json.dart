import '../../../models/localized_text.dart';
import '../models/mosque.dart';

/// Maps [Mosque] to and from a `public.mosques` row.
///
/// Kept out of the model so the model stays free of storage concerns, and so
/// the column names live next to the migration that defines them
/// (supabase/migrations/0001_mosques.sql).
///
/// Unknown enum values are dropped rather than throwing: a row written by a
/// newer build of the app must not break an older one.
abstract final class MosqueJson {
  static Mosque fromRow(Map<String, dynamic> row) {
    return Mosque(
      id: row['id'] as String,
      name: _text(row['name']) ?? const LocalizedText({}),
      subtitle: _text(row['subtitle']),
      description: _text(row['description']),
      category: _category(row['category'] as String?),
      establishedYear: (row['established_year'] as num?)?.toInt(),
      registrationNumber: row['registration_number'] as String?,
      logoUrl: row['logo_url'] as String?,
      coverUrl: row['cover_url'] as String?,
      country: row['country'] as String?,
      city: row['city'] as String?,
      district: row['district'] as String?,
      address: row['address'] as String?,
      latitude: (row['latitude'] as num?)?.toDouble(),
      longitude: (row['longitude'] as num?)?.toDouble(),
      phone: row['phone'] as String?,
      email: row['email'] as String?,
      website: row['website'] as String?,
      socialLinks: _stringMap(row['social_links']),
      imamName: row['imam_name'] as String?,
      chairmanName: row['chairman_name'] as String?,
      administratorName: row['administrator_name'] as String?,
      treasurerName: row['treasurer_name'] as String?,
      facilities: _facilities(row['facilities']),
    );
  }

  /// The columns a client may write. `id`, `created_at` and `updated_at` are
  /// left out: the first is the key, the other two belong to the database.
  static Map<String, dynamic> toUpdate(Mosque mosque) {
    return {
      'name': mosque.name.toJson(),
      'subtitle': mosque.subtitle?.toJson(),
      'description': mosque.description?.toJson(),
      'category': mosque.category?.name,
      'established_year': mosque.establishedYear,
      'registration_number': mosque.registrationNumber,
      'logo_url': mosque.logoUrl,
      'cover_url': mosque.coverUrl,
      'country': mosque.country,
      'city': mosque.city,
      'district': mosque.district,
      'address': mosque.address,
      'latitude': mosque.latitude,
      'longitude': mosque.longitude,
      'phone': mosque.phone,
      'email': mosque.email,
      'website': mosque.website,
      'social_links': mosque.socialLinks,
      'imam_name': mosque.imamName,
      'chairman_name': mosque.chairmanName,
      'administrator_name': mosque.administratorName,
      'treasurer_name': mosque.treasurerName,
      'facilities': [for (final f in mosque.facilities) f.name],
    };
  }

  static LocalizedText? _text(Object? value) {
    if (value is! Map) return null;
    return LocalizedText.fromJson(Map<String, dynamic>.from(value));
  }

  static Map<String, String> _stringMap(Object? value) {
    if (value is! Map) return const {};
    return {
      for (final entry in value.entries)
        if (entry.value is String) '${entry.key}': entry.value as String,
    };
  }

  static MosqueCategory? _category(String? value) {
    if (value == null) return null;
    for (final c in MosqueCategory.values) {
      if (c.name == value) return c;
    }
    return null;
  }

  static Set<MosqueFacility> _facilities(Object? value) {
    if (value is! List) return const {};
    return {
      for (final raw in value)
        for (final f in MosqueFacility.values)
          if (f.name == raw) f,
    };
  }
}

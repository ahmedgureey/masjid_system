import 'package:flutter/foundation.dart';

import '../../../models/localized_text.dart';

/// Kind of mosque.
enum MosqueCategory {
  /// Jāmiʿ — holds Friday (Jumuʿah) prayer.
  jamia,
  masjid,

  /// Prayer hall (muṣallā).
  musalla,
}

/// Optional facilities. Only facilities explicitly set by an administrator
/// are shown as available.
enum MosqueFacility {
  womenPrayerArea,
  quranRooms,
  ablution,
  parking,
  accessibility,
}

/// Public mosque information (mirrors the `mosques` and
/// `contact_information` tables, docs/al-ikhlas-plan.md §3).
///
/// Every field except [id] and [name] is optional: missing information is
/// shown as "not added yet", never invented.
@immutable
class Mosque {
  const Mosque({
    required this.id,
    required this.name,
    this.subtitle,
    this.description,
    this.category,
    this.establishedYear,
    this.registrationNumber,
    this.logoUrl,
    this.coverUrl,
    this.country,
    this.city,
    this.district,
    this.address,
    this.latitude,
    this.longitude,
    this.phone,
    this.email,
    this.website,
    this.socialLinks = const {},
    this.imamName,
    this.chairmanName,
    this.administratorName,
    this.treasurerName,
    this.facilities = const {},
  });

  final String id;
  final LocalizedText name;

  /// Optional tagline under the name on the home screen.
  final LocalizedText? subtitle;
  final LocalizedText? description;
  final MosqueCategory? category;
  final int? establishedYear;
  final String? registrationNumber;

  /// Uploaded by an administrator (Supabase Storage). Null until uploaded.
  final String? logoUrl;
  final String? coverUrl;

  // Location
  final String? country;
  final String? city;
  final String? district;
  final String? address;
  final double? latitude;
  final double? longitude;

  // Official (public) contact details of the mosque.
  final String? phone;
  final String? email;
  final String? website;

  /// Platform name (e.g. "Facebook") → URL.
  final Map<String, String> socialLinks;

  // Leadership: names only. Personal contact details are never stored here.
  final String? imamName;
  final String? chairmanName;
  final String? administratorName;
  final String? treasurerName;

  /// Facilities the mosque is confirmed to have.
  final Set<MosqueFacility> facilities;

  bool get hasCoordinates => latitude != null && longitude != null;
}

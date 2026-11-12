import 'package:flutter_test/flutter_test.dart';
import 'package:masjid_management/features/mosque/data/mosque_json.dart';
import 'package:masjid_management/features/mosque/models/mosque.dart';
import 'package:masjid_management/models/localized_text.dart';

/// A row as `public.mosques` returns it (supabase/migrations/0001_mosques.sql).
Map<String, dynamic> _row({Map<String, dynamic> overrides = const {}}) => {
  'id': 'al-ikhlas',
  'name': {'so': 'Masjid Al-Ikhlas', 'en': 'Masjid Al-Ikhlas'},
  'subtitle': null,
  'description': null,
  'category': 'jamia',
  'established_year': 1998,
  'registration_number': 'REG-1',
  'logo_url': null,
  'cover_url': null,
  'country': 'Somalia',
  'city': 'Mogadishu',
  'district': 'Hodan',
  'address': 'Street 1',
  'latitude': 2.0469,
  'longitude': 45.3182,
  'phone': '+252',
  'email': 'info@example.com',
  'website': 'https://example.com',
  'social_links': {'facebook': 'https://fb.example'},
  'imam_name': 'Imam',
  'chairman_name': null,
  'administrator_name': null,
  'treasurer_name': null,
  'facilities': ['ablution', 'parking'],
  'created_at': '2026-01-01T00:00:00Z',
  'updated_at': '2026-01-02T00:00:00Z',
  ...overrides,
};

void main() {
  group('fromRow', () {
    test('maps every column of a full row', () {
      final m = MosqueJson.fromRow(_row());
      expect(m.id, 'al-ikhlas');
      expect(m.name.resolve('en'), 'Masjid Al-Ikhlas');
      expect(m.category, MosqueCategory.jamia);
      expect(m.establishedYear, 1998);
      expect(m.registrationNumber, 'REG-1');
      expect(m.city, 'Mogadishu');
      expect(m.latitude, closeTo(2.0469, 1e-9));
      expect(m.longitude, closeTo(45.3182, 1e-9));
      expect(m.socialLinks, {'facebook': 'https://fb.example'});
      expect(m.imamName, 'Imam');
      expect(m.facilities, {MosqueFacility.ablution, MosqueFacility.parking});
    });

    test('a bare row (only id and name) leaves everything else empty', () {
      final m = MosqueJson.fromRow({
        'id': 'al-ikhlas',
        'name': {'en': 'Masjid Al-Ikhlas'},
      });
      expect(m.id, 'al-ikhlas');
      expect(m.subtitle, isNull);
      expect(m.category, isNull);
      expect(m.establishedYear, isNull);
      expect(m.latitude, isNull);
      expect(m.socialLinks, isEmpty);
      expect(m.facilities, isEmpty);
    });

    test('unknown enum values are dropped, not thrown', () {
      // A row written by a newer build must not break an older one.
      final m = MosqueJson.fromRow(
        _row(
          overrides: {
            'category': 'cathedral',
            'facilities': ['ablution', 'helipad'],
          },
        ),
      );
      expect(m.category, isNull);
      expect(m.facilities, {MosqueFacility.ablution});
    });

    test('integers arriving as num are converted', () {
      final m = MosqueJson.fromRow(
        _row(overrides: {'established_year': 1998.0, 'latitude': 2}),
      );
      expect(m.establishedYear, 1998);
      expect(m.latitude, 2.0);
    });

    test('non-string values in social_links are skipped', () {
      final m = MosqueJson.fromRow(
        _row(
          overrides: {
            'social_links': {'facebook': 'https://fb.example', 'x': 42},
          },
        ),
      );
      expect(m.socialLinks, {'facebook': 'https://fb.example'});
    });
  });

  group('toUpdate', () {
    test('uses the column names the table declares', () {
      final update = MosqueJson.toUpdate(MosqueJson.fromRow(_row()));
      expect(update['established_year'], 1998);
      expect(update['registration_number'], 'REG-1');
      expect(update['imam_name'], 'Imam');
      expect(update['social_links'], {'facebook': 'https://fb.example'});
      expect(update['category'], 'jamia');
      expect(update['facilities'], containsAll(['ablution', 'parking']));
    });

    test('never writes id or the database-owned timestamps', () {
      final update = MosqueJson.toUpdate(MosqueJson.fromRow(_row()));
      expect(update.containsKey('id'), isFalse);
      expect(update.containsKey('created_at'), isFalse);
      expect(update.containsKey('updated_at'), isFalse);
    });

    test('round trip keeps the values', () {
      final original = MosqueJson.fromRow(_row());
      final back = MosqueJson.fromRow({
        'id': original.id,
        ...MosqueJson.toUpdate(original),
      });
      expect(back.name.values, original.name.values);
      expect(back.category, original.category);
      expect(back.facilities, original.facilities);
      expect(back.socialLinks, original.socialLinks);
      expect(back.city, original.city);
      expect(back.longitude, original.longitude);
    });

    test('a mosque with nothing filled in writes nulls, not placeholders', () {
      const bare = Mosque(
        id: 'al-ikhlas',
        name: LocalizedText({'en': 'Masjid Al-Ikhlas'}),
      );
      final update = MosqueJson.toUpdate(bare);
      expect(update['city'], isNull);
      expect(update['category'], isNull);
      expect(update['facilities'], isEmpty);
      expect(update['social_links'], isEmpty);
    });
  });
}

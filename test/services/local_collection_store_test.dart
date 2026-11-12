import 'package:flutter_test/flutter_test.dart';
import 'package:masjid_management/services/local_collection_store.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<LocalCollectionStore> _store([
  Map<String, Object> initial = const {},
]) async {
  SharedPreferences.setMockInitialValues(initial);
  return LocalCollectionStore(await SharedPreferences.getInstance());
}

void main() {
  group('Seeding happens once', () {
    test('the first read writes the seed and returns it', () async {
      final store = await _store();
      expect(store.hasSeeded('events'), isFalse);

      final rows = await store.readOrSeed('events', () => [
        {'id': 'a'},
      ]);

      expect(rows, [
        {'id': 'a'},
      ]);
      expect(store.hasSeeded('events'), isTrue);
      expect(store.read('events'), [
        {'id': 'a'},
      ]);
    });

    test('a later read does not seed again', () async {
      final store = await _store();
      await store.readOrSeed('events', () => [
        {'id': 'sample'},
      ]);
      await store.write('events', [
        {'id': 'mine'},
      ]);

      var seedBuilt = false;
      final rows = await store.readOrSeed('events', () {
        seedBuilt = true;
        return [
          {'id': 'sample'},
        ];
      });

      expect(seedBuilt, isFalse, reason: 'the seed must not even be built');
      expect(rows, [
        {'id': 'mine'},
      ]);
    });

    test('deleting everything does not bring the samples back', () async {
      // The whole point of the collection store. Seeding on "empty" instead
      // of "never written" would undo exactly what the user asked for.
      final store = await _store();
      await store.readOrSeed('events', () => [
        {'id': 'sample-1'},
        {'id': 'sample-2'},
      ]);

      await store.write('events', const []);

      final rows = await store.readOrSeed('events', () => [
        {'id': 'sample-1'},
      ]);
      expect(rows, isEmpty);
    });

    test('reset makes the next read seed again', () async {
      final store = await _store();
      await store.readOrSeed('events', () => [
        {'id': 'a'},
      ]);
      await store.reset('events');

      expect(store.hasSeeded('events'), isFalse);
      expect(
        await store.readOrSeed('events', () => [
          {'id': 'b'},
        ]),
        [
          {'id': 'b'},
        ],
      );
    });
  });

  group('Damaged storage is survivable', () {
    test('a value that is not JSON reads as empty', () async {
      final store = await _store({'collection:events': 'not json {'});
      expect(store.read('events'), isEmpty);
    });

    test('JSON that is not a list reads as empty', () async {
      final store = await _store({'collection:events': '{"id":"a"}'});
      expect(store.read('events'), isEmpty);
    });

    test('non-object entries in the list are skipped', () async {
      final store = await _store({
        'collection:events': '[{"id":"a"}, 7, null, {"id":"b"}]',
      });
      expect(store.read('events'), [
        {'id': 'a'},
        {'id': 'b'},
      ]);
    });

    test('an unparseable document still counts as seeded', () async {
      // Otherwise a damaged document would be silently replaced by the
      // samples, which looks to the user like their data coming back wrong.
      final store = await _store({'collection:events': 'not json {'});
      expect(store.hasSeeded('events'), isTrue);
      expect(
        await store.readOrSeed('events', () => [
          {'id': 'sample'},
        ]),
        isEmpty,
      );
    });
  });

  test('collections do not collide with settings keys', () async {
    final store = await _store({'events': 'a settings value'});
    expect(store.hasSeeded('events'), isFalse);
  });
}

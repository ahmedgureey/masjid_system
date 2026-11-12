import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'local_storage_service.dart';

/// Lists of records kept on the device, one JSON document per collection.
///
/// [LocalStorageService] holds single settings — a locale, a theme, who is
/// signed in. This holds the content the user creates: events, articles,
/// projects, campaigns. The split is deliberate; mixing a growing JSON
/// document in with small scalar keys makes both harder to reason about.
///
/// Why a store at all: the repositories used to build their sample data in
/// the constructor and keep it in a field, so anything the user added or
/// changed was gone the next time the app started, and a deleted sample came
/// straight back. Seeding through [readOrSeed] makes the samples ordinary
/// rows the moment the app first runs — after that they are the user's to
/// edit or delete, and the decision sticks.
///
/// This is device-local. It is not shared between phones, it does not survive
/// uninstalling the app, and it is not a backend. When the Supabase-backed
/// repositories land, they replace the repositories that use this store;
/// nothing else has to change.
class LocalCollectionStore {
  LocalCollectionStore(this._prefs);

  final SharedPreferences _prefs;

  /// Namespaced so a collection can never collide with a settings key.
  static String _k(String collection) => 'collection:$collection';

  /// Whether [collection] has ever been written, which is not the same as it
  /// having rows: a user who deletes every event leaves an empty list behind,
  /// and re-seeding the samples at that point would undo exactly what they
  /// asked for.
  bool hasSeeded(String collection) => _prefs.containsKey(_k(collection));

  /// The stored rows, or an empty list when nothing was ever written.
  ///
  /// A document that cannot be parsed is treated as absent rather than
  /// thrown: a half-written or older-format value should cost the user their
  /// local data at worst, never the ability to open the screen.
  List<Map<String, dynamic>> read(String collection) {
    final raw = _prefs.getString(_k(collection));
    if (raw == null || raw.isEmpty) return const [];
    try {
      final decoded = jsonDecode(raw);
      if (decoded is! List) return const [];
      return decoded.whereType<Map<String, dynamic>>().toList();
    } on FormatException {
      return const [];
    }
  }

  Future<void> write(String collection, List<Map<String, dynamic>> rows) =>
      _prefs.setString(_k(collection), jsonEncode(rows));

  /// Forgets [collection] entirely, so the next [readOrSeed] seeds again.
  Future<void> reset(String collection) => _prefs.remove(_k(collection));

  /// The stored rows, seeding [seed] on the very first run.
  ///
  /// [seed] is a callback rather than a value so sample data that is
  /// expensive to build, or dated relative to today, is only built when it is
  /// actually going to be used.
  Future<List<Map<String, dynamic>>> readOrSeed(
    String collection,
    List<Map<String, dynamic>> Function() seed,
  ) async {
    if (hasSeeded(collection)) return read(collection);
    final rows = seed();
    await write(collection, rows);
    return rows;
  }
}

final localCollectionStoreProvider = Provider<LocalCollectionStore>(
  (ref) => LocalCollectionStore(ref.watch(sharedPreferencesProvider)),
);

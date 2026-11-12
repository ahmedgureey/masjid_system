import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/supabase_config.dart';
import '../../../models/localized_text.dart';
import '../models/mosque.dart';
import 'supabase_mosque_repository.dart';

/// Source of the mosque's public information.
///
/// Today: [LocalMosqueRepository] (in-memory mock).
/// Supabase phase: an implementation reading/writing the `mosques` and
/// `contact_information` tables replaces it in [mosqueRepositoryProvider].
abstract interface class MosqueRepository {
  Future<Mosque> getMosque();

  /// Saves [mosque] and returns the stored version.
  Future<Mosque> updateMosque(Mosque mosque);
}

/// MOCK — in-memory only.
///
/// Starts with the only information confirmed by the owner: the mosque
/// name. Everything else is empty until an administrator enters it.
/// Saved changes live in memory and are lost when the app closes.
class LocalMosqueRepository implements MosqueRepository {
  LocalMosqueRepository({this.latency = const Duration(milliseconds: 600)});

  final Duration latency;

  Mosque _current = const Mosque(
    id: 'al-ikhlas',
    name: LocalizedText({
      'so': 'Masjid Al-Ikhlas',
      'en': 'Masjid Al-Ikhlas',
      'ar': 'مسجد الإخلاص',
    }),
  );

  @override
  Future<Mosque> getMosque() async => _current;

  @override
  Future<Mosque> updateMosque(Mosque mosque) async {
    await Future<void>.delayed(latency);
    return _current = mosque;
  }
}

/// Postgres when a backend key was supplied at build time, otherwise the
/// in-memory sample data. One switch, so a build with no key still runs.
final mosqueRepositoryProvider = Provider<MosqueRepository>(
  (ref) => SupabaseConfig.isConfigured
      ? SupabaseMosqueRepository()
      : LocalMosqueRepository(),
);

/// The mosque as currently known by the app; [MosqueController.save]
/// updates it after a successful save.
final mosqueProvider = AsyncNotifierProvider<MosqueController, Mosque>(
  MosqueController.new,
);

class MosqueController extends AsyncNotifier<Mosque> {
  @override
  Future<Mosque> build() => ref.read(mosqueRepositoryProvider).getMosque();

  /// Saves through the repository. Throws if saving fails; the current state
  /// is only replaced after success.
  Future<void> save(Mosque mosque) async {
    final saved = await ref.read(mosqueRepositoryProvider).updateMosque(mosque);
    state = AsyncData(saved);
  }
}

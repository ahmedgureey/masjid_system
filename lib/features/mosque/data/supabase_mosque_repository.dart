import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/constants/app_constants.dart';
import '../models/mosque.dart';
import 'mosque_json.dart';
import 'mosque_repository.dart';

/// [MosqueRepository] backed by the `public.mosques` table.
///
/// Reads are public (RLS policy `mosques_public_read`); writes succeed only
/// for a signed-in administrator of that mosque (`mosques_admin_update`). A
/// write by anyone else fails at the database, not in the UI — the permission
/// providers in the app only decide what to show.
///
/// See supabase/migrations/0001_mosques.sql.
class SupabaseMosqueRepository implements MosqueRepository {
  SupabaseMosqueRepository({SupabaseClient? client, String? mosqueId})
    : _client = client ?? Supabase.instance.client,
      _mosqueId = mosqueId ?? AppConstants.defaultMosqueId;

  final SupabaseClient _client;

  /// Which mosque this installation serves. One row today; the column exists
  /// so more can be added without reshaping anything.
  final String _mosqueId;

  static const String _table = 'mosques';

  @override
  Future<Mosque> getMosque() async {
    final row = await _client
        .from(_table)
        .select()
        .eq('id', _mosqueId)
        .maybeSingle();
    if (row == null) {
      throw StateError(
        'No mosque with id "$_mosqueId". Run '
        'supabase/migrations/0001_mosques.sql against this project.',
      );
    }
    return MosqueJson.fromRow(row);
  }

  @override
  Future<Mosque> updateMosque(Mosque mosque) async {
    final rows = await _client
        .from(_table)
        .update(MosqueJson.toUpdate(mosque))
        .eq('id', mosque.id)
        .select();
    if (rows.isEmpty) {
      // RLS returns success with no rows when the policy refuses the write,
      // so an empty result is a permission problem, not a missing row.
      throw StateError(
        'The mosque was not saved. You are signed in but not an administrator '
        'of "${mosque.id}".',
      );
    }
    return MosqueJson.fromRow(rows.first);
  }
}

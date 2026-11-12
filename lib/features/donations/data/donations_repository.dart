import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../services/local_collection_store.dart';
import '../../mosque/data/mosque_repository.dart';
import '../models/donation_models.dart';
import '../models/money.dart';
import 'donation_json.dart';

/// Source of campaigns, donations and expenses.
///
/// Today: [LocalDonationsRepository] — in-memory MOCK data, every record
/// flagged `isSample` and titled "TUSAALE". Changes live in memory only.
/// Supabase phase: tables `donation_campaigns`, `donations`, `expenses` and
/// an insert-only `audit_logs`, all scoped by `mosque_id` with Row Level
/// Security (members read only aggregates and their own donations; only
/// treasurers / admins record, verify or void).
abstract interface class DonationsRepository {
  /// Campaigns visible to the public (drafts excluded).
  Future<List<DonationCampaign>> getCampaigns({required String mosqueId});

  Future<List<Donation>> getDonations({required String mosqueId});

  /// Stores a demo submission: never counted, no receipt.
  Future<Donation> submitDemoDonation(Donation draft);

  /// Staff: records an offline donation as **pending** until verified.
  Future<Donation> recordOfflineDonation(Donation draft);

  Future<Donation> confirmDonation(
    String id, {
    required String actor,
    required DateTime now,
  });

  /// Voids (never deletes) a donation with a mandatory reason.
  Future<Donation> voidDonation(
    String id, {
    required String reason,
    required String actor,
    required DateTime now,
  });

  Future<List<MosqueExpense>> getExpenses({required String mosqueId});

  Future<MosqueExpense> addExpense(MosqueExpense draft);

  Future<MosqueExpense> setExpenseStatus(
    String id,
    ExpenseStatus status, {
    required String actor,
    required DateTime now,
  });

  /// Removes a campaign. A campaign is a plan, not money: nothing is
  /// counted from it, so deleting one is safe. The donations that pointed at
  /// it are deliberately left alone — a record of money received must not
  /// disappear because the campaign it funded was tidied away.
  Future<void> deleteCampaign(String id);

  /// Removes every record flagged `isSample`, across campaigns, donations
  /// and expenses.
  Future<void> clearSampleData();

  /// Removes a donation record outright, audit trail and all.
  ///
  /// [voidDonation] remains the right tool for a record that was wrong: it
  /// takes the money out of the totals while keeping the row and its trail,
  /// which is what a mosque's books need. Deletion is for a record that
  /// should never have existed at all — a test entry, a duplicate — and the
  /// UI warns before using it on anything that counts.
  Future<void> deleteDonation(String id);

  /// Removes an expense record outright, audit trail and all. The same
  /// trade-off as [deleteDonation] against [voidExpense].
  Future<void> deleteExpense(String id);

  Future<MosqueExpense> voidExpense(
    String id, {
    required String reason,
    required String actor,
    required DateTime now,
  });
}

/// Campaigns, donations and expenses held on the device.
///
/// With a [store], the samples are written once on the very first run and
/// are ordinary rows from then on, so what the user records survives closing
/// the app and a cleared sample set stays cleared. Without a [store] it is
/// purely in-memory, which is what the widget tests want: they pass their own
/// lists and assert on what they passed.
class LocalDonationsRepository implements DonationsRepository {
  LocalDonationsRepository({
    required this.seedDate,
    this.store,
    this.latency = const Duration(milliseconds: 400),
    List<DonationCampaign>? campaigns,
    List<Donation>? donations,
    List<MosqueExpense>? expenses,
  }) : _initialCampaigns = campaigns,
       _initialDonations = donations,
       _initialExpenses = expenses;

  final Duration latency;

  /// What the sample dates are built around.
  final DateTime seedDate;

  /// Null in tests that work purely in memory.
  final LocalCollectionStore? store;

  static const String campaignsCollection = 'donation_campaigns';
  static const String donationsCollection = 'donations';
  static const String expensesCollection = 'expenses';

  /// What the caller supplied, used as the seed instead of the samples.
  final List<DonationCampaign>? _initialCampaigns;
  final List<Donation>? _initialDonations;
  final List<MosqueExpense>? _initialExpenses;

  /// Empty until [_ensureLoaded]. The synchronous helpers below rely on
  /// these being populated, which is why every public method loads first.
  List<DonationCampaign> _campaigns = [];
  List<Donation> _donations = [];
  List<MosqueExpense> _expenses = [];
  bool _isLoaded = false;

  int _sequence = 100;

  Future<void> _wait() async {
    if (latency > Duration.zero) await Future<void>.delayed(latency);
  }

  /// Fills the three lists, from the store when there is one.
  ///
  /// Called at the top of every public method rather than in the
  /// constructor: reading the device is asynchronous, and a repository that
  /// did it eagerly would have to be awaited before it could be provided.
  Future<void> _ensureLoaded() async {
    if (_isLoaded) return;

    final store = this.store;
    if (store == null) {
      _campaigns = List.of(_initialCampaigns ?? sampleCampaigns(seedDate));
      _donations = List.of(_initialDonations ?? sampleDonations(seedDate));
      _expenses = List.of(_initialExpenses ?? sampleExpenses(seedDate));
    } else {
      _campaigns = DonationJson.campaignsFrom(
        await store.readOrSeed(
          campaignsCollection,
          () => DonationJson.campaignsTo(
            _initialCampaigns ?? sampleCampaigns(seedDate),
          ),
        ),
      );
      _donations = DonationJson.donationsFrom(
        await store.readOrSeed(
          donationsCollection,
          () => DonationJson.donationsTo(
            _initialDonations ?? sampleDonations(seedDate),
          ),
        ),
      );
      _expenses = DonationJson.expensesFrom(
        await store.readOrSeed(
          expensesCollection,
          () => DonationJson.expensesTo(
            _initialExpenses ?? sampleExpenses(seedDate),
          ),
        ),
      );
    }
    _isLoaded = true;
  }

  /// Writes all three lists back. A no-op without a store.
  ///
  /// All three together because one action can touch more than one of them
  /// (clearing the samples touches every one), and three small writes are
  /// not worth tracking which changed.
  Future<void> _flush() async {
    final store = this.store;
    if (store == null) return;
    await store.write(
      campaignsCollection,
      DonationJson.campaignsTo(_campaigns),
    );
    await store.write(
      donationsCollection,
      DonationJson.donationsTo(_donations),
    );
    await store.write(expensesCollection, DonationJson.expensesTo(_expenses));
  }

  @override
  Future<void> deleteCampaign(String id) async {
    await _wait();
    await _ensureLoaded();
    _campaigns.removeWhere((c) => c.id == id);
    await _flush();
  }

  @override
  Future<void> clearSampleData() async {
    await _wait();
    await _ensureLoaded();
    _campaigns.removeWhere((c) => c.isSample);
    _donations.removeWhere((d) => d.isSample);
    _expenses.removeWhere((e) => e.isSample);
    await _flush();
  }

  @override
  Future<void> deleteDonation(String id) async {
    await _wait();
    await _ensureLoaded();
    _donations.removeWhere((d) => d.id == id);
    await _flush();
  }

  @override
  Future<void> deleteExpense(String id) async {
    await _wait();
    await _ensureLoaded();
    _expenses.removeWhere((e) => e.id == id);
    await _flush();
  }

  String _next(String prefix) =>
      '$prefix-${(++_sequence).toString().padLeft(5, '0')}';

  @override
  Future<List<DonationCampaign>> getCampaigns({
    required String mosqueId,
  }) async {
    await _wait();
    await _ensureLoaded();
    return [
      for (final c in _campaigns)
        if (c.mosqueId == mosqueId && c.status != CampaignStatus.draft) c,
    ];
  }

  @override
  Future<List<Donation>> getDonations({required String mosqueId}) async {
    await _wait();
    await _ensureLoaded();
    return [
      for (final d in _donations)
        if (d.mosqueId == mosqueId) d,
    ];
  }

  Future<Donation> _store(Donation d) async {
    _donations.add(d);
    await _flush();
    return d;
  }

  Future<Donation> _replace(Donation d) async {
    final i = _donations.indexWhere((x) => x.id == d.id);
    _donations[i] = d;
    await _flush();
    return d;
  }

  Donation _find(String id) => _donations.firstWhere(
    (d) => d.id == id,
    orElse: () => throw StateError('Donation $id not found'),
  );

  Donation _copyNew(
    Donation draft, {
    required String prefix,
    required bool demo,
    required DonationStatus status,
    required AuditEntry entry,
  }) {
    final ref = _next(prefix);
    return Donation(
      id: ref.toLowerCase(),
      mosqueId: draft.mosqueId,
      reference: ref,
      campaignId: draft.campaignId,
      amount: draft.amount,
      date: draft.date,
      method: draft.method,
      status: status,
      isDemo: demo,
      userId: draft.userId,
      donorName: draft.isAnonymous ? null : draft.donorName,
      donorContact: draft.isAnonymous ? null : draft.donorContact,
      isAnonymous: draft.isAnonymous,
      message: draft.message,
      externalReference: draft.externalReference,
      recordedBy: draft.recordedBy,
      audit: [entry],
    );
  }

  @override
  Future<Donation> submitDemoDonation(Donation draft) async {
    await _wait();
    await _ensureLoaded();
    return _store(
      _copyNew(
        draft,
        prefix: 'DEMO',
        demo: true,
        // Status stays pending, but isDemo excludes it from every total.
        status: DonationStatus.pending,
        entry: AuditEntry(
          at: draft.date,
          actor: draft.userId ?? '—',
          action: AuditAction.demoSubmitted,
        ),
      ),
    );
  }

  @override
  Future<Donation> recordOfflineDonation(Donation draft) async {
    await _wait();
    await _ensureLoaded();
    return _store(
      _copyNew(
        draft,
        prefix: 'DQ',
        demo: false,
        status: DonationStatus.pending,
        entry: AuditEntry(
          at: draft.date,
          actor: draft.recordedBy ?? '—',
          action: AuditAction.recorded,
        ),
      ),
    );
  }

  @override
  Future<Donation> confirmDonation(
    String id, {
    required String actor,
    required DateTime now,
  }) async {
    await _wait();
    await _ensureLoaded();
    final d = _find(id);
    if (d.isDemo || d.isVoided || d.status != DonationStatus.pending) {
      throw StateError('Only pending real donations can be confirmed.');
    }
    return _replace(
      d.copyWith(
        status: DonationStatus.confirmed,
        audit: [
          ...d.audit,
          AuditEntry(at: now, actor: actor, action: AuditAction.confirmed),
        ],
      ),
    );
  }

  @override
  Future<Donation> voidDonation(
    String id, {
    required String reason,
    required String actor,
    required DateTime now,
  }) async {
    await _wait();
    await _ensureLoaded();
    final d = _find(id);
    if (reason.trim().isEmpty) throw ArgumentError('A reason is required.');
    if (d.isVoided) throw StateError('Already voided.');
    return _replace(
      d.copyWith(
        voidedAt: now,
        voidReason: reason.trim(),
        audit: [
          ...d.audit,
          AuditEntry(
            at: now,
            actor: actor,
            action: AuditAction.voided,
            note: reason.trim(),
          ),
        ],
      ),
    );
  }

  @override
  Future<List<MosqueExpense>> getExpenses({required String mosqueId}) async {
    await _wait();
    await _ensureLoaded();
    return [
      for (final e in _expenses)
        if (e.mosqueId == mosqueId) e,
    ];
  }

  MosqueExpense _findExpense(String id) => _expenses.firstWhere(
    (e) => e.id == id,
    orElse: () => throw StateError('Expense $id not found'),
  );

  Future<MosqueExpense> _replaceExpense(MosqueExpense e) async {
    final i = _expenses.indexWhere((x) => x.id == e.id);
    _expenses[i] = e;
    await _flush();
    return e;
  }

  @override
  Future<MosqueExpense> addExpense(MosqueExpense draft) async {
    await _wait();
    await _ensureLoaded();
    final id = _next('KH').toLowerCase();
    final e = MosqueExpense(
      id: id,
      mosqueId: draft.mosqueId,
      category: draft.category,
      description: draft.description,
      reason: draft.reason,
      amount: draft.amount,
      date: draft.date,
      payee: draft.payee,
      projectId: draft.projectId,
      recordedBy: draft.recordedBy,
      // Every new expense needs approval before it counts in reports.
      status: ExpenseStatus.pending,
      audit: [
        AuditEntry(
          at: draft.date,
          actor: draft.recordedBy,
          action: AuditAction.expenseRecorded,
        ),
      ],
    );
    _expenses.add(e);
    await _flush();
    return e;
  }

  @override
  Future<MosqueExpense> setExpenseStatus(
    String id,
    ExpenseStatus status, {
    required String actor,
    required DateTime now,
  }) async {
    await _wait();
    await _ensureLoaded();
    final e = _findExpense(id);
    if (e.isVoided || e.status != ExpenseStatus.pending) {
      throw StateError('Only pending expenses can be approved or rejected.');
    }
    return _replaceExpense(
      e.copyWith(
        status: status,
        audit: [
          ...e.audit,
          AuditEntry(
            at: now,
            actor: actor,
            action: status == ExpenseStatus.approved
                ? AuditAction.expenseApproved
                : AuditAction.expenseRejected,
          ),
        ],
      ),
    );
  }

  @override
  Future<MosqueExpense> voidExpense(
    String id, {
    required String reason,
    required String actor,
    required DateTime now,
  }) async {
    await _wait();
    await _ensureLoaded();
    final e = _findExpense(id);
    if (reason.trim().isEmpty) throw ArgumentError('A reason is required.');
    if (e.isVoided) throw StateError('Already voided.');
    return _replaceExpense(
      e.copyWith(
        voidedAt: now,
        voidReason: reason.trim(),
        audit: [
          ...e.audit,
          AuditEntry(
            at: now,
            actor: actor,
            action: AuditAction.voided,
            note: reason.trim(),
          ),
        ],
      ),
    );
  }

  // -------------------------------------------------------------------------
  // SAMPLE DATA — clearly labelled, not real campaigns or money.
  // -------------------------------------------------------------------------

  static const String sampleMosqueId = 'al-ikhlas';

  static const String _note =
      'Tani waa olole tusaale ah (mock) oo loogu talagalay tijaabinta '
      'naqshadda app-ka. Ma aha olole rasmi ah oo masaajidka, lacagna laguma '
      'ururinayo.';

  static List<DonationCampaign> sampleCampaigns(DateTime seed) {
    DateTime day(int offset) =>
        DateTime(seed.year, seed.month, seed.day + offset);
    DonationCampaign c(
      String id,
      String title,
      CampaignCategory category,
      int targetUsd, {
      CampaignStatus status = CampaignStatus.active,
      int? startOffset,
      int? endOffset,
    }) => DonationCampaign(
      id: id,
      mosqueId: sampleMosqueId,
      title: 'TUSAALE: $title',
      description: _note,
      category: category,
      target: Money.major(targetUsd, Currency.usd),
      startDate: startOffset == null ? null : day(startOffset),
      endDate: endOffset == null ? null : day(endOffset),
      status: status,
      createdAt: day(-90),
      isSample: true,
    );

    return [
      c(
        'camp-construction',
        'Dhismaha masaajidka',
        CampaignCategory.construction,
        50000,
        startOffset: -60,
        endOffset: 300,
      ),
      c(
        'camp-maintenance',
        'Dayactirka masaajidka',
        CampaignCategory.maintenance,
        5000,
        startOffset: -30,
      ),
      c(
        'camp-utilities',
        'Korontada iyo biyaha',
        CampaignCategory.utilities,
        1200,
      ),
      c(
        'camp-quran',
        "Waxbarashada Qur'aanka",
        CampaignCategory.quranEducation,
        3000,
        startOffset: -45,
        endOffset: 120,
      ),
      c(
        'camp-families',
        'Taageerada qoysaska baahan',
        CampaignCategory.needyFamilies,
        4000,
      ),
      // No confirmed donations: shows $0 honestly.
      c(
        'camp-ramadan',
        'Quudinta Ramadaan',
        CampaignCategory.ramadanFood,
        6000,
        startOffset: 10,
        endOffset: 40,
      ),
      c(
        'camp-general',
        'Deeqaha guud ee masaajidka',
        CampaignCategory.general,
        2000,
      ),
      c(
        'camp-old',
        'Olole dhammaaday',
        CampaignCategory.maintenance,
        500,
        status: CampaignStatus.completed,
        startOffset: -200,
        endOffset: -100,
      ),
      c(
        'camp-draft',
        'Qabyo (draft)',
        CampaignCategory.general,
        100,
        status: CampaignStatus.draft,
      ),
    ];
  }

  static List<Donation> sampleDonations(DateTime seed) {
    var n = 0;
    Donation d(
      String campaignId,
      Money amount,
      int daysAgo,
      PaymentMethod method,
      DonationStatus status, {
      bool voided = false,
      bool anonymous = false,
    }) {
      n++;
      final date = DateTime(seed.year, seed.month, seed.day - daysAgo, 10);
      final ref = 'TUSAALE-${n.toString().padLeft(4, '0')}';
      return Donation(
        id: 'sample-donation-$n',
        mosqueId: sampleMosqueId,
        reference: ref,
        campaignId: campaignId,
        amount: amount,
        date: date,
        method: method,
        status: status,
        isSample: true,
        donorName: anonymous ? null : 'Tusaale: deeq-bixiye $n',
        isAnonymous: anonymous,
        recordedBy: 'Tusaale: hayaha khasnadda',
        voidedAt: voided ? date.add(const Duration(days: 1)) : null,
        voidReason: voided
            ? 'Tusaale: lacag laba jeer la diiwaangeliyay'
            : null,
        audit: [
          AuditEntry(
            at: date,
            actor: 'Tusaale: hayaha khasnadda',
            action: AuditAction.recorded,
          ),
          if (status == DonationStatus.confirmed)
            AuditEntry(
              at: date,
              actor: 'Tusaale: hayaha khasnadda',
              action: AuditAction.confirmed,
            ),
        ],
      );
    }

    const usd = Currency.usd;
    return [
      d(
        'camp-construction',
        const Money.major(500, usd),
        2,
        PaymentMethod.bankTransfer,
        DonationStatus.confirmed,
      ),
      d(
        'camp-construction',
        const Money.major(1200, usd),
        9,
        PaymentMethod.mobileMoney,
        DonationStatus.confirmed,
        anonymous: true,
      ),
      d(
        'camp-construction',
        const Money.major(300, usd),
        1,
        PaymentMethod.cash,
        DonationStatus.pending,
      ),
      d(
        'camp-maintenance',
        const Money.major(250, usd),
        4,
        PaymentMethod.cash,
        DonationStatus.confirmed,
      ),
      d(
        'camp-maintenance',
        const Money.major(80, usd),
        3,
        PaymentMethod.mobileMoney,
        DonationStatus.failed,
      ),
      d(
        'camp-utilities',
        const Money.major(150, usd),
        6,
        PaymentMethod.mobileMoney,
        DonationStatus.confirmed,
      ),
      d(
        'camp-utilities',
        const Money.major(1500, usd),
        12,
        PaymentMethod.bankTransfer,
        DonationStatus.confirmed,
      ),
      d(
        'camp-quran',
        const Money(4550, usd),
        5,
        PaymentMethod.cash,
        DonationStatus.confirmed,
      ),
      d(
        'camp-quran',
        const Money.major(100, usd),
        7,
        PaymentMethod.bankTransfer,
        DonationStatus.refunded,
      ),
      d(
        'camp-families',
        const Money.major(400, usd),
        8,
        PaymentMethod.mobileMoney,
        DonationStatus.confirmed,
      ),
      d(
        'camp-families',
        const Money.major(200, usd),
        8,
        PaymentMethod.mobileMoney,
        DonationStatus.confirmed,
        voided: true,
      ),
      d(
        'camp-general',
        const Money.major(60, usd),
        3,
        PaymentMethod.cash,
        DonationStatus.confirmed,
      ),
      // Different currency: never added to the USD campaign total.
      d(
        'camp-general',
        const Money.major(50000, Currency.sos),
        3,
        PaymentMethod.cash,
        DonationStatus.confirmed,
      ),
      d(
        'camp-old',
        const Money.major(500, usd),
        150,
        PaymentMethod.cash,
        DonationStatus.confirmed,
      ),
    ];
  }

  static List<MosqueExpense> sampleExpenses(DateTime seed) {
    var n = 0;
    MosqueExpense e(
      ExpenseCategory category,
      String description,
      int usd,
      int daysAgo,
      ExpenseStatus status, {
      bool voided = false,
      String? projectId,
    }) {
      n++;
      final date = DateTime(seed.year, seed.month, seed.day - daysAgo, 9);
      return MosqueExpense(
        id: 'sample-expense-$n',
        mosqueId: sampleMosqueId,
        category: category,
        description: 'TUSAALE: $description',
        reason: 'Tusaale: sabab ganacsi oo meel-hayn ah',
        amount: Money.major(usd, Currency.usd),
        date: date,
        payee: 'Tusaale: alaab-qeybiye',
        projectId: projectId,
        recordedBy: 'Tusaale: hayaha khasnadda',
        status: status,
        voidedAt: voided ? date.add(const Duration(days: 1)) : null,
        voidReason: voided ? 'Tusaale: qalad la saxay' : null,
        audit: [
          AuditEntry(
            at: date,
            actor: 'Tusaale: hayaha khasnadda',
            action: AuditAction.expenseRecorded,
          ),
        ],
        isSample: true,
      );
    }

    return [
      e(
        ExpenseCategory.electricity,
        'Biilka korontada',
        120,
        2,
        ExpenseStatus.approved,
        projectId: 'proj-solar',
      ),
      e(ExpenseCategory.water, 'Biilka biyaha', 40, 3, ExpenseStatus.approved),
      e(
        ExpenseCategory.cleaning,
        'Agabka nadiifinta',
        35,
        1,
        ExpenseStatus.pending,
      ),
      e(
        ExpenseCategory.maintenance,
        'Dayactirka saqafka',
        900,
        6,
        ExpenseStatus.rejected,
        projectId: 'proj-roof',
      ),
      e(
        ExpenseCategory.education,
        'Buugaagta ardayda',
        75,
        4,
        ExpenseStatus.approved,
        voided: true,
        projectId: 'proj-quran-school',
      ),
    ];
  }
}

final donationsRepositoryProvider = Provider<DonationsRepository>(
  (ref) => LocalDonationsRepository(
    seedDate: DateTime.now(),
    store: ref.watch(localCollectionStoreProvider),
  ),
);

Future<String> _mosqueId(Ref ref) async =>
    (await ref.watch(mosqueProvider.future)).id;

/// Public campaigns of the current mosque.
final campaignsProvider = FutureProvider<List<DonationCampaign>>((ref) async {
  final mosqueId = await _mosqueId(ref);
  return ref
      .watch(donationsRepositoryProvider)
      .getCampaigns(mosqueId: mosqueId);
});

/// All donation records of the current mosque (UI shows aggregates to the
/// public, a user's own records in history, and everything to staff).
final donationsProvider =
    AsyncNotifierProvider<DonationsController, List<Donation>>(
      DonationsController.new,
    );

class DonationsController extends AsyncNotifier<List<Donation>> {
  @override
  Future<List<Donation>> build() async {
    final mosqueId = await _mosqueId(ref);
    return ref
        .read(donationsRepositoryProvider)
        .getDonations(mosqueId: mosqueId);
  }

  DonationsRepository get _repo => ref.read(donationsRepositoryProvider);

  void _upsert(Donation d) {
    final list = [...?state.value];
    final i = list.indexWhere((x) => x.id == d.id);
    if (i >= 0) {
      list[i] = d;
    } else {
      list.add(d);
    }
    state = AsyncData(list);
  }

  Future<Donation> submitDemo(Donation draft) async {
    final d = await _repo.submitDemoDonation(draft);
    _upsert(d);
    return d;
  }

  Future<Donation> recordOffline(Donation draft) async {
    final d = await _repo.recordOfflineDonation(draft);
    _upsert(d);
    return d;
  }

  Future<Donation> confirm(
    String id, {
    required String actor,
    required DateTime now,
  }) async {
    final d = await _repo.confirmDonation(id, actor: actor, now: now);
    _upsert(d);
    return d;
  }

  Future<Donation> voidDonation(
    String id, {
    required String reason,
    required String actor,
    required DateTime now,
  }) async {
    final d = await _repo.voidDonation(
      id,
      reason: reason,
      actor: actor,
      now: now,
    );
    _upsert(d);
    return d;
  }

  /// Removes the whole "TUSAALE" demonstration set — sample campaigns,
  /// donations and expenses together.
  ///
  /// Every donation-side list is invalidated rather than patched: the
  /// campaigns and expenses providers hold their own copies, and leaving
  /// either showing a sample that no longer exists would be worse than one
  /// extra read.
  Future<void> clearSampleData() async {
    await _repo.clearSampleData();
    state = AsyncData([...?state.value]..removeWhere((d) => d.isSample));
    ref
      ..invalidate(campaignsProvider)
      ..invalidate(expensesProvider);
  }

  /// Removes a donation record for good; throws on failure (state
  /// unchanged). [voidDonation] is the reversible-looking option that keeps
  /// the audit trail — the screens offer both and say which does what.
  Future<void> delete(String id) async {
    await _repo.deleteDonation(id);
    state = AsyncData([...?state.value]..removeWhere((d) => d.id == id));
  }
}

/// Expenses of the current mosque (staff only).
final expensesProvider =
    AsyncNotifierProvider<ExpensesController, List<MosqueExpense>>(
      ExpensesController.new,
    );

class ExpensesController extends AsyncNotifier<List<MosqueExpense>> {
  @override
  Future<List<MosqueExpense>> build() async {
    final mosqueId = await _mosqueId(ref);
    return ref
        .read(donationsRepositoryProvider)
        .getExpenses(mosqueId: mosqueId);
  }

  DonationsRepository get _repo => ref.read(donationsRepositoryProvider);

  void _upsert(MosqueExpense e) {
    final list = [...?state.value];
    final i = list.indexWhere((x) => x.id == e.id);
    if (i >= 0) {
      list[i] = e;
    } else {
      list.add(e);
    }
    state = AsyncData(list);
  }

  Future<MosqueExpense> add(MosqueExpense draft) async {
    final e = await _repo.addExpense(draft);
    _upsert(e);
    return e;
  }

  Future<MosqueExpense> setStatus(
    String id,
    ExpenseStatus status, {
    required String actor,
    required DateTime now,
  }) async {
    final e = await _repo.setExpenseStatus(id, status, actor: actor, now: now);
    _upsert(e);
    return e;
  }

  Future<MosqueExpense> voidExpense(
    String id, {
    required String reason,
    required String actor,
    required DateTime now,
  }) async {
    final e = await _repo.voidExpense(
      id,
      reason: reason,
      actor: actor,
      now: now,
    );
    _upsert(e);
    return e;
  }

  /// Removes an expense record for good; throws on failure (state
  /// unchanged). [voidExpense] is the option that keeps the audit trail.
  Future<void> delete(String id) async {
    await _repo.deleteExpense(id);
    state = AsyncData([...?state.value]..removeWhere((e) => e.id == id));
  }
}

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:masjid_management/app.dart';
import 'package:masjid_management/core/widgets/widgets.dart';
import 'package:masjid_management/features/authentication/application/demo_session_provider.dart';
import 'package:masjid_management/features/donations/application/donation_validation.dart';
import 'package:masjid_management/features/donations/application/finance_calculations.dart';
import 'package:masjid_management/features/donations/application/finance_services.dart';
import 'package:masjid_management/features/donations/data/donations_repository.dart';
import 'package:masjid_management/features/donations/models/donation_labels.dart';
import 'package:masjid_management/features/donations/models/donation_models.dart';
import 'package:masjid_management/features/donations/models/money.dart';
import 'package:masjid_management/features/donations/screens/campaign_screens.dart';
import 'package:masjid_management/features/donations/screens/donations_screen.dart';
import 'package:masjid_management/features/donations/screens/history_receipt_screens.dart';
import 'package:masjid_management/features/donations/screens/staff_screens.dart';
import 'package:masjid_management/routing/app_routes.dart';
import 'package:material_ui/material_ui.dart';

import '../../helpers/test_app.dart';

// testNow = Wed 11 Nov 2026. Sample confirmed USD per campaign:
// construction 1,700 (+300 pending) · maintenance 250 (80 failed) ·
// utilities 1,650 of 1,200 (100 %) · quran 45.50 (100 refunded) ·
// families 400 (200 voided) · ramadan 0 · general 60 (+ SOS 50,000) ·
// old (completed) 500. Approved expenses: 120 + 40 = 160 USD.

const _usd = Currency.usd;

LocalDonationsRepository _repo() =>
    LocalDonationsRepository(seedDate: testNow, latency: Duration.zero);

class _FailingRepo implements DonationsRepository {
  _FailingRepo();

  final LocalDonationsRepository inner = _repo();
  bool fail = true;

  @override
  Future<List<DonationCampaign>> getCampaigns({required String mosqueId}) {
    if (fail) throw Exception('network');
    return inner.getCampaigns(mosqueId: mosqueId);
  }

  @override
  Future<List<Donation>> getDonations({required String mosqueId}) =>
      inner.getDonations(mosqueId: mosqueId);

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

Future<ProviderContainer> _open(
  WidgetTester tester,
  String location, {
  String locale = 'so',
  Size size = const Size(400, 2400),
  double scale = 1.0,
  String? signedInAs,
  DonationsRepository? repo,
}) async {
  await pumpFullApp(
    tester,
    prefs: {localeCodeKey: locale},
    surfaceSize: size,
    textScale: scale,
    overrides: [donationsRepositoryProvider.overrideWithValue(repo ?? _repo())],
  );
  await passSplash(tester);
  final container = ProviderScope.containerOf(
    tester.element(find.byType(MasjidApp)),
  );
  if (signedInAs != null) {
    container
        .read(demoSessionProvider.notifier)
        .signIn(displayName: signedInAs);
  }
  await goTo(tester, location);
  return container;
}

Future<void> _tap(WidgetTester tester, Finder finder) async {
  await tester.ensureVisible(finder);
  await tester.pumpAndSettle();
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

Finder _input(String key) => find.descendant(
  of: find.byKey(Key(key)),
  matching: find.byType(EditableText),
);

String _text(WidgetTester tester, Finder finder) =>
    tester.widget<Text>(finder).data!;

void main() {
  final campaigns = LocalDonationsRepository.sampleCampaigns(testNow);
  final donations = LocalDonationsRepository.sampleDonations(testNow);
  final expenses = LocalDonationsRepository.sampleExpenses(testNow);
  DonationCampaign campaign(String id) =>
      campaigns.firstWhere((c) => c.id == id);

  group('Money', () {
    test('formats with Western digits and currency', () {
      expect(const Money(125000, _usd).format(), r'$1,250.00');
      expect(const Money.major(50000, Currency.sos).format(), 'SOS 50,000.00');
      expect(const Money(-1250, _usd).format(), r'-$12.50');
      expect(const Money.zero(_usd).format(), r'$0.00');
    });

    test('never mixes currencies', () {
      expect(
        () => const Money.major(1, _usd) + const Money.major(1, Currency.sos),
        throwsArgumentError,
      );
    });
  });

  group('Amount validation', () {
    test('parse', () {
      expect(DonationValidation.parse('20', _usd), const Money(2000, _usd));
      expect(DonationValidation.parse('20.5', _usd), const Money(2050, _usd));
      expect(
        DonationValidation.parse('1,250.75', _usd),
        const Money(125075, _usd),
      );
      expect(DonationValidation.parse('abc', _usd), isNull);
      expect(DonationValidation.parse('1.234', _usd), isNull);
    });

    test('errors: empty, zero, negative, invalid, decimals, too large', () {
      AmountError? v(String? s) => DonationValidation.amount(s, _usd);
      expect(v(null), AmountError.required);
      expect(v('  '), AmountError.required);
      expect(v('0'), AmountError.notPositive);
      expect(v('0.00'), AmountError.notPositive);
      expect(v('-5'), AmountError.notPositive);
      expect(v('abc'), AmountError.invalid);
      expect(v('1.2.3'), AmountError.invalid);
      expect(v('1.234'), AmountError.tooManyDecimals);
      expect(v('2000000'), AmountError.tooLarge);
      expect(v('20'), isNull);
      expect(v('0.01'), isNull);
    });

    test('comma only accepted as a thousands separator', () {
      // A decimal comma must not silently become 10× / 100× the amount.
      expect(DonationValidation.parse('1,5', _usd), isNull);
      expect(DonationValidation.parse('12,50', _usd), isNull);
      expect(DonationValidation.parse('1,25,0', _usd), isNull);
      expect(DonationValidation.amount('12,50', _usd), AmountError.invalid);
      expect(
        DonationValidation.parse('12,500', _usd),
        const Money(1250000, _usd),
      );
      expect(
        DonationValidation.parse('1,250,000', _usd),
        const Money(125000000, _usd),
      );
      expect(normalizeAmountText(' 1,250.50 '), '1250.50');
      expect(normalizeAmountText('1,5'), isNull);
    });
  });

  group('Demo user id', () {
    test('uses the email (not the display name) so users stay apart', () async {
      final c = await testContainer();
      addTearDown(c.dispose);
      expect(c.read(donorUserIdProvider), isNull);
      c
          .read(demoSessionProvider.notifier)
          .signIn(displayName: 'Ahmed', email: 'Ahmed.A@Example.com');
      expect(c.read(donorUserIdProvider), 'ahmed.a@example.com');
      // Same display name, different email → a different id.
      c
          .read(demoSessionProvider.notifier)
          .signIn(displayName: 'Ahmed', email: 'other@example.com');
      expect(c.read(donorUserIdProvider), 'other@example.com');
      // No email (e.g. phone sign-in) → falls back to the name.
      c.read(demoSessionProvider.notifier).signIn(displayName: 'Ahmed');
      expect(c.read(donorUserIdProvider), 'Ahmed');
    });
  });

  group('Calculations', () {
    test(
      'confirmed totals exclude pending, failed, refunded, voided, demo',
      () {
        final p = FinanceCalculations.campaignProgress(
          campaign('camp-construction'),
          donations,
        );
        expect(p.raised, const Money.major(1700, _usd));
        expect(p.pending, const Money.major(300, _usd));
        expect(p.percent, 3);
        expect(
          FinanceCalculations.campaignProgress(
            campaign('camp-maintenance'),
            donations,
          ).raised,
          const Money.major(250, _usd),
        );
        expect(
          FinanceCalculations.campaignProgress(
            campaign('camp-families'),
            donations,
          ).raised,
          const Money.major(400, _usd),
        );
        expect(
          FinanceCalculations.campaignProgress(
            campaign('camp-quran'),
            donations,
          ).raised,
          const Money(4550, _usd),
        );
      },
    );

    test('progress is capped at 100 % and remaining never below zero', () {
      final p = FinanceCalculations.campaignProgress(
        campaign('camp-utilities'),
        donations,
      );
      expect(p.raised, const Money.major(1650, _usd));
      expect(p.fraction, 1.0);
      expect(p.percent, 100);
      expect(p.remaining, const Money.zero(_usd));
    });

    test('campaign without confirmed donations shows zero', () {
      final p = FinanceCalculations.campaignProgress(
        campaign('camp-ramadan'),
        donations,
      );
      expect(p.raised.isZero, isTrue);
      expect(p.percent, 0);
      expect(p.remaining, campaign('camp-ramadan').target);
    });

    test('other currencies are not added to a USD campaign', () {
      expect(
        FinanceCalculations.campaignProgress(
          campaign('camp-general'),
          donations,
        ).raised,
        const Money.major(60, _usd),
      );
    });

    test('demo donations never count, even if marked confirmed', () {
      final demo = Donation(
        id: 'x',
        mosqueId: 'al-ikhlas',
        reference: 'DEMO-1',
        campaignId: 'camp-ramadan',
        amount: const Money.major(1000, _usd),
        date: testNow,
        method: PaymentMethod.online,
        status: DonationStatus.confirmed,
        isDemo: true,
      );
      expect(demo.countsAsConfirmed, isFalse);
      expect(demo.hasReceipt, isFalse);
      expect(
        FinanceCalculations.campaignProgress(campaign('camp-ramadan'), [
          ...donations,
          demo,
        ]).raised.isZero,
        isTrue,
      );
    });

    test('yearly report per currency, expenses and net', () {
      final r = FinanceCalculations.report(
        period: ReportPeriod(ReportGranularity.year, testNow),
        donations: donations,
        expenses: expenses,
      );
      final usd = r.byCurrency[_usd]!;
      expect(usd.confirmedDonations, const Money(460550, _usd));
      expect(usd.expenses, const Money.major(160, _usd));
      expect(usd.net, const Money(444550, _usd));
      expect(
        usd.byCampaign['camp-construction'],
        const Money.major(1700, _usd),
      );
      expect(
        usd.byMethod[PaymentMethod.bankTransfer],
        const Money.major(2000, _usd),
      );
      final sos = r.byCurrency[Currency.sos]!;
      expect(sos.confirmedDonations, const Money.major(50000, Currency.sos));
      expect(sos.expenses.isZero, isTrue);
    });

    test('empty period and period shifting across a year', () {
      final r = FinanceCalculations.report(
        period: ReportPeriod(ReportGranularity.year, DateTime(2025)),
        donations: donations,
        expenses: expenses,
      );
      expect(r.isEmpty, isTrue);
      final dec = ReportPeriod(ReportGranularity.month, DateTime(2026, 12, 5));
      expect(dec.start, DateTime(2026, 12));
      expect(dec.end, DateTime(2027));
      expect(dec.shift(1).start, DateTime(2027));
      expect(
        ReportPeriod(
          ReportGranularity.day,
          DateTime(2026, 12, 31),
        ).shift(1).start,
        DateTime(2027),
      );
    });

    test('expenses total counts only approved, non-voided', () {
      expect(
        FinanceCalculations.expensesTotal(expenses, _usd),
        const Money.major(160, _usd),
      );
    });
  });

  group('Repository rules', () {
    test(
      'confirm pending, void with reason, demo cannot be confirmed',
      () async {
        final repo = _repo();
        final confirmed = await repo.confirmDonation(
          'sample-donation-3',
          actor: 'T',
          now: testNow,
        );
        expect(confirmed.countsAsConfirmed, isTrue);
        expect(confirmed.audit.last.action, AuditAction.confirmed);

        final voided = await repo.voidDonation(
          'sample-donation-1',
          reason: 'Laba jeer',
          actor: 'T',
          now: testNow,
        );
        expect(voided.countsAsConfirmed, isFalse);
        expect(voided.voidReason, 'Laba jeer');
        expect(
          () => repo.voidDonation(
            'sample-donation-2',
            reason: ' ',
            actor: 'T',
            now: testNow,
          ),
          throwsArgumentError,
        );

        final demo = await repo.submitDemoDonation(
          Donation(
            id: '',
            mosqueId: 'al-ikhlas',
            reference: '',
            campaignId: 'camp-ramadan',
            amount: const Money.major(10, _usd),
            date: testNow,
            method: PaymentMethod.cash,
            status: DonationStatus.pending,
            donorName: 'Secret',
            isAnonymous: true,
          ),
        );
        expect(demo.isDemo, isTrue);
        expect(demo.reference, startsWith('DEMO-'));
        expect(demo.donorName, isNull); // anonymous: identity not stored
        expect(
          () => repo.confirmDonation(demo.id, actor: 'T', now: testNow),
          throwsStateError,
        );
        // Records are never deleted.
        expect(
          (await repo.getDonations(mosqueId: 'al-ikhlas')).length,
          donations.length + 1,
        );
      },
    );

    test('public campaigns exclude drafts and other mosques', () async {
      final list = await _repo().getCampaigns(mosqueId: 'al-ikhlas');
      expect(list.map((c) => c.id), isNot(contains('camp-draft')));
      expect(await _repo().getCampaigns(mosqueId: 'other'), isEmpty);
    });

    test('history filter by state, campaign, period and query', () {
      final list = filterDonationHistory(
        donations,
        state: DonationStateFilter.confirmed,
        campaignId: 'camp-construction',
        now: testNow,
      );
      expect(list.map((d) => d.id), ['sample-donation-1', 'sample-donation-2']);
      expect(
        filterDonationHistory(
          donations,
          state: DonationStateFilter.voided,
          now: testNow,
        ).single.id,
        'sample-donation-11',
      );
      expect(
        filterDonationHistory(
          donations,
          state: DonationStateFilter.all,
          period: HistoryPeriod.last30Days,
          now: testNow,
        ).map((d) => d.id),
        isNot(contains('sample-donation-14')),
      );
      expect(
        filterDonationHistory(
          donations,
          state: DonationStateFilter.all,
          now: testNow,
          query: 'tusaale-0005',
        ).single.id,
        'sample-donation-5',
      );
    });

    test('payments are unavailable (no real processing)', () async {
      const p = UnavailablePaymentProcessor();
      expect(p.isAvailable, isFalse);
    });
  });

  group('Donor screens', () {
    testWidgets('overview: sample notice, active campaigns, computed totals', (
      tester,
    ) async {
      await _open(tester, AppRoutes.donations);
      expect(find.text('Deeqaha'), findsOneWidget);
      expect(find.byKey(const Key('donationsSampleNotice')), findsOneWidget);
      expect(find.byKey(const ValueKey('campaign-camp-draft')), findsNothing);
      expect(find.byKey(const ValueKey('campaign-camp-old')), findsNothing);
      final card = find.byKey(const ValueKey('campaign-camp-construction'));
      expect(
        find.descendant(of: card, matching: find.text(r'$1,700.00')),
        findsOneWidget,
      );
      expect(
        find.descendant(of: card, matching: find.text('3%')),
        findsOneWidget,
      );
      expect(find.byKey(const Key('donQuickStaff')), findsNothing);
    });

    testWidgets('campaign list filters by status and category', (tester) async {
      await _open(tester, AppRoutes.donationCampaigns);
      expect(find.byKey(const ValueKey('campaign-camp-old')), findsNothing);
      await _tap(tester, find.byKey(const ValueKey('campStatus-completed')));
      expect(find.byKey(const ValueKey('campaign-camp-old')), findsOneWidget);
      expect(
        find.byKey(const ValueKey('campaign-camp-construction')),
        findsNothing,
      );
      await _tap(tester, find.byKey(const Key('campStatus-all')));
      await _tap(tester, find.byKey(const ValueKey('campCat-ramadanFood')));
      expect(
        find.byKey(const ValueKey('campaign-camp-ramadan')),
        findsOneWidget,
      );
      expect(find.byKey(const ValueKey('campaign-camp-quran')), findsNothing);
    });

    testWidgets('details: zero state, capped progress, pending note', (
      tester,
    ) async {
      await _open(tester, AppRoutes.campaign('camp-ramadan'));
      expect(find.byKey(const Key('campaignNoDonations')), findsOneWidget);
      expect(_text(tester, find.byKey(const Key('campaignRaised'))), r'$0.00');
      expect(
        _text(tester, find.byKey(const Key('campaignRemaining'))),
        r'$6,000.00',
      );

      await goTo(tester, AppRoutes.campaign('camp-utilities'));
      expect(_text(tester, find.byKey(const Key('campaignPercent'))), '100%');
      expect(
        _text(tester, find.byKey(const Key('campaignRemaining'))),
        r'$0.00',
      );

      await goTo(tester, AppRoutes.campaign('camp-construction'));
      expect(find.textContaining(r'$300.00'), findsOneWidget);
    });

    testWidgets(
      'donate: validation, anonymous, demo result, totals unchanged',
      (tester) async {
        await _open(tester, AppRoutes.campaign('camp-construction'));
        await _tap(tester, find.byKey(const Key('campaignDonateButton')));
        expect(find.byKey(const Key('donateDemoWarning')), findsOneWidget);
        expect(find.text('Lacagta: USD'), findsOneWidget);
        expect(find.text('TUSAALE: Dhismaha masaajidka'), findsOneWidget);

        await _tap(tester, find.byKey(const Key('donateSubmit')));
        expect(find.text('Meeshan waa in la buuxiyaa'), findsOneWidget);
        await tester.enterText(_input('donateAmountField'), '0');
        await _tap(tester, find.byKey(const Key('donateSubmit')));
        expect(
          find.text('Qaddarku waa inuu ka badnaadaa eber.'),
          findsOneWidget,
        );
        await tester.enterText(_input('donateAmountField'), '-5');
        await _tap(tester, find.byKey(const Key('donateSubmit')));
        expect(
          find.text('Qaddarku waa inuu ka badnaadaa eber.'),
          findsOneWidget,
        );

        // Anonymous hides identity fields.
        expect(find.byKey(const Key('donateName')), findsOneWidget);
        await _tap(tester, find.byKey(const Key('donateAnonymous')));
        expect(find.byKey(const Key('donateName')), findsNothing);
        expect(find.byKey(const Key('donateContact')), findsNothing);

        await _tap(tester, find.byKey(const ValueKey('suggested-20')));
        await _tap(tester, find.byKey(const Key('donateSubmit')));
        expect(find.byKey(const Key('donateDemoDone')), findsOneWidget);
        expect(
          _text(tester, find.byKey(const Key('demoStatus'))),
          'Tijaabo — lama socodsiin',
        );
        expect(
          _text(tester, find.byKey(const Key('demoReference'))),
          startsWith('DEMO-'),
        );

        await _tap(tester, find.byKey(const Key('demoBack')));
        // Still $1,700 — the demo submission is not counted.
        expect(
          _text(tester, find.byKey(const Key('campaignRaised'))),
          r'$1,700.00',
        );
      },
    );

    testWidgets('history needs sign-in; shows only own demo records', (
      tester,
    ) async {
      await _open(tester, AppRoutes.donationHistory);
      expect(
        find.text('Gal si aad u aragto taariikhda deeqahaaga.'),
        findsOneWidget,
      );

      await _open(tester, AppRoutes.donate, signedInAs: 'Tester');
      await tester.enterText(_input('donateAmountField'), '15');
      await _tap(tester, find.byKey(const Key('donateSubmit')));
      await _tap(tester, find.byKey(const Key('demoViewHistory')));
      expect(find.byType(DonationHistoryScreen), findsOneWidget);
      expect(find.text('Tijaabo — lama socodsiin'), findsWidgets);
      // Sample records of other donors are never shown here.
      expect(find.textContaining('TUSAALE-0001'), findsNothing);
      expect(find.byTooltip('Rasiid'), findsNothing); // demo: no receipt

      await _tap(tester, find.byKey(const ValueKey('historyState-confirmed')));
      expect(
        find.text('Ma jiraan deeqo u dhigma shaandhooyinkan.'),
        findsOneWidget,
      );
    });

    testWidgets('receipt: sample label, reference, status; none when invalid', (
      tester,
    ) async {
      await _open(
        tester,
        AppRoutes.receipt('sample-donation-1'),
        signedInAs: 'Staff',
      );
      expect(find.byKey(const Key('receiptSampleBanner')), findsOneWidget);
      expect(
        _text(tester, find.byKey(const Key('receiptReference'))),
        'TUSAALE-0001',
      );
      expect(
        _text(tester, find.byKey(const Key('receiptStatus'))),
        'La xaqiijiyay',
      );
      // Pending donation: no receipt.
      await goTo(tester, AppRoutes.receipt('sample-donation-3'));
      expect(find.byKey(const Key('receiptUnavailable')), findsOneWidget);
    });

    testWidgets('receipt is not shown to someone who is not the owner', (
      tester,
    ) async {
      await _open(tester, AppRoutes.receipt('sample-donation-1'));
      expect(find.byKey(const Key('receiptUnavailable')), findsOneWidget);
    });

    testWidgets('error state with retry', (tester) async {
      final repo = _FailingRepo();
      await _open(tester, AppRoutes.donations, repo: repo);
      expect(find.byType(ErrorState), findsOneWidget);
      repo.fail = false;
      // Tap at once: Riverpod would otherwise retry by itself.
      await tester.tap(
        find.descendant(
          of: find.byType(ErrorState),
          matching: find.byType(AppButton),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(ErrorState), findsNothing);
      expect(find.byType(DonationsScreen), findsOneWidget);
    });
  });

  group('Staff screens (frontend-only permission)', () {
    testWidgets('ordinary users are redirected away', (tester) async {
      await _open(tester, AppRoutes.financeStaff);
      expect(find.byType(StaffDonationsScreen), findsNothing);
      expect(find.byType(DonationsScreen), findsOneWidget);
      await goTo(tester, AppRoutes.financeReports);
      expect(find.byType(DonationsScreen), findsOneWidget);
    });

    testWidgets('verify a pending donation updates confirmed totals', (
      tester,
    ) async {
      final c = await _open(tester, AppRoutes.donations, signedInAs: 'Staff');
      expect(find.byKey(const Key('donQuickStaff')), findsOneWidget);
      await _tap(tester, find.byKey(const Key('donQuickStaff')));
      expect(find.byKey(const Key('staffNotice')), findsOneWidget);
      await _tap(
        tester,
        find.byKey(const ValueKey('staff-sample-donation-3')).first,
      );
      await _tap(tester, find.byKey(const Key('staffConfirm')));
      await _tap(tester, find.byKey(const Key('confirmDonationYes')));
      expect(find.text('La xaqiijiyay'), findsWidgets);
      final list = c.read(donationsProvider).value!;
      final p = FinanceCalculations.campaignProgress(
        campaign('camp-construction'),
        list,
      );
      expect(p.raised, const Money.major(2000, _usd));
      expect(find.byKey(const Key('auditTrail')), findsOneWidget);
    });

    testWidgets('void needs a reason and removes the amount from totals', (
      tester,
    ) async {
      final c = await _open(
        tester,
        AppRoutes.staffDonation('sample-donation-1'),
        signedInAs: 'Staff',
      );
      await _tap(tester, find.byKey(const Key('staffVoid')));
      await _tap(tester, find.byKey(const Key('voidConfirm')));
      expect(find.text('Meeshan waa in la buuxiyaa'), findsOneWidget);
      await tester.enterText(find.byKey(const Key('voidReasonField')), 'Qalad');
      await _tap(tester, find.byKey(const Key('voidConfirm')));
      expect(_text(tester, find.byKey(const Key('staffVoidReason'))), 'Qalad');
      expect(find.byKey(const Key('staffVoid')), findsNothing);
      final p = FinanceCalculations.campaignProgress(
        campaign('camp-construction'),
        c.read(donationsProvider).value!,
      );
      expect(p.raised, const Money.major(1200, _usd));
    });

    testWidgets('record offline donation is saved as pending', (tester) async {
      final c = await _open(
        tester,
        AppRoutes.financeStaff,
        signedInAs: 'Staff',
      );
      await _tap(tester, find.byKey(const Key('staffRecord')));
      await _tap(tester, find.byKey(const Key('recordSave')));
      expect(find.text('Fadlan dooro mid'), findsOneWidget);
      await _tap(tester, find.byKey(const Key('recordCampaign')));
      await _tap(tester, find.text('TUSAALE: Korontada iyo biyaha').last);
      await tester.enterText(_input('recordAmount'), '75');
      await _tap(tester, find.byKey(const Key('recordSave')));
      expect(find.byType(StaffDonationsScreen), findsOneWidget);
      final recorded = c
          .read(donationsProvider)
          .value!
          .where((d) => d.reference.startsWith('DQ-'))
          .single;
      expect(recorded.status, DonationStatus.pending);
      expect(recorded.countsAsConfirmed, isFalse);
      expect(recorded.recordedBy, 'Staff');
    });

    testWidgets('expenses: totals, add, approve, void', (tester) async {
      await _open(tester, AppRoutes.expenses, signedInAs: 'Staff');
      expect(
        _text(tester, find.byKey(const ValueKey('expenseTotal-USD'))),
        r'$160.00',
      );
      // Approve the pending sample expense ($35).
      await _tap(
        tester,
        find.byKey(const ValueKey('expense-sample-expense-3')),
      );
      await _tap(tester, find.byKey(const Key('expenseApprove')));
      expect(find.text('La oggolaaday'), findsWidgets);
      await tester.tap(find.byType(BackButton));
      await tester.pumpAndSettle();
      expect(
        _text(tester, find.byKey(const ValueKey('expenseTotal-USD'))),
        r'$195.00',
      );

      // New expense: validation, then saved as pending (not counted).
      await _tap(tester, find.byKey(const Key('expenseAdd')));
      await _tap(tester, find.byKey(const Key('expenseSave')));
      expect(find.text('Fadlan dooro mid'), findsOneWidget);
      await _tap(tester, find.byKey(const Key('expenseCategory')));
      await _tap(tester, find.text('Koronto').last);
      await tester.enterText(_input('expenseDescription'), 'Test');
      await tester.enterText(_input('expenseReason'), 'Test reason');
      await tester.enterText(_input('expenseAmount'), '10');
      await _tap(tester, find.byKey(const Key('expenseSave')));
      expect(
        _text(tester, find.byKey(const ValueKey('expenseTotal-USD'))),
        r'$195.00',
      );
    });

    testWidgets('report: year totals per currency and rules', (tester) async {
      await _open(tester, AppRoutes.financeReports, signedInAs: 'Staff');
      await _tap(tester, find.byKey(const ValueKey('reportGranularity-year')));
      expect(_text(tester, find.byKey(const Key('reportPeriodLabel'))), '2026');
      expect(
        _text(tester, find.byKey(const ValueKey('reportConfirmed-USD'))),
        r'$4,605.50',
      );
      expect(
        _text(tester, find.byKey(const ValueKey('reportExpenses-USD'))),
        r'$160.00',
      );
      expect(
        _text(tester, find.byKey(const ValueKey('reportNet-USD'))),
        r'$4,445.50',
      );
      expect(
        _text(tester, find.byKey(const ValueKey('reportConfirmed-SOS'))),
        'SOS 50,000.00',
      );
      await _tap(tester, find.byKey(const Key('reportPrev')));
      expect(
        find.text('Diiwaan la xaqiijiyay kuma jiro muddadan'),
        findsOneWidget,
      );
      await tester.scrollUntilVisible(
        find.byKey(const Key('reportRules')),
        400,
        scrollable: find.byType(Scrollable).first,
      );
      expect(find.byKey(const Key('reportRules')), findsOneWidget);
    });
  });

  group('Layout', () {
    const cases = <String, (Size, double, String)>{
      'small Android 320x568 @200%': (Size(320, 568), 2.0, 'so'),
      'Arabic 360x780 @130%': (Size(360, 780), 1.3, 'ar'),
      'large 440x956 English': (Size(440, 956), 1.0, 'en'),
    };
    for (final MapEntry(key: name, value: (size, scale, locale))
        in cases.entries) {
      testWidgets('donation screens have no overflow on $name', (tester) async {
        await _open(
          tester,
          AppRoutes.donations,
          locale: locale,
          size: size,
          scale: scale,
          signedInAs: 'Staff',
        );
        expect(tester.takeException(), isNull);
        for (final route in [
          AppRoutes.campaign('camp-construction'),
          AppRoutes.donate,
          AppRoutes.donationHistory,
          AppRoutes.receipt('sample-donation-1'),
          AppRoutes.financeStaff,
          AppRoutes.staffDonation('sample-donation-3'),
          AppRoutes.expenses,
          AppRoutes.financeReports,
        ]) {
          await goTo(tester, route);
          expect(tester.takeException(), isNull, reason: route);
        }
        expect(find.byType(CampaignsScreen), findsNothing);
      });
    }
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:masjid_management/features/donations/data/donations_repository.dart';
import 'package:masjid_management/features/events/data/event_json.dart';
import 'package:masjid_management/features/events/data/events_repository.dart';
import 'package:masjid_management/features/events/models/mosque_event.dart';
import 'package:masjid_management/features/news/data/article_json.dart';
import 'package:masjid_management/features/news/data/articles_repository.dart';
import 'package:masjid_management/features/projects/data/project_json.dart';
import 'package:masjid_management/features/projects/data/projects_repository.dart';
import 'package:masjid_management/services/local_collection_store.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// The seed date the whole file works from, so sample ids are predictable.
final _seed = DateTime(2026, 11, 16);

const _mosqueId = 'al-ikhlas';

Future<LocalCollectionStore> _freshStore() async {
  SharedPreferences.setMockInitialValues({});
  return LocalCollectionStore(await SharedPreferences.getInstance());
}

void main() {
  group('Events survive a restart', () {
    test('an added event is still there next time the app starts', () async {
      final store = await _freshStore();

      final first = LocalEventsRepository(
        seedDate: _seed,
        store: store,
        latency: Duration.zero,
      );
      await first.saveEvent(
        MosqueEvent(
          id: 'mine-1',
          title: 'Kulan bulsho',
          description: 'Mine, not a sample.',
          category: EventCategory.communityMeetings,
          start: _seed,
          location: 'Hoolka',
        ),
      );

      // A second repository over the same storage is what the next launch
      // of the app actually does.
      final second = LocalEventsRepository(
        seedDate: _seed,
        store: store,
        latency: Duration.zero,
      );
      final events = await second.getEvents();

      expect(events.map((e) => e.id), contains('mine-1'));
      expect(
        events.firstWhere((e) => e.id == 'mine-1').title,
        'Kulan bulsho',
      );
    });

    test('a deleted sample does not come back', () async {
      // The bug this whole change exists to fix: the samples used to be
      // rebuilt in the constructor, so deleting one lasted until restart.
      final store = await _freshStore();

      final first = LocalEventsRepository(
        seedDate: _seed,
        store: store,
        latency: Duration.zero,
      );
      final before = await first.getEvents();
      expect(before.any((e) => e.isSample), isTrue);
      for (final event in before) {
        await first.deleteEvent(event.id);
      }

      final second = LocalEventsRepository(
        seedDate: _seed,
        store: store,
        latency: Duration.zero,
      );
      expect(await second.getEvents(), isEmpty);
    });

    test('deleting an id that is not there is not an error', () async {
      final repo = LocalEventsRepository(
        seedDate: _seed,
        store: await _freshStore(),
        latency: Duration.zero,
      );
      final before = (await repo.getEvents()).length;
      await repo.deleteEvent('no-such-event');
      expect((await repo.getEvents()).length, before);
    });

    test('without a store nothing is written to the device', () async {
      final store = await _freshStore();
      final repo = LocalEventsRepository(
        seedDate: _seed,
        latency: Duration.zero,
      );
      await repo.deleteEvent((await repo.getEvents()).first.id);
      expect(store.hasSeeded(LocalEventsRepository.collection), isFalse);
    });

    test('the caller\'s own list is not mutated', () async {
      final mine = [
        MosqueEvent(
          id: 'a',
          title: 'A',
          description: '',
          category: EventCategory.other,
          start: _seed,
          location: '',
        ),
      ];
      final repo = LocalEventsRepository(
        seedDate: _seed,
        latency: Duration.zero,
        initial: mine,
      );
      await repo.deleteEvent('a');
      expect(mine, hasLength(1), reason: 'the list passed in is the caller\'s');
    });
  });

  group('Articles survive a restart', () {
    test('a deleted sample stays deleted', () async {
      final store = await _freshStore();

      final first = LocalArticlesRepository(
        seedDate: _seed,
        store: store,
        latency: Duration.zero,
      );
      final before = await first.getAllArticles(mosqueId: _mosqueId);
      expect(before, isNotEmpty);
      await first.deleteArticle(before.first.id);

      final second = LocalArticlesRepository(
        seedDate: _seed,
        store: store,
        latency: Duration.zero,
      );
      final after = await second.getAllArticles(mosqueId: _mosqueId);
      expect(after.map((a) => a.id), isNot(contains(before.first.id)));
      expect(after, hasLength(before.length - 1));
    });

    test('a round trip through storage keeps the body intact', () async {
      // The body is the part most likely to be lost: it is a list of
      // sealed block types rather than plain fields.
      final store = await _freshStore();
      final source = LocalArticlesRepository(
        seedDate: _seed,
        latency: Duration.zero,
      );
      final original = (await source.getAllArticles(mosqueId: _mosqueId))
          .firstWhere((a) => a.body.isNotEmpty);

      final repo = LocalArticlesRepository(
        seedDate: _seed,
        store: store,
        latency: Duration.zero,
      );
      await repo.saveArticle(original);

      final reloaded = (await LocalArticlesRepository(
        seedDate: _seed,
        store: store,
        latency: Duration.zero,
      ).getAllArticles(mosqueId: _mosqueId)).firstWhere(
        (a) => a.id == original.id,
      );

      expect(reloaded.body, hasLength(original.body.length));
      expect(reloaded.bodyText('so'), original.bodyText('so'));
      expect(reloaded.title.values, original.title.values);
      expect(reloaded.status, original.status);
      expect(reloaded.isSample, original.isSample);
    });
  });

  group('Projects survive a restart', () {
    test('deleting a project also removes its updates', () async {
      final store = await _freshStore();

      final first = LocalProjectsRepository(
        seedDate: _seed,
        store: store,
        latency: Duration.zero,
      );
      final projects = await first.getProjects(mosqueId: _mosqueId);
      final withUpdates = <String>{
        for (final u in await first.getUpdates(mosqueId: _mosqueId))
          u.projectId,
      };
      final target = projects.firstWhere((p) => withUpdates.contains(p.id));

      await first.deleteProject(target.id);

      final second = LocalProjectsRepository(
        seedDate: _seed,
        store: store,
        latency: Duration.zero,
      );
      expect(
        (await second.getProjects(mosqueId: _mosqueId)).map((p) => p.id),
        isNot(contains(target.id)),
      );
      expect(
        (await second.getUpdates(
          mosqueId: _mosqueId,
        )).where((u) => u.projectId == target.id),
        isEmpty,
        reason: 'orphan updates would be unreachable but kept for ever',
      );
    });

    test('money comes back exactly, not as a rounded double', () async {
      final store = await _freshStore();
      final first = LocalProjectsRepository(
        seedDate: _seed,
        store: store,
        latency: Duration.zero,
      );
      final original = (await first.getProjects(mosqueId: _mosqueId)).first;

      final reloaded = (await LocalProjectsRepository(
        seedDate: _seed,
        store: store,
        latency: Duration.zero,
      ).getProjects(mosqueId: _mosqueId)).firstWhere(
        (p) => p.id == original.id,
      );

      expect(reloaded.budget.minor, original.budget.minor);
      expect(reloaded.budget.currency, original.budget.currency);
      expect(reloaded.milestones, hasLength(original.milestones.length));
      expect(reloaded.history, hasLength(original.history.length));
    });
  });

  group('Donations', () {
    test('clearing the samples leaves real records alone', () async {
      final store = await _freshStore();
      final first = LocalDonationsRepository(
        seedDate: _seed,
        store: store,
        latency: Duration.zero,
      );

      final before = await first.getDonations(mosqueId: _mosqueId);
      expect(before.any((d) => d.isSample), isTrue);
      final real = before.where((d) => !d.isSample).map((d) => d.id).toSet();

      await first.clearSampleData();

      final second = LocalDonationsRepository(
        seedDate: _seed,
        store: store,
        latency: Duration.zero,
      );
      final after = await second.getDonations(mosqueId: _mosqueId);
      expect(after.any((d) => d.isSample), isFalse);
      expect(after.map((d) => d.id).toSet(), real);
      expect(
        (await second.getCampaigns(
          mosqueId: _mosqueId,
        )).any((c) => c.isSample),
        isFalse,
      );
    });

    test('a deleted donation stays deleted across a restart', () async {
      final store = await _freshStore();
      final first = LocalDonationsRepository(
        seedDate: _seed,
        store: store,
        latency: Duration.zero,
      );
      final before = await first.getDonations(mosqueId: _mosqueId);
      final target = before.firstWhere((d) => d.countsAsConfirmed);

      await first.deleteDonation(target.id);

      final second = LocalDonationsRepository(
        seedDate: _seed,
        store: store,
        latency: Duration.zero,
      );
      final after = await second.getDonations(mosqueId: _mosqueId);
      expect(after.map((d) => d.id), isNot(contains(target.id)));
      expect(after, hasLength(before.length - 1));
    });

    test('a deleted expense stays deleted across a restart', () async {
      final store = await _freshStore();
      final first = LocalDonationsRepository(
        seedDate: _seed,
        store: store,
        latency: Duration.zero,
      );
      final before = await first.getExpenses(mosqueId: _mosqueId);
      expect(before, isNotEmpty);

      await first.deleteExpense(before.first.id);

      final second = LocalDonationsRepository(
        seedDate: _seed,
        store: store,
        latency: Duration.zero,
      );
      expect(
        (await second.getExpenses(mosqueId: _mosqueId)).map((e) => e.id),
        isNot(contains(before.first.id)),
      );
    });

    test('voiding still keeps the record and its trail', () async {
      // Delete is now available alongside void, so the distinction between
      // them is worth pinning: voiding must not start behaving like a
      // delete just because a delete exists.
      final repo = LocalDonationsRepository(
        seedDate: _seed,
        store: await _freshStore(),
        latency: Duration.zero,
      );
      final target = (await repo.getDonations(
        mosqueId: _mosqueId,
      )).firstWhere((d) => d.countsAsConfirmed);

      final voided = await repo.voidDonation(
        target.id,
        reason: 'duplicate',
        actor: 'tester',
        now: _seed,
      );

      expect(voided.isVoided, isTrue);
      expect(voided.countsAsConfirmed, isFalse);
      expect(voided.audit.length, greaterThan(target.audit.length));
      expect(
        (await repo.getDonations(mosqueId: _mosqueId)).map((d) => d.id),
        contains(target.id),
        reason: 'void keeps the row; only delete removes it',
      );
    });

    test('deleting a campaign keeps the donations made to it', () async {
      // A record of money received must not vanish because the campaign it
      // funded was tidied away.
      final store = await _freshStore();
      final first = LocalDonationsRepository(
        seedDate: _seed,
        store: store,
        latency: Duration.zero,
      );
      final donations = await first.getDonations(mosqueId: _mosqueId);
      final campaignId = donations.first.campaignId;

      await first.deleteCampaign(campaignId);

      final second = LocalDonationsRepository(
        seedDate: _seed,
        store: store,
        latency: Duration.zero,
      );
      expect(
        (await second.getCampaigns(mosqueId: _mosqueId)).map((c) => c.id),
        isNot(contains(campaignId)),
      );
      expect(
        (await second.getDonations(
          mosqueId: _mosqueId,
        )).where((d) => d.campaignId == campaignId),
        isNotEmpty,
      );
    });
  });

  group('Unreadable rows cost one record, not the screen', () {
    test('an event without an id or a start is dropped', () {
      expect(EventJson.fromJson({'title': 'no id'}), isNull);
      expect(EventJson.fromJson({'id': 'a', 'start': 'not a date'}), isNull);
      expect(
        EventJson.listFrom([
          {'id': 'a', 'start': _seed.toIso8601String()},
          {'title': 'broken'},
        ]),
        hasLength(1),
      );
    });

    test('an article without an id is dropped', () {
      expect(ArticleJson.fromJson({'title': <String, String>{}}), isNull);
    });

    test('a project without a readable budget is dropped', () {
      expect(ProjectJson.fromJson({'id': 'p'}), isNull);
      expect(
        ProjectJson.fromJson({
          'id': 'p',
          'budget': {'minor': 100, 'currency': 'XYZ'},
        }),
        isNull,
        reason: 'an unknown currency must not become a default one',
      );
    });

    test('an unknown enum value falls back instead of throwing', () {
      final event = EventJson.fromJson({
        'id': 'a',
        'start': _seed.toIso8601String(),
        'category': 'something_a_newer_build_wrote',
        'status': 'also_new',
      });
      expect(event, isNotNull);
      expect(event!.category, EventCategory.other);
      expect(event.status, EventStatus.scheduled);
    });
  });
}

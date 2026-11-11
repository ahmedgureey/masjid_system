import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/localization/l10n.dart';
import '../../../core/localization/locale_provider.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/widgets.dart';
import '../../../routing/app_routes.dart';
import '../../../routing/navigation_guard.dart';
import '../../donations/data/donations_repository.dart';
import '../../donations/models/donation_models.dart';
import '../../donations/widgets/donation_widgets.dart';
import '../../donations/widgets/finance_async.dart';
import '../../mosque/data/mosque_repository.dart';
import '../application/project_logic.dart';
import '../data/projects_repository.dart';
import '../models/project_category.dart';
import '../models/project_models.dart';
import '../widgets/project_widgets.dart';

/// "Mashaariicda Masaajidka": search, category / status filters, featured,
/// ongoing and recently added sections (each project shown once).
class ProjectsScreen extends ConsumerStatefulWidget {
  const ProjectsScreen({super.key});

  @override
  ConsumerState<ProjectsScreen> createState() => _ProjectsScreenState();
}

class _ProjectsScreenState extends ConsumerState<ProjectsScreen> {
  final _search = TextEditingController();
  String? _categoryId;
  ProjectStatus? _status;

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  Future<void> _refresh() async {
    ref
      ..invalidate(projectsProvider)
      ..invalidate(donationsProvider);
    await ref.read(projectsProvider.future);
  }

  bool get _filtering =>
      _search.text.trim().isNotEmpty || _categoryId != null || _status != null;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final canManage = ref.watch(canManageProjectsProvider);
    return Scaffold(
      appBar: AppTopBar(title: l10n.projTitle),
      floatingActionButton: canManage
          ? FloatingActionButton.extended(
              key: const Key('projectAdd'),
              onPressed: () => context.pushIfCurrent(AppRoutes.newProject),
              icon: const Icon(Icons.add_rounded),
              label: Text(l10n.projAdd),
            )
          : null,
      body: SafeArea(
        top: false,
        child: FinanceAsync<List<MosqueProject>, List<Donation>>(
          first: ref.watch(projectsProvider),
          second: ref.watch(donationsProvider),
          onRetry: _refresh,
          builder: (projects, donations) => RefreshIndicator(
            onRefresh: _refresh,
            child: _list(context, projects, donations),
          ),
        ),
      ),
    );
  }

  Widget _list(
    BuildContext context,
    List<MosqueProject> projects,
    List<Donation> donations,
  ) {
    final l10n = context.l10n;
    final lang = ref.watch(localeProvider).languageCode;
    final mosqueName = ref.watch(mosqueProvider).value?.name.resolve(lang);

    Widget card(MosqueProject p) => Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.space3),
      child: ProjectCard(
        key: ValueKey('project-${p.id}'),
        project: p,
        funding: ProjectLogic.funding(p, donations),
        mosqueName: mosqueName,
        lang: lang,
        onTap: () => context.pushIfCurrent(AppRoutes.project(p.id)),
      ),
    );

    Widget chip(Key key, String label, bool selected, VoidCallback onTap) =>
        Padding(
          padding: const EdgeInsetsDirectional.only(end: AppSpacing.space2),
          child: ChoiceChip(
            key: key,
            label: Text(label),
            selected: selected,
            onSelected: (_) => onTap(),
          ),
        );

    final children = <Widget>[
      TextField(
        key: const Key('projectSearch'),
        controller: _search,
        onChanged: (_) => setState(() {}),
        textInputAction: TextInputAction.search,
        decoration: InputDecoration(
          hintText: l10n.projSearchHint,
          prefixIcon: const Icon(Icons.search_rounded),
          suffixIcon: _search.text.isEmpty
              ? null
              : IconButton(
                  tooltip: l10n.newsClearSearch,
                  icon: const Icon(Icons.close_rounded),
                  onPressed: () => setState(_search.clear),
                ),
        ),
      ),
      const SizedBox(height: AppSpacing.space3),
      SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            chip(
              const Key('projCat-all'),
              l10n.donAllCategories,
              _categoryId == null,
              () => setState(() => _categoryId = null),
            ),
            for (final c in projectCategories)
              chip(
                ValueKey('projCat-${c.id}'),
                c.name.resolve(lang),
                _categoryId == c.id,
                () => setState(() => _categoryId = c.id),
              ),
          ],
        ),
      ),
      const SizedBox(height: AppSpacing.space2),
      SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            chip(
              const Key('projStatus-all'),
              l10n.donFilterAll,
              _status == null,
              () => setState(() => _status = null),
            ),
            for (final s in ProjectStatus.values)
              chip(
                ValueKey('projStatus-${s.name}'),
                s.label(l10n),
                _status == s,
                () => setState(() => _status = s),
              ),
          ],
        ),
      ),
      if (projects.any((p) => p.isSample)) ...[
        const SizedBox(height: AppSpacing.space3),
        DonationNotice(
          key: const Key('projectsSampleNotice'),
          icon: Icons.science_outlined,
          title: l10n.projSampleTitle,
          text: l10n.projSampleMessage,
        ),
      ],
      const SizedBox(height: AppSpacing.space4),
    ];

    if (projects.isEmpty) {
      children.add(
        EmptyState(
          icon: Icons.construction_rounded,
          title: l10n.projEmptyTitle,
          message: l10n.projEmptyMessage,
        ),
      );
    } else if (_filtering) {
      final results = ProjectLogic.filter(
        projects,
        query: _search.text,
        categoryId: _categoryId,
        status: _status,
      );
      if (results.isEmpty) {
        children.add(
          EmptyState(
            icon: Icons.search_off_rounded,
            title: l10n.projNoResults,
            message: l10n.newsNoResultsMessage,
          ),
        );
      } else {
        children.addAll(results.map(card));
      }
    } else {
      final sorted = ProjectLogic.filter(projects);
      final featured = sorted.where((p) => p.isFeatured).toList();
      final ongoing = sorted
          .where((p) => !p.isFeatured && p.status == ProjectStatus.ongoing)
          .toList();
      final others = sorted
          .where((p) => !featured.contains(p) && !ongoing.contains(p))
          .toList();
      void section(String title, List<MosqueProject> items) {
        if (items.isEmpty) return;
        children
          ..add(SectionHeader(title: title))
          ..addAll(items.map(card))
          ..add(const SizedBox(height: AppSpacing.space2));
      }

      section(l10n.projFeatured, featured);
      section(l10n.projOngoing, ongoing);
      section(l10n.projRecent, others);
    }

    return ListView(
      key: const Key('projectsList'),
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.space4,
        AppSpacing.space4,
        AppSpacing.space4,
        96,
      ),
      children: children,
    );
  }
}

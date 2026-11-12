import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/localization/l10n.dart';
import '../../../core/localization/locale_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/clock_provider.dart';
import '../../../core/utils/validators.dart';
import '../../../core/widgets/widgets.dart';
import '../../../models/localized_text.dart';
import '../../../routing/app_routes.dart';
import '../../mosque/data/mosque_repository.dart';
import '../data/articles_repository.dart';
import '../models/article.dart';
import '../models/article_category.dart';

/// Add / edit article form for mosque administrators. Access is guarded by
/// the router (frontend-only, see `canManageNewsProvider`). Saves go to the
/// in-memory mock repository; the success message says the change is
/// temporary.
class EditArticleScreen extends ConsumerWidget {
  const EditArticleScreen({super.key, this.articleId});

  /// Null → new article.
  final String? articleId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final articlesAsync = ref.watch(articlesProvider);
    final categories =
        ref.watch(articleCategoriesProvider).value ?? const <ArticleCategory>[];
    final mosque = ref.watch(mosqueProvider).value;

    return articlesAsync.when(
      loading: () => const Scaffold(body: AppLoadingIndicator()),
      error: (_, _) => Scaffold(
        appBar: const AppTopBar(),
        body: ErrorState(onRetry: () => ref.invalidate(articlesProvider)),
      ),
      data: (articles) {
        if (mosque == null) {
          return const Scaffold(body: AppLoadingIndicator());
        }
        if (articleId == null) {
          return _ArticleForm(
            initial: null,
            categories: categories,
            mosqueId: mosque.id,
          );
        }
        final article = articles.where((a) => a.id == articleId).firstOrNull;
        if (article == null) {
          return Scaffold(
            appBar: const AppTopBar(),
            body: EmptyState(
              icon: Icons.article_outlined,
              title: l10n.newsNotFound,
            ),
          );
        }
        return _ArticleForm(
          initial: article,
          categories: categories,
          mosqueId: mosque.id,
        );
      },
    );
  }
}

class _ArticleForm extends ConsumerStatefulWidget {
  const _ArticleForm({
    required this.initial,
    required this.categories,
    required this.mosqueId,
  });

  final Article? initial;
  final List<ArticleCategory> categories;
  final String mosqueId;

  @override
  ConsumerState<_ArticleForm> createState() => _ArticleFormState();
}

class _ArticleFormState extends ConsumerState<_ArticleForm> {
  final _formKey = GlobalKey<FormState>();
  late final String _lang = ref.read(localeProvider).languageCode;

  late final _title = TextEditingController(
    text: widget.initial?.title.resolve(_lang),
  );
  late final _summary = TextEditingController(
    text: widget.initial?.summary.resolve(_lang),
  );
  late final _cover = TextEditingController(
    text: widget.initial?.coverImageUrl,
  );
  late final _author = TextEditingController(text: widget.initial?.authorName);
  late final _body = TextEditingController(text: _initialBodyText);

  late String? _categoryId = widget.initial?.categoryId;
  late ArticleStatus _status = widget.initial?.status ?? ArticleStatus.draft;
  late bool _featured = widget.initial?.isFeatured ?? false;

  bool _saving = false;
  bool _allowPop = false;

  bool get _isNew => widget.initial == null;

  /// The simple editor only understands paragraphs. An article that also has
  /// headings, images or quotations keeps its body exactly as it is — losing
  /// an author's work to a half-built editor would be worse than making them
  /// wait for the full one.
  late final bool _bodyEditable =
      widget.initial == null ||
      widget.initial!.body.every((b) => b is ParagraphBlock);

  String get _initialBodyText {
    final initial = widget.initial;
    if (initial == null) return '';
    return [
      for (final block in initial.body)
        if (block is ParagraphBlock) block.text.resolve(_lang),
    ].join('\n\n');
  }

  @override
  void initState() {
    super.initState();
    for (final c in [_title, _summary, _cover, _author, _body]) {
      c.addListener(_onChanged);
    }
  }

  @override
  void dispose() {
    for (final c in [_title, _summary, _cover, _author, _body]) {
      c.dispose();
    }
    super.dispose();
  }

  void _onChanged() => setState(() {});

  /// Keeps the translations this form does not edit.
  LocalizedText _localized(LocalizedText? existing, String text) =>
      LocalizedText({...?existing?.values, _lang: text.trim()});

  List<ArticleBlock> _bodyBlocks() {
    final initial = widget.initial;
    if (!_bodyEditable) return initial!.body;
    final paragraphs = _body.text
        .split(RegExp(r'\n\s*\n'))
        .map((p) => p.trim())
        .where((p) => p.isNotEmpty);
    // Paragraph n of the edited language replaces paragraph n of the stored
    // body, so the other languages survive a text edit.
    final existing = <ParagraphBlock>[
      for (final b in initial?.body ?? const <ArticleBlock>[])
        if (b is ParagraphBlock) b,
    ];
    var index = 0;
    return [
      for (final p in paragraphs)
        ParagraphBlock(
          _localized(
            index < existing.length ? existing[index++].text : null,
            p,
          ),
        ),
    ];
  }

  Article _snapshot(DateTime now) {
    final i = widget.initial;
    String? opt(TextEditingController c) =>
        c.text.trim().isEmpty ? null : c.text.trim();
    final published = _status == ArticleStatus.published;
    return Article(
      id: i?.id ?? 'local-${DateTime.now().microsecondsSinceEpoch}',
      mosqueId: i?.mosqueId ?? widget.mosqueId,
      slug: i?.slug,
      title: _localized(i?.title, _title.text),
      summary: _localized(i?.summary, _summary.text),
      body: _bodyBlocks(),
      coverImageUrl: opt(_cover),
      categoryId: _categoryId ?? i?.categoryId ?? '',
      authorId: i?.authorId,
      authorName: opt(_author),
      status: _status,
      isFeatured: _featured,
      // Stamped the first time it is published, then left alone.
      publishedAt: published ? (i?.publishedAt ?? now) : i?.publishedAt,
      createdAt: i?.createdAt ?? now,
      updatedAt: i == null ? null : now,
      sourceReferences: i?.sourceReferences ?? const [],
      shareUrl: i?.shareUrl,
      isSample: i?.isSample ?? false,
    );
  }

  bool get _isDirty {
    final i = widget.initial;
    if (i == null) {
      return _title.text.trim().isNotEmpty ||
          _summary.text.trim().isNotEmpty ||
          _cover.text.trim().isNotEmpty ||
          _author.text.trim().isNotEmpty ||
          _body.text.trim().isNotEmpty ||
          _categoryId != null ||
          _featured ||
          _status != ArticleStatus.draft;
    }
    return _title.text.trim() != i.title.resolve(_lang) ||
        _summary.text.trim() != i.summary.resolve(_lang) ||
        (_cover.text.trim().isEmpty ? null : _cover.text.trim()) !=
            i.coverImageUrl ||
        (_author.text.trim().isEmpty ? null : _author.text.trim()) !=
            i.authorName ||
        _body.text.trim() != _initialBodyText.trim() ||
        _categoryId != i.categoryId ||
        _status != i.status ||
        _featured != i.isFeatured;
  }

  Future<void> _save() async {
    if (_saving) return; // prevents duplicate submissions
    FocusScope.of(context).unfocus();
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _saving = true);
    final l10n = context.l10n;
    final messenger = ScaffoldMessenger.of(context);
    final now = ref.read(clockProvider).value ?? DateTime.now();
    try {
      await ref.read(articlesProvider.notifier).save(_snapshot(now));
      if (!mounted) return;
      messenger.showSnackBar(SnackBar(content: Text(l10n.newsSavedLocal)));
      setState(() => _allowPop = true);
      _leave();
    } catch (_) {
      if (!mounted) return;
      setState(() => _saving = false);
      messenger.showSnackBar(
        SnackBar(
          backgroundColor: AppColors.error,
          content: Text(l10n.newsSaveError),
        ),
      );
    }
  }

  /// Back to the previous screen, or to the news list when the form was
  /// opened directly (deep link) and there is nothing to go back to.
  void _leave() {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go(AppRoutes.news);
    }
  }

  Future<void> _cancel() async {
    if (!_isDirty || await _confirmDiscard()) {
      if (!mounted) return;
      setState(() => _allowPop = true);
      _leave();
    }
  }

  Future<bool> _confirmDiscard() async {
    final l10n = context.l10n;
    final discard = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.discardTitle),
        content: Text(l10n.discardMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(l10n.discardKeepEditing),
          ),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(l10n.discardConfirm),
          ),
        ],
      ),
    );
    return discard ?? false;
  }

  String _statusLabel(ArticleStatus status, AppLocalizations l10n) =>
      switch (status) {
        ArticleStatus.draft => l10n.newsStatusDraft,
        ArticleStatus.published => l10n.newsStatusPublished,
        ArticleStatus.archived => l10n.newsStatusArchived,
      };

  Widget _gap(Widget child, {Key? key}) => Padding(
    key: key,
    padding: const EdgeInsets.only(bottom: AppSpacing.space4),
    child: child,
  );

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final textTheme = Theme.of(context).textTheme;

    return PopScope(
      canPop: _allowPop || !_isDirty,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _cancel();
      },
      child: Scaffold(
        appBar: AppTopBar(
          title: _isNew ? l10n.newsFormNewTitle : l10n.newsFormEditTitle,
        ),
        body: SafeArea(
          top: false,
          child: Column(
            children: [
              Expanded(
                // Not a ListView: every field stays mounted for validation.
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(AppSpacing.space4),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _gap(
                          key: const Key('articleFieldTitle'),
                          AppTextField(
                            label: l10n.newsFieldTitle,
                            controller: _title,
                            isRequired: true,
                            maxLines: 2,
                            validator: AppValidators.required(l10n),
                          ),
                        ),
                        _gap(
                          key: const Key('articleFieldSummary'),
                          AppTextField(
                            label: l10n.newsFieldSummary,
                            controller: _summary,
                            isRequired: true,
                            maxLines: 3,
                            validator: AppValidators.required(l10n),
                          ),
                        ),
                        _gap(
                          DropdownButtonFormField<String>(
                            key: const Key('articleFieldCategory'),
                            initialValue: _categoryId,
                            isExpanded: true,
                            decoration: InputDecoration(
                              labelText: l10n.newsFieldCategory,
                            ),
                            onChanged: (v) => setState(() => _categoryId = v),
                            validator: (v) =>
                                v == null ? l10n.newsValidationCategory : null,
                            items: [
                              for (final c in widget.categories)
                                DropdownMenuItem(
                                  value: c.id,
                                  child: Text(c.name.resolve(_lang)),
                                ),
                            ],
                          ),
                        ),
                        if (!_bodyEditable)
                          _gap(
                            AppCard(
                              variant: AppCardVariant.gold,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(
                                    Icons.info_outline_rounded,
                                    color: AppColors.gold800,
                                  ),
                                  const SizedBox(width: AppSpacing.space3),
                                  Expanded(
                                    child: Text(
                                      l10n.newsBodyRichNotice,
                                      style: textTheme.bodySmall?.copyWith(
                                        color: AppColors.gold800,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        _gap(
                          key: const Key('articleFieldBody'),
                          AppTextField(
                            label: l10n.newsFieldBody,
                            controller: _body,
                            enabled: _bodyEditable,
                            isRequired: _bodyEditable,
                            maxLines: 10,
                            helperText: l10n.newsBodyHint,
                            validator: _bodyEditable
                                ? AppValidators.required(l10n)
                                : null,
                          ),
                        ),
                        _gap(
                          key: const Key('articleFieldCover'),
                          AppTextField(
                            label: l10n.newsFieldCover,
                            controller: _cover,
                            keyboardType: TextInputType.url,
                            prefixIcon: Icons.image_outlined,
                            validator: AppValidators.optional(
                              AppValidators.url(l10n),
                            ),
                          ),
                        ),
                        _gap(
                          key: const Key('articleFieldAuthor'),
                          AppTextField(
                            label: l10n.newsFieldAuthor,
                            controller: _author,
                            prefixIcon: Icons.person_outline_rounded,
                          ),
                        ),
                        _gap(
                          DropdownButtonFormField<ArticleStatus>(
                            key: const Key('articleFieldStatus'),
                            initialValue: _status,
                            isExpanded: true,
                            decoration: InputDecoration(
                              labelText: l10n.newsFieldStatus,
                            ),
                            onChanged: (v) => setState(
                              () => _status = v ?? ArticleStatus.draft,
                            ),
                            items: [
                              for (final s in ArticleStatus.values)
                                DropdownMenuItem(
                                  value: s,
                                  child: Text(_statusLabel(s, l10n)),
                                ),
                            ],
                          ),
                        ),
                        AppCheckboxField(
                          key: const Key('articleFieldFeatured'),
                          label: Text(l10n.newsFieldFeatured),
                          initialValue: _featured,
                          onChanged: (v) => setState(() => _featured = v),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              _ActionBar(
                saveLabel: l10n.profileSave,
                cancelLabel: l10n.profileCancel,
                saving: _saving,
                onSave: _save,
                onCancel: _saving ? null : _cancel,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActionBar extends StatelessWidget {
  const _ActionBar({
    required this.saveLabel,
    required this.cancelLabel,
    required this.saving,
    required this.onSave,
    required this.onCancel,
  });

  final String saveLabel;
  final String cancelLabel;
  final bool saving;
  final VoidCallback onSave;
  final VoidCallback? onCancel;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: Color(0x0F1F2937),
            blurRadius: 8,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.space3),
        child: Row(
          children: [
            Expanded(
              child: AppButton.secondary(
                key: const Key('articleCancelButton'),
                label: cancelLabel,
                expand: true,
                onPressed: onCancel,
              ),
            ),
            const SizedBox(width: AppSpacing.space3),
            Expanded(
              child: AppButton.primary(
                key: const Key('articleSaveButton'),
                label: saveLabel,
                icon: Icons.check_rounded,
                expand: true,
                isLoading: saving,
                onPressed: onSave,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

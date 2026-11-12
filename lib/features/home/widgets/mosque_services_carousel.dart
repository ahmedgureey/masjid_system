import 'dart:async';

import 'package:material_ui/material_ui.dart';

import '../../../core/localization/l10n.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../models/mosque_service_slide.dart';

/// Auto-rotating hero banner at the top of the dashboard.
///
/// Shows one mosque service at a time over the green header. Rotation is
/// paused while the user touches the carousel, while the screen is covered by
/// another route ([TickerMode]), and whenever the platform asks for reduced
/// motion — the last case also keeps widget tests deterministic, because the
/// test harness relies on `pumpAndSettle`.
class MosqueServicesCarousel extends StatefulWidget {
  const MosqueServicesCarousel({
    super.key,
    required this.slides,
    required this.onSlideTap,
    this.interval = const Duration(seconds: 5),
    this.transition = const Duration(milliseconds: 420),
  });

  final List<MosqueServiceSlide> slides;

  /// Opens the route of the tapped slide.
  final ValueChanged<MosqueServiceSlide> onSlideTap;

  final Duration interval;
  final Duration transition;

  /// Below this height the icon badge is dropped so the text still fits.
  /// Scaled by the system font size, so a large accessibility setting gives
  /// the words the room the badge would have taken.
  static const double _compactHeight = 128;

  @override
  State<MosqueServicesCarousel> createState() => _MosqueServicesCarouselState();
}

class _MosqueServicesCarouselState extends State<MosqueServicesCarousel> {
  /// The carousel wraps around, so the controller starts deep inside a large
  /// virtual range and `page % slides.length` picks the slide. No visible
  /// jump back to the first page.
  static const int _virtualLoops = 1000;

  late final PageController _controller;
  Timer? _timer;
  int _index = 0;
  bool _reduceMotion = false;
  bool _tickerEnabled = true;

  int get _count => widget.slides.length;

  @override
  void initState() {
    super.initState();
    _controller = PageController(initialPage: _count * _virtualLoops);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _reduceMotion = MediaQuery.disableAnimationsOf(context);
    _tickerEnabled = TickerMode.valuesOf(context).enabled;
    _syncTimer();
  }

  @override
  void didUpdateWidget(MosqueServicesCarousel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.interval != widget.interval ||
        oldWidget.slides.length != widget.slides.length) {
      _syncTimer();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _timer = null;
    _controller.dispose();
    super.dispose();
  }

  /// Single place that decides whether the timer should be running.
  void _syncTimer() {
    final shouldRun = _tickerEnabled && !_reduceMotion && _count > 1;
    if (shouldRun) {
      _start();
    } else {
      _stop();
    }
  }

  void _start() {
    _timer?.cancel();
    _timer = Timer.periodic(widget.interval, (_) => _advance());
  }

  void _stop() {
    _timer?.cancel();
    _timer = null;
  }

  void _advance() {
    // The timer is cancelled in dispose(), but guard anyway: a callback must
    // never touch a disposed controller or an unmounted element.
    if (!mounted || !_controller.hasClients) return;
    final page = _controller.page?.round() ?? _controller.initialPage;
    _controller.animateToPage(
      page + 1,
      duration: widget.transition,
      curve: Curves.easeInOut,
    );
  }

  void _onPageChanged(int page) {
    final next = page % _count;
    if (next == _index) return;
    setState(() => _index = next);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Column(
      children: [
        Expanded(
          child: Listener(
            // Pause while the finger is down, resume when it leaves.
            onPointerDown: (_) => _stop(),
            onPointerUp: (_) => _syncTimer(),
            onPointerCancel: (_) => _syncTimer(),
            child: PageView.builder(
              key: const Key('homeServicesCarousel'),
              controller: _controller,
              onPageChanged: _onPageChanged,
              itemBuilder: (context, page) {
                final slide = widget.slides[page % _count];
                return _Slide(
                  slide: slide,
                  l10n: l10n,
                  onTap: () => widget.onSlideTap(slide),
                );
              },
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.space3),
        Semantics(
          // Generic "Page x of y" wording, shared with onboarding.
          label: l10n.onboardingPageLabel(_index + 1, _count),
          child: ExcludeSemantics(
            child: _Dots(count: _count, index: _index, animate: !_reduceMotion),
          ),
        ),
      ],
    );
  }
}

class _Slide extends StatelessWidget {
  const _Slide({required this.slide, required this.l10n, required this.onTap});

  final MosqueServiceSlide slide;
  final AppLocalizations l10n;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: onTap,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final textScale = MediaQuery.textScalerOf(context).scale(16) / 16;
            final compact =
                constraints.maxHeight <
                MosqueServicesCarousel._compactHeight * textScale;
            return Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.space5,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (!compact) ...[
                    _SlideBadge(icon: slide.icon),
                    const SizedBox(height: AppSpacing.space3),
                  ],
                  Flexible(
                    child: Text(
                      slide.title(l10n),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.titleMedium?.copyWith(
                        color: AppColors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.space1),
                  Flexible(
                    child: Text(
                      slide.subtitle(l10n),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.bodySmall?.copyWith(
                        color: AppColors.green100,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

/// Gold-ringed icon badge: the illustration for a slide. Vector only — the
/// project ships no mosque photography, and a broken image URL would be worse
/// than an honest symbol.
class _SlideBadge extends StatelessWidget {
  const _SlideBadge({required this.icon});

  final IconData icon;

  static const double _size = 52;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: _size,
      height: _size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.white.withValues(alpha: 0.10),
        border: Border.all(
          color: AppColors.gold.withValues(alpha: 0.65),
          width: 1.5,
        ),
      ),
      child: Icon(icon, size: _size * 0.5, color: AppColors.gold),
    );
  }
}

/// Page dots sized for a dark background: gold pill for the active slide.
class _Dots extends StatelessWidget {
  const _Dots({
    required this.count,
    required this.index,
    required this.animate,
  });

  final int count;
  final int index;
  final bool animate;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < count; i++)
          AnimatedContainer(
            duration: animate
                ? const Duration(milliseconds: 250)
                : Duration.zero,
            margin: const EdgeInsets.symmetric(horizontal: 3),
            width: i == index ? 20 : 6,
            height: 6,
            decoration: BoxDecoration(
              color: i == index
                  ? AppColors.gold
                  : AppColors.white.withValues(alpha: 0.35),
              borderRadius: BorderRadius.circular(AppRadius.full),
            ),
          ),
      ],
    );
  }
}

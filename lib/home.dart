import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:planning_poker_open/shared/presentation/widgets/basic_toolbar.dart';
import 'package:planning_poker_open/shared/utils/routes_names.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: Column(
        children: [
          const BasicToolBar(showCreateNewGameButton: true),
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 600),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: colorScheme.primaryContainer.withOpacity(0.3),
                          shape: BoxShape.circle,
                        ),
                        child: SvgPicture.asset(
                          'assets/img/planning_poker_icon.svg',
                          colorFilter: ColorFilter.mode(
                            colorScheme.primary,
                            BlendMode.srcIn,
                          ),
                          height: 64,
                        ),
                      ),
                      const SizedBox(height: 32),
                      SelectableText(
                        'Free Scrum Poker\nfor agile teams',
                        textAlign: TextAlign.center,
                        style: textTheme.headlineLarge?.copyWith(
                          fontWeight: FontWeight.w800,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 16),
                      SelectableText(
                        'Estimate your stories collaboratively in real time.\nUse it for free or deploy your own version.',
                        textAlign: TextAlign.center,
                        style: textTheme.bodyLarge?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                          height: 1.6,
                        ),
                      ),
                      const SizedBox(height: 40),
                      FilledButton.icon(
                        icon: const Icon(Icons.add),
                        label: const Text('Create new game'),
                        style: FilledButton.styleFrom(
                          minimumSize: const Size(240, 52),
                          textStyle: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          context.goNamed(RoutesNames.createGame);
                        },
                      ),
                      const SizedBox(height: 48),
                      FittedBox(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _FeatureChip(
                              icon: Icons.bolt_outlined,
                              label: 'Real-time',
                              colorScheme: colorScheme,
                            ),
                            const SizedBox(width: 12),
                            _FeatureChip(
                              icon: Icons.group_outlined,
                              label: 'Collaborative',
                              colorScheme: colorScheme,
                            ),
                            const SizedBox(width: 12),
                            _FeatureChip(
                              icon: Icons.lock_open_outlined,
                              label: 'Open source',
                              colorScheme: colorScheme,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FeatureChip extends StatelessWidget {
  const _FeatureChip({
    required this.icon,
    required this.label,
    required this.colorScheme,
  });

  final IconData icon;
  final String label;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withOpacity(0.4),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: colorScheme.primary),
          const SizedBox(width: 6),
          SelectableText(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:planning_poker_open/edit_user_data/edit_user_data_dialog.dart';
import 'package:planning_poker_open/shared/presentation/widgets/basic_separation_space.dart';
import 'package:planning_poker_open/shared/styles/basic_styles.dart';
import 'package:planning_poker_open/shared/utils/helpers.dart';
import 'package:planning_poker_open/shared/utils/routes_names.dart';
import 'package:planning_poker_open/user_authentication/models/user_app.dart';

/// Breakpoint below which the toolbar switches to the mobile (bottom sheet) layout.
const double _kMobileBreakpoint = 600;

class BasicToolBar extends StatelessWidget {
  const BasicToolBar({
    super.key,
    this.title,
    this.actions,
    this.showCreateNewGameButton = false,
  });

  final Widget? title;
  final bool showCreateNewGameButton;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    final UserApp? activeUser = getActiveUserApp(context);
    final bool isUserLogged = activeUser != null;

    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isMobile = constraints.maxWidth < _kMobileBreakpoint;

        if (isMobile) {
          return _MobileToolBar(
            title: title,
            actions: actions,
            showCreateNewGameButton: showCreateNewGameButton,
            activeUser: activeUser,
            isUserLogged: isUserLogged,
          );
        }

        return _DesktopToolBar(
          title: title,
          actions: actions,
          showCreateNewGameButton: showCreateNewGameButton,
          activeUser: activeUser,
          isUserLogged: isUserLogged,
        );
      },
    );
  }
}

class _DesktopToolBar extends StatelessWidget {
  const _DesktopToolBar({
    required this.title,
    required this.actions,
    required this.showCreateNewGameButton,
    required this.activeUser,
    required this.isUserLogged,
  });

  final Widget? title;
  final List<Widget>? actions;
  final bool showCreateNewGameButton;
  final UserApp? activeUser;
  final bool isUserLogged;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 32,
        vertical: 24,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _LogoTitle(title: title, colorScheme: colorScheme),
          Row(
            children: [
              if (actions != null && actions!.isNotEmpty) ...[
                ...actions!,
                const SizedBox(width: 8),
              ],
              if (isUserLogged) ...[
                TextButton.icon(
                  onPressed: () {
                    context.goNamed(RoutesNames.myGames);
                  },
                  icon: const Icon(Icons.history_outlined),
                  label: const Text('My games'),
                  style: TextButton.styleFrom(
                    foregroundColor: colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(width: 8),
              ],
              if (showCreateNewGameButton) ...[
                ElevatedButton(
                  onPressed: () {
                    context.goNamed(RoutesNames.createGame);
                  },
                  child: const Text('Create new game'),
                ),
                const SizedBox(width: 16),
              ],
              if (isUserLogged) _UserAvatarButton(activeUser: activeUser!),
            ],
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Mobile layout – collapses actions into a bottom sheet
// ---------------------------------------------------------------------------

class _MobileToolBar extends StatelessWidget {
  const _MobileToolBar({
    required this.title,
    required this.actions,
    required this.showCreateNewGameButton,
    required this.activeUser,
    required this.isUserLogged,
  });

  final Widget? title;
  final List<Widget>? actions;
  final bool showCreateNewGameButton;
  final UserApp? activeUser;
  final bool isUserLogged;

  void _openBottomSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => _ToolbarBottomSheet(
        actions: actions,
        showCreateNewGameButton: showCreateNewGameButton,
        activeUser: activeUser,
        isUserLogged: isUserLogged,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _LogoTitle(title: title, colorScheme: colorScheme),
          _MobileMenuButton(
            activeUser: activeUser,
            isUserLogged: isUserLogged,
            onTap: () => _openBottomSheet(context),
          ),
        ],
      ),
    );
  }
}

class _MobileMenuButton extends StatelessWidget {
  const _MobileMenuButton({
    required this.activeUser,
    required this.isUserLogged,
    required this.onTap,
  });

  final UserApp? activeUser;
  final bool isUserLogged;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    if (isUserLogged && activeUser != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest.withOpacity(0.5),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: colorScheme.outlineVariant.withOpacity(0.5),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                maxRadius: 14,
                backgroundColor: Colors.blueAccent.withOpacity(0.15),
                foregroundColor: Colors.blueAccent,
                child: Text(
                  activeUser!.username[0].toUpperCase(),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
              const SizedBox(width: 6),
              Icon(
                Icons.menu,
                size: 18,
                color: colorScheme.primary,
              ),
            ],
          ),
        ),
      );
    }

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest.withOpacity(0.5),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: colorScheme.outlineVariant.withOpacity(0.5),
          ),
        ),
        child: Icon(
          Icons.menu_rounded,
          size: 20,
          color: colorScheme.onSurface,
        ),
      ),
    );
  }
}

class _ToolbarBottomSheet extends StatelessWidget {
  const _ToolbarBottomSheet({
    required this.actions,
    required this.showCreateNewGameButton,
    required this.activeUser,
    required this.isUserLogged,
  });

  final List<Widget>? actions;
  final bool showCreateNewGameButton;
  final UserApp? activeUser;
  final bool isUserLogged;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Drag handle
            Center(
              child: Container(
                width: 36,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: colorScheme.outlineVariant,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),

            // User info card (if logged in)
            if (isUserLogged && activeUser != null) ...[
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: _UserInfoTile(activeUser: activeUser!),
              ),
              const SizedBox(height: 16),
            ],

            // Nav section header label
            if (isUserLogged || actions != null)
              Padding(
                padding: const EdgeInsets.only(left: 4, bottom: 8),
                child: Text(
                  'Navigation',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        letterSpacing: 0.8,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),

            // Extra page-specific actions
            if (actions != null && actions!.isNotEmpty) ...[
              ...actions!.map(
                (action) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: action,
                ),
              ),
              const SizedBox(height: 4),
            ],

            // My games
            if (isUserLogged)
              _BottomSheetNavItem(
                icon: Icons.history_outlined,
                label: 'My games',
                onTap: () {
                  Navigator.pop(context);
                  context.goNamed(RoutesNames.myGames);
                },
              ),

            // Create new game – primary CTA
            if (showCreateNewGameButton)
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: FilledButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    context.goNamed(RoutesNames.createGame);
                  },
                  icon: const Icon(Icons.add_rounded),
                  label: const Text('Create new game'),
                  style: FilledButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                    textStyle: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// A single tappable nav row inside the bottom sheet.
class _BottomSheetNavItem extends StatelessWidget {
  const _BottomSheetNavItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer.withOpacity(0.5),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                size: 18,
                color: colorScheme.primary,
              ),
            ),
            const SizedBox(width: 14),
            Text(
              label,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
            ),
            const Spacer(),
            Icon(
              Icons.chevron_right_rounded,
              size: 20,
              color: colorScheme.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }
}

class _LogoTitle extends StatelessWidget {
  const _LogoTitle({
    required this.title,
    required this.colorScheme,
  });

  final Widget? title;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () {
              context.go(RoutesNames.home);
            },
            child: SvgPicture.asset(
              'assets/img/planning_poker_icon.svg',
              colorFilter: ColorFilter.mode(
                colorScheme.primary,
                BlendMode.srcIn,
              ),
              height: 44,
            ),
          ),
        ),
        const BasicSeparationSpace.horizontal(multiplier: 0.4),
        title ??
            const SelectableText(
              'Planning Poker',
              style: BasicStyles.titleStyle,
            ),
      ],
    );
  }
}

class _UserAvatarButton extends StatelessWidget {
  const _UserAvatarButton({required this.activeUser});

  final UserApp activeUser;

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        return InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: () {
            final RenderBox box = context.findRenderObject()! as RenderBox;
            final Offset offset = box.localToGlobal(Offset.zero);

            showDialog<void>(
              context: context,
              barrierColor: Colors.transparent,
              builder: (_) => SizedBox(
                width: 320,
                child: Stack(
                  children: [
                    Positioned(
                      left: offset.dx - 120,
                      top: offset.dy + box.size.height + 8,
                      child: Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: BorderSide(
                            color: Theme.of(context)
                                .colorScheme
                                .outlineVariant
                                .withOpacity(0.5),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 24,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CircleAvatar(
                                radius: 28,
                                backgroundColor:
                                    Colors.blueAccent.withOpacity(0.15),
                                foregroundColor: Colors.blueAccent,
                                child: Text(
                                  activeUser.username[0].toUpperCase(),
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  MouseRegion(
                                    cursor: SystemMouseCursors.click,
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.pop(context);
                                        showDialog(
                                          context: context,
                                          builder: (_) => EditUserDataDialog(
                                            actualUserData: activeUser,
                                          ),
                                        );
                                      },
                                      child: Row(
                                        children: [
                                          SelectableText(
                                            activeUser.username,
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium
                                                ?.copyWith(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                          ),
                                          const SizedBox(width: 6),
                                          Icon(
                                            Icons.edit_outlined,
                                            size: 16,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSurfaceVariant,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondaryContainer,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: SelectableText(
                                      activeUser.type,
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelSmall
                                          ?.copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSecondaryContainer,
                                          ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(width: 16),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 6,
            ),
            child: Row(
              children: [
                CircleAvatar(
                  maxRadius: 16,
                  backgroundColor: Colors.blueAccent.withOpacity(0.15),
                  foregroundColor: Colors.blueAccent,
                  child: Text(
                    activeUser.username[0].toUpperCase(),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                SelectableText(
                  activeUser.username,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(width: 4),
                Icon(
                  Icons.keyboard_arrow_down_rounded,
                  size: 20,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// User info tile shown at the top of the mobile bottom sheet.
class _UserInfoTile extends StatelessWidget {
  const _UserInfoTile({required this.activeUser});

  final UserApp activeUser;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        // Avatar with a soft glow ring
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.blueAccent.withOpacity(0.25),
              width: 2,
            ),
          ),
          child: CircleAvatar(
            radius: 24,
            backgroundColor: Colors.blueAccent.withOpacity(0.15),
            foregroundColor: Colors.blueAccent,
            child: Text(
              activeUser.username[0].toUpperCase(),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Tappable username row
              InkWell(
                borderRadius: BorderRadius.circular(8),
                onTap: () {
                  Navigator.pop(context);
                  showDialog<void>(
                    context: context,
                    builder: (_) => EditUserDataDialog(
                      actualUserData: activeUser,
                    ),
                  );
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      activeUser.username,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: colorScheme.secondaryContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  activeUser.type,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: colorScheme.onSecondaryContainer,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

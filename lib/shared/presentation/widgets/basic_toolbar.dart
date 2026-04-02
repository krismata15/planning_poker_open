import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:planning_poker_open/edit_user_data/edit_user_data_dialog.dart';
import 'package:planning_poker_open/shared/presentation/widgets/basic_separation_space.dart';
import 'package:planning_poker_open/shared/styles/basic_styles.dart';
import 'package:planning_poker_open/shared/utils/helpers.dart';
import 'package:planning_poker_open/shared/utils/routes_names.dart';
import 'package:planning_poker_open/user_authentication/models/user_app.dart';

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
    final colorScheme = Theme.of(context).colorScheme;
    final UserApp? activeUser = getActiveUserApp(context);
    final bool isUserLogged = activeUser != null;
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 32,
        vertical: 24,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
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
              //Image.asset('img/paz.jpg'),
              const BasicSeparationSpace.horizontal(multiplier: 0.4),
              title ??
                  const Text(
                    'Planning Poker',
                    style: BasicStyles.titleStyle,
                  ),
            ],
          ),
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
                    foregroundColor:
                        Theme.of(context).colorScheme.onSurfaceVariant,
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
              if (isUserLogged)
                Builder(
                  builder: (context) {
                    return InkWell(
                      borderRadius: BorderRadius.circular(24),
                      onTap: () {
                        final RenderBox box =
                            context.findRenderObject()! as RenderBox;
                        final Offset offset = box.localToGlobal(Offset.zero);

                        showDialog(
                          context: context,
                          barrierColor: Colors.transparent,
                          builder: (_) => SizedBox(
                            width: 320,
                            child: Stack(
                              children: [
                                Positioned(
                                  left: offset.dx -
                                      120, // Adjusted for better alignment
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
                                            backgroundColor: Colors.blueAccent
                                                .withOpacity(0.15),
                                            foregroundColor: Colors.blueAccent,
                                            child: Text(
                                              activeUser.username[0]
                                                  .toUpperCase(),
                                              style: const TextStyle(
                                                fontSize: 22,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 16),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              MouseRegion(
                                                cursor:
                                                    SystemMouseCursors.click,
                                                child: GestureDetector(
                                                  onTap: () {
                                                    Navigator.pop(context);
                                                    showDialog(
                                                      context: context,
                                                      builder: (_) =>
                                                          EditUserDataDialog(
                                                        actualUserData:
                                                            activeUser,
                                                      ),
                                                    );
                                                  },
                                                  child: Row(
                                                    children: [
                                                      Text(
                                                        activeUser.username,
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .titleMedium
                                                            ?.copyWith(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
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
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 8,
                                                        vertical: 2),
                                                decoration: BoxDecoration(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .secondaryContainer,
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                                child: Text(
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
                                          const SizedBox(
                                              width: 16), // space before edge
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
                              backgroundColor:
                                  Colors.blueAccent.withOpacity(0.15),
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
                            Text(
                              activeUser.username,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall
                                  ?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                            const SizedBox(width: 4),
                            Icon(
                              Icons.keyboard_arrow_down_rounded,
                              size: 20,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
            ],
          ),
        ],
      ),
    );
  }
}

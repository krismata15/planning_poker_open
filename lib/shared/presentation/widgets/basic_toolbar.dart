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
                    'img/planning_poker_icon.svg',
                    colorFilter: const ColorFilter.mode(
                      Colors.blueAccent,
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
              /*TextButton(
                        onPressed: () {},
                        child: Text('Sign Up'),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: Text('Login'),
                      ),*/
              if (isUserLogged)
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                  ),
                  child: Builder(
                    builder: (context) {
                      return TextButton(
                        onPressed: () {
                          final RenderBox box =
                              context.findRenderObject()! as RenderBox;
                          final Offset offset = box.localToGlobal(Offset.zero);

                          // Todo: this dialog looks bad, fix it
                          showDialog(
                            context: context,
                            barrierColor: Colors.transparent,
                            builder: (_) => SizedBox(
                              width: 400,
                              child: Stack(
                                children: [
                                  Positioned(
                                    left: offset.dx - 20,
                                    top: offset.dy + box.size.height,
                                    right: 0,
                                    child: Card(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 16,
                                        ),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                vertical: 20,
                                              ),
                                              child: Row(
                                                children: [
                                                  CircleAvatar(
                                                    radius: 24,
                                                    backgroundColor: Colors
                                                        .blueAccent
                                                        .withOpacity(0.9),
                                                    foregroundColor:
                                                        Colors.white,
                                                    child: Text(
                                                      activeUser.username[0]
                                                          .toUpperCase(),
                                                      style: const TextStyle(
                                                        fontSize: 20,
                                                      ),
                                                    ),
                                                  ),
                                                  const BasicSeparationSpace
                                                          .horizontal(
                                                      multiplier: 0.5),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      MouseRegion(
                                                        cursor:
                                                            SystemMouseCursors
                                                                .click,
                                                        child: GestureDetector(
                                                          onTap: () {
                                                            Navigator.pop(
                                                                context);
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
                                                                activeUser
                                                                    .username,
                                                                style: BasicStyles
                                                                    .subTitleStyle,
                                                              ),
                                                              const BasicSeparationSpace
                                                                      .horizontal(
                                                                  multiplier:
                                                                      0.3),
                                                              const Icon(
                                                                Icons
                                                                    .mode_edit_outline_outlined,
                                                                size: 20,
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      const BasicSeparationSpace
                                                          .vertical(
                                                        multiplier: 0.3,
                                                      ),
                                                      SelectableText(
                                                        activeUser.type,
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
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
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Row(
                            children: [
                              CircleAvatar(
                                maxRadius: 16,
                                backgroundColor:
                                    Colors.blueAccent.withOpacity(0.9),
                                foregroundColor: Colors.white,
                                child: Center(
                                  child: Text(
                                    activeUser.username[0].toUpperCase(),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                activeUser.username,
                                style: BasicStyles.subTitleStyle,
                              ),
                              const SizedBox(width: 4),
                              const Icon(
                                Icons.keyboard_arrow_down_rounded,
                                size: 22,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              if (actions != null && actions!.isNotEmpty) ...actions!,
              if (showCreateNewGameButton)
                ElevatedButton(
                  onPressed: () {
                    context.goNamed(RoutesNames.createGame);
                  },
                  child: const Text('Create new game'),
                ),
            ],
          )
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:planning_poker_open/shared/presentation/widgets/basic_separation_space.dart';
import 'package:planning_poker_open/shared/presentation/widgets/basic_toolbar.dart';
import 'package:planning_poker_open/shared/styles/basic_styles.dart';

class ActiveGameToolBar extends StatelessWidget {
  const ActiveGameToolBar({super.key, this.title});

  final Widget? title;

  @override
  Widget build(BuildContext context) {
    return BasicToolBar(
      title: title,
      actions: [
        OutlinedButton(
          onPressed: () {
            showDialog<void>(
              context: context,
              builder: (_) => const _InvitationLinkDialog(),
            );
          },
          child: const Padding(
            padding: EdgeInsets.symmetric(
              vertical: 10,
              horizontal: 6,
            ),
            child: Row(
              children: [
                Icon(Icons.people_alt_outlined),
                BasicSeparationSpace.horizontal(
                  multiplier: 0.5,
                ),
                Text(
                  'Invite players',
                  style: BasicStyles.subTitleStyle,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _InvitationLinkDialog extends StatelessWidget {
  const _InvitationLinkDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: BasicStyles.horizontalPadding,
          vertical: BasicStyles.verticalPadding,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const BasicSeparationSpace.vertical(),
            const Text(
              'Invite players',
              style: BasicStyles.titleStyle,
            ),
            const BasicSeparationSpace.vertical(
              multiplier: 2,
            ),
            TextField(
              controller: TextEditingController()..text = Uri.base.toString(),
              autofocus: true,
              readOnly: true,
            ),
            const BasicSeparationSpace.vertical(
              multiplier: 2,
            ),
            ElevatedButton(
                onPressed: () async {
                  final NavigatorState navigator = Navigator.of(context);
                  await Clipboard.setData(
                    ClipboardData(
                      text: Uri.base.toString(),
                    ),
                  );
                  navigator.pop();
                },
                child: const Text('Copy link')),
          ],
        ),
      ),
    );
  }
}

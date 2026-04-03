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

class _InvitationLinkDialog extends StatefulWidget {
  const _InvitationLinkDialog();

  @override
  State<_InvitationLinkDialog> createState() => _InvitationLinkDialogState();
}

class _InvitationLinkDialogState extends State<_InvitationLinkDialog> {
  bool _copied = false;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final link = Uri.base.toString();

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 480),
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Icon(
                Icons.people_alt_outlined,
                size: 40,
                color: colorScheme.primary,
              ),
              const SizedBox(height: 16),
              Text(
                'Invite players',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                'Share this link so others can join the game.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
              ),
              const SizedBox(height: 24),
              TextField(
                controller: TextEditingController()..text = link,
                readOnly: true,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.link),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _copied ? Icons.check : Icons.copy,
                      color:
                          _copied ? Colors.green : colorScheme.onSurfaceVariant,
                    ),
                    onPressed: () async {
                      await Clipboard.setData(ClipboardData(text: link));
                      setState(() => _copied = true);
                    },
                  ),
                ),
              ),
              const SizedBox(height: 24),
              FilledButton.icon(
                icon: Icon(_copied ? Icons.check : Icons.copy),
                label: Text(_copied ? 'Copied!' : 'Copy link'),
                style: FilledButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () async {
                  await Clipboard.setData(ClipboardData(text: link));
                  setState(() => _copied = true);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

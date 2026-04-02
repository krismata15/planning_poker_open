import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:planning_poker_open/shared/presentation/widgets/basic_toolbar.dart';
import 'package:planning_poker_open/shared/styles/basic_styles.dart';
import 'package:planning_poker_open/user_authentication/bloc/authentication_bloc.dart';

class LoginAnonymouslyPage extends StatefulWidget {
  const LoginAnonymouslyPage({super.key, this.guardedRoute});

  final String? guardedRoute;

  @override
  State<LoginAnonymouslyPage> createState() => _LoginAnonymouslyPageState();
}

class _LoginAnonymouslyPageState extends State<LoginAnonymouslyPage> {
  bool isLoading = false;

  String? username;

  @override
  Widget build(BuildContext context) {
    final bool validUsername = username != null && username!.isNotEmpty;
    final colorScheme = Theme.of(context).colorScheme;

    return BlocListener<AuthenticationBloc, AuthenticationState>(
      listener: (context, state) {
        if (state is AuthenticationInProgress) {
          setState(() {
            isLoading = true;
          });
        } else {
          setState(() {
            isLoading = false;
          });
        }

        if (state is AuthenticationAuthenticated) {
          if (widget.guardedRoute != null) {
            context.go(widget.guardedRoute!);
          }
        }
      },
      child: Scaffold(
        body: Column(
          children: [
            const BasicToolBar(),
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: BasicStyles.horizontalPadding,
                    vertical: BasicStyles.verticalPadding,
                  ),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 480),
                    child: Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: BorderSide(
                          color: colorScheme.outlineVariant,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(32),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Icon(
                              Icons.person_outline,
                              size: 48,
                              color: colorScheme.primary,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Welcome',
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall
                                  ?.copyWith(
                                    fontWeight: FontWeight.w700,
                                  ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Choose a display name to join the game.',
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    color: colorScheme.onSurfaceVariant,
                                  ),
                            ),
                            const SizedBox(height: 32),
                            TextField(
                              decoration: const InputDecoration(
                                label: Text('Display name'),
                                prefixIcon: Icon(Icons.badge_outlined),
                              ),
                              onChanged: (value) {
                                setState(() {
                                  username = value;
                                });
                              },
                              textInputAction: TextInputAction.done,
                              onSubmitted: validUsername
                                  ? (_) {
                                      context.read<AuthenticationBloc>().add(
                                            AuthenticateAnonymously(
                                              username: username!,
                                            ),
                                          );
                                    }
                                  : null,
                            ),
                            const SizedBox(height: 32),
                            FilledButton.icon(
                              icon: isLoading
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    )
                                  : const Icon(Icons.arrow_forward),
                              label: const Text('Continue'),
                              style: FilledButton.styleFrom(
                                minimumSize:
                                    const Size(double.infinity, 52),
                                textStyle: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              onPressed: isLoading
                                  ? null
                                  : validUsername
                                      ? () {
                                          context
                                              .read<AuthenticationBloc>()
                                              .add(
                                                AuthenticateAnonymously(
                                                  username: username!,
                                                ),
                                              );
                                        }
                                      : null,
                            ),
                          ],
                        ),
                      ),
                    ),
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


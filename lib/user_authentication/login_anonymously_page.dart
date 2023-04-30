import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:planning_poker_open/styles/basic_styles.dart';
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

        if (state is AuthenticationSuccess) {
          if (widget.guardedRoute != null) {
            print('enter here and goind to ${widget.guardedRoute}');
            context.go(widget.guardedRoute!);
          }
        }
      },
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: BasicStyles.horizontalPadding,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Choose your display name',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 20,
                ),
              ),
              const SizedBox(
                height: BasicStyles.standardSeparationVertical * 2.5,
              ),
              TextField(
                onChanged: (value) {
                  setState(() {
                    username = value;
                  });
                },
              ),
              const SizedBox(
                height: BasicStyles.standardSeparationVertical * 2,
              ),
              Center(
                child: ElevatedButton(
                  onPressed: validUsername
                      ? () {
                          context.read<AuthenticationBloc>().add(
                                AuthenticateAnonymously(username: username!),
                              );
                        }
                      : null,
                  child: isLoading
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : const Text('Continue'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

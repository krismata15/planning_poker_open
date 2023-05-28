import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:planning_poker_open/user_authentication/bloc/authentication_bloc.dart';
import 'package:planning_poker_open/user_authentication/models/user_app.dart';

UserApp? getActiveUserApp(BuildContext context) {
  return context.watch<AuthenticationBloc>().state
          is AuthenticationAuthenticated
      ? (context.watch<AuthenticationBloc>().state
              as AuthenticationAuthenticated)
          .user
      : null;
}

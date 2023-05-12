import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:planning_poker_open/active_game/presentation/active_game_page.dart';
import 'package:planning_poker_open/create_game/presentation/create_new_game_page.dart';
import 'package:planning_poker_open/firebase_options.dart';
import 'package:planning_poker_open/home.dart';
import 'package:planning_poker_open/shared/utils/firebase_populate_script.dart';
import 'package:planning_poker_open/shared/utils/routes_names.dart';
import 'package:planning_poker_open/user_authentication/bloc/authentication_bloc.dart';
import 'package:planning_poker_open/user_authentication/login_anonymously_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  //Bloc.observer = AppBlocObserver();

  //await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
  //FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8080);
  await FirebasePopulateScript.populate();

  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthenticationBloc(),
      child: Builder(
        builder: (context) {
          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            routerConfig: _router,
            title: 'Planning Poker',
            theme: ThemeData(
              primarySwatch: Colors.blue,
              elevatedButtonTheme: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(180, 50),
                  textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              inputDecorationTheme: InputDecorationTheme(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                isDense: true,
              ),
              dropdownMenuTheme: DropdownMenuThemeData(
                inputDecorationTheme: InputDecorationTheme(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  isDense: true,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

final GoRouter _router = GoRouter(
  routes: [
    GoRoute(
      path: RoutesNames.home,
      builder: (context, state) => const Home(),
      redirect: (context, state) {
        print(context.read<AuthenticationBloc>().state);
        print(state.path);
        print(state.fullPath);
        print(state.location);
        print(state.toString());
        print(RoutesNames.home);
        final bool guardedPath = guardedPaths.contains(state.fullPath);
        print('Guarded path $guardedPath');
        if (FirebaseAuth.instance.currentUser == null && guardedPath) {
          print('rute guarded ${state.location}');
          return '${RoutesPaths.login}?guarded-route=${state.location}';
        }
      },
      routes: [
        GoRoute(
          name: RoutesNames.login,
          path: RoutesNames.login,
          builder: (context, state) {
            state.queryParameters.forEach((key, value) {
              print('$key: $value');
            });
            return LoginAnonymouslyPage(
              guardedRoute: state.queryParameters['guarded-route'],
            );
          },
        ),
        GoRoute(
          name: RoutesNames.createGame,
          path: RoutesNames.createGame,
          builder: (context, state) => const CreateNewGamePage(),
        ),
        GoRoute(
          name: RoutesNames.activeGame,
          path: '${RoutesNames.activeGame}/:gameId',
          builder: (context, state) => ActiveGamePage(
            gameId: state.pathParameters['gameId'],
          ),
        ),
      ],
    ),
  ],
);

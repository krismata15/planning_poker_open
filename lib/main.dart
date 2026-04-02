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
import 'package:planning_poker_open/my_games/presentation/my_games_page.dart';
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
  //await FirebasePopulateScript.populate();

  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final AuthenticationBloc authenticationBloc;

  @override
  void initState() {
    super.initState();
    authenticationBloc = AuthenticationBloc()
      ..add(AuthenticationInitialCheck());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => authenticationBloc,
      child: Builder(
        builder: (context) {
          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            routerConfig: _router,
            title: 'Planning Poker',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
              useMaterial3: true,
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
        final bool guardedPath = guardedPaths.contains(state.fullPath);
        if (FirebaseAuth.instance.currentUser == null && guardedPath) {
          return '${RoutesPaths.login}?guarded-route=${state.uri}';
        }
        return null;
      },
      routes: [
        GoRoute(
          name: RoutesNames.login,
          path: RoutesNames.login,
          builder: (context, state) {
            return LoginAnonymouslyPage(
              guardedRoute: state.uri.queryParameters['guarded-route'],
            );
          },
        ),
        GoRoute(
          name: RoutesNames.createGame,
          path: RoutesNames.createGame,
          builder: (context, state) => const CreateNewGamePage(),
        ),
        GoRoute(
          name: RoutesNames.myGames,
          path: RoutesNames.myGames,
          builder: (context, state) => const MyGamesPage(),
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

import 'package:example/presentation/fourth_screen.dart';
import 'package:example/presentation/main_screen.dart';
import 'package:example/presentation/second_screen.dart';
import 'package:b_router/b_router.dart';
import 'package:example/presentation/simple_screen.dart';
import 'package:flutter/material.dart';

import 'redirected_screen.dart';
import 'third_screen.dart';

class AppRoot extends StatefulWidget {
  const AppRoot({Key? key}) : super(key: key);

  @override
  State<AppRoot> createState() => _AppRootState();
}

class _AppRootState extends State<AppRoot> {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  late final BRouterCubit _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = BRouterCubit(routes: _routes);
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => BRouterProvider(
        bloc: _bloc,
        child: Builder(
          builder: (context) => MaterialApp.router(
            theme: ThemeData.from(
              colorScheme: ColorScheme.fromSwatch(
                primarySwatch: Colors.blue,
              ).copyWith(secondary: Colors.yellow),
            ),
            routerDelegate: BRouterDelegate(
              navigatorKey: _navigatorKey,
              bloc: _bloc,
              stayOpened: (context) => showDialog<bool?>(
                context: context,
                builder: (context) => AlertDialog(
                  content: const Text("Close app?"),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text("No"),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text("Yes"),
                    ),
                  ],
                ),
              ),
            ),
            routeInformationParser: BRouterParser(routes: _routes),
          ),
        ),
      );

  List<BRoute> get _routes => [
        BRoute(
          path: "/",
          builder: (context, _, __) => const MainScreen(),
        ),
        BRoute(
          path: "page2",
          allowedParams: const ["something"],
          builder: (context, arguments, uri) => SecondScreen(
            text: uri.queryParameters["something"] ?? "no argument was provided",
          ),
        ),
        BRoute(
          path: "third-screen",
          builder: (context, arguments, uri) => ThirdScreen(
            text: arguments?["arg"] ?? "no argument was provided",
          ),
        ),
        BRoute(
          path: "third-screen/:id",
          builder: (context, arguments, uri) => FourthScreen(
            text: arguments?["id"] ?? "no argument was provided",
          ),
        ),
        BRoute(
          path: "redirected-screen/:id",
          builder: (context, arguments, uri) => RedirectedScreen(
            text: arguments?["id"] ?? "no argument was provided",
          ),
        ),
        BRoute(
          path: "other-screen",
          allowedParams: const ["foo"],
          builder: (context, arguments, uri) => RedirectedScreen(
            text: uri.queryParameters["foo"] ?? "",
          ),
        ),
        BRoute(
          path: "simple-screen-1",
          builder: (_, arguments, uri) => SimpleScreen(
            screenNumber: 1,
            onButtonPressed: (context) => context.bPush(name: "simple-screen-2"),
          ),
        ),
        BRoute(
          path: "simple-screen-2",
          builder: (_, arguments, uri) => SimpleScreen(
            screenNumber: 2,
            onButtonPressed: (context) => context.bPush(name: "simple-screen-3"),
          ),
        ),
        BRoute(
          path: "simple-screen-3",
          builder: (_, arguments, uri) => SimpleScreen(
            screenNumber: 3,
            onButtonPressed: (context) => context.bPush(name: "simple-screen-4"),
          ),
        ),
        BRoute(
          path: "simple-screen-4",
          builder: (_, arguments, uri) => SimpleScreen(
            screenNumber: 4,
            onButtonPressed: (context) {},
          ),
        ),
      ];
}

import 'package:example/presentation/fourth_screen.dart';
import 'package:example/presentation/main_screen.dart';
import 'package:example/presentation/second_screen.dart';
import 'package:b_router/b_router.dart';
import 'package:example/presentation/simple_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'redirected_screen.dart';
import 'third_screen.dart';

class AppRoot extends StatefulWidget {
  const AppRoot({super.key});

  @override
  State<AppRoot> createState() => _AppRootState();
}

class _AppRootState extends State<AppRoot> {
  @override
  Widget build(BuildContext context) => BRouter(
        routes: _routes,
        pageBuilder: (context, route, uri) => MaterialPage(
          key: ValueKey<String>("${route.name}_page"),
          name: route.name,
          onPopInvoked: (didPop, result) {
            if (kDebugMode) print("Page ${route.name} popped with result $result");
            PopRouteEvent(route: route, result: result).dispatch(context);
          },
          child: route.builder(context, route.arguments, uri),
        ),
        builder: (context, config) => MaterialApp.router(
          theme: ThemeData.from(
            colorScheme: ColorScheme.fromSwatch(
              primarySwatch: Colors.blue,
            ).copyWith(secondary: Colors.yellow),
          ),
          routeInformationParser: config.routeInformationParser,
          routerDelegate: config.routerDelegate,
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

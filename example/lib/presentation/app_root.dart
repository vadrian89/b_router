import 'package:example/presentation/fourth_screen.dart';
import 'package:example/presentation/main_screen.dart';
import 'package:example/presentation/second_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:b_router/b_router.dart';
import 'package:flutter/material.dart';

import 'third_screen.dart';

class AppRoot extends StatefulWidget {
  const AppRoot({Key? key}) : super(key: key);

  @override
  State<AppRoot> createState() => _AppRootState();
}

class _AppRootState extends State<AppRoot> {
  late final BRouterCubit _bloc;
  late final GlobalKey<NavigatorState> _navigatorKey;

  @override
  void initState() {
    super.initState();
    _bloc = BRouterCubit(routes: _routes);
    _navigatorKey = GlobalKey<NavigatorState>();
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
          pageBuilder: (context, _, __) => MainScreen(
            onPressed: (_) => context.read<BRouterCubit>().push(
              name: "page2",
              arguments: {"page-2-arg": "Screen pushed with argument!!"},
              params: {"something": "45"},
            ),
          ),
        ),
        BRoute(
          path: "page2",
          pageBuilder: (context, arguments, uri) => SecondScreen(
            text: uri.queryParameters["something"] ?? "no argument was provided",
          ),
        ),
        BRoute(
          path: "third-screen",
          pageBuilder: (context, arguments, uri) => ThirdScreen(
            text: arguments?["arg"] ?? "no argument was provided",
          ),
        ),
        BRoute(
          path: "third-screen/:id",
          pageBuilder: (context, arguments, uri) => FourthScreen(
            text: arguments?["id"] ?? "no argument was provided",
          ),
        ),
      ];
}

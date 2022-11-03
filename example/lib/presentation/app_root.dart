import 'package:example/presentation/main_screen.dart';
import 'package:example/presentation/second_level_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:b_router/b_router.dart';
import 'package:flutter/material.dart';

class AppRoot extends StatelessWidget {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  AppRoot({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => BRouterProvider(
        routes: _routes,
        child: Builder(
          builder: (context) => MaterialApp.router(
            theme: ThemeData.from(
              colorScheme: ColorScheme.fromSwatch(
                primarySwatch: Colors.blue,
              ).copyWith(secondary: Colors.yellow),
            ),
            routerDelegate: BRouterDelegate(
              navigatorKey: navigatorKey,
              bloc: context.watch<BRouterCubit>(),
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
          name: "/",
          pageBuilder: (context, __) => MainScreen(
            onPressed: (_) => context.read<BRouterCubit>().push(name: "page2", arguments: {
              "page-2-arg": "Screen pushed with argument!!",
            }),
          ),
        ),
        BRoute(
          name: "page2",
          pageBuilder: (BuildContext context, arguments) => SecondLevelScreen(
            text: arguments?["page-2-arg"] ?? "no argument was provided",
            onButtonPressed: (_) => context.read<BRouterCubit>().push(name: "page2/:idOfSomething"),
          ),
          routes: [
            BRoute(
              name: ":urlParameter",
              redirect: (context) => "login",
              pageBuilder: (context, arguments) => SecondLevelScreen(
                text: "The value of urlParameter is: ${arguments!["urlParameter"]}",
                onButtonPressed: (context) {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      content: const Text("This is a material dialog"),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.maybePop(context, "dialog result"),
                          child: const Text("Pop with return value"),
                        ),
                      ],
                    ),
                  ).then((value) => print("returned value $value"));
                },
              ),
            ),
          ],
        ),
        BRoute(
          name: "login",
          pageBuilder: (context, __) => const Center(child: Text("Replaced screen")),
        ),
      ];
}

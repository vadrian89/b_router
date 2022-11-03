## BRouter is a Navigator 2.0 alternative built using bloc package.

It's still a work in progress and shouldn't be used in production apps.

## Features

- Easy to use for those familiar with bloc usage.  
- Easy to plug with custom RouterDelegate/RouteInformationProvider/RouteInformationParser/etc.  
- Handles browser navigation history and URL.
- It's simple and the code is easy to read.

## Getting started

TODO: List prerequisites and provide or point to information on how to
start using the package.

## Usage

```dart
BRouterProvider(
    routes: _routes,
    Builder(
        builder: (context) => MaterialApp.router(
            routerDelegate: BRouterDelegate(
                navigatorKey: navigatorKey, /// Initialise the key before using the router.  
                bloc: context.watch<BRouterCubit>(),
            ),
            routeInformationParser: BRouterParser(routes: _routes),
        ),
    )
);

List<BRoute> get _routes => [
    BRoute(
        name: "/",
        pageBuilder: (context, arguments) => const RootScreen(),
    ),
    BRoute(
        name: "screen1",
        pageBuilder: (context, arguments) => const Screen1(),
    ),
    BRoute(
        name: "screen2",
        pageBuilder: (context, arguments) => const Screen2(),
        routes: [
            BRoute(
                name: ":id",
                pageBuilder: (context, arguments) => const Screen3(id: arguments["id"]),
            ),
        ]
    ),
];
```

Full example can be found inside 'example' directory.

import 'package:b_router/application.dart';
import 'package:b_router/router.dart';
import 'package:b_router/src/router/route_event.dart';
import 'package:flutter/material.dart';

import '../utils/route_logger.dart';

/// The main router widget.
///
/// Used to:
/// - build the necessary router components: delegate, parser, provider
/// and back button dispatcher
/// - handle the route events: push, redirect
/// - updated the current router state
class BRouter extends StatefulWidget {
  /// The list of routes used by the router.
  final List<BRoute> routes;

  /// Callback used to build the "not found" route.
  ///
  /// By default it will use [NotFoundScreen].
  ///
  /// If a route is not found in the list of [routes], this builder will be used.
  final RouteBuilderCallback? notFoundBuilder;

  /// The builder for the router.
  ///
  /// Used to build the [Router] widget with the provided [RouterConfig].
  ///
  /// You can pass it directly to the [Router] widget or use the respective delegate, parser,
  /// provider and back button dispatcher, separately.
  final Widget Function(BuildContext context, RouterConfig<BRouterState> config) builder;

  const BRouter({
    super.key,
    required this.routes,
    required this.builder,
    this.notFoundBuilder,
  }) : assert(routes.length > 0, "Routes list cannot be empty");
  @override
  State<BRouter> createState() => _BRouterState();
}

class _BRouterState extends State<BRouter> {
  RouteLogger get _logger => RouteLogger();
  late final List<BRoute> _routes;
  late final BRouterStateNotifier _stateNotifier;
  late final BRouterDelegate _delegate;
  late final BRouterParser _parser;
  late final BRouteInformationProvider _provider;
  late final RouterConfig<BRouterState> _routerConfig;

  BRouterState get _currentState => _stateNotifier.value;

  @override
  void initState() {
    super.initState();
    _routes = widget.routes;
    _stateNotifier = BRouterStateNotifier(
      onStateChanged: (previous, current) => _logger.d(
        "Router state changed -> FROM: $previous TO: $current",
      ),
    );
    _delegate = BRouterDelegate(stateNotifier: _stateNotifier, onPopInvoked: _pop);
    _parser = BRouterParser(routes: _routes);
    _provider = BRouteInformationProvider(routes: _routes);
    _routerConfig = RouterConfig(
      routerDelegate: _delegate,
      routeInformationParser: _parser,
      routeInformationProvider: _provider,
    );
  }

  @override
  void dispose() {
    _stateNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => NotificationListener<RouteEvent>(
        onNotification: (notification) {
          _routeEventReceived(notification);
          return true;
        },
        child: widget.builder(context, _routerConfig),
      );

  void _routeEventReceived(RouteEvent event) => switch (event) {
        PushRouteEvent() => _push(event),
        RedirectRouteEvent() => _redirect(event),
      };

  void _push(PushRouteEvent event) {
    final name = event.name;
    final arguments = event.arguments;
    final params = event.params;
    _logger.d("Pushing new route");
    _logger.d("New route name: $name");
    _logger.d("New route arguments: $arguments");
    _logger.d("New route params: $params");
    final sanitizedArguments = Map<String, dynamic>.from(arguments ?? const {});
    var route = BRoute.fromPath(name, _routes)?.addParameters(
      arguments: sanitizedArguments..removeWhere((_, value) => value == null),
      params: params,
    );
    route ??= BRoute.notfound(
      builder: widget.notFoundBuilder,
      arguments: sanitizedArguments,
      params: params,
    );
    List<BRoute> tmpList = switch (_currentState) {
      FoundRoutes(:final routes) => List.from(routes),
      _ => const [],
    };

    /// If the top route is the same as the new route we replace it.
    /// We also make sure we don't try to replace the root route.
    if (tmpList.length >= 2 && tmpList.last.path == name) {
      tmpList = tmpList.getRange(0, tmpList.length - 2).toList();
    }

    _logger.d("Old routes list: $tmpList");
    tmpList = List.from([...tmpList, route]);
    _logger.d("New routes list: $tmpList");
    _stateNotifier.value = BRouterState.routesFound(routes: List.from(tmpList));
  }

  void _redirect(RedirectRouteEvent event) {
    final location = event.location;
    final params = event.params;
    _logger.d("Redirecting to $location with params: $params");
    final state = BRouterState.fromUri(
      uri: Uri.parse(location).replace(queryParameters: params),
      routes: _routes,
    );
    _delegate.setNewRoutePath(state);
  }

  void _pop(BRoute route, [Object? result]) {
    _logger.d("Popping route: $route with result: $result");
    final currentRoutes = switch (_currentState) {
      FoundRoutes(:final routes) => List.from(routes),
      _ => const [],
    };
    if (currentRoutes.isEmpty) {
      _logger.w("No routes to pop.");
      return;
    }
    final pushedRoutes = currentRoutes.where((element) => element != route).toList();
    if (result != null) {
      _stateNotifier.value = BRouterState.poppedResult(
        route: route,
        uri: _currentState.uri,
        popResult: result,
      );
    }
    _stateNotifier.value = BRouterState.routesFound(routes: List.from(pushedRoutes));
  }
}

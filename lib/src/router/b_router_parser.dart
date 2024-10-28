import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../bloc/b_router_cubit.dart';
import 'b_route.dart';

/// The [RouteInformationParser] implementation for our [MaterialApp.router]
///
/// It's main directives are to enable browser history, update the URL and restore the state based on inserted URL.
class BRouterParser extends RouteInformationParser<BRouterState> {
  final List<BRoute> routes;

  const BRouterParser({required this.routes});

  /// Parse the incoming [Uri] string and based on [Uri.pathSegments] length return the correct [BRouterState].
  @override
  Future<BRouterState> parseRouteInformation(RouteInformation routeInformation) {
    final uri = routeInformation.uri;
    BRouterState state = const BRouterState.initial();
    if (uri.pathSegments.isNotEmpty) {
      state = BRouterState.fromUri(uri: uri, routes: routes);
    }
    return SynchronousFuture(state);
  }

  /// Restore the route information from the given configuration (or state, in our case).
  ///
  /// It's required to properly update the browser's history.
  @override
  RouteInformation restoreRouteInformation(BRouterState configuration) => RouteInformation(
        uri: Uri.tryParse(_location(configuration)),
      );

  /// Get the location of the current navigation stack.
  ///
  /// Example: ```/page1/page2/?p=some-parameter```
  String _location(BRouterState state) => state.maybeWhen(
        initial: () => BRouterState.rootPath,
        routesFound: (routes) {
          final path = _locationFromRoutes(routes);
          return path.isNotEmpty ? path : BRouterState.rootPath;
        },
        orElse: () => BRouterState.notFoundPath,
      );

  String _locationFromRoutes(List<BRoute> list) {
    String path = "";
    String query = "";
    for (final route in list) {
      if (route.path != BRouterState.rootPath) {
        query += route.params.entries.map((e) => "${e.key}=${e.value}").join(",");
        final routePath = path.endsWith(route.pathSegments.first) ? route.name : route.path;
        path += "/${routePath.replaceFirst(BRoute.parameterStart, "")}";
      }
    }
    return query.isNotEmpty ? "$path?$query" : path;
  }
}

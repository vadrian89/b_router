import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../application/b_router/b_router_cubit.dart';
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
    final uri = Uri.parse(routeInformation.location ?? "");
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
  RouteInformation restoreRouteInformation(BRouterState configuration) =>
      RouteInformation(location: configuration.location);
}

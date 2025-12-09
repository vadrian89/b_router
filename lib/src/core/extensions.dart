import 'package:b_router/src/router/route_event.dart';
import 'package:flutter/material.dart';

import '../application/state.dart';
import '../router/route.dart';
import '../widgets/state_provider.dart';

extension BRouterContextExtensions on BuildContext {
  /// Get the current BRouteStateProvider from the context.
  BRouterStateProvider get routerStateProvider => BRouterStateProvider.of(this);

  /// Get the current [BRouterState] from the context.
  BRouterState get routerState => routerStateProvider.state;

  /// Get the currently pushed routes from the context.
  ///
  /// Keep in mind that this will return an empty list if the current state does not contain any
  /// routes.
  List<BRoute> get pushedRoutes => switch (routerState) {
        FoundRoutes(:final routes) => routes,
        _ => const [],
      };

  /// Get the last route pushed.
  ///
  /// This will return null if there are no routes in the stack.
  ///
  /// It's a shorthand for `pushedRoutes.lastOrNull`.
  BRoute? get topRoute => pushedRoutes.lastOrNull;

  /// Redirect to the new [location].
  ///
  /// For more see [BRouterCubit.redirect].
  void bRedirect({
    required String location,
    Map<String, String>? params,
  }) =>
      RedirectRouteEvent(location: location, params: params).dispatch(this);

  /// Push a new page to the stack.
  ///
  /// For more see [BRouterCubit.push];
  void bPush({
    required String name,
    Map<String, dynamic>? arguments,
    Map<String, String>? params,
  }) =>
      PushRouteEvent(name: name, arguments: arguments, params: params).dispatch(this);
}

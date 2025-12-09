import 'package:b_router/bloc.dart';
import 'package:b_router/src/router/route_event.dart';
import 'package:flutter/material.dart';

import '../router/route.dart';
import '../widgets/state_provider.dart';

extension BRouterContextExtensions on BuildContext {
  /// Get the current [BRouterState] from the context.
  BRouterState get routerState => BRouteStateProvider.of(this).state;

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

  /// Get the last route pushed.
  BRoute? get bTopRoute => switch (routerState) {
        FoundRoutes(:final routes) => routes.isNotEmpty ? routes.last : null,
        _ => null,
      };
}

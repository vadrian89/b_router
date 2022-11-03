import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../application/b_router_bloc.dart';
import 'b_route.dart';

extension BRouterContextExtensions on BuildContext {
  /// Get the nearest [BRouterCubit] instance.
  ///
  /// Use [watchBRouter] if you need to retrieve it inside a build method of a widget.
  BRouterCubit get bRouter => read<BRouterCubit>();

  /// Watch for [BRouterCubit] changes inside build methods.
  ///
  /// For one time usage use [bRouter].
  BRouterCubit get watchBRouter => watch<BRouterCubit>();

  /// Redirect to the new [location].
  ///
  /// For more see [BRouterCubit.redirect].
  void bRedirect({required String location}) => bRouter.redirect(location: location);

  /// Push a new page to the stack.
  ///
  /// For more see [BRouterCubit.push];
  void bPush({required String name, Map<String, dynamic>? arguments}) =>
      bRouter.push(name: name, arguments: arguments);

  /// Get the last route pushed.
  BRoute? get bTopRoute => bRouter.state.whenOrNull(routesFound: (routes) => routes.last);
}

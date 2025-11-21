import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:b_router/bloc.dart';
import '../router/route.dart';

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
  void bRedirect({required String location, Map<String, String>? params}) => bRouter.redirect(
        location: location,
        params: params,
      );

  /// Push a new page to the stack.
  ///
  /// For more see [BRouterCubit.push];
  void bPush({
    required String name,
    Map<String, dynamic>? arguments,
    Map<String, String>? params,
  }) =>
      bRouter.push(
        name: name,
        arguments: arguments,
        params: params,
      );

  /// Get the last route pushed.
  BRoute? get bTopRoute => switch (bRouter.state) {
        FoundRoutes(:final routes) => routes.isNotEmpty ? routes.last : null,
        _ => null,
      };
}

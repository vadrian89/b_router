import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_strategy/url_strategy.dart';

import 'package:b_router/bloc.dart';
import '../b_route.dart';

/// The provider used to initialise [BRouterCubit] and set up the provided [routes].
///
/// Preferably to be put above the MaterialApp/CupertinoApp widget so the bloc be available
/// everywhere inside the app.
class BRouterProvider extends StatefulWidget {
  /// The bloc managing the router.
  ///
  /// Used when the bloc is initialised outside this widget.
  final BRouterCubit? bloc;

  /// The routes used for navigation.
  final List<BRoute>? routes;

  /// The child of this widget.
  final Widget child;

  const BRouterProvider({
    super.key,
    this.bloc,
    this.routes,
    required this.child,
  }) : assert(bloc != null || routes != null);

  @override
  State<BRouterProvider> createState() => _BRouterProviderState();
}

class _BRouterProviderState extends State<BRouterProvider> {
  @override
  void initState() {
    super.initState();
    setPathUrlStrategy();
  }

  @override
  Widget build(BuildContext context) => (widget.bloc != null)
      ? BlocProvider.value(value: widget.bloc!, child: widget.child)
      : BlocProvider(
          create: (context) => BRouterCubit(routes: widget.routes!),
          child: widget.child,
        );
}

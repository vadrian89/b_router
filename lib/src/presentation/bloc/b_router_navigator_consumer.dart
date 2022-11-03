import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../application/b_router/b_router_cubit.dart';

/// Consumer used to manage the navigation stack inside [BRouterDelegate].
class BRouterNavigatorConsumer extends StatelessWidget {
  final VoidCallback notifyListeners;
  final Widget Function(BuildContext context, BRouterState state) builder;

  const BRouterNavigatorConsumer({
    super.key,
    required this.notifyListeners,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) => BlocConsumer<BRouterCubit, BRouterState>(
        listener: (context, state) => notifyListeners(),
        listenWhen: (previous, current) => current.maybeWhen(
          orElse: () => false,
          routesFound: (_) => true,
          unknown: () => true,
        ),
        builder: builder,
        buildWhen: (previous, current) => current.maybeWhen(
          orElse: () => false,
          routesFound: (_) => true,
          unknown: () => true,
        ),
      );
}

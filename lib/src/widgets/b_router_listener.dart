import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../application/b_router_cubit.dart';

/// Shorthand widget for BlocListener<BRouterCubit, BRouterState>.
class BRouterListener extends StatelessWidget {
  /// The child of this widget.
  final Widget child;

  /// For info, see [BlocListener.bloc].
  final BRouterCubit? bloc;

  /// For info, see [BlocListener.listener].
  final BlocWidgetListener<BRouterState> listener;

  /// For info, see [BlocListener.listenWhen].
  final BlocListenerCondition<BRouterState>? listenWhen;

  const BRouterListener({
    super.key,
    required this.child,
    required this.listener,
    this.listenWhen,
    this.bloc,
  });

  @override
  Widget build(BuildContext context) => BlocListener<BRouterCubit, BRouterState>(
        bloc: bloc,
        listener: listener,
        listenWhen: listenWhen,
        child: child,
      );
}

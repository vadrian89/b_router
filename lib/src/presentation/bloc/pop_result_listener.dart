import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../application/b_router/b_router_cubit.dart';

/// Use this widget to listen when you need to get the result from a screen/dialog which has a
/// return value.
class PopResultListener extends StatelessWidget {
  /// The child of this widget.
  final Widget child;

  /// Called when the [BRouterState.poppedResult] is emitted for this listener.
  ///
  /// Called only the result is not null and [pathName] matches the name reported by the state.
  final ValueChanged<dynamic> onResultChanged;

  /// The path name for which results to listen.
  ///
  /// It should have the same value as [BRoute.name].
  final String? pathName;

  const PopResultListener({
    super.key,
    required this.child,
    required this.onResultChanged,
    this.pathName,
  });

  @override
  Widget build(BuildContext context) => BlocListener<BRouterCubit, BRouterState>(
        listener: (context, state) => state.whenOrNull(
          poppedResult: (_, popResult) => onResultChanged(popResult),
        ),
        listenWhen: (_, current) => current.maybeWhen(
          orElse: () => false,
          poppedResult: (name, popResult) => popResult != null && name == pathName,
        ),
        child: child,
      );
}

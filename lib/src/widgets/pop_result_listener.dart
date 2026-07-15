import 'package:b_router/application.dart';
import 'package:flutter/material.dart';

import 'listener.dart';

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
  Widget build(BuildContext context) => BRouterListener(
        listener: (context, state) => switch (state) {
          PoppedResultRoute(:final popResult) => onResultChanged(popResult),
          _ => null,
        },
        listenWhen: (_, current) => switch (current) {
          PoppedResultRoute(:final route, :final popResult) =>
            popResult != null && route.name == pathName,
          _ => false,
        },
        child: child,
      );
}

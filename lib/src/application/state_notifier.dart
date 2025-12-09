import 'package:b_router/bloc.dart';
import 'package:flutter/foundation.dart';

import 'b_router_cubit.dart' show BRouterState;

/// A [ValueNotifier] which holds the current [BRouterState].
///
/// Used to notify listeners about state changes in the router.
class BRouterStateNotifier extends ValueNotifier<BRouterState> {
  /// Called when the state changes.
  ///
  /// This only happens when the new state is different from the previous one.
  final void Function(BRouterState previous, BRouterState current)? onStateChanged;

  BRouterStateNotifier({this.onStateChanged}) : super(const BRouterState.initial());

  @override
  set value(BRouterState newState) {
    if (newState == value) return;
    onStateChanged?.call(value, newState);
    super.value = newState;
  }
}

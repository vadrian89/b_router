import 'package:b_router/application.dart';
import 'package:flutter/material.dart';

import 'state_provider.dart';

/// Listener for changes in the [BRouterState].
///
/// This widget listens for changes notified by the [BRouterStateProvider] and
/// invokes the provided [listener] callback whenever the [BRouterState] changes.
///
/// It allows optional filtering of state changes through the [listenWhen] callback,
/// which determines whether the [listener] should be invoked based on the previous
/// and current states.
///
/// The [child] widget is built as a descendant of this listener, but should not trigger rebuilds.
class BRouterListener extends StatefulWidget {
  /// The child of this widget.
  final Widget child;

  /// For info, see [BlocListener.listener].
  final void Function(BuildContext context, BRouterState state) listener;

  /// For info, see [BlocListener.listenWhen].
  final bool Function(BRouterState previous, BRouterState current)? listenWhen;

  const BRouterListener({
    super.key,
    required this.child,
    required this.listener,
    this.listenWhen,
  });

  @override
  State<BRouterListener> createState() => _BRouterListenerState();
}

class _BRouterListenerState extends State<BRouterListener> {
  late final Widget _child;
  BRouterStateNotifier? _stateNotifier;
  BRouterState? _previousState;

  @override
  void initState() {
    super.initState();
    _child = widget.child;
  }

  @override
  void didChangeDependencies() {
    final stateNotifier = BRouterStateProvider.of(context).stateNotifier;
    if (stateNotifier != _stateNotifier) {
      _stateNotifier?.removeListener(_valueChanged);
      _stateNotifier = stateNotifier;
      _stateNotifier?.addListener(_valueChanged);
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) => _child;

  void _valueChanged() {
    final newState = _stateNotifier!.value;
    final listenWhen = widget.listenWhen?.call(_previousState ?? newState, newState) ?? true;
    if ((_previousState != newState) && listenWhen) widget.listener(context, newState);
    _previousState = newState;
  }
}

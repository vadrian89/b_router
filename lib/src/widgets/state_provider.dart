import 'package:b_router/application.dart';
import 'package:flutter/widgets.dart';

/// An inherited widget that provides access to the [BRouterState] through the build context.
class BRouterStateProvider extends InheritedWidget {
  /// The current notifier that holds the [BRouterState].
  final BRouterStateNotifier stateNotifier;

  /// The current [BRouterState] provided by this widget.
  ///
  /// This is a shorthand for `stateNotifier.value` and provides direct access to the current state.
  BRouterState get state => stateNotifier.value;

  const BRouterStateProvider({
    super.key,
    required this.stateNotifier,
    required super.child,
  });

  static BRouterStateProvider? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<BRouterStateProvider>();

  static BRouterStateProvider of(BuildContext context) {
    final state = maybeOf(context);
    if (state == null) {
      throw FlutterError(
        'BRouteStateProvider.of() called with a context that does not contain a BRouteStateProvider.',
      );
    }
    return state;
  }

  @override
  bool updateShouldNotify(BRouterStateProvider oldWidget) =>
      oldWidget.stateNotifier != stateNotifier;
}

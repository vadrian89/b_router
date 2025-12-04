import 'package:b_router/src/application/b_router_cubit.dart';
import 'package:flutter/widgets.dart';

/// An inherited widget that provides access to the [BRouterState] through the build context.
class BRouteStateProvider extends InheritedWidget {
  /// The current state of the BRouter.
  final BRouterState state;

  const BRouteStateProvider({
    super.key,
    required this.state,
    required super.child,
  });

  static BRouteStateProvider? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<BRouteStateProvider>();

  static BRouteStateProvider of(BuildContext context) {
    final state = maybeOf(context);
    if (state == null) {
      throw FlutterError(
        'BRouteStateProvider.of() called with a context that does not contain a BRouteStateProvider.',
      );
    }
    return state;
  }

  @override
  bool updateShouldNotify(BRouteStateProvider oldWidget) => oldWidget.state != state;
}

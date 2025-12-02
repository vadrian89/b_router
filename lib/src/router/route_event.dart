import 'package:flutter/widgets.dart';

/// The base class for route events used in the BRouter system.
///
/// This class extends [Notification] to allow route events to be dispatched
/// through the widget tree using the Flutter notification mechanism.
sealed class RouteEvent extends Notification {
  const RouteEvent();
}

/// Event to push a new route onto the navigation stack.
class PushRouteEvent extends RouteEvent {
  final String name;
  final Map<String, dynamic>? arguments;
  final Map<String, String>? params;

  const PushRouteEvent({required this.name, this.arguments, this.params});
}

/// Event to redirect to a new route, replacing the current navigation stack.
class RedirectRouteEvent extends RouteEvent {
  final String location;
  final Map<String, String>? params;

  const RedirectRouteEvent({required this.location, this.params});
}

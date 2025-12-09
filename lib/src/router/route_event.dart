import 'package:b_router/router.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

/// The base class for route events used in the BRouter system.
///
/// This class extends [Notification] to allow route events to be dispatched
/// through the widget tree using the Flutter notification mechanism.
sealed class RouteEvent extends Notification with EquatableMixin {
  @override
  bool? get stringify => true;

  const RouteEvent();
}

/// Event to push a new route onto the navigation stack.
class PushRouteEvent extends RouteEvent {
  /// The name of the route to push.
  ///
  /// This should correspond to [BRoute.name] defined in the class.
  final String name;

  /// The arguments to pass to the new route.
  ///
  /// This should include any data the route needs to build its content. The difference between
  /// [arguments] and [params] is that [arguments] can hold any type of data, while [params] are
  /// specifically for string key-value pairs typically used in URL parameters.
  ///
  /// [arguments] do not appear in the URL and cannot be passed via deep links because
  /// we don't know if they are serializable or not.
  final Map<String, dynamic>? arguments;

  /// The parameters to pass to the new route.
  ///
  /// This will typically be used for URL parameters and should be a map of string key-value pairs.
  /// These parameters can be included in the URL and are suitable for deep linking.
  final Map<String, String>? params;

  @override
  List<Object?> get props => [name, arguments, params];

  const PushRouteEvent({required this.name, this.arguments, this.params});
}

/// Event to redirect to a new route, replacing the current navigation stack.
class RedirectRouteEvent extends RouteEvent {
  /// The location (URL) to redirect to.
  final String location;

  /// The parameters to pass to the new route.
  final Map<String, String>? params;

  @override
  List<Object?> get props => [location, params];

  const RedirectRouteEvent({required this.location, this.params});
}

/// Event used to pop a specific route from the navigation stack.
class PopRouteEvent extends RouteEvent {
  /// The name of the route to pop.
  ///
  /// Since the developr should have access to the list of routes, we will leave it as [BRoute].
  final BRoute route;

  /// The result to return when popping the route.
  final Object? result;

  @override
  List<Object?> get props => [route, result];

  const PopRouteEvent({required this.route, this.result});
}

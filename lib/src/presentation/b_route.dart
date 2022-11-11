// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// Route class which is used for route configuration.
class BRoute extends Equatable {
  /// Used to identify parameter values, such as: `:id`, `:a-value`, etc.
  static String parameterId = ":";

  /// The path segment name.
  ///
  /// The path should be set as "/" for root, "home" for home, etc.
  ///
  /// The path segment is case sensitive, so be warned: ```home != Home```.
  final String name;

  /// Arguments used for this route.
  ///
  /// Afterwards they can be retrieved using their respective keys.
  final Map<String, dynamic>? arguments;

  /// The page which will be used to populate the navigation stack.
  final Widget Function(BuildContext context, Map<String, dynamic>? arguments) pageBuilder;

  /// List of sub routes for this route.
  ///
  /// Useful for have pages which depend on this one.
  final List<BRoute>? routes;

  /// Split the [name] into a list, using `/`.
  List<String> get nameSegments => name.split("/").where((element) => element.isNotEmpty).toList();

  @override
  List<Object> get props => [name, ...?arguments?.keys];

  @override
  bool? get stringify => true;

  const BRoute({
    required this.name,
    this.arguments,
    required this.pageBuilder,
    this.routes,
  });

  /// Get the route, from [routes], using [name], if exists.
  static BRoute? fromName(String name, List<BRoute> routes) {
    for (final route in routes) {
      if (route.name == name) {
        return route;
      }
    }
    return null;
  }

  /// Find sub-route for [this] route.
  ///
  /// It first searchs for the full [name].
  ///
  /// If it doesn't find it procedes to search by first character, using [parameterId] as starting
  /// character.
  /// If it finds by the first character it assumes the name contains a parameter and it will
  /// proceed to parse the value of it.
  ///
  /// For example: If the value of [name] is `:505` and a route with the name `:id` is found, then
  /// that route will be returned and [arguments] will contain ```{"id": "505"}``` and the name
  /// of the found route will be turned into `505`.
  BRoute? findRoute({required String name}) {
    if (routes?.isEmpty ?? true) {
      return null;
    }
    for (final route in routes!) {
      if (route.name == name) {
        return route;
      }

      if (name.substring(0, 1) == parameterId && route.name.substring(0, 1) == parameterId) {
        return route.copyWith(
          arguments: Map<String, dynamic>.from({
            route.name.substring(1): name.substring(1),
            ...?route.arguments,
          }),
          name: name.substring(1),
        );
      }
    }
    return null;
  }

  /// Append the [arguments] to this instance's arguments list.
  BRoute addArguments([Map<String, dynamic>? arguments]) => copyWith(
        arguments: {
          ...?this.arguments,
          ...?arguments,
        },
      );

  /// Get the root route from [routes].
  static BRoute? rootRoute(List<BRoute> routes) => fromName("/", routes);

  BRoute copyWith({
    String? name,
    Map<String, dynamic>? arguments,
    Widget Function(BuildContext context, Map<String, dynamic>? arguments)? pageBuilder,
    String? Function(BuildContext context)? redirect,
  }) =>
      BRoute(
        name: name ?? this.name,
        arguments: arguments ?? this.arguments,
        pageBuilder: pageBuilder ?? this.pageBuilder,
      );
}

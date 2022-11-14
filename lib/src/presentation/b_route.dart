// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// Route class which is used for route configuration.
class BRoute extends Equatable {
  /// Used to identify parameter values, such as: `:id`, `:a-value`, etc.
  static String parameterStart = ":";

  /// The path of this route.
  ///
  /// The path should be set as "/" for root, "home" for home, etc.
  ///
  /// When setting adding value parameters to the path also add a parent path.
  /// Example: for a product page with parameter :id set the path to `products/:id`. This is to
  /// find the correct parent and make sure the navigation stack is built correctly.
  ///
  /// The path segment is case sensitive, so be warned: ```home != Home```.
  final String path;

  /// Arguments used for this route.
  ///
  /// Afterwards they can be retrieved using their respective keys.
  /// We sometimes need to pass dart objects to a route without adding them to the [Uri].
  ///
  /// This is because they contain lots of data and would make the URL unreadable, and not all
  /// routes should have visible parameters.
  ///
  /// For URL-visible parameters user [params] or [queryParams].
  final Map<String, dynamic> arguments;

  /// Used to set [Uri.queryParameters].
  ///
  /// If you want to add objects which should not be added the the URL, user [arguments] instead.
  final Map<String, String> params;

  /// The page which will be used to populate the navigation stack.
  final Widget Function(BuildContext context, Map<String, dynamic>? arguments, Uri uri) pageBuilder;

  /// The name part of the [path].
  ///
  /// For routes with parameter values it will return the parameter value, [nameSegments.last].
  /// Otherwise it will return the value of [path],
  String get name => pathContainsParameter ? pathSegments.last : path;

  /// Split the [name] into a list, using `/`.
  List<String> get pathSegments => path.split("/").where((element) => element.isNotEmpty).toList();

  /// If the [path] contains
  bool get pathContainsParameter =>
      pathSegments.isNotEmpty ? pathSegments.last.startsWith(BRoute.parameterStart) : false;

  @override
  List<Object> get props => [
        path,
        ...arguments.values,
        ...params.values,
      ];

  @override
  bool? get stringify => true;

  const BRoute({
    required this.path,
    this.arguments = const <String, dynamic>{},
    this.params = const <String, String>{},
    required this.pageBuilder,
  });

  /// Get the route, from [routes], using [name], if exists.
  static BRoute? fromPath(String path, List<BRoute> routes) {
    for (final route in routes) {
      if (route.containsPath(path)) {
        return route.pathContainsParameter ? route.updatePathParameter(path) : route;
      }
    }
    return null;
  }

  BRoute updatePathParameter(String value) {
    final parameterValue = value.split("/").last;
    return addParameters(arguments: {name.substring(1): parameterValue}).copyWith(
      path: pathSegments
          .map((e) => e.startsWith(BRoute.parameterStart) ? parameterValue : e)
          .join("/${BRoute.parameterStart}"),
    );
  }

  /// Check if this route contains the incoming [value].
  ///
  /// First we check if ```path == value```.
  ///
  /// If the above doesn't pass it will check if [pathContainsParameter] returns true and if it
  /// does, it will verify that both ```pathSegments.first == valueSegments.first``` and
  /// ```valueSegments.startsWith(BRoute.parameterStart)```.
  ///
  /// ```final valueSegments = value.split("/")```
  bool containsPath(String value) {
    if (path == value) {
      return true;
    }
    if (pathContainsParameter) {
      final valueSegments = value.split("/");
      return (valueSegments.length == 2) && (valueSegments.first == pathSegments.first);
    }
    return false;
  }

  /// Add all parameters to this instance's arguments list.
  ///
  /// [arguments] are appended while [params] are replaced.
  BRoute addParameters({Map<String, dynamic>? arguments, Map<String, String>? params}) => copyWith(
        arguments: {
          ...this.arguments,
          ...?arguments,
        },
        params: params,
      );

  /// Get the root route from [routes].
  static BRoute? rootRoute(List<BRoute> routes) => fromPath("/", routes);

  BRoute copyWith({
    String? path,
    Map<String, dynamic>? arguments,
    Map<String, String>? params,
    Widget Function(BuildContext context, Map<String, dynamic>? arguments, Uri uri)? pageBuilder,
  }) =>
      BRoute(
        path: path ?? this.path,
        arguments: arguments ?? this.arguments,
        params: params ?? this.params,
        pageBuilder: pageBuilder ?? this.pageBuilder,
      );
}

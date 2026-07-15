import 'dart:async';

import 'package:b_router/b_router.dart';
import 'package:flutter/widgets.dart';

/// {@template RedirectPathBuilder}
/// Used to build a new path for the router based on the current [BrouterState].
///
/// This is useful when you want to redirect the user to a different path,
/// such as the user is not authenticated and you want to redirect him to the login page.
/// {@endtemplate}
typedef RedirectPathBuilder = String? Function(BuildContext context, BRouterState state);

/// {@template PageBuilder}
/// Custom page builder.
///
/// If set, it will be used to build the page instead of the default one.
/// This is because the default page builder builds a [MaterialPage] with a standard key.
///
/// It provides [context], the [route] to be built and the current [uri] of the router.
///
/// This method brings more flexibility to the developer.
/// {@endtemplate}
typedef PageBuilder = Page<Object?> Function(
  BuildContext context,
  BRoute route,
  Uri uri,
);

/// {@template StayOpenedCallback}
/// If set, it will be called when the user presses the back button.
///
/// A value of `true` will keep the application opened while `false` will close it.
///
/// Read more at [popRoute].
/// {@endtemplate}
typedef StayOpenedCallback = FutureOr<bool?> Function(BuildContext context);

/// {@template PageChildBuilder}
/// Builds the widget which will be used inside the [Page].
///
/// [arguments] are the arguments passed to the route. These are also available
/// from [Page.arguments] field.
/// [uri] is the current uri of the route.
/// {@endtemplate}
typedef PageChildBuilder = Function(BuildContext context, Map<String, dynamic>? arguments, Uri uri);

/// {@template PagePopInvokedCallback}
/// Called when a page is popped.
///
/// This is so we know which [route] was popped and what was the [result] of the pop.
/// {@endtemplate}
typedef RoutePopInvokedCallback<T> = void Function(BRoute route, T result);

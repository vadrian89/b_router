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
/// This method brings more flexibility to the developer.
/// {@endtemplate}
typedef PageBuilder = Page<Object?> Function(BuildContext context, BRoute route);

/// {@template StayOpenedCallback}
/// If set, it will be called when the user presses the back button.
///
/// A value of `true` will keep the application opened while `false` will close it.
///
/// Read more at [popRoute].
/// {@endtemplate}
typedef StayOpenedCallback = FutureOr<bool?> Function(BuildContext context);

import 'dart:async';

import 'package:b_router/b_router.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// The root delegate of the app.
///
/// Used as value for [MaterialApp.router.routerDelegate].
/// This is the place where we set up what and how screens shown to the user.
///
/// Because I prefer to get rid of [addListener] and [removeListener] methods, I added [ChangeNotifier]
/// as mixin and call [notifyListeners] whenever [BRouterCubit] emits a new state.
class BRouterDelegate extends RouterDelegate<BRouterState>
    with PopNavigatorRouterDelegateMixin<BRouterState>, ChangeNotifier {
  final GlobalKey<NavigatorState> _navigatorKey;
  final BRouterCubit _bloc;

  /// If set, it will be called when the user presses the back button.
  ///
  /// A value of `true` will keep the application opened while `false` will close it.
  ///
  /// Read more at [popRoute].
  final FutureOr<bool?> Function(BuildContext context)? stayOpened;

  /// Build the widget used when navigation errors occur.
  ///
  /// By default it will use [NotFoundScreen].
  final Widget Function(BuildContext context)? errorBuilder;

  final String? Function(BuildContext context, BRouterState state)? redirect;

  /// Custom page builder.
  ///
  /// If set, it will be used to build the page instead of the default one.
  /// This is because the default page builder builds a [MaterialPage] with a standard key.
  ///
  /// This method brings more flexibility to the developer.
  final Page Function(BuildContext context, BRoute route)? pageBuilder;

  NavigatorState? get _navigatorState => navigatorKey!.currentState;

  @override
  GlobalKey<NavigatorState>? get navigatorKey => _navigatorKey;

  @override
  BRouterState get currentConfiguration => _bloc.state;

  BRouterDelegate({
    required GlobalKey<NavigatorState> navigatorKey,
    required BRouterCubit bloc,
    this.stayOpened,
    this.errorBuilder,
    this.redirect,
    this.pageBuilder,
  })  : _navigatorKey = navigatorKey,
        _bloc = bloc;

  @override
  Widget build(BuildContext context) => BRouterListener(
        listener: (_, __) => notifyListeners(),
        child: Navigator(
          key: navigatorKey,
          pages: _pagesFromState(context),
          onPopPage: _onPopPageParser,
        ),
      );

  List<Page> _pagesFromState(BuildContext context) => currentConfiguration.maybeWhen(
        orElse: () => [],
        routesFound: (routes) {
          final path = (redirect != null) ? redirect!(context, currentConfiguration) : null;
          if (path?.isNotEmpty ?? false) {
            final route = routes.firstWhere(
              (element) => element.path == path,
              orElse: () => routes.first,
            );
            return [
              pageBuilder?.call(context, route) ??
                  _page(
                    valueKey: "${route.name}_page",
                    child: Builder(
                      builder: (context) => routes.first.routeBuilder(
                        context,
                        route.arguments,
                        currentConfiguration.uri,
                      ),
                    ),
                  ),
            ];
          }
          return List.generate(
            routes.length,
            (index) =>
                pageBuilder?.call(context, routes[index]) ??
                _page(
                  valueKey: "${routes[index].name}_page",
                  child: Builder(
                    builder: (context) => routes[index].routeBuilder(
                      context,
                      routes[index].arguments,
                      currentConfiguration.uri,
                    ),
                  ),
                ),
          );
        },
        unknown: () => [
          _page(
            valueKey: "not_found_page",
            child: Builder(
              builder: (errorBuilder != null) ? errorBuilder! : (context) => const NotFoundScreen(),
            ),
          ),
        ],
      );

  /// Set a new path based on the one reported by the system, by calling [BRouterCubit.setNewRoutePath].
  ///
  /// This method is called by the [Router] when a new route has been requested by the underlying system.
  /// It’s recommended to return a [SynchronousFuture] to avoid waiting for microtasks.
  ///
  /// This happens right after the RouteInformation has been parsed by the [Router].
  /// For example: when a URL has been manually inserted, the URL get’s parsed, then this mehod is called.
  @override
  Future<void> setNewRoutePath(BRouterState configuration) => SynchronousFuture(
        _bloc.setNewRoutePath(configuration),
      );

  /// Manage popped [Page]s.
  ///
  /// To manage the navigation stack we call [BRouterCubit.popRoute] and handle any [result]
  /// returned from the page.
  ///
  /// For more see [Navigator.onPopPage].
  bool _onPopPageParser(Route<dynamic> route, dynamic result) {
    if (!route.didPop(result)) return false;
    return _bloc.popRoute(result);
  }

  /// Called by the [Router] when the [Router.backButtonDispatcher] reports that
  /// the operating system is requesting that the current route be popped.
  ///
  /// Since poped pages can be managed from [Navigator.onPopPage], here we only handle any
  /// non-[Page]s, such as dialogs, bottom sheets, etc.
  ///
  /// Closing the app can be prevented with the help of [stayOpened].
  /// Exit confirmation example:
  /// ```dart
  /// showDialog<bool?>(
  ///   context: context!,
  ///   builder: (context) => AlertDialog(
  ///     content: const Text("Close app?"),
  ///       actions: [
  ///         TextButton(
  ///           onPressed: () => Navigator.pop(context, true),
  ///           child: const Text("No"),
  ///         ),
  ///         TextButton(
  ///           onPressed: () => Navigator.pop(context, false),
  ///           child: const Text("Yes"),
  ///         ),
  ///     ],
  ///   ),
  /// )
  /// ```
  /// If [stayOpened] is set and returns `null`, it will be replaced with a `true` value.
  /// `false`, means the entire app will be popped, that's why a `true` value will keep the app
  /// opened. For more info see [RouterDelegate.popRoute].
  @override
  Future<bool> popRoute() async {
    if (_navigatorState?.canPop() ?? false) {
      return _navigatorState!.maybePop();
    }
    return (stayOpened != null)
        ? (await stayOpened!(navigatorKey!.currentContext!) ?? true)
        : false;
  }

  /// Build a [Page] (screens) to use in [Navigator.pages] list.
  Page _page({
    required String valueKey,
    required Widget child,
  }) =>
      MaterialPage(
        key: ValueKey<String>(valueKey),
        child: child,
      );
}

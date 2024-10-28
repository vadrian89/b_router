import 'dart:async';

import 'package:b_router/b_router.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'pages/page_list_builder.dart';

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

  /// {@macro StayOpenedCallback}
  final StayOpenedCallback? stayOpened;

  /// Build the widget used when navigation errors occur.
  ///
  /// By default it will use [NotFoundScreen].
  final WidgetBuilder? errorBuilder;

  /// {@macro RedirectPathBuilder}
  final RedirectPathBuilder? redirect;

  /// {@macro PageBuilder}
  final PageBuilder? pageBuilder;

  @override
  GlobalKey<NavigatorState>? get navigatorKey => _navigatorKey;
  NavigatorState? get _navigatorState => navigatorKey!.currentState;
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
        listener: (context, state) => notifyListeners(),
        child: Navigator(
          key: navigatorKey,
          onPopPage: _onPopPageParser,
          pages: PageListBuilder(
            context: context,
            currentState: currentConfiguration,
            redirect: redirect,
            errorChildBuilder: errorBuilder,
            pageBuilder: pageBuilder,
          ).build(),
        ),
      );

  /// Manage popped [Page]s.
  ///
  /// To manage the navigation stack we call [BRouterCubit.popRoute] and handle any [result]
  /// returned from the page.
  ///
  /// For more see [Navigator.onPopPage].
  bool _onPopPageParser(Route<dynamic> route, dynamic result) {
    if (!route.didPop(result)) return false;
    return _bloc.pop(route: route, result: result);
  }

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

  /// Called by the [Router] when the [Router.backButtonDispatcher] reports that
  /// the operating system is requesting that the current route be popped.
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
  ///
  /// [Page.canPop] needs to be set false for the root page, in order to prevent the app
  /// from closing.
  @override
  Future<bool> popRoute() async {
    if (_navigatorState?.canPop() ?? false) {
      return _navigatorState!.maybePop();
    }
    return (stayOpened != null)
        ? (await stayOpened!(navigatorKey!.currentContext!) ?? true)
        : false;
  }
}

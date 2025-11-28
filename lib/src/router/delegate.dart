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

  /// Build the widget used when navigation errors occur.
  ///
  /// By default it will use [NotFoundScreen].
  final WidgetBuilder? errorBuilder;

  /// {@macro RedirectPathBuilder}
  final RedirectPathBuilder? redirect;

  /// {@macro PageBuilder}
  final PageBuilder? pageBuilder;

  /// Callback used for [Navigator.onDidRemovePage].
  final DidRemovePageCallback? onDidRemovePage;

  @override
  GlobalKey<NavigatorState>? get navigatorKey => _navigatorKey;

  /// NavigatorState? get _navigatorState => navigatorKey!.currentState;
  @override
  BRouterState get currentConfiguration => _bloc.state;

  BRouterDelegate({
    required GlobalKey<NavigatorState> navigatorKey,
    required BRouterCubit bloc,
    this.errorBuilder,
    this.redirect,
    this.pageBuilder,
    this.onDidRemovePage,
  })  : _navigatorKey = navigatorKey,
        _bloc = bloc;

  @override
  Widget build(BuildContext context) => BRouterListener(
        listener: (context, state) => notifyListeners(),
        child: Navigator(
          key: navigatorKey,
          pages: PageListBuilder(
            context: context,
            currentState: currentConfiguration,
            redirect: redirect,
            errorChildBuilder: errorBuilder,
            pageBuilder: pageBuilder,
            onPopInvoked: (route, result) => _bloc.pop(route: route, result: result),
          ).build(),
          onDidRemovePage: onDidRemovePage ?? (page) {},
        ),
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
}

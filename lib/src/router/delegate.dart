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
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  final BRouterStateNotifier stateNotifier;

  /// {@macro PageBuilder}
  final PageBuilder? pageBuilder;

  /// Callback used for [Navigator.onDidRemovePage].
  final DidRemovePageCallback? onDidRemovePage;

  /// Callback when a page is popped.
  ///
  /// Passed to [MaterialPage.onPopInvoked].
  final RoutePopInvokedCallback<Object?> onPopInvoked;

  @override
  GlobalKey<NavigatorState>? get navigatorKey => _navigatorKey;

  /// NavigatorState? get _navigatorState => navigatorKey!.currentState;
  @override
  BRouterState get currentConfiguration => stateNotifier.value;

  BRouterDelegate({
    required this.stateNotifier,
    this.pageBuilder,
    this.onDidRemovePage,
    required this.onPopInvoked,
  }) {
    stateNotifier.addListener(notifyListeners);
  }

  @override
  void dispose() {
    stateNotifier.removeListener(notifyListeners);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ValueListenableBuilder(
        valueListenable: stateNotifier,
        builder: (context, value, child) => BRouterStateProvider(
          state: value,
          child: child!,
        ),
        child: Navigator(
          key: navigatorKey,
          pages: PageListBuilder(
            context: context,
            currentState: currentConfiguration,
            pageBuilder: pageBuilder,
            onPopInvoked: onPopInvoked,
          ).build(),
          onDidRemovePage: onDidRemovePage ?? (page) {},
        ),
      );

  /// Implement the logic for what happens when the top route was popped.
  ///
  /// If the current state is [BRouterState.unknown], it will call [goToRoot]. This is to prevent
  /// any issues that might arise from popping a route when the state is unknown.
  /// void pop({required BRoute route, Object? result}) {
  ///   _logger.d("Popping route.");
  ///   final currentState = this.pushedRoutes.value;
  ///   if (currentState case UnknownRoute()) {
  ///     this.pushedRoutes.value = BRouterState.initial();
  ///     return;
  ///   }
  ///   final pushedRoutes = _pushedRoutes.where((element) => element != route).toList();
  ///   if (pushedRoutes.isEmpty) {
  ///     _logger.w("Cannot pop the root route.");
  ///     return goToRoot();
  ///   }
  ///   _pushedRoutes = List.from(pushedRoutes);
  ///   if (result != null) {
  ///     _logger.d("Popping route with result: $result");
  ///     emit(BRouterState.poppedResult(route: route, uri: currentState.uri, popResult: result));
  ///   }
  ///   _showFound();
  /// }

  /// Set a new path based on the one reported by the system, by calling [BRouterCubit.setNewRoutePath].
  ///
  /// This method is called by the [Router] when a new route has been requested by the underlying system.
  /// It’s recommended to return a [SynchronousFuture] to avoid waiting for microtasks.
  ///
  /// This happens right after the RouteInformation has been parsed by the [Router].
  /// For example: when a URL has been manually inserted, the URL get’s parsed, then this mehod is called.
  @override
  Future<void> setNewRoutePath(BRouterState configuration) {
    stateNotifier.value = configuration;
    return SynchronousFuture(null);
  }
}

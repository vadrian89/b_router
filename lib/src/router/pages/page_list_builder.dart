import 'package:b_router/b_router.dart';
import 'package:b_router/src/interfaces/builder.dart';
import 'package:flutter/material.dart';

import 'default_page_builder.dart';

class PageListBuilder implements ObjectBuilder<List<Page>> {
  /// The current build context.
  final BuildContext context;

  /// The current state of the router.
  final BRouterState currentState;

  /// {@macro PageBuilder}
  final PageBuilder? pageBuilder;

  /// Callback when a page is popped.
  ///
  /// Passed to [MaterialPage.onPopInvoked].
  final RoutePopInvokedCallback<Object?> onPopInvoked;

  const PageListBuilder({
    required this.context,
    required this.currentState,
    this.pageBuilder,
    required this.onPopInvoked,
  });

  @override
  List<Page> build() => switch (currentState) {
        FoundRoutes(:final routes) => _foundPages(routes),
        _ => const [],
      };

  List<Page> _foundPages(List<BRoute> routes) => List.generate(
        routes.length,
        (index) {
          final route = routes[index];
          final uri = currentState.uri;
          var page = pageBuilder?.call(context, route, uri);
          page ??= DefaultPageBuilder(
            name: route.name,
            onPopInvoked: (didPop, result) => didPop ? onPopInvoked(route, result) : null,
            builder: (context) => route.builder(context, route.arguments, uri),
          ).build();
          return page;
        },
      );
}

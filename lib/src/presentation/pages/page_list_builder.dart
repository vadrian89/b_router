import 'package:b_router/b_router.dart';
import 'package:b_router/src/interfaces/builder.dart';
import 'package:flutter/material.dart';

import '../../core/typedefs.dart';
import 'default_page_builder.dart';

class PageListBuilder implements ObjectBuilder<List<Page>> {
  /// The current build context.
  final BuildContext context;

  /// The current state of the router.
  final BRouterState currentState;

  /// {@macro RedirectPathBuilder}
  final RedirectPathBuilder? redirect;

  /// The error page builder.
  final WidgetBuilder? errorChildBuilder;

  /// {@macro PageBuilder}
  final PageBuilder? pageBuilder;

  /// Callback when a page is popped.
  ///
  /// Passed to [MaterialPage.onPopInvoked].
  final PopInvokedWithResultCallback<Object?> onPopInvoked;

  const PageListBuilder({
    required this.context,
    required this.currentState,
    this.pageBuilder,
    this.redirect,
    this.errorChildBuilder,
    required this.onPopInvoked,
  });

  @override
  List<Page> build() {
    var list = const <Page>[];
    if (currentState case UnknownRoute()) {
      list = [DefaultPageBuilder.notFound(builder: errorChildBuilder).build()];
    } else if (currentState case FoundRoutes(:final routes)) {
      final redirectedPath = redirect?.call(context, currentState)?.trim() ?? "";
      if (redirectedPath.isNotEmpty) list = _redirectedBuilder(routes, redirectedPath);
      list = _foundPages(routes);
    }
    return list;
  }

  List<Page> _foundPages(List<BRoute> routes) => List.generate(
        routes.length,
        (index) {
          final route = routes[index];
          var page = pageBuilder?.call(context, route);
          page ??= DefaultPageBuilder(
            name: route.name,
            onPopInvoked: onPopInvoked,
            builder: (context) => route.builder(
              context,
              route.arguments,
              currentState.uri,
            ),
          ).build();
          return page;
        },
      );

  List<Page> _redirectedBuilder(List<BRoute> routes, String redirectedPath) {
    final route = routes.firstWhere(
      (element) => element.path == redirectedPath,
      orElse: () => routes.first,
    );
    var page = pageBuilder?.call(context, route);
    page ??= DefaultPageBuilder(
      name: route.name,
      onPopInvoked: onPopInvoked,
      builder: (context) => routes.first.builder(
        context,
        route.arguments,
        currentState.uri,
      ),
    ).build();
    return [page];
  }
}

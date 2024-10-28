import 'package:b_router/b_router.dart';
import 'package:flutter/material.dart';

import '../../interfaces/builder.dart';

/// Page builder used if there is no custom page builder set.
class DefaultPageBuilder implements ObjectBuilder<Page<Object?>> {
  /// The value key of the page as a [String].
  ///
  /// Passed to [MaterialPage.key].
  final String name;

  /// The child widget of the page.
  ///
  /// Passed to [MaterialPage.child].
  final WidgetBuilder builder;

  const DefaultPageBuilder({
    required this.name,
    required this.builder,
  });

  factory DefaultPageBuilder.notFound({WidgetBuilder? builder}) => DefaultPageBuilder(
        name: "not_found",
        builder: builder ?? (context) => const NotFoundScreen(),
      );

  @override
  Page<Object?> build() => MaterialPage(
        key: ValueKey<String>("${name}_page"),
        name: name,
        child: Builder(builder: builder),
      );
}

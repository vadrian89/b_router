import 'package:b_router/router.dart';
import 'package:flutter/foundation.dart';

import '../../bloc.dart';

extension BRouterStateHelpersMixin on BRouterState {
  /// maybeMap Pattern matching for BRouterState.
  ///
  /// Legacy from freezed implementation, kept for easier migration.
  @Deprecated("Use switch expressions instead.")
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(InitialRoute value)? initial,
    TResult Function(FoundRoutes value)? routesFound,
    TResult Function(UnknownRoute value)? unknown,
    TResult Function(PoppedResultRoute value)? poppedResult,
    required TResult Function() orElse,
  }) {
    final that = this;
    return switch (that) {
      InitialRoute() when initial != null => initial(that),
      FoundRoutes() when routesFound != null => routesFound(that),
      UnknownRoute() when unknown != null => unknown(that),
      PoppedResultRoute() when poppedResult != null => poppedResult(that),
      _ => orElse(),
    };
  }

  /// map Pattern matching for BRouterState.
  ///
  /// Legacy from freezed implementation, kept for easier migration.
  @Deprecated("Use switch expressions instead.")
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(InitialRoute value) initial,
    required TResult Function(FoundRoutes value) routesFound,
    required TResult Function(UnknownRoute value) unknown,
    required TResult Function(PoppedResultRoute value) poppedResult,
  }) {
    final that = this;
    return switch (that) {
      InitialRoute() => initial(that),
      FoundRoutes() => routesFound(that),
      UnknownRoute() => unknown(that),
      PoppedResultRoute() => poppedResult(that),
    };
  }

  /// mapOrNull Pattern matching for BRouterState.
  ///
  /// Legacy from freezed implementation, kept for easier migration.
  @Deprecated("Use switch expressions instead.")
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(InitialRoute value)? initial,
    TResult? Function(FoundRoutes value)? routesFound,
    TResult? Function(UnknownRoute value)? unknown,
    TResult? Function(PoppedResultRoute value)? poppedResult,
  }) {
    final that = this;
    return switch (that) {
      InitialRoute() when initial != null => initial(that),
      FoundRoutes() when routesFound != null => routesFound(that),
      UnknownRoute() when unknown != null => unknown(that),
      PoppedResultRoute() when poppedResult != null => poppedResult(that),
      _ => null,
    };
  }

  /// when Pattern matching for BRouterState.
  ///
  /// Legacy from freezed implementation, kept for easier migration.
  @Deprecated("Use switch expressions instead.")
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function(List<BRoute> routes) routesFound,
    required TResult Function() unknown,
    required TResult Function(BRoute route, Uri uri, dynamic popResult) poppedResult,
  }) {
    final that = this;
    return switch (that) {
      InitialRoute() => initial(),
      FoundRoutes(:final routes) => routesFound(routes),
      UnknownRoute() => unknown(),
      PoppedResultRoute(:final route, :final uri, :final popResult) => poppedResult(
          route,
          uri,
          popResult,
        ),
    };
  }

  /// maybeWhen Pattern matching for BRouterState.
  ///
  /// Legacy from freezed implementation, kept for easier migration.
  @Deprecated("Use switch expressions instead.")
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(List<BRoute> routes)? routesFound,
    TResult Function()? unknown,
    TResult Function(BRoute route, Uri uri, dynamic popResult)? poppedResult,
    required TResult Function() orElse,
  }) {
    final that = this;
    return switch (that) {
      InitialRoute() when initial != null => initial(),
      FoundRoutes(:final routes) when routesFound != null => routesFound(routes),
      UnknownRoute() when unknown != null => unknown(),
      PoppedResultRoute(:final route, :final uri, :final popResult) when poppedResult != null =>
        poppedResult(
          route,
          uri,
          popResult,
        ),
      _ => orElse(),
    };
  }

  /// whenOrNull Pattern matching for BRouterState.
  ///
  /// Legacy from freezed implementation, kept for easier migration.
  @Deprecated("Use switch expressions instead.")
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function(List<BRoute> routes)? routesFound,
    TResult? Function()? unknown,
    TResult? Function(BRoute route, Uri uri, dynamic popResult)? poppedResult,
  }) {
    final that = this;
    return switch (that) {
      InitialRoute() when initial != null => initial(),
      FoundRoutes(:final routes) when routesFound != null => routesFound(routes),
      UnknownRoute() when unknown != null => unknown(),
      PoppedResultRoute(:final route, :final uri, :final popResult) when poppedResult != null =>
        poppedResult(
          route,
          uri,
          popResult,
        ),
      _ => null,
    };
  }
}

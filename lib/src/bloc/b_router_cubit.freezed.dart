// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'b_router_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BRouterState {
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is BRouterState);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'BRouterState()';
  }
}

/// @nodoc
class $BRouterStateCopyWith<$Res> {
  $BRouterStateCopyWith(BRouterState _, $Res Function(BRouterState) __);
}

/// Adds pattern-matching-related methods to [BRouterState].
extension BRouterStatePatterns on BRouterState {
  /// A variant of `map` that fallback to returning `orElse`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(InitialRoute value)? initial,
    TResult Function(FoundRoutes value)? routesFound,
    TResult Function(UnknownRoute value)? unknown,
    TResult Function(PoppedResultRoute value)? poppedResult,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case InitialRoute() when initial != null:
        return initial(_that);
      case FoundRoutes() when routesFound != null:
        return routesFound(_that);
      case UnknownRoute() when unknown != null:
        return unknown(_that);
      case PoppedResultRoute() when poppedResult != null:
        return poppedResult(_that);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// Callbacks receives the raw object, upcasted.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case final Subclass2 value:
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(InitialRoute value) initial,
    required TResult Function(FoundRoutes value) routesFound,
    required TResult Function(UnknownRoute value) unknown,
    required TResult Function(PoppedResultRoute value) poppedResult,
  }) {
    final _that = this;
    switch (_that) {
      case InitialRoute():
        return initial(_that);
      case FoundRoutes():
        return routesFound(_that);
      case UnknownRoute():
        return unknown(_that);
      case PoppedResultRoute():
        return poppedResult(_that);
    }
  }

  /// A variant of `map` that fallback to returning `null`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(InitialRoute value)? initial,
    TResult? Function(FoundRoutes value)? routesFound,
    TResult? Function(UnknownRoute value)? unknown,
    TResult? Function(PoppedResultRoute value)? poppedResult,
  }) {
    final _that = this;
    switch (_that) {
      case InitialRoute() when initial != null:
        return initial(_that);
      case FoundRoutes() when routesFound != null:
        return routesFound(_that);
      case UnknownRoute() when unknown != null:
        return unknown(_that);
      case PoppedResultRoute() when poppedResult != null:
        return poppedResult(_that);
      case _:
        return null;
    }
  }

  /// A variant of `when` that fallback to an `orElse` callback.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(List<BRoute> routes)? routesFound,
    TResult Function()? unknown,
    TResult Function(BRoute route, Uri uri, dynamic popResult)? poppedResult,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case InitialRoute() when initial != null:
        return initial();
      case FoundRoutes() when routesFound != null:
        return routesFound(_that.routes);
      case UnknownRoute() when unknown != null:
        return unknown();
      case PoppedResultRoute() when poppedResult != null:
        return poppedResult(_that.route, _that.uri, _that.popResult);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// As opposed to `map`, this offers destructuring.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case Subclass2(:final field2):
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function(List<BRoute> routes) routesFound,
    required TResult Function() unknown,
    required TResult Function(BRoute route, Uri uri, dynamic popResult)
        poppedResult,
  }) {
    final _that = this;
    switch (_that) {
      case InitialRoute():
        return initial();
      case FoundRoutes():
        return routesFound(_that.routes);
      case UnknownRoute():
        return unknown();
      case PoppedResultRoute():
        return poppedResult(_that.route, _that.uri, _that.popResult);
    }
  }

  /// A variant of `when` that fallback to returning `null`
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function(List<BRoute> routes)? routesFound,
    TResult? Function()? unknown,
    TResult? Function(BRoute route, Uri uri, dynamic popResult)? poppedResult,
  }) {
    final _that = this;
    switch (_that) {
      case InitialRoute() when initial != null:
        return initial();
      case FoundRoutes() when routesFound != null:
        return routesFound(_that.routes);
      case UnknownRoute() when unknown != null:
        return unknown();
      case PoppedResultRoute() when poppedResult != null:
        return poppedResult(_that.route, _that.uri, _that.popResult);
      case _:
        return null;
    }
  }
}

/// @nodoc

class InitialRoute extends BRouterState {
  const InitialRoute() : super._();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is InitialRoute);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'BRouterState.initial()';
  }
}

/// @nodoc

class FoundRoutes extends BRouterState {
  const FoundRoutes({required final List<BRoute> routes})
      : _routes = routes,
        super._();

  final List<BRoute> _routes;
  List<BRoute> get routes {
    if (_routes is EqualUnmodifiableListView) return _routes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_routes);
  }

  /// Create a copy of BRouterState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $FoundRoutesCopyWith<FoundRoutes> get copyWith =>
      _$FoundRoutesCopyWithImpl<FoundRoutes>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is FoundRoutes &&
            const DeepCollectionEquality().equals(other._routes, _routes));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_routes));

  @override
  String toString() {
    return 'BRouterState.routesFound(routes: $routes)';
  }
}

/// @nodoc
abstract mixin class $FoundRoutesCopyWith<$Res>
    implements $BRouterStateCopyWith<$Res> {
  factory $FoundRoutesCopyWith(
          FoundRoutes value, $Res Function(FoundRoutes) _then) =
      _$FoundRoutesCopyWithImpl;
  @useResult
  $Res call({List<BRoute> routes});
}

/// @nodoc
class _$FoundRoutesCopyWithImpl<$Res> implements $FoundRoutesCopyWith<$Res> {
  _$FoundRoutesCopyWithImpl(this._self, this._then);

  final FoundRoutes _self;
  final $Res Function(FoundRoutes) _then;

  /// Create a copy of BRouterState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? routes = null,
  }) {
    return _then(FoundRoutes(
      routes: null == routes
          ? _self._routes
          : routes // ignore: cast_nullable_to_non_nullable
              as List<BRoute>,
    ));
  }
}

/// @nodoc

class UnknownRoute extends BRouterState {
  const UnknownRoute() : super._();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is UnknownRoute);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'BRouterState.unknown()';
  }
}

/// @nodoc

class PoppedResultRoute extends BRouterState {
  const PoppedResultRoute(
      {required this.route, required this.uri, this.popResult})
      : super._();

  final BRoute route;
  final Uri uri;
  final dynamic popResult;

  /// Create a copy of BRouterState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $PoppedResultRouteCopyWith<PoppedResultRoute> get copyWith =>
      _$PoppedResultRouteCopyWithImpl<PoppedResultRoute>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is PoppedResultRoute &&
            (identical(other.route, route) || other.route == route) &&
            (identical(other.uri, uri) || other.uri == uri) &&
            const DeepCollectionEquality().equals(other.popResult, popResult));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, route, uri, const DeepCollectionEquality().hash(popResult));

  @override
  String toString() {
    return 'BRouterState.poppedResult(route: $route, uri: $uri, popResult: $popResult)';
  }
}

/// @nodoc
abstract mixin class $PoppedResultRouteCopyWith<$Res>
    implements $BRouterStateCopyWith<$Res> {
  factory $PoppedResultRouteCopyWith(
          PoppedResultRoute value, $Res Function(PoppedResultRoute) _then) =
      _$PoppedResultRouteCopyWithImpl;
  @useResult
  $Res call({BRoute route, Uri uri, dynamic popResult});
}

/// @nodoc
class _$PoppedResultRouteCopyWithImpl<$Res>
    implements $PoppedResultRouteCopyWith<$Res> {
  _$PoppedResultRouteCopyWithImpl(this._self, this._then);

  final PoppedResultRoute _self;
  final $Res Function(PoppedResultRoute) _then;

  /// Create a copy of BRouterState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? route = null,
    Object? uri = null,
    Object? popResult = freezed,
  }) {
    return _then(PoppedResultRoute(
      route: null == route
          ? _self.route
          : route // ignore: cast_nullable_to_non_nullable
              as BRoute,
      uri: null == uri
          ? _self.uri
          : uri // ignore: cast_nullable_to_non_nullable
              as Uri,
      popResult: freezed == popResult
          ? _self.popResult
          : popResult // ignore: cast_nullable_to_non_nullable
              as dynamic,
    ));
  }
}

// dart format on

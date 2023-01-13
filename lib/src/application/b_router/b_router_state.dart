part of 'b_router_cubit.dart';

@freezed
class BRouterState with _$BRouterState {
  /// The root path of the app.
  static const rootPath = "/";

  /// 404 - page not found state
  static const notFoundPath = "404";

  /// Define the private constructor to enable support for class methods and properties.
  const BRouterState._();

  /// [BRouterState.initial] is the initial state of the app.
  ///
  /// This should be used to show the user a loading screen/widget, until the app verifies
  /// if the user is authenticated or not.
  const factory BRouterState.initial() = _Initial;

  /// [BRouterState.routesFound] contains all the routes found.
  ///
  /// [modalsOpened] is the number of modal/dialogs opened and is a counter to safely close them
  /// without closing the top screen.
  const factory BRouterState.routesFound({required List<BRoute> routes}) = _RoutesFound;

  /// [BRouterState.unknown] is the state returned when the user requests an uknown page.
  ///
  /// This is the equivalent of error 404 for HTTP requests: https://en.wikipedia.org/wiki/HTTP_404.
  /// It shows [UnkownScreen].
  const factory BRouterState.unknown() = _Unknown;

  /// Emitted when a screen poped with a result.
  ///
  /// [route] is the one which returned this result.
  /// [popResult] is the result returned.
  const factory BRouterState.poppedResult({
    required BRoute route,
    @Deprecated("Will be deleted") required String name,
    dynamic popResult,
  }) = _PoppedResult;

  /// Built the state based on the provided [Uri].
  ///
  /// This constructor is used inside [BRouterParser.parseRouteInformation] and used for redirect
  /// in [BRouterCubit.redirect].
  ///
  /// [routes] list contains all the routes available to the router and is used to find the correct
  /// routes.
  ///
  /// The workflow is as follows:
  /// 1. It will try and retrieve the root route. If this fail [BRouterState.unknown] will be returned.
  /// 2. It will loop between all [Uri.pathSegments] and try to find the correct route:
  ///   a. It will try to find a route based on the current segment. If none is found and the route has only
  ///   1 segment inside the path it will return [BRouterState.unknown].
  ///   b. Otherwise, if it's not the first path segment, it will try to find a route by combining
  ///   previous segment with current segment ```"${pathSegments[i - 1]}/$segment"``` (i is the
  ///   current index in the loop).
  /// 3. It will regenerate the found routes list and it will attach the query parameters passed
  /// from [uri] to the 2nd round in found list. This is because we don't know which route contains which
  /// parameter.
  factory BRouterState.fromUri({required Uri uri, required List<BRoute> routes}) {
    List<BRoute> routesList = const [];
    final rootRoute = BRoute.rootRoute(routes);
    if (rootRoute == null) {
      return const BRouterState.unknown();
    }
    routesList = List.from([rootRoute]);
    final pathSegments = uri.pathSegments;
    for (int i = 0; i < pathSegments.length; i++) {
      final segment = pathSegments[i];
      BRoute? route = BRoute.fromPath(segment, routes);
      if (route == null && pathSegments.length < 2) {
        const BRouterState.unknown();
      }
      if (i > 0) {
        route ??= BRoute.fromPath("${pathSegments[i - 1]}/$segment", routes);
      }
      if (route != null) {
        routesList = List.from([...routesList, route]);
      }
    }
    if (routesList.length > 1) {
      routesList = List.generate(
        routesList.length,
        (index) => (index == 1)
            ? routesList[index].addParameters(params: uri.queryParameters)
            : routesList[index],
      );
    }
    return BRouterState.routesFound(routes: routesList);
  }

  /// Get the app [Uri] based on the current state.
  Uri get uri => maybeWhen(
        initial: () => Uri.parse(rootPath),
        orElse: () => Uri.parse(notFoundPath),
        routesFound: (routes) => Uri(
          pathSegments: _pathSegments(routes),
          queryParameters: _params(routes),
        ),
      );

  Map<String, String>? _params(List<BRoute> list) {
    Map<String, String> params = Map<String, String>.fromEntries(
      list.expand((element) => element.params.entries),
    );
    return params.isNotEmpty ? params : null;
  }

  List<String> _pathSegments(List<BRoute> list) {
    List<String> tmpList = const [];
    for (final route in list) {
      if (route.path != rootPath) {
        tmpList = List.from([
          ...tmpList,
          (route.pathContainsParameter)
              ? route.name.replaceFirst(BRoute.parameterStart, "")
              : route.name,
        ]);
      }
    }
    return tmpList;
  }
}

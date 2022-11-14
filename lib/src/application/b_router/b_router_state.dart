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
  /// [name] is the route named for which the result is ment to.
  /// [popResult] is the result returned.
  const factory BRouterState.poppedResult({required String name, dynamic popResult}) =
      _PoppedResult;

  /// Factory constructor used to get the correct state from an [Uri].
  ///
  /// This constructor is used inside [BRouterParser.parseRouteInformation].
  factory BRouterState.fromUri({required Uri uri, required List<BRoute> routes}) {
    List<BRoute> routesList = const [];
    final rootRoute = BRoute.rootRoute(routes)?.addParameters(params: uri.queryParameters);
    if (rootRoute == null) {
      return const BRouterState.unknown();
    }
    routesList = List.from([rootRoute]);
    for (final pathSegment in uri.pathSegments) {
      BRoute? route = BRoute.fromPath(pathSegment, routes);
      route ??= BRoute.fromPath("${routesList.last.path}/$pathSegment", routes);
      if (route == null) {
        return const BRouterState.unknown();
      }
      routesList = List.from([...routesList, route]);
    }
    return BRouterState.routesFound(routes: routesList);
  }

  /// Get the location of the current navigation stack.
  ///
  /// Example: ```/page1/page2/?p=some-parameter```
  String get location => maybeWhen(
        initial: () => rootPath,
        routesFound: (routes) {
          final path = _locationFromRoutes(routes);
          return path.isNotEmpty ? path : rootPath;
        },
        orElse: () => notFoundPath,
      );

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

  String _locationFromRoutes(List<BRoute> list) {
    String query = "";
    String path = "";
    List<BRoute> tmpList = const [];
    for (final route in list) {
      query += route.params.entries.map((e) => "${e.key}=${e.value}").join(",");
      if (route.path != rootPath) {
        path += "/${route.name.replaceFirst(BRoute.parameterStart, "")}";
      }
      tmpList = List.from([...tmpList, route]);
    }
    return "$path${query.isNotEmpty ? "?" : ""}$query";
  }
}

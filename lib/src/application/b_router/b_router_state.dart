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
    final rootRoute = BRoute.rootRoute(routes);
    if (rootRoute == null) {
      return const BRouterState.unknown();
    }
    routesList = List.from([rootRoute, ...routesList]);
    for (final pathSegment in uri.pathSegments) {
      BRoute? route = BRoute.fromName(pathSegment, routes);

      /// If the initial [route] returned no found route, we check to see if it matches a route
      /// with name containg a parameter, such as ```/products/:43```.
      route ??= BRoute.fromName(routesList.last.name, routes)?.findRoute(
        name: "${BRoute.parameterId}$pathSegment",
      );

      if (route == null) {
        return const BRouterState.unknown();
      }
      routesList = List.from([...routesList, route]);
    }
    return BRouterState.routesFound(routes: routesList);
  }

  /// Get the location of the current navigation stack.
  ///
  /// Example: /page1/page2/p=some-paramter
  String get location => maybeWhen(
        initial: () => rootPath,
        routesFound: (routes) {
          String path = _locationFromRoutes(routes);
          if (path.isEmpty) {
            path = rootPath;
          }
          return path;
        },
        orElse: () => notFoundPath,
      );

  String _locationFromRoutes(List<BRoute> list) =>
      list.where((element) => element.name != rootPath).fold(
            "",
            (previousValue, element) => "$previousValue/${element.name}",
          );
}

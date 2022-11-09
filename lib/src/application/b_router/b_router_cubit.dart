import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logger/logger.dart';

import '../../presentation/b_route.dart';

part 'b_router_state.dart';
part 'b_router_cubit.freezed.dart';

/// Bloc used to manage the router.
class BRouterCubit extends Cubit<BRouterState> {
  final Logger _logger;
  final List<BRoute> _allRoutes;

  /// Get the list of the routes for this router.
  List<BRoute> get routes => _allRoutes;

  List<BRoute> _pushedRoutes = const [];

  BRouterCubit({required List<BRoute> routes})
      : _logger = Logger(),
        _allRoutes = List.from(routes),
        super(const BRouterState.initial()) {
    _logger.d("Initialising BRouterCubit");
  }

  /// Push a new page to the navigation stack.
  ///
  /// [name] must be a valid route name.
  /// [name] must be either simple, such as `login` or with parameter, such as `products/:id`
  /// (id is just a placeholder it can be anything, it can be either `:id, :name, :etc,`).
  ///
  /// Paramater values are identified using [BRoute.parameterId] value.
  ///
  /// [arguments] can be retrieved when at the page's build time.
  ///
  /// If a route with the same name already exists, it will be removed and this route
  /// will be added to the stack.
  void push({required String name, Map<String, dynamic>? arguments}) {
    _logger.d("Pushing new route for name: $name and arguments: $arguments");
    final nameSegments = name.split("/");
    BRoute? route = BRoute.fromName(nameSegments.first.replaceAll("/", ""), _allRoutes);
    if (route != null && nameSegments.length == 2) {
      _logger.d("Searching for sub-route: ${nameSegments.last}");
      route = route.findRoute(name: nameSegments.last);
    }
    if (route == null) {
      _logger.w("Couldn't find any route!");
      emit(const BRouterState.unknown());
      return;
    }
    _logger.d("Old pushed routes list: $_pushedRoutes");
    _pushedRoutes = List.from([
      ..._pushedRoutes.where((element) => element.name != route?.name),
      route.addArguments(arguments),
    ]);
    _logger.d("New pushed routes list: $_pushedRoutes");
    _showFound();
  }

  /// Redirect to the given [location].
  ///
  /// This should be used when you need to redirect to a specific page.
  /// Becareful, as this method will replace the current navigation stack all together.
  void redirect({required String location}) {
    _logger.d("Redirecting to $location");
    setNewRoutePath(BRouterState.fromUri(uri: Uri.parse(location), routes: _allRoutes));
  }

  /// Implement the logic for what happens when the back button was called.
  ///
  /// Return `true` if the app navigated back or `false` if it's the root of the app.
  /// The value of the [result] argument is the value returned by the [Route].
  bool popRoute(dynamic result) {
    _logger.d("Popping route.");
    return state.maybeWhen(
      unknown: goToRoot,
      routesFound: (routes) {
        if (result != null) {
          _logger.w("Result was returned from page: $result");
          emit(BRouterState.poppedResult(name: routes.last.name, popResult: result));
        }
        if (routes.length == 1) {
          _logger.w("Pop route was called at root!");
          return false;
        }
        _pushedRoutes = List.generate(_pushedRoutes.length - 1, (index) => _pushedRoutes[index]);
        if (routes.length > 2) {
          _showFound();
          return true;
        }
        return goToRoot();
      },
      orElse: () => false,
    );
  }

  void _showFound() => emit(BRouterState.routesFound(routes: _pushedRoutes));

  /// Go to the root of the app.
  ///
  /// Recommended to be used whenever you want to go the root of the app.
  bool goToRoot() {
    _logger.d("goToRoot was called.");
    _pushedRoutes = List.from([BRoute.rootRoute(routes)]);
    _showFound();
    return true;
  }

  /// Method called by the overriden [BRouterDelegate.setNewRoutePath] method.
  ///
  /// The incoming routerState is what is parsed by the implemented [BRouterParser.parseRouteInformation].
  /// We need to carefully manage incoming paths because we need to make sure we do not show any private
  /// tot unauthenticated users.
  ///
  /// Because we need to use futures, we cannot return a synchronous value.
  Future<void> setNewRoutePath(BRouterState parsedState) async {
    _logger.d("setNewRoutePath was called for state: $parsedState");
    parsedState.whenOrNull(
      initial: goToRoot,
      routesFound: _setNewRoutes,
      unknown: () => emit(const BRouterState.unknown()),
    );
  }

  void _setNewRoutes(List<BRoute> list) {
    _pushedRoutes = List.from(list);
    _showFound();
  }

  @override
  Future<void> close() {
    _logger.d("Closing BRouterCubit.");
    _logger.close();
    return super.close();
  }
}

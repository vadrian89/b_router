import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logger/logger.dart';

import '../router/b_route.dart';

part 'b_router_state.dart';
part 'b_router_cubit.freezed.dart';

/// Bloc used to manage the router.
class BRouterCubit extends Cubit<BRouterState> {
  final Logger _logger;
  final List<BRoute> _allRoutes;
  List<BRoute> _pushedRoutes = const [];

  /// Get a list of the all routes for this router.
  List<BRoute> get allRoutes => List.from(_allRoutes);

  /// Get a list of currently pushed routes for this router.
  List<BRoute> get pushedRoutes => List.from(_pushedRoutes);

  /// Get the top-most pushed route from [pushedRoutes].
  BRoute get topRoute => pushedRoutes.last;

  BRouterCubit({required List<BRoute> routes})
      : _logger = Logger(),
        _allRoutes = List.from(routes),
        super(const BRouterState.initial());

  /// Push a new page to the navigation stack.
  ///
  /// [name] must be a valid route name.
  /// [name] must be either simple, such as `login` or with parameter, such as `products/:id`
  /// (id is just a placeholder it can be anything, it can be either `:id, :name, :etc,`).
  ///
  /// Paramater values are identified using [BRoute.parameterStart] value.
  ///
  /// [arguments] can be retrieved when at the page's build time.
  ///
  /// If a route with the same name already exists, it will be removed and this route
  /// will be added to the stack.
  void push({
    required String name,
    Map<String, dynamic>? arguments,
    Map<String, String>? params,
  }) {
    _logger.d("Pushing new route");
    _logger.d("New route name: $name");
    _logger.d("New route arguments: $arguments");
    _logger.d("New route params: $params");
    final nameSegments = name.split("/");
    if (nameSegments.length > 2) {
      _logger.e("$name contains more than 2 segments: $nameSegments");
      emit(const BRouterState.unknown());
      return;
    }

    final sanitizedArguments = Map<String, dynamic>.from(arguments ?? const {});
    final route = BRoute.fromPath(name, _allRoutes)?.addParameters(
      arguments: sanitizedArguments..removeWhere((_, value) => value == null),
      params: params,
    );

    if (route == null) {
      _logger.e("Couldn't find any route!");
      emit(const BRouterState.unknown());
      return;
    }

    List<BRoute> tmpList = List.from(_pushedRoutes);

    /// If the top route is the same as the new route we replace it.
    /// We also make sure we don't try to replace the root route.
    if (tmpList.length >= 2 && tmpList.last.path == name) {
      tmpList = tmpList.getRange(0, tmpList.length - 2).toList();
    }
    tmpList = List.from([...tmpList, route]);

    _logger.d("Old pushed routes list: $_pushedRoutes");
    _pushedRoutes = List.from(tmpList);
    _logger.d("New pushed routes list: $_pushedRoutes");
    _showFound();
  }

  /// Redirect to the given [location].
  ///
  /// This should be used when you need to redirect to a specific page.
  /// Becareful, as this method will replace the current navigation stack all together.
  void redirect({required String location, Map<String, String>? params}) {
    _logger.d("Redirecting to $location with params: $params");
    setNewRoutePath(
      BRouterState.fromUri(
        uri: Uri.parse(location).replace(queryParameters: params),
        routes: _allRoutes,
      ),
    );
  }

  /// Remove the [Page] from the navigation stack.
  ///
  /// This method will remove the page with the given [name] from the navigation stack.
  /// If a custom page builder is used, be sure to set the name of the page same as the
  /// route's name. Otherwise, the page will not be removed when a pop is event happens.
  ///
  /// If the route is not found, nothing will happen. This is due to the fact, that changing the
  /// current list of routes will trigger this method again, which will result an empty routes list.
  void remove(Page<Object?> page) {
    if (state case UnknownRoute()) return;
    _pushedRoutes = _pushedRoutes.where((element) => page.name != element.name).toList();
    _showFound();
  }

  /// Implement the logic for what happens when the top route was popped.
  ///
  /// If the current state is [BRouterState.unknown], it will call [goToRoot]. This is to prevent
  /// any issues that might arise from popping a route when the state is unknown.
  void pop({required BRoute route, Object? result}) {
    _logger.d("Popping route.");
    if (state case UnknownRoute()) return goToRoot();
    _pushedRoutes = _pushedRoutes.where((element) => element != route).toList();
    if (result != null) {
      _logger.d("Popping route with result: $result");
      emit(BRouterState.poppedResult(route: route, uri: state.uri, popResult: result));
    }
    _showFound();
  }

  /// Go to the root of the app.
  ///
  /// Recommended to be used whenever you want to go the root of the app.
  void goToRoot() {
    _logger.d("goToRoot was called.");
    _pushedRoutes = List.from([BRoute.rootRoute(allRoutes)]);
    _showFound();
  }

  /// Method called by the overriden [BRouterDelegate.setNewRoutePath] method.
  ///
  /// The incoming routerState is what is parsed by the implemented [BRouterParser.parseRouteInformation].
  /// We need to carefully manage incoming paths because we need to make sure we do not show any private
  /// tot unauthenticated users.
  ///
  /// Because we need to use futures, we cannot return a synchronous value.
  void setNewRoutePath(BRouterState parsedState) {
    _logger.d("setNewRoutePath was called for state: $parsedState");
    return switch (parsedState) {
      InitialRoute() => goToRoot(),
      FoundRoutes(:final routes) => _setNewRoutes(routes),
      UnknownRoute() => emit(const BRouterState.unknown()),
      _ => null,
    };
  }

  void _showFound() => emit(BRouterState.routesFound(routes: _pushedRoutes));

  void _setNewRoutes(List<BRoute> list) {
    _pushedRoutes = List.from(list);
    _showFound();
  }

  @override
  Future<void> close() {
    _logger.close();
    return super.close();
  }
}

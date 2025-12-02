import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../../bloc.dart';
import 'route.dart';

/// A [RouteInformationProvider] implemented for this package.
///
/// The implementation is based of the default [PlatformRouteInformationProvider].
class BRouteInformationProvider extends RouteInformationProvider
    with WidgetsBindingObserver, ChangeNotifier {
  static final RouteInformation _emptyRouteInformation = RouteInformation(uri: Uri.tryParse(""));

  /// List of all available routes.
  ///
  /// Used to properly build the state of the [RouteInformation].
  final List<BRoute> routes;
  RouteInformation _value;
  @override
  RouteInformation get value => _value;
  RouteInformation _valueInEngine = _emptyRouteInformation;

  static WidgetsBinding get _binding => WidgetsBinding.instance;

  /// Create a platform route information provider.
  ///
  /// Use the [initialPath] to set the default route information for this
  /// provider.
  BRouteInformationProvider({
    String? initialPath,
    required this.routes,
  }) : _value = RouteInformation(
          uri: Uri.parse(initialPath ?? "/"),
          state: const BRouterState.initial(),
        ) {
    if (kFlutterMemoryAllocationsEnabled) {
      ChangeNotifier.maybeDispatchObjectCreation(this);
    }
  }

  @override
  void routerReportsNewRouteInformation(
    RouteInformation routeInformation, {
    RouteInformationReportingType type = RouteInformationReportingType.none,
  }) {
    SystemNavigator.selectMultiEntryHistory();
    SystemNavigator.routeInformationUpdated(
      uri: routeInformation.uri,
      state: routeInformation.state,
      replace: switch (type) {
        RouteInformationReportingType.neglect => true,
        RouteInformationReportingType.navigate => false,
        RouteInformationReportingType.none =>
          !_uriEquals(_valueInEngine.uri, routeInformation.uri) ||
              (_valueInEngine == _emptyRouteInformation),
      },
    );
    _value = routeInformation;
    _valueInEngine = routeInformation;
  }

  @override
  void addListener(VoidCallback listener) {
    if (!hasListeners) _binding.addObserver(this);
    super.addListener(listener);
  }

  @override
  void removeListener(VoidCallback listener) {
    super.removeListener(listener);
    if (!hasListeners) _removeBindingObserver();
  }

  @override
  void dispose() {
    // In practice, this will rarely be called. We assume that the listeners
    // will be added and removed in a coherent fashion such that when the object
    // is no longer being used, there's no listener, and so it will get garbage
    // collected.
    if (hasListeners) _removeBindingObserver();
    super.dispose();
  }

  @override
  Future<bool> didPushRouteInformation(RouteInformation routeInformation) async {
    assert(hasListeners);
    _platformReportsNewRouteInformation(routeInformation);
    return true;
  }

  void _platformReportsNewRouteInformation(RouteInformation routeInformation) {
    if (_value == routeInformation) {
      return;
    }
    _value = routeInformation;
    _valueInEngine = routeInformation;
    notifyListeners();
  }

  bool _uriEquals(Uri a, Uri b) {
    const deepCollectionEquality = DeepCollectionEquality();
    return deepCollectionEquality.equals(a.path, b.path) &&
        deepCollectionEquality.equals(a.fragment, b.fragment) &&
        const DeepCollectionEquality.unordered().equals(a.queryParametersAll, b.queryParametersAll);
  }

  bool _removeBindingObserver() => _binding.removeObserver(this);
}

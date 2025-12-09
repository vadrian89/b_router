## 0.0.7
* Added RouteEvent and BRouteStateProvider to the exported classes

## 0.0.6
* Added BRouteInformationProvider, which is not currently used.
* Added BRouterStateNotifier which notifies listeners when the current BRouterState changes
* Added BRouteStateProvider which passes the current BRouterState down the widget tree, using InheritedWidget system
* Added RouteEvent, PushRouteEvent and RedirectRouteEvent which are Notifications used to notify the router to push/redirect routes
* Added BRouter which builds RouterConfig for passing it to Router widgets, listens to PushRouteEvent and RedirectRouteEvent to handle pushing/redirecting routes and listens for pop events from routes
* Removed BRouterDelegate.stayOpened callback
* Removed BRouterDelegate.errorBuilder callback
* Removed BRouterDelegate.redirect callback
* Replaced bloc with BRouterStateNotifier, in BRouterDelegate
* Updated BRouterDelegate to listen for state changes and pass the it to the widget tree using BRouteStateProvider
* Updated BRouterListener to listen for changes using BRouteStateProvider
* Removed dependencies on bloc and flutter_bloc

## 0.0.5
* Updated for Flutter 3.32.8
* Added RouteLogger and updated BRouterCubit to use it
* Removed BRouterDelegate.stayOpened
* Updated vscode config
* Migrated from freezed
* Updated Android settings
* Updated bloc/fluter_bloc to 9.1.x

## 0.0.1
* Initial Release

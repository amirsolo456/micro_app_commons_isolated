import 'package:micro_app_core/services/routing/route_events.dart';

/// * Micro App Events
/// Register the micro app events here
/// so we provide them in [RouteEvents] to be fired from accross the micro apps.
/// The [initRouteListeners] method above will listen to the events listened here.
///

// class PageNotFoundEvents extends RouteEvent {
//   RouteEvent pageNotFoundEvent = PageNotFoundEvents( );
//   PageNotFoundEvents(this.pageNotFoundEvent);
// }
class PageNotFoundEvent extends RouteEvent {
  final String routeName;
  PageNotFoundEvent(this.routeName);
}

class ShortKeyNotFoundEvent extends RouteEvent {
  final String shortKey;
  ShortKeyNotFoundEvent(this.shortKey);
}

///
/// Exports the events in a class so we dont need to import
/// them from other micro apps. SignInEvents will be used by [RouteEvents]
///
class NotFoundEvents extends RouteEvent {
  RouteEvent pageNotFoundEvent(String routeName) =>
      PageNotFoundEvent(routeName);
  RouteEvent shortKeyNotFoundEvent(String shortKey) =>
      ShortKeyNotFoundEvent(shortKey);
}

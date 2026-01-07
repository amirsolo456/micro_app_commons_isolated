import 'package:micro_app_core/services/routing/route_events.dart';

import '../../../domain/entities/enum.dart';

/// * Micro App Events
/// Register the micro app events here
/// so we provide them in [RouteEvents] to be fired from accross the micro apps.
/// The [initRouteListeners] method above will listen to the events listened here.
///

// class PageNotFoundEvents extends RouteEvent {
//   RouteEvent pageNotFoundEvent = PageNotFoundEvents( );
//   PageNotFoundEvents(this.pageNotFoundEvent);
// }
class ShowPopupEvent extends RouteEvent {
  final String? message;
  final PopupType type;
  ShowPopupEvent({this.message, required this.type});
}

///
/// Exports the events in a class so we dont need to import
/// them from other micro apps. SignInEvents will be used by [RouteEvents]
///
class PopupEvents extends RouteEvent {
  RouteEvent showPopupEvent({String? message, required PopupType type}) =>
      ShowPopupEvent(message: message, type: type);
}

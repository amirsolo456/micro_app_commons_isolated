import 'package:micro_app_core/services/routing/route_events.dart';
import 'package:models_package/Base/login_module.dart';

/// * Micro App Events
/// Register the micro app events here
/// so we provide them in [RouteEvents] to be fired from accross the micro apps.
/// The [initRouteListeners] method above will listen to the events listened here.
///

// class PageNotFoundEvents extends RouteEvent {
//   RouteEvent pageNotFoundEvent = PageNotFoundEvents( );
//   PageNotFoundEvents(this.pageNotFoundEvent);
// }
class GotoLoginEvent extends RouteEvent {}

class GotoErpAppEvent extends RouteEvent {
  final LoginModuleResult result;

  GotoErpAppEvent(this.result);
}

class GotoSalesEvent extends RouteEvent {}

class GotoVisitorsEvent extends RouteEvent {}

class GotoStorageEvent extends RouteEvent {}

///
/// Exports the events in a class so we dont need to import
/// them from other micro apps. SignInEvents will be used by [RouteEvents]
///
class LauncherCustomEvents extends RouteEvent {
  RouteEvent gotoLoginEvent() => GotoLoginEvent();

  RouteEvent gotoVisitorsEvent() => GotoVisitorsEvent();

  RouteEvent gotoStorageEvent() => GotoStorageEvent();

  RouteEvent gotoErpAppEvent(LoginModuleResult result) =>
      GotoErpAppEvent(result);
}

import 'package:flutter/cupertino.dart';
import 'package:micro_app_core/services/custom_event_bus/custom_event_bus.dart';
import 'package:micro_app_core/services/routing/routing_transitions.dart';
import 'package:micro_app_core/src/micro_app.dart' as microApp;
import 'package:micro_app_core/src/micro_core_utils.dart';

import '../../not_found_page.dart';
import 'not_found_events.dart';
import 'not_found_inject.dart';

class NotFoundResolver implements microApp.MicroApp {
  @override
  String get microAppName => "/notFound";

  @override
  Map<String, WidgetBuilderArgs> get routes => <String, WidgetBuilderArgs>{
    microAppName: (BuildContext context, Object? args) => const NotFoundPage(),
  };

  @override
  void initEventListeners() {
    CustomEventBus.on<PageNotFoundEvent>((event) {
      // we can use events to navigate as well.
      // Routing.pushNamed<UserLoggedOutEvent>(Routes.SignIn);
      print('LOGGED OUT');
    });
    CustomEventBus.on<ShortKeyNotFoundEvent>((event) {
      // we can use events to navigate as well.
      // Routing.pushNamed<UserLoggedOutEvent>(Routes.SignIn);
      print('LOGGED OUT');
    });
  }

  @override
  void injectionsRegister() => Inject.initialize();

  @override
  NotFoundEvents microAppEvents() => NotFoundEvents();

  @override
  Widget? microAppWidget() => null;

  @override
  TransitionType? get transitionType => TransitionType.fade;
}

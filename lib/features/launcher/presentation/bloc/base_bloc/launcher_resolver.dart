import 'package:flutter/cupertino.dart';
import 'package:micro_app_commons/features/launcher/presentation/bloc/base_bloc/launcher_events.dart';
import 'package:micro_app_commons/features/launcher/presentation/launcher_page.dart';
import 'package:micro_app_core/services/custom_event_bus/custom_event_bus.dart';
import 'package:micro_app_core/services/routing/routing_transitions.dart';
import 'package:micro_app_core/src/micro_app.dart' as microApp;
import 'package:micro_app_core/src/micro_core_utils.dart';

import 'launcher_inject.dart';

class LauncherResolver implements microApp.MicroApp {
  @override
  String get microAppName => "/notFound";

  @override
  Map<String, WidgetBuilderArgs> get routes => <String, WidgetBuilderArgs>{
    microAppName: (BuildContext context, Object? args) => LauncherPage(),
  };

  @override
  void initEventListeners() {
    CustomEventBus.on<GotoErpAppEvent>((event) {
      // we can use events to navigate as well.
      // Routing.pushNamed<UserLoggedOutEvent>(Routes.SignIn);
      print('LOGGED OUT');
    });
    CustomEventBus.on<GotoLoginEvent>((event) {
      // we can use events to navigate as well.
      // Routing.pushNamed<UserLoggedOutEvent>(Routes.SignIn);
      print('LOGGED OUT');
    });
    CustomEventBus.on<GotoStorageEvent>((event) {
      // we can use events to navigate as well.
      // Routing.pushNamed<UserLoggedOutEvent>(Routes.SignIn);
      print('LOGGED OUT');
    });
    CustomEventBus.on<GotoSalesEvent>((event) {
      // we can use events to navigate as well.
      // Routing.pushNamed<UserLoggedOutEvent>(Routes.SignIn);
      print('LOGGED OUT');
    });
  }

  @override
  void injectionsRegister() => Inject.initialize();

  @override
  LauncherCustomEvents microAppEvents() => LauncherCustomEvents();

  @override
  Widget? microAppWidget() => null;

  @override
  TransitionType? get transitionType => TransitionType.fade;
}

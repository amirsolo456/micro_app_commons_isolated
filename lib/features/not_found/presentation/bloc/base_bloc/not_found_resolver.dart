import 'package:flutter/cupertino.dart';
import 'package:micro_app_core/index.dart';


import '../../not_found_page.dart';
import 'not_found_events.dart';
import 'not_found_inject.dart';

class NotFoundResolver extends  MicroApp {
  NotFoundResolver() : super(NotFoundCoreModel());
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

  // @override
  // CoreDto<Object> initDatas = {};

  @override
  void callCustom(Object e) {
    // TODO: implement callCustom
  }
}

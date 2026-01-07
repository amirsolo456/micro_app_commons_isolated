import 'package:flutter/cupertino.dart';
import 'package:micro_app_commons/features/popup/presentation/bloc/base_bloc/popup_events.dart';
import 'package:micro_app_commons/features/popup/presentation/bloc/base_bloc/popup_inject.dart';
import 'package:micro_app_commons/features/popup/presentation/popup_page.dart';
import 'package:micro_app_core/services/custom_event_bus/custom_event_bus.dart';
import 'package:micro_app_core/services/routing/routing_transitions.dart';
import 'package:micro_app_core/src/micro_app.dart' as microApp;
import 'package:micro_app_core/src/micro_core_utils.dart';
import 'package:resources_package/l10n/app_localizations.dart';

class PopupResolver implements microApp.MicroApp {
  @override
  String get microAppName => "/popup";

  @override
  Map<String, WidgetBuilderArgs> get routes => {};

  @override
  void initEventListeners() {
    CustomEventBus.on<ShowPopupEvent>(_showPopup);
  }

  void _showPopup(ShowPopupEvent event) {
    final context = navigatorKey.currentContext;
    if (context == null) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      showCupertinoDialog(
        context: context,
        barrierDismissible: true,
        builder: (_) => PopupPage(
          title:
              event.message ?? AppLocalizations.of(context)?.usersTitle ?? '',
          type: event.type,
          description: '',
        ),
      );
    });
  }

  @override
  void injectionsRegister() => Inject.initialize();

  @override
  PopupEvents microAppEvents() => PopupEvents();

  @override
  Widget? microAppWidget() => null;

  @override
  TransitionType? get transitionType => TransitionType.fade;
}

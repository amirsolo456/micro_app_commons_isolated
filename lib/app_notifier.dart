// ==================== GLOBAL NOTIFIER ====================
import 'dart:core';

import 'package:erp_app/micro_app/erp_events.dart';
import 'package:flutter/material.dart';
import 'package:login_module/micro_app/login_module_events.dart';
import 'package:micro_app_core/services/custom_event_bus/custom_event_bus.dart';
import 'package:micro_app_core/services/routing/route_events.dart';
import 'package:micro_app_core/services/routing/routes.dart';
import 'package:models_package/Base/login_module.dart';
import 'package:resources_package/Resources/Theme/theme_manager.dart';

class AppNotifier extends ChangeNotifier {
  // AppNotifier() {
  //   _loadDefaultMenu();
  // }

  // ==================== STATE ====================
  final Map<String, Widget> _generatedPages = <String, Widget>{};

  final bool _isMenuLoading = false;
  String? _errorMessage;
  ThemeManager _themeConfig = ThemeManager();
  String? _selectedItemId;
  bool _sidebarCollapsed = false;
  bool _isDrawerOpen = false;
  bool _isLogin = true;
  final LoginModuleResult _currentLoginModuleResult = LoginModuleResult.failure('');
  bool _isLoading = false;
  final bool _isPopop = false;
  String? _userName;
  String? _userEmail;
  String? _userRole;
  int _netMode = 0;
  Locale _currentLocale = Locale('fa');
  String? _deviceToken;
  final Map<String, bool> _expandedStates = <String, bool>{};
  String? _currentRoute;

  /// Current emitted event (intention). Micro-apps should register builders
  /// with [MicroAppWidgetRegistry] so the UI can resolve a widget for this
  /// event and show it inside the detail pane (IndexedStack in ContentWrapper).
  RouteEvent? _currentEvent;

  RouteEvent? get currentEvent => _currentEvent;

  // ==================== MENU HELPERS ====================
  void emit(RouteEvent event) {
    _currentEvent = event;
    CustomEventBus.emit(event);
    notifyListeners();
  }

  // void _assignPageToMenuItem(MenuItemModel item) {
  //   if (item.routeName != null) item.page = getPageByRout(item.routeName!);
  //
  //   if (item.children != null) {
  //     for (final MenuItemModel child in item.children!) {
  //       _assignPageToMenuItem(child);
  //     }
  //   }
  // }

  Routes getRoutesByNme(String name) {
    switch (name.toLowerCase()) {
      case 'purchase':
        return Routes.erpApp;
      case 'profile':
        return Routes.loginApp;
      default:
        return Routes.erpApp;
    }
  }

  // ==================== NAVIGATION ====================

  void toggleExpanded(String itemId) {
    _expandedStates[itemId] = !isExpanded(itemId);
    notifyListeners();
  }

  void selectItem(String itemId, {bool closeDrawer = true}) {}

  void navigateTo(String routeName) {
    _currentRoute = routeName;
    final RouteEvent? ev = _mapRouteToEvent(routeName);
    if (ev != null) {
      emit(ev);
      CustomEventBus.emit(ev);
    }
    notifyListeners();
  }

  void clearPageCache() {
    _generatedPages.clear();
    notifyListeners();
  }

  void goBack() {
    // Logic for going back in navigation history
    notifyListeners();
  }

  // Widget? getCurrentPage(BuildContext context) {
  //   if (_selectedItemId == null) return const HomePage();
  //
  //   final MenuItemModel? item = findItemById(_selectedItemId!);
  //   if (item == null) return const HomePage();
  //
  //   // اگر صفحه از قبل ساخته شده، برگردون
  //   if (_generatedPages.containsKey(_selectedItemId!)) {
  //     return _generatedPages[_selectedItemId!];
  //   }
  //
  //   // اولویت با page مستقیم
  //   if (item.page != null) {
  //     _generatedPages[_selectedItemId!] = item.page!;
  //     return item.page;
  //   }
  //
  //   // اگر routeName داره
  //   if (item.routeName != null && item.routeName!.isNotEmpty) {
  //     final Widget page = getPageByRout(item.routeName!);
  //     _generatedPages[_selectedItemId!] = page;
  //     return page;
  //   }
  //   // اولویت با pageBuilder است
  //   if (item.page != null) {
  //     return item.page;
  //   }
  //
  //   // سپس با page مستقیم
  //   if (item.page != null) {
  //     return item.page!;
  //   }
  //
  //   final Widget defaultPage = getPageByRout('home');
  //   _generatedPages[_selectedItemId!] = defaultPage;
  //   return defaultPage;
  // }

  RouteEvent? _mapRouteToEvent(String routeName) {
    switch (routeName) {
      case '/login':
      // return LoginModuleShownEvent(
      //   _netMode,
      //   _currentLocale,
      //   _deviceToken ?? '',
      // );
      case '/erpApp':
        return ErpShownEvent();

      default:
        return null;
    }
  }

  bool checkIsLogin() {
    // if (_selectedItemId == null ||
    //     selectedItem == null ||
    //     !selectedItem!.routeName!.contains('signIn')) {
    //   return false;
    // }
    return true;
  }

  // FutureOr<void> loadMenu() async {
  //   if (_isMenuLoading) return;
  //
  //   _errorMessage = null;
  //   notifyListeners();
  //
  //   try {
  //     // دریافت منو از سرور
  //     // توجه: باید MenuRepository را در injection_container ثبت کنید
  //     final MenuRemoteDatasource menuRepo = sl.get<MenuRemoteDatasource>();
  //     final List<MenuItem> serverItems = await menuRepo.getMenuItems();
  //     final List<MenuItemModel> convertedItems = serverItems
  //         .map((MenuItem item) => MenuItemModel.fromMenuItem(item))
  //         .toList();
  //     for (final MenuItemModel item in convertedItems) {
  //       _assignPageToMenuItem(item);
  //     }
  //     _menuItemModels = convertedItems;
  //     clearPageCache(); // کش صفحات رو پاک کن
  //   } catch (e) {
  //     _errorMessage = 'خطا در دریافت منو: $e';
  //     // می‌توانید منوی پیش‌فرض را بارگیری کنید
  //     _loadDefaultMenu();
  //   } finally {
  //     _isMenuLoading = false;
  //     notifyListeners();
  //   }
  // }

  Future<void> showMyDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('AlertDialog Title'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('This is a demo alert dialog.'),
                Text('Would you like to approve of this message?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Approve'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void setNetworkMod(int mode) {
    _netMode = mode;
    notifyListeners();
  }

  void toggleSidebar() {
    _sidebarCollapsed = !_sidebarCollapsed;
    notifyListeners();
  }

  void sidebarManually(bool state) {
    if (_sidebarCollapsed != state) {
      _sidebarCollapsed = state;
      notifyListeners();
    }
  }

  void setSidebarCollapsed(bool collapsed) {
    _sidebarCollapsed = collapsed;
    notifyListeners();
  }

  void changeToLogin() {
    _isLogin = true;
    notifyListeners();
    _selectedItemId = 'purchases';
    emit(LoginModuleUserLoggedOutEvent());
  }

  void changeToLogout() {
    _isLogin = false;
    notifyListeners();
    _selectedItemId = 'purchases';
    emit(LoginModuleUserLoggedOutEvent());
  }

  // ==================== USER METHODS ====================
  void updateUserInfo({String? name, String? email, String? role}) {
    _userName = name ?? _userName;
    _userEmail = email ?? _userEmail;
    _userRole = role ?? _userRole;
    notifyListeners();
  }

  void logout() {
    _userName = null;
    _userEmail = null;
    _userRole = null;
    _selectedItemId = null;
    _currentRoute = '/home';
    _expandedStates.clear();
    notifyListeners();
  }

  void resetAll() {
    _expandedStates.clear();
    _selectedItemId = null;
    _currentRoute = '/home';
    _themeConfig = ThemeManager();
    _isDrawerOpen = false;
    _isLoading = false;
    _errorMessage = null;
    _userName = null;
    _userEmail = null;
    _userRole = null;
    notifyListeners();
  }

  // ==================== GETTERS ====================
  bool get menuIsLoaded => !_isMenuLoading;

  String? get errorMessage => _errorMessage;

  ThemeManager get themeConfig => _themeConfig;

  bool get isSidebarCollapsed => _sidebarCollapsed;

  bool get isDrawerOpen => _isDrawerOpen;

  String? get selectedItemId => _selectedItemId;

  bool get isLogin => _isLogin;

  bool get isLoading => _isLoading;

  bool get isPopop => _isPopop;

  bool get isMenuLoading => _isMenuLoading;

  String? get userName => _userName;

  String? get userEmail => _userEmail;

  String? get userRole => _userRole;

  String? get currentRoute => _currentRoute;

  // Helper methods

  bool isExpanded(String itemId) => _expandedStates[itemId] ?? false;

  bool isSelected(String itemId) => _selectedItemId == itemId;

  // ==================== THEME METHODS ====================
  void toggleTheme() {
    _themeConfig = _themeConfig.copyWith(
      localMode: _currentLocale,
      primaryColor: _themeConfig.primaryColor,
    );
    notifyListeners();
  }

  void setCurrentLocal(Locale locale) {
    _currentLocale = locale;
    notifyListeners();
  }

  void setDeviceToken(String token) {
    _deviceToken = token;
    notifyListeners();
  }

  void setThemeMode(ThemeMode mode) async {
    await ThemeManager.setTheme(mode, persist: true);
    _themeConfig = ThemeManager();
    notifyListeners();
  }

  void updatePrimaryColor(Color color) {
    _themeConfig = _themeConfig.copyWith(primaryColor: color);
    notifyListeners();
  }

  void updateSecondaryColor(Color color) {
    _themeConfig = _themeConfig.copyWith(secondaryColor: color);
    notifyListeners();
  }

  // ==================== UI STATE METHODS ====================
  void toggleDrawer() {
    _isDrawerOpen = !_isDrawerOpen;
    notifyListeners();
  }

  void setDrawerOpen(bool isOpen) {
    _isDrawerOpen = isOpen;
    notifyListeners();
  }

  void setLoading(bool loading) {
    _isLoading = loading;
    if (!loading) {
      _errorMessage = null;
    }
    notifyListeners();
  }

  void showPopop(String? message) {
    _errorMessage = message;
    notifyListeners();
  }

  void setError(String? message) {
    _errorMessage = message;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}

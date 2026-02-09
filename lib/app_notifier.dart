// ==================== GLOBAL NOTIFIER ====================
import 'dart:async';
import 'dart:core';

import 'package:erp_app/index.dart';

import 'package:flutter/material.dart';
import 'package:login_module/micro_app/login_module_events.dart';
import 'package:micro_app_core/index.dart';
import 'package:micro_app_core/services/routing/route_events.dart';
import 'package:models_package/index.dart';
import 'package:resources_package/Resources/Theme/theme_manager.dart';
import 'package:skeletonizer/skeletonizer.dart';

// ==================== کلاس پایه AppNotifier ====================
class AppNotifier extends ChangeNotifier {
  // ==================== STATE ====================
  final Map<int, Widget> _pageCache = {};
  final Map<int, bool> _showSkeleton = {};
  final Map<int, Timer> _skeletonTimers = {};
  late final PageCacheManager _cacheManager = PageCacheManager(
    maxAge: const Duration(minutes: 5),
  );

  bool _isProcessingSignOut = false;
  final Map<String, Widget> _generatedPages = <String, Widget>{};
  NavButtonTabBarMode _selectedTab = NavButtonTabBarMode.erpDashboardTabMode;
  final bool _isMenuLoading = false;

  String? _errorMessage;
  AppTheme _themeConfig = AppTheme.light();
  String? _selectedItemId;

  // ignore: prefer_final_fields
  bool _sidebarCollapsed = false;
  bool _isDrawerOpen = false;
  bool _isLogin = true;

  Map<int, Widget> get pageCache => Map.from(_pageCache);

  bool _isLoading = false;

  // ignore: unused_field
  final int _netMode = 0;
  final bool _isPopup = false;
  static final Map<String, bool> _defValue = {'first': false};
  final Map<String, bool> _isListRoute = _defValue;

  String get getListRoute => _isListRoute.keys.last ?? '';
  final Map<String, bool> _isFormRoute = _defValue;

  String get getFormRoute => _isFormRoute.keys.last ?? '';

  // ignore: unused_field
  final List<String> _errors = [];
  String? _userName;
  String? _userEmail;
  String? _userRole;

  // ignore: unused_field
  String? _deviceToken;
  Locale _currentLocale = Locale('fa');
  final Map<String, bool> _expandedStates = <String, bool>{};
  String? _currentRoute;
  final List<Completer<void>> _pendingOperations = [];

  // ==================== CORE METHODS ====================
  void pageCacheProvider({NavButtonTabBarMode? initialTab}) {
    _selectedTab = initialTab ?? NavButtonTabBarMode.erpDashboardTabMode;
  }

  RouteEvent? _currentEvent;

  RouteEvent? get currentEvent => _currentEvent;

  void emit(RouteEvent event) {
    _currentEvent = event;
    CustomEventBus.emit(event);
    notifyListeners();
  }

  // ==================== PAGE MANAGEMENT ====================
  // @protected
  Widget createRawPage(NavButtonTabBarMode tab) {
    return sl<ErpResolver>().initDatas.getPage(tab) ?? _defaultPage(tab);
  }

  Widget _defaultPage(NavButtonTabBarMode tab) {
    return Center(child: Text('صفحه ${tab.value}'));
  }

  void changePage(
    PageType pageType, {
    String? route,
    NavButtonTabBarMode? tab,
  }) {
    // _pageType = pageType; // اگر فیلد _pageType را دارید
    if (pageType == PageType.tabBar) {
      if (tab != null) {
        _selectedTab = tab;
      }
    } else if (route != null &&
        route != '' &&
        pageType == PageType.listGenerator) {
      _selectedTab = NavButtonTabBarMode.erpGenericListTabMode;
      _isListRoute[route] = true;
    } else if (route != null &&
        route != '' &&
        pageType == PageType.formGenerator) {
      _selectedTab = NavButtonTabBarMode.erpGenericFormTabMode;
      _isFormRoute[route] = true;
    } else {}
    notifyListeners();
  }

  Future<void> signOut(BuildContext context, {bool force = false}) async {
    if (_isProcessingSignOut) return;

    _isProcessingSignOut = true;

    notifyListeners();
  }

  Widget getPage(NavButtonTabBarMode tab, {bool forceRefresh = false}) {
    if (_isProcessingSignOut) {
      return _buildSignOutScreen();
    }

    // Dashboard tab - special logic
    if (tab == NavButtonTabBarMode.erpDashboardTabMode) {
      return const Text('Dashboard');
    }

    // Check cache
    if (!forceRefresh &&
        (tab == NavButtonTabBarMode.skeletion ||
            _pageCache.containsKey(tab.value))) {
      final showSkeleton = _showSkeleton[tab.value] ?? false;
      final cachedPage = _pageCache[tab.value];
      if (cachedPage != null) {
        return _wrapWithSkeleton(
          cachedPage,
          tab.value,
          showSkeleton: showSkeleton,
        );
      }
    }

    // Create new page
    final rawPage = _cacheManager.getOrCreate(
      tab.value,
      () => createRawPage(tab),
    );

    // Cache it
    _pageCache[tab.value] = rawPage;

    // Activate skeleton
    _activateSkeleton(tab.value);

    return _wrapWithSkeleton(rawPage, tab.value, showSkeleton: true);
  }

  // ==================== SKELETON & CACHE HELPERS ====================
  void _activateSkeleton(int tabValue) {
    _showSkeleton[tabValue] = true;
    _skeletonTimers[tabValue]?.cancel();

    final timer = Timer(const Duration(milliseconds: 400), () {
      if (!_isProcessingSignOut) {
        _showSkeleton[tabValue] = false;
        notifyListeners();
      }
    });

    _skeletonTimers[tabValue] = timer;
  }

  Widget _wrapWithSkeleton(
    Widget page,
    int tabValue, {
    required bool showSkeleton,
  }) {
    return Skeletonizer(
      containersColor: Colors.white,
      enabled: showSkeleton && !_isProcessingSignOut,
      child: page,
    );
  }

  Widget _buildSignOutScreen() {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            const Text(
              'در حال خروج از برنامه...',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              'لغو ${_pendingOperations.length} عملیات در حال اجرا',
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  void clearPageCache() {
    _pageCache.clear();
    _generatedPages.clear();
    notifyListeners();
  }

  // ==================== NAVIGATION ====================
  void navigateTo(String routeName) {
    _currentRoute = routeName;
    final RouteEvent? ev = _mapRouteToEvent(routeName);
    if (ev != null) {
      emit(ev);
      CustomEventBus.emit(ev);
    }
    notifyListeners();
  }

  RouteEvent? _mapRouteToEvent(String routeName) {
    switch (routeName) {
      case '/erpApp':
        return ErpShownEvent();
      default:
        return null;
    }
  }

  void toggleExpanded(String itemId) {
    _expandedStates[itemId] = !isExpanded(itemId);
    notifyListeners();
  }

  void selectItem(String itemId, {bool closeDrawer = true}) {}

  // ==================== OPERATION MANAGEMENT ====================
  void registerPendingOperation(Completer<void> completer) {
    if (_isProcessingSignOut) {
      completer.completeError('Operation cancelled due to sign out');
      return;
    }
    _pendingOperations.add(completer);
  }

  void unregisterPendingOperation(Completer<void> completer) {
    _pendingOperations.remove(completer);
  }

  // ==================== USER & AUTH ====================
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

  // ==================== UI STATE ====================
  void resetAll() {
    _expandedStates.clear();
    _selectedItemId = null;
    _currentRoute = '/home';
    _themeConfig = AppTheme.light();
    _isDrawerOpen = false;
    _isLoading = false;
    _errorMessage = null;
    _userName = null;
    _userEmail = null;
    _userRole = null;
    clearPageCache();
    notifyListeners();
  }

  // ==================== GETTERS ====================
  bool get menuIsLoaded => !_isMenuLoading;

  String? get errorMessage => _errorMessage;

  AppTheme get themeConfig => AppTheme.light();

  bool get isSidebarCollapsed => _sidebarCollapsed;

  bool get isDrawerOpen => _isDrawerOpen;

  String? get selectedItemId => _selectedItemId;

  bool get isLogin => _isLogin;

  bool get isLoading => _isLoading;

  bool get isPopup => _isPopup;

  bool get isMenuLoading => _isMenuLoading;

  String? get userName => _userName;

  String? get userEmail => _userEmail;

  String? get userRole => _userRole;

  String? get currentRoute => _currentRoute;

  NavButtonTabBarMode get selectedTab => _selectedTab;

  bool isExpanded(String itemId) => _expandedStates[itemId] ?? false;

  bool isSelected(String itemId) => _selectedItemId == itemId;

  // ==================== THEME & UI ====================
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

  Locale currentLocal() {
    // notifyListeners();
    return _currentLocale;
  }

  void setThemeMode(ThemeMode mode) async {
    await AppTheme.setTheme(mode, persist: true);
    _themeConfig = AppTheme.light();
    notifyListeners();
  }
}

// ==================== میکسین برای CoreDto ====================
mixin MicroMixin<T extends CoreDto<E>, E extends Enum> on AppNotifier {
  T? _dynamicPageBuilderSource;
  Map<NavButtonTabBarMode, T>? _allDynamicPageBuilderSource;

  void registerDynamicSource(T source) {
    _dynamicPageBuilderSource = source;
    notifyListeners();
  }

  void clearDynamicSource() {
    _dynamicPageBuilderSource = null;
    notifyListeners();
  }

  void setAllDynamicPageBuilderSource(Map<NavButtonTabBarMode, T> source) {
    _allDynamicPageBuilderSource = source;
    notifyListeners();
  }

  T? get dynamicSource => _dynamicPageBuilderSource;

  Map<NavButtonTabBarMode, T>? get allDynamicPageBuilderSource =>
      _allDynamicPageBuilderSource;

  @override
  Widget createRawPage(NavButtonTabBarMode tab) {
    if (_allDynamicPageBuilderSource != null) {
      final builder = _allDynamicPageBuilderSource![tab];
      if (builder != null) {
        final content = _getContentFromBuilder(builder, tab);
        if (content != null) return content;
      }
    }

    // 2. Try single dynamic source
    if (_dynamicPageBuilderSource != null) {
      final content = _getContentFromBuilder(_dynamicPageBuilderSource!, tab);
      if (content != null) return content;
    }

    // 3. Fallback to default
    return super.createRawPage(tab);
  }

  Widget? _getContentFromBuilder(T builder, NavButtonTabBarMode tab) {
    return null;
  }
}

// ==================== کلاس تخصصی ====================
class MicroAppNotifier<T extends CoreDto<E>, E extends Enum> extends AppNotifier
    with MicroMixin<T, E> {
  MicroAppNotifier([T? src]) {
    if (src != null) registerDynamicSource(src);
  }
}

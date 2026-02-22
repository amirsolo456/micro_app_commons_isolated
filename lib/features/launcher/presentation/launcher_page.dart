import 'package:flutter/material.dart';
import 'package:micro_app_commons/features/not_found/presentation/bloc/base_bloc/not_found_resolver.dart';
import 'package:micro_app_core/services/custom_event_bus/custom_event_bus.dart';
import 'package:micro_app_core/services/routing/routes.dart';

class LauncherPage extends StatefulWidget {
  const LauncherPage({super.key});

  @override
  State<LauncherPage> createState() => _LauncherPageState();
}

class _LauncherPageState extends State<LauncherPage> {
  int _pageIndex = 0;

  final List<Widget> _banners = [
    BannerCard(
      title: 'تخفیف ۲۰ درصدی!',
      subtitle: 'چون آریان تک در کنار شما یک ساله شد.',
      tag: 'آرین تک',
    ),
    BannerCard(
      title: 'پلن جدید!',
      subtitle: 'پیشنهاد ویژه برای کسب‌وکارها',
      tag: 'آرین تک',
      colorFrom: Color(0xFF1E8BED),
      colorTo: Color(0xFF6EC1FF),
    ),
    BannerCard(
      title: 'خبر مهم',
      subtitle: 'بروزرسانی جدید سیستم منتشر شد.',
      tag: 'اطلاع',
      colorFrom: Color(0xFF0F9D58),
      colorTo: Color(0xFF6EE7B7),
    ),
  ];

  void onLoginTab() {
    CustomEventBus.emit(
      RouteEvents.loginEvents.loginModuleUserLoggedOutEvent(),
    );
  }

  void onErpTab() {
    CustomEventBus.emit(RouteEvents.erpEvents.erpShownEvent);
    // Routing.pushNamed(Routes.erpApp);
  }

  void onSalesTab() {
    CustomEventBus.emit(
      RouteEvents.notFoundEvents.pageNotFoundEvent(
        NotFoundResolver().microAppName,
      ),
    );
    // Routing.pushNamed(Routes.notFoundPage);
  }

  void onStorageTab() {
    CustomEventBus.emit(
      RouteEvents.notFoundEvents.pageNotFoundEvent(
        NotFoundResolver().microAppName,
      ),
    );
  }

  void onVisitorsTab() {
    CustomEventBus.emit(
      RouteEvents.notFoundEvents.pageNotFoundEvent(
        NotFoundResolver().microAppName,
      ),
    );
  }



  void onMozeTab() {
    CustomEventBus.emit(
      RouteEvents.notFoundEvents.pageNotFoundEvent(
        NotFoundResolver().microAppName,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final spacing = 14.0;
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(spacing),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // AppBar سفارشی
              Row(
                children: [
                  // const CircleAvatar(
                  //   radius: 18,
                  //   backgroundColor: Colors.transparent,
                  //   child: Icon(Icons.person_outline, color: Colors.black54),
                  // ),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Text(
                      'محسن احمدی',
                      style: TextStyle(color: Colors.black87, fontSize: 14),
                    ),
                  ),
                  // لوگو
                  Row(
                    children: const [
                      Text(
                        'ArianTech',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(width: 6),
                      Icon(Icons.sync, color: Colors.black54),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 18),

              // Grid آیکون‌ها (3 ستون)
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                ),
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 12,
                ),
                child: GridView.count(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  crossAxisCount: 3,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  children: [
                    _FeatureBox(
                      icon: Icons.local_shipping,
                      label: 'موضع',
                      onTabEvent: onMozeTab,
                    ),
                    _FeatureBox(
                      icon: Icons.warehouse,
                      label: 'انبار',
                      onTabEvent: onStorageTab,
                    ),
                    _FeatureBox(
                      icon: Icons.layers_rounded,
                      label: 'ERP',
                      onTabEvent: onErpTab,
                    ),
                    _FeatureBox(
                      icon: Icons.crop_square_outlined,
                      label: 'خروج',
                      onTabEvent: onLoginTab,
                    ), // empty placeholder
                    _FeatureBox(
                      icon: Icons.shopping_cart,
                      label: 'خرده فروشی',
                      onTabEvent: onSalesTab,
                    ),
                    _FeatureBox(
                      icon: Icons.person_outline,
                      label: 'VISITOR',
                      onTabEvent: onVisitorsTab,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 14),

              // Banner carousel با دات ایندیکیتور
              SizedBox(
                height: 165,
                child: Column(
                  children: [
                    Expanded(
                      child: PageView.builder(
                        itemCount: _banners.length,
                        onPageChanged: (i) => setState(() => _pageIndex = i),
                        itemBuilder: (context, index) => _banners[index],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        _banners.length,
                        (i) => AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          width: _pageIndex == i ? 26 : 8,
                          height: 8,
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          decoration: BoxDecoration(
                            color: _pageIndex == i
                                ? Colors.blueAccent
                                : Colors.grey[300],
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 14),

              // اطلاعیه ها کارت
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // header with "اطلاعیه ها" و دکمه "مشاهده همه"
                    Row(
                      children: [
                        const Expanded(
                          child: Text(
                            'اطلاعیه ها',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey[200],
                            foregroundColor: Colors.black87,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                          ),
                          onPressed: () {},
                          child: const Text('مشاهده همه'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    // notification item
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            children: [
                              ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.grey[200],
                                  foregroundColor: Colors.black87,
                                  elevation: 0,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                ),
                                child: const Text('نمایش'),
                              ),
                              const SizedBox(width: 8),
                              const Expanded(
                                child: Text(
                                  'موجودی انبار شما به‌روزرسانی شد. لطفا توجه داشته باشید که تعداد فعلی کالاها و مواد موجود در انبار ممکن است تغییر کرده باشد. برای مشاهده جزئیات دقیق‌تر...',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.black87,
                                  ),
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              // سه نقطه
                              PopupMenuButton<int>(
                                itemBuilder: (context) => [
                                  const PopupMenuItem(
                                    value: 1,
                                    child: Text('جزئیات'),
                                  ),
                                  const PopupMenuItem(
                                    value: 2,
                                    child: Text('حذف'),
                                  ),
                                ],
                                icon: const Icon(
                                  Icons.more_vert,
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 14),

              // کارت عضویت
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    // const CircleAvatar(
                    //   backgroundColor: Colors.black,
                    //   child: Icon(Icons.arrow_back, color: Colors.white),
                    // ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'عضویت در خبرنامه',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 6),
                          Text(
                            'میتونی هرلحظه و هرجا از اخبار مربوطه باخبر بشی !',
                            style: TextStyle(fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[200],
                        foregroundColor: Colors.black87,
                        elevation: 0,
                      ),
                      child: const Text('عضویت'),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

}

class _FeatureBox extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTabEvent;

  const _FeatureBox({
    required this.icon,
    required this.label,
    required this.onTabEvent,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTabEvent.call(),
      borderRadius: BorderRadius.circular(12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 62,
            height: 62,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.blue.withAlpha(120)),
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.withAlpha(60),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(icon, size: 30, color: Colors.blueGrey),
          ),
          const SizedBox(height: 8),
          if (label.isNotEmpty)
            Text(label, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}

// ویجت بنر
class BannerCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String tag;
  final Color colorFrom;
  final Color colorTo;

  const BannerCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.tag,
    this.colorFrom = const Color(0xFF0B63FF),
    this.colorTo = const Color(0xFF4FC3F7),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [colorFrom, colorTo]),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: colorFrom.withAlpha(200),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          // left: big number (placeholder)
          Expanded(
            flex: 2,
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                '1',
                style: TextStyle(
                  fontSize: 56,
                  fontWeight: FontWeight.bold,
                  color: Colors.white.withAlpha(950),
                  shadows: [
                    Shadow(
                      blurRadius: 6,
                      color: Colors.black26,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          // right: texts
          Expanded(
            // flex: 5,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,

                children: [
                  // tag
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(150),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      tag,
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    subtitle,
                    style: const TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black87,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 8,
                        ),
                      ),
                      child: const Text('مشاهده پلن ها'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

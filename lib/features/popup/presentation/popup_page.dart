import 'package:flutter/material.dart';
import 'package:micro_app_commons/features/popup/domain/entities/enum.dart';

import '../data/repositories/popup_style_repository.dart';

class PopupPage extends StatelessWidget {
  final PopupType type;
  final String title;
  final String description;
  final Widget? action;
  const PopupPage({
    super.key,

    required this.type,
    required this.title,
    required this.description,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    final style = resolveMessageStyle(type);
    final title = switch (type) {
      PopupType.error => 'خطا',
      PopupType.warning => 'هشدار',
      PopupType.success => 'موفق',
      PopupType.info => 'اطلاعیه',
      PopupType.defaultType => 'معلق',
    };
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: style.background,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: style.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(style.icon, color: style.iconColor),
          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: style.titleColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  description,
                  style: const TextStyle(fontSize: 13, color: Colors.black54),
                ),
                if (action != null) ...[const SizedBox(height: 12), action!],
              ],
            ),
          ),

          const SizedBox(width: 8),
          InkWell(onTap: () {}, child: const Icon(Icons.close, size: 18)),
        ],
      ),
    );
    // return CupertinoAlertDialog(
    //   title: Text(title),
    //   content: Text(message),
    //   actions: [
    //     CupertinoDialogAction(
    //       child: const Text('باشه'),
    //       onPressed: () => Navigator.of(context).pop(),
    //     ),
    //   ],
    // );
  }
}

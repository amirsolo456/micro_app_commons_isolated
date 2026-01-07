import 'package:flutter/material.dart';

import '../../domain/entities/enum.dart';
import '../../domain/entities/popup_styles.dart';

PopupStyles resolveMessageStyle(PopupType type) {
  switch (type) {
    case PopupType.success:
      return const PopupStyles(
        background: Color(0xFFEAF7EE),
        border: Color(0xFF2E7D32),
        iconColor: Color(0xFF2E7D32),
        icon: Icons.check_circle_outline,
        titleColor: Color(0xFF2E7D32),
      );

    case PopupType.error:
      return const PopupStyles(
        background: Color(0xFFFDECEA),
        border: Color(0xFFD32F2F),
        iconColor: Color(0xFFD32F2F),
        icon: Icons.error_outline,
        titleColor: Color(0xFFD32F2F),
      );

    case PopupType.warning:
      return const PopupStyles(
        background: Color(0xFFFFF8E1),
        border: Color(0xFFF9A825),
        iconColor: Color(0xFFF9A825),
        icon: Icons.warning_amber_outlined,
        titleColor: Color(0xFFF9A825),
      );

    case PopupType.info:
      return const PopupStyles(
        background: Color(0xFFF1F7FE),
        border: Color(0xFF1976D2),
        iconColor: Color(0xFF1976D2),
        icon: Icons.info_outline,
        titleColor: Color(0xFF1976D2),
      );

    default:
      return const PopupStyles(
        background: Colors.white,
        border: Color(0xFFE0E0E0),
        iconColor: Colors.black54,
        icon: Icons.check,
        titleColor: Colors.black87,
      );
  }
}

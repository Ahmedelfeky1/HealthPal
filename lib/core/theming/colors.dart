import 'package:flutter/material.dart';

class ColorsManager {
  // --- 1. اللون الأساسي (The Hero Color) ---
  static const Color mainBlue = Color(0xFF247CFF);

  // --- 2. ألوان النصوص والعناوين ---
  static const Color darkTeal = Color(0xFF1C2A3A); //

  // ده "Black" أو gray/800 (للنصوص العادية الغامقة)
  static const Color darkBlue = Color(0xFF1F2A37);

  // النصوص الفرعية (gray/700)
  static const Color darkGray = Color(0xFF374151);

  // الوصف والتفاصيل (gray/500)
  static const Color gray = Color(0xFF6B7280);

  // النصوص الخفيفة جداً (gray/400)
  static const Color lightGray = Color(0xFF9CA3AF);

  // --- 3. الخلفيات والحدود ---
  static const Color moreLightGray = Color(0xFFF5F5F5);
  static const Color lighterGray = Color(0xFFE5E7EB);
  static const Color gray50 = Color.fromARGB(90, 229, 231, 235);

  // --- 4. ألوان الحالة (Utility) ---
  static const Color starOrange = Color(0xFFFEB052);
  static const Color errorRed = Color(0xFFEF0000);
  static const Color successGreen = Color(0xFF4D9B91);
  static const Color favoriteRed = Color(0xff880808);

  // --- 5. أبيض وأسود ---
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  
}


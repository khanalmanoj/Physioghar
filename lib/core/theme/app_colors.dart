import 'package:flutter/material.dart';

class PhysioColors {
  // Brand & Accent
  static const Color pine = Color(0xFF2F5D50);         // Primary Brand
  static const Color pineLight = Color(0xFF3F7965);    // Secondary / Gradients
  static const Color pinePale = Color(0xFFD1E8DF);     // Soft Accents / Active Chips
  static const Color mist = Color(0xFFEEF1ED);         // Neutral Backgrounds / Borders
  
  // CTA & Status
  static const Color amber = Color(0xFFE2962F);        // Primary CTA / Highlights
  static const Color amberPale = Color(0xFFFBEFD9);    // Pending / Warning States
  static const Color cream = Color(0xFFFBFBF8);        // Main Page Background
  
  // Text & Content
  static const Color ink = Color(0xFF1E2A2E);          // Primary Headings / Text
  static const Color inkMid = Color(0xFF4A5854);       // Secondary / Body Text
  static const Color inkMute = Color(0xFF8FA8A0);      // Caption / Inactive Text
  
  // Alerts & Destruction
  static const Color danger = Color(0xFFC84B4B);       // Error / Declines / Deletes
  static const Color dangerPale = Color(0xFFFCE8E8);   // Error pill backgrounds
  static const Color white = Colors.white;
}

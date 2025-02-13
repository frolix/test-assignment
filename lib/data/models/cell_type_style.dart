// lib/models/cell_styles.dart
import 'package:flutter/material.dart';

enum CellType { start, end, blocked, path, empty }

class CellStyles {
  static const Map<CellType, Color> colors = {
    CellType.start: Color(0xFF64FFDA),
    CellType.end: Color(0xFF009688),
    CellType.blocked: Color(0xFF000000),
    CellType.path: Color(0xFF4CAF50),
    CellType.empty: Color(0xFFFFFFFF),
  };
}

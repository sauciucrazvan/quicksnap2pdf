import 'package:flutter/material.dart';

import 'package:quicksnap2pdf/app.dart';
import 'package:system_theme/system_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemTheme.fallbackColor = const Color(0xFF865432);
  await SystemTheme.accentColor.load();

  runApp(const MainApp());
}

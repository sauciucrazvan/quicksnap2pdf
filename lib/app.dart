import 'package:fluent_ui/fluent_ui.dart';

import 'package:quicksnap2pdf/views/default_view.dart';
import 'package:system_theme/system_theme.dart';

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FluentApp(
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      theme: FluentThemeData(
        brightness: Brightness.light,
        accentColor: SystemTheme.accentColor.accent.toAccentColor(),
      ),
      darkTheme: FluentThemeData(
        brightness: Brightness.dark,
        accentColor: SystemTheme.accentColor.accent.toAccentColor(),
      ),
      home: const DefaultView(),
    );
  }
}

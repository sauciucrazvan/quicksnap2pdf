import 'package:fluent_ui/fluent_ui.dart';
import 'package:quicksnap2pdf/views/about_view.dart';
import 'package:quicksnap2pdf/views/default_view.dart';

class SidebarView extends StatefulWidget {
  const SidebarView({super.key});

  @override
  State<SidebarView> createState() => _SidebarViewState();
}

class _SidebarViewState extends State<SidebarView> {
  int selectedIndex = 0;

  final List<Widget> _pages = [const DefaultView(), const AboutView()];

  @override
  Widget build(BuildContext context) {
    return NavigationView(
      appBar: NavigationAppBar(
        title: const Text('Quicksnap to PDF'),
        automaticallyImplyLeading: false,
      ),
      pane: NavigationPane(
        selected: selectedIndex,
        onChanged: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
        displayMode: PaneDisplayMode.auto,
        items: [
          PaneItem(
            icon: Center(child: const Icon(FluentIcons.document_set)),
            title: const Text('Convertor'),
            onTap: () {
              setState(() {
                selectedIndex = 0;
              });
            },
            body: _pages[selectedIndex],
          ),
          PaneItem(
            icon: Center(child: const Icon(FluentIcons.info)),
            title: const Text('About'),
            onTap: () {
              setState(() {
                selectedIndex = 1; // Setează pagina About
              });
            },
            body: _pages[selectedIndex],
          ),
        ],
      ),
      // content:
      //     _pages[selectedIndex], // Conținutul corespunzător paginii selectate
    );
  }
}

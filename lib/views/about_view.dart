import 'package:fluent_ui/fluent_ui.dart';
import 'package:quicksnap2pdf/build_info.dart';
import 'package:url_launcher/url_launcher_string.dart';

class AboutView extends StatefulWidget {
  const AboutView({super.key});

  @override
  State<AboutView> createState() => _AboutViewState();
}

class _AboutViewState extends State<AboutView> {
  Future<void> _launchURL(String url) async {
    if (await canLaunchUrlString(url)) {
      await launchUrlString(url);
    } else {
      throw 'Cannot open $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldPage(
      header: Padding(
        padding: const EdgeInsets.only(left: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              "About Quicksnap to PDF",
              style: FluentTheme.of(context).typography.subtitle,
              textAlign: TextAlign.start,
            ),
          ],
        ),
      ),
      content: Padding(
        padding: const EdgeInsets.only(left: 20),
        child: Align(
          alignment: Alignment.topLeft,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Running on $buildVersion, built on $buildDate.",
                style: FluentTheme.of(context).typography.body,
                textAlign: TextAlign.start,
              ),
              const SizedBox(height: 4),

              Row(
                spacing: 4,
                children: [
                  Button(
                    onPressed:
                        () => _launchURL(
                          "https://github.com/sauciucrazvan/quicksnap2pdf",
                        ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(FluentIcons.git_graph),
                        SizedBox(width: 8),
                        Text("GitHub Repository"),
                      ],
                    ),
                  ),
                  Button(
                    onPressed:
                        () => _launchURL(
                          "https://github.com/sauciucrazvan/quicksnap2pdf/issues",
                        ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(FluentIcons.bug),
                        SizedBox(width: 8),
                        Text("Report an issue"),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),
              Text(
                "Application made by Răzvan Sauciuc.",
                style: FluentTheme.of(context).typography.body,
                textAlign: TextAlign.start,
              ),
              const SizedBox(height: 4),
              Row(
                spacing: 4,
                children: [
                  Button(
                    onPressed: () => _launchURL("https://razvansauciuc.dev"),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(FluentIcons.globe),
                        SizedBox(width: 8),
                        Text("Website"),
                      ],
                    ),
                  ),
                  Button(
                    onPressed:
                        () => _launchURL("https://github.com/sauciucrazvan"),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(FluentIcons.git_graph),
                        SizedBox(width: 8),
                        Text("GitHub"),
                      ],
                    ),
                  ),
                  Button(
                    onPressed:
                        () => _launchURL("mailto:razvansauciucc@outlook.com"),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(FluentIcons.mail),
                        SizedBox(width: 8),
                        Text("Send an email"),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

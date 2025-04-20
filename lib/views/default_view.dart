import 'dart:io';
import 'dart:math';

import 'package:desktop_drop/desktop_drop.dart';
import 'package:file_selector/file_selector.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;

class DefaultView extends StatefulWidget {
  const DefaultView({super.key});

  @override
  State<DefaultView> createState() => _DefaultViewState();
}

class _DefaultViewState extends State<DefaultView> {
  final List<File> _images = [];
  File? _generatedPdf;

  Future<void> _pickImages() async {
    final files = await openFiles(
      acceptedTypeGroups: [
        XTypeGroup(
          label: 'Images',
          extensions: ['jpg', 'jpeg', 'png', 'bmp', 'gif'],
        ),
      ],
    );

    if (files.isNotEmpty) {
      setState(() {
        _images.addAll(files.map((f) => File(f.path)));
      });
    }
  }

  Future<void> _generatePdf() async {
    final pdf = pw.Document();

    for (var image in _images) {
      final imageBytes = await image.readAsBytes();
      final img = pw.MemoryImage(imageBytes);

      pdf.addPage(
        pw.Page(build: (pw.Context context) => pw.Center(child: pw.Image(img))),
      );
    }

    final outputDir = await getTemporaryDirectory();
    final file = File("${outputDir.path}/output.pdf");
    await file.writeAsBytes(await pdf.save());

    setState(() {
      _generatedPdf = file;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldPage(
      header: Padding(
        padding: const EdgeInsets.only(left: 20),
        child: Text(
          'Quicksnap to PDF',
          style: FluentTheme.of(context).typography.title,
        ),
      ),

      content: Column(
        children: [
          Expanded(
            child: DropTarget(
              onDragDone: (details) {
                setState(() {
                  _images.addAll(details.files.map((f) => File(f.path)));
                });
              },
              child: GestureDetector(
                onTap: _pickImages,
                child: Container(
                  width: double.infinity,
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: FluentTheme.of(context).accentColor,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(FluentIcons.bulk_upload, size: 48),
                      SizedBox(height: 8),
                      Text("Drag & drop images here or click to select"),
                    ],
                  ),
                ),
              ),
            ),
          ),
          if (_images.isNotEmpty)
            Expanded(
              child: ListView.builder(
                itemCount: _images.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                      _images[index].path.split(Platform.pathSeparator).last,
                    ),
                  );
                },
              ),
            ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Button(
                onPressed: _images.isEmpty ? null : _generatePdf,
                child: Row(
                  children: const [
                    Icon(FluentIcons.pdf),
                    SizedBox(width: 8),
                    Text("Convert to PDF"),
                  ],
                ),
              ),
              Button(
                onPressed:
                    _generatedPdf == null
                        ? null
                        : () => OpenFile.open(_generatedPdf?.path),
                child: Row(
                  children: const [
                    Icon(FluentIcons.preview),
                    SizedBox(width: 8),
                    Text("Preview PDF"),
                  ],
                ),
              ),
              Button(
                onPressed:
                    _generatedPdf == null
                        ? null
                        : () async {
                          String fileName =
                              List.generate(
                                16,
                                (i) =>
                                    'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789'[Random.secure()
                                        .nextInt(62)],
                              ).join();

                          final result = await getSaveLocation(
                            suggestedName: '$fileName.pdf',
                            acceptedTypeGroups: [
                              XTypeGroup(label: 'PDF', extensions: ['pdf']),
                            ],
                          );

                          if (result != null && _generatedPdf != null) {
                            final savedFile = File(result.path);
                            await _generatedPdf!.copy(savedFile.path);

                            showDialog(
                              context: context,
                              builder:
                                  (_) => ContentDialog(
                                    title: const Text('Success!'),
                                    content: const Text(
                                      'PDF saved successfully to the desired location!',
                                    ),
                                    actions: [
                                      Button(
                                        child: const Text('OK'),
                                        onPressed: () => Navigator.pop(context),
                                      ),
                                    ],
                                  ),
                            );
                          }
                        },
                child: Row(
                  children: const [
                    Icon(FluentIcons.download),
                    SizedBox(width: 8),
                    Text("Download PDF"),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

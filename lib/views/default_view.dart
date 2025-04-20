import 'dart:io';
import 'dart:math';

import 'package:desktop_drop/desktop_drop.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;

class DefaultView extends StatefulWidget {
  const DefaultView({super.key});

  @override
  State<DefaultView> createState() => _DefaultViewState();
}

class _DefaultViewState extends State<DefaultView> {
  List<File> _images = [];
  File? _generatedPdf;

  Future<void> _pickImages() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.image,
    );

    if (result != null) {
      setState(() {
        _images.addAll(result.paths.map((path) => File(path!)));
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
    return Scaffold(
      appBar: AppBar(title: const Text("Quicksnap to PDF"), centerTitle: true),
      body: Column(
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
                    border: Border.all(color: Colors.blueAccent),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.upload_file, size: 48),
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
              ElevatedButton.icon(
                icon: const Icon(Icons.picture_as_pdf),
                label: const Text("Convert to PDF"),
                onPressed: _images.isEmpty ? null : _generatePdf,
              ),
              ElevatedButton.icon(
                icon: const Icon(Icons.preview),
                label: const Text("Preview PDF"),
                onPressed:
                    _generatedPdf == null
                        ? null
                        : () => OpenFile.open(_generatedPdf?.path),
              ),
              ElevatedButton.icon(
                icon: const Icon(Icons.download),
                label: const Text("Download PDF"),
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

                          final result = await FilePicker.platform.saveFile(
                            dialogTitle: 'Save PDF as',
                            fileName: '$fileName.pdf',
                            type: FileType.custom,
                            allowedExtensions: ['pdf'],
                          );

                          if (result != null && _generatedPdf != null) {
                            await _generatedPdf!.copy(result);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("PDF saved successfully!"),
                              ),
                            );
                          }
                        },
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

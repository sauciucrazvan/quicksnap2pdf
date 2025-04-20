import 'package:flutter/material.dart';
import 'package:quicksnap2pdf/views/Default.dart';

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: DefaultView(),
      debugShowCheckedModeBanner: false,
    );
  }
}

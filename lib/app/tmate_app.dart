import 'package:flutter/material.dart';
import '../features/discovery/discovery_screen.dart';

class TMateApp extends StatelessWidget {
  const TMateApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TMate',
      theme: ThemeData(useMaterial3: true),
      home: const DiscoveryScreen(),
    );
  }
}

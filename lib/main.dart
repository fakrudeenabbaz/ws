import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app/tmate_app.dart';
import 'core/ble_service.dart'; // relative path

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await BleService.I.init();
  runApp(const ProviderScope(child: TMateApp()));
}

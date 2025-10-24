// lib/util/permissions.dart
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:permission_handler/permission_handler.dart';

/// Returns true if Bluetooth is ON and permissions are granted.
Future<bool> ensureAndroidBlePerms() async {
  // Android 12+: Nearby Devices group; <12 still needs location
  final statuses = await [
    Permission.bluetoothScan,
    Permission.bluetoothConnect,
    Permission.bluetoothAdvertise,
    Permission.locationWhenInUse,
  ].request();

  final allGranted = statuses.values.every((s) => s.isGranted);
  if (!allGranted) return false;

  final state = await FlutterBluePlus.adapterState.first;
  return state == BluetoothAdapterState.on;
}

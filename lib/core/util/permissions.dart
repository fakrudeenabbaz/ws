import 'package:permission_handler/permission_handler.dart';

Future<bool> requestBlePermissions() async {
  final statuses = await [
    Permission.bluetoothScan,
    Permission.bluetoothConnect,
    Permission.bluetoothAdvertise,
  ].request();

  return statuses.values.every((s) => s.isGranted);
}

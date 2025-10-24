import 'dart:async';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class BLEManager {
  StreamSubscription<List<ScanResult>>? _scanSub;

  Future<void> _ensureReady() async {
    // 1) hardware support
    if (await FlutterBluePlus.isSupported == false) {
      throw StateError("Bluetooth LE not supported on this device.");
    }
    // 2) try to turn on (Android; iOS user controls it)
    if (!kIsWeb && Platform.isAndroid) {
      try { await FlutterBluePlus.turnOn(); } catch (_) {}
    }
    // 3) wait until adapter is ON
    await FlutterBluePlus.adapterState
        .firstWhere((s) => s == BluetoothAdapterState.on);
  }

  Future<void> startScan({Duration? timeout}) async {
    await _ensureReady();

    // Subscribe once; keep a single listener
    _scanSub ??= FlutterBluePlus.scanResults.listen(
          (results) {
        if (results.isEmpty) return;
        final r = results.last;
        // Visible console line while testing:
        // ignore: avoid_print
        print("FOUND: id=${r.device.remoteId} rssi=${r.rssi} name=${r.advertisementData.advName}");
      },
      onError: (e) => print("Scan error: $e"),
      cancelOnError: false,
    );

    await FlutterBluePlus.startScan(
      withServices: [Guid('0000FEAA-0000-1000-8000-00805F9B34FB')],
      timeout: const Duration(seconds: 0), // continuous
    );
    FlutterBluePlus.scanResults.listen((results) {
      for (final r in results) {
        // Read service/manufacturer data, update peer table
      }
    });
  }

  Future<void> stopScan() async {
    await _scanSub?.cancel();
    _scanSub = null;
    await FlutterBluePlus.stopScan();
  }
}

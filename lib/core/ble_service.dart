// lib/core/ble_service.dart
import 'dart:async';
import 'dart:typed_data';                     // ✅ add this
import 'package:flutter/foundation.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_ble_peripheral/flutter_ble_peripheral.dart';
import '../core/util/permissions.dart';

class BleService {
  BleService._();
  static final BleService I = BleService._();

  final _peripheral = FlutterBlePeripheral();
  StreamSubscription<List<ScanResult>>? _scanSub;

  static const int kMfgId = 0x03E8;

  bool _advertising = false;
  bool _scanning = false;
  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;
    _initialized = true;

    final ok = await ensureAndroidBlePerms();
    if (!ok) {
      debugPrint('❌ BLE perms or adapter not ready.');
      return;
    }

    final state = await FlutterBluePlus.adapterState.first;
    if (state != BluetoothAdapterState.on) {
      await FlutterBluePlus.adapterState.firstWhere((s) => s == BluetoothAdapterState.on);
    }

    await start();
  }

  Future<void> start() async {
    await _startAdvertising();
    await _startScanning();
  }

  Future<void> stop() async {
    if (_scanning) {
      await _scanSub?.cancel();
      _scanSub = null;
      await FlutterBluePlus.stopScan();
      _scanning = false;
    }
    if (_advertising) {
      await _peripheral.stop();
      _advertising = false;
    }
  }

  Future<void> _startAdvertising() async {
    if (_advertising) return;

    final adv = AdvertiseData(
      includeDeviceName: false,
      manufacturerId: kMfgId,
      manufacturerData: _buildBeacon(),      // ✅ now Uint8List
    );

    await _peripheral.start(advertiseData: adv);
    _advertising = true;
    debugPrint('📢 Advertising started (mfgId=0x${kMfgId.toRadixString(16)})');
  }

  // ✅ Return Uint8List instead of List<int>
  Uint8List _buildBeacon() {
    final nodeId = [0x00, 0x00, 0x00, 0x01];   // TODO: persist random 4B id
    final ttl = 4, seqHi = 0x00, seqLo = 0x01, flags = 0x00;
    return Uint8List.fromList([...nodeId, ttl, seqHi, seqLo, flags]);
  }

  Future<void> _startScanning() async {
    if (_scanning) return;
    await FlutterBluePlus.startScan(continuousUpdates: true);

    _scanSub = FlutterBluePlus.scanResults.listen((results) {
      for (final r in results) {
        final m = r.advertisementData.manufacturerData;
        if (m.containsKey(kMfgId)) {
          final bytes = m[kMfgId]!;
          // TODO: parse bytes (nodeId, ttl, seq, flags)
          debugPrint('🔎 TMate peer: ${r.device.remoteId.str} RSSI=${r.rssi} bytes=${bytes.length}');
        }
      }
    });

    _scanning = true;
    debugPrint('🔎 Scanning started (manufacturer filter kMfgId=0x${kMfgId.toRadixString(16)})');
  }
}

// lib/core/ble/ble_advertiser.dart
import 'dart:typed_data';                                  // ✅ add this
import 'package:flutter/foundation.dart';
import 'package:flutter_ble_peripheral/flutter_ble_peripheral.dart';

class BLEAdvertiser {
  final FlutterBlePeripheral _peripheral = FlutterBlePeripheral();
  bool _isAdvertising = false;

  static const int kMfgId = 0x03E8;

  Future<void> start() async {
    final adv = AdvertiseData(
      includeDeviceName: false,
      manufacturerId: kMfgId,
      manufacturerData: _buildBeacon(),                    // ✅ now Uint8List
    );

    await _peripheral.start(advertiseData: adv);
    _isAdvertising = true;
    debugPrint('📢 BLEAdvertiser started (mfgId=0x${kMfgId.toRadixString(16)})');
  }

  Future<void> stop() async {
    await _peripheral.stop();
    _isAdvertising = false;
  }

  Future<bool> isAdvertising() async => _isAdvertising;

  // ✅ Return Uint8List
  Uint8List _buildBeacon() {
    final nodeId = [0x00, 0x00, 0x00, 0x01];
    final ttl = 4, seqHi = 0x00, seqLo = 0x01, flags = 0x00;
    return Uint8List.fromList([...nodeId, ttl, seqHi, seqLo, flags]);
  }
}

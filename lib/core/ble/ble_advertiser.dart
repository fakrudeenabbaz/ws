// lib/core/ble/ble_advertiser.dart
import 'dart:io' show Platform;
import 'package:flutter_ble_peripheral/flutter_ble_peripheral.dart';

class BLEAdvertiser {
  // Keep your TMate service UUID simple for discovery
  static const String tmateServiceUuid = "0000A11A-0000-1000-8000-00805F9B34FB";

  final _peripheral = FlutterBlePeripheral();

  Future<void> start() async {
    if (!(Platform.isAndroid || Platform.isIOS)) return;

    // NOTE: In 1.2.6 the enums/params are named like this:
    final settings = AdvertiseSettings(
      advertiseMode: AdvertiseMode.advertiseModeLowLatency,
      txPowerLevel: AdvertiseTxPower.advertiseTxPowerHigh, // <- not 'TxPowerLevel'
      timeout: 0,            // 0 = keep advertising
      connectable: true,
    );

    // NOTE: field is 'serviceUuid', not 'uuid'
    final data = AdvertiseData(
      includeDeviceName: true,
      serviceUuid: tmateServiceUuid,
      // manufacturerId / serviceData optional — skip for iOS simplicity
    );

    // NOTE: start() expects named params 'advertiseData' and (optional) 'advertiseSettings'
    await _peripheral.start(
      advertiseData: data,
      advertiseSettings: settings,
    );
  }

  Future<void> stop() async => _peripheral.stop();

  Future<bool> isAdvertising() async => await _peripheral.isAdvertising;
}

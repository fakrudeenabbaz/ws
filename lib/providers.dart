import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/ble/ble_manager.dart';
import 'core/mesh/mesh_engine.dart';

final bleManagerProvider = Provider<BLEManager>((ref) => BLEManager());

final meshEngineProvider = Provider<MeshEngine>((ref) {
  final ble = ref.read(bleManagerProvider);
  return MeshEngine(ble: ble);
});

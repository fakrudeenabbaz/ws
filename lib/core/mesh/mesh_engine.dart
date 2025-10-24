import 'dart:collection';
import '../ble/ble_manager.dart';

class MeshEngine {
  final BLEManager ble;
  MeshEngine({required this.ble});

  final _seen = LinkedHashSet<String>(); // simple dedup cache

  Future<void> initialize() async {
    await ble.startScan();
    // TODO: start advertising via native channel (if needed) & timers.
  }

  bool _markSeen(String id) {
    if (_seen.contains(id)) return false;
    _seen.add(id);
    if (_seen.length > 2048) _seen.remove(_seen.first);
    return true;
  }

  void onInbound(String msgId, List<int> data, int ttl) {
    if (!_markSeen(msgId)) return;
    // TODO: decrypt, persist, update UI, and re-broadcast if ttl>0
  }
}

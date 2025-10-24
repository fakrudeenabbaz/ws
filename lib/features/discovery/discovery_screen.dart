import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers.dart';
import '../../core/util/permissions.dart';
import '../../core/ble/ble_advertiser.dart';

class DiscoveryScreen extends ConsumerStatefulWidget {
  const DiscoveryScreen({super.key});

  @override
  ConsumerState<DiscoveryScreen> createState() => _DiscoveryScreenState();
}

class _DiscoveryScreenState extends ConsumerState<DiscoveryScreen> {
  final _adv = BLEAdvertiser();
  bool _advertising = false;

  @override
  void initState() {
    super.initState();
    _initBle();
  }

  Future<void> _initBle() async {
    final granted = await requestBlePermissions();
    if (!mounted) return;
    if (granted) {
      await ref.read(meshEngineProvider).initialize(); // starts scanning
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Bluetooth permissions required')),
      );
    }
  }

  Future<void> _toggleAdvertise() async {
    final now = await _adv.isAdvertising();
    if (now) {
      await _adv.stop();
      setState(() => _advertising = false);
    } else {
      await _adv.start();
      setState(() => _advertising = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('TMate – Discovery')),
      body: const Center(child: Text('Scanning nearby peers…')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _toggleAdvertise,
        label: Text(_advertising ? 'Stop Advertising' : 'Start Advertising'),
        icon: Icon(_advertising ? Icons.stop : Icons.campaign),
      ),
    );
  }
}

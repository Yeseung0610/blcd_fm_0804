import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

// 사용하려는 블루투스 디바이스명과 일치해야함
const String _deviceName = 'BLDC_FM_0803';

class BLCDProvider extends ChangeNotifier {

  BluetoothDevice? _connectedDevice;

  BluetoothCharacteristic? _characteristic;

  bool get isConnected => _connectedDevice != null;

  void connectToDevice(BuildContext context) {
    if (_connectedDevice != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('이미 기기에 연결되어있습니다.'),
        ),
      );
      return;
    }

    FlutterBluePlus.startScan(timeout: const Duration(seconds: 4), androidUsesFineLocation: true);

      FlutterBluePlus.scanResults.listen((results) async {
      final matchDevices = results.where((element) => element.device.platformName == _deviceName);
      if (matchDevices.isNotEmpty) {
        FlutterBluePlus.stopScan();

        _connectedDevice = matchDevices.first.device;
        await _connectedDevice?.connect();

        await _discoverServices();

        notifyListeners();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('연결 가능한 기기가 없습니다.'),
          ),
        );
      }
    });
  }

  void disconnectToDevice(BuildContext context) async {
    if (_connectedDevice != null) {
      await _connectedDevice!.disconnect();
      _connectedDevice = null;
      _characteristic = null;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('연결된 기기가 없습니다.'),
        ),
      );
    }
  }


  void checkInVehicle() {
    _sendCommand([]);
  }

  void checkOutVehicle() {
    _sendCommand([]);
  }


  // Utils function
  void _sendCommand(List<int> command) {
    if (_characteristic != null) {
      _characteristic!.write(command);
    }
  }

  void _readResponse() async {
    if (_characteristic != null) {
      var response = await _characteristic!.read();
      if (kDebugMode) {
        print('Response: $response');
      }
    }
  }

  Future<void> _discoverServices() async {
    if (_connectedDevice == null) return;

    final services = await _connectedDevice!.discoverServices();
    for (var service in services) {
      for (var char in service.characteristics) {
        if (char.properties.write) {
          _characteristic = char;
          notifyListeners();
        }
      }
    }
  }
}
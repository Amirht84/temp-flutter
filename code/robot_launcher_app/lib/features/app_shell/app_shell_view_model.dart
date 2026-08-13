/*import 'dart:async';

import 'package:flutter/material.dart';
import 'package:core/core.dart';

class AppShellViewModel extends ChangeNotifier {

    AppShellViewModel(BleRepository repo) : _repo = repo, isScanning = false, isConnected = false, isConnecting = false;

    final BleRepository _repo;
    StreamSubscription<bool>? _connectionSubscription;

    bool isConnected;
    bool isScanning;
    bool isConnecting;

    Future<void> connect() async {
        isScanning = true;
        notifyListeners();
        final BleDevice? dev = await _repo.scanForRobots();
        isScanning = false;
        if(dev != null) {
            isConnecting = true;
            notifyListeners();
            await _connectionSubscription?.cancel();
            _connectionSubscription = _repo.connectToRobot(dev).listen((connState){
              switch((isConnecting, isConnected, connState)){
                case (true, _, true):
                  isConnected = true;
                  isConnecting = false;
                case (_, true, false):
                  isConnected = false;
                case (true, _, false):
                  isConnecting = false;
                default:
                  throw StateError('Unexpected State in AppShellViewModel.connect()');
              }
                notifyListeners();
            });
        } else {
          notifyListeners();
        }
    }

    @override
    void dispose() {
      _connectionSubscription?.cancel();
      super.dispose();
    }
}*/